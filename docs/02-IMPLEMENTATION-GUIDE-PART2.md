# StreetPrint 5 - Implementation Guide (Part 2)

**Phases 5-12**

---

## PHASE 5: ActiveStorage Setup & Migration

**Objective:** Migrate from Paperclip to ActiveStorage, get all images working

**Duration:** 12-20 hours  
**Prerequisites:** Phase 4 complete, data imported successfully

### Step 5.1: Verify ActiveStorage Installed

```bash
# Check migration exists
ls db/migrate/*active_storage*
# Should show create_active_storage_tables migration

# Run migration if not already
rails db:migrate

# Verify tables
rails console
```

```ruby
ActiveRecord::Base.connection.tables.grep(/active_storage/)
# => ["active_storage_blobs", "active_storage_attachments", "active_storage_variant_records"]
```

### Step 5.2: Update Photo Model for ActiveStorage

```ruby
# app/models/photo.rb
class Photo < ApplicationRecord
  belongs_to :item
  
  # New ActiveStorage attachment
  has_one_attached :image
  
  # Legacy associations (keep during migration)
  has_one :local_photo, dependent: :destroy
  has_one :cloudfile_photo, dependent: :destroy
  
  # Ordering
  default_scope -> { order(order: :asc) }
  
  # Check if migrated to ActiveStorage
  def migrated?
    image.attached?
  end
  
  # Get source photo (CloudFile or Local)
  def source_photo
    cloudfile_photo || local_photo
  end
  
  # Variant methods for ActiveStorage
  def thumb
    return nil unless image.attached?
    image.variant(resize_to_limit: [50, 50])
  end
  
  def large
    return nil unless image.attached?
    image.variant(resize_to_limit: [550, 420])
  end
  
  # URL methods (works with both old and new system)
  def thumb_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_representation_url(thumb, only_path: true)
    else
      source_photo&.photo&.url(:thumb)
    end
  end
  
  def large_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_representation_url(large, only_path: true)
    else
      source_photo&.photo&.url(:large)
    end
  end
  
  def original_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
    else
      source_photo&.photo&.url
    end
  end
  
  # Liquid template compatibility
  def to_liquid
    {
      'caption' => caption,
      'thumb_url' => thumb_url,
      'large_url' => large_url,
      'original_url' => original_url
    }
  end
end
```

### Step 5.3: Update MediaFile Model

```ruby
# app/models/media_file.rb
class MediaFile < ApplicationRecord
  belongs_to :item
  
  # ActiveStorage attachment
  has_one_attached :file
  
  # Get filename
  def filename
    if file.attached?
      file.filename.to_s
    else
      file_file_name
    end
  end
  
  # Display name
  def display_name
    title.presence || filename
  end
  
  # URL
  def url
    if file.attached?
      Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true)
    else
      # Old Paperclip path
      "/system/file/#{Rails.env}/#{id}/#{file_file_name}"
    end
  end
  
  def to_liquid
    {
      'display_name' => display_name,
      'url' => url,
      'filename' => filename
    }
  end
end
```

### Step 5.4: Create Photo Migration Rake Task

```ruby
# lib/tasks/migrate_photos_to_active_storage.rake
require 'open-uri'

namespace :photos do
  desc "Migrate Paperclip photos to ActiveStorage"
  task migrate: :environment do
    require 'ruby-progressbar'
    
    total = Photo.count
    migrated_count = 0
    failed_count = 0
    skipped_count = 0
    
    progressbar = ProgressBar.create(
      title: "Photos",
      total: total,
      format: "%t: |%B| %p%% %e"
    )
    
    Photo.find_each do |photo|
      progressbar.increment
      
      # Skip if already migrated
      if photo.image.attached?
        skipped_count += 1
        next
      end
      
      # Get source (CloudFile or Local)
      source = photo.source_photo
      unless source
        Rails.logger.warn "Photo #{photo.id}: No source found"
        failed_count += 1
        next
      end
      
      begin
        if source.is_a?(CloudfilePhoto)
          migrate_from_cloudfile(photo, source)
        else
          migrate_from_local(photo, source)
        end
        
        migrated_count += 1
      rescue => e
        Rails.logger.error "Photo #{photo.id} failed: #{e.message}"
        failed_count += 1
      end
    end
    
    puts "\n" + "="*70
    puts "Migration Complete"
    puts "="*70
    puts "Total:    #{total}"
    puts "Migrated: #{migrated_count}"
    puts "Skipped:  #{skipped_count} (already migrated)"
    puts "Failed:   #{failed_count}"
    puts "="*70
  end
  
  def migrate_from_cloudfile(photo, cloudfile)
    filename = cloudfile.photo_file_name
    
    # Construct S3 URL (updated in Phase 1)
    # This should already be S3/Cloudflare URL
    if filename.start_with?('http')
      url = filename
    else
      # Fallback: construct URL
      bucket = ENV['AWS_BUCKET'] || 'streetprint-production'
      url = "https://#{bucket}.s3.amazonaws.com/#{filename}"
    end
    
    # Download and attach
    downloaded = URI.open(url)
    photo.image.attach(
      io: downloaded,
      filename: File.basename(filename),
      content_type: cloudfile.photo_content_type || 'image/jpeg'
    )
  end
  
  def migrate_from_local(photo, local_photo)
    # Get local file path
    path = local_photo.photo.path rescue nil
    path ||= Rails.root.join(
      'public', 'system', 'local', 'photo', Rails.env,
      local_photo.id.to_s, 'original', local_photo.photo_file_name
    )
    
    unless File.exist?(path)
      raise "Local file not found: #{path}"
    end
    
    photo.image.attach(
      io: File.open(path),
      filename: local_photo.photo_file_name,
      content_type: local_photo.photo_content_type || 'image/jpeg'
    )
  end
  
  # Rollback task (if needed)
  task rollback: :environment do
    Photo.find_each do |photo|
      photo.image.purge if photo.image.attached?
    end
    puts "All ActiveStorage attachments removed"
  end
end
```

### Step 5.5: Install ProgressBar Gem (Optional)

```ruby
# Add to Gemfile
gem 'ruby-progressbar'

bundle install
```

### Step 5.6: Test Migration on Small Sample

```bash
rails console
```

```ruby
# Test with one photo
photo = Photo.joins(:cloudfile_photo).first
source = photo.cloudfile_photo

# Check source URL
puts source.photo_file_name

# Try to open URL
require 'open-uri'
downloaded = URI.open(source.photo_file_name)
puts "Downloaded: #{downloaded.size} bytes"

# Attach to photo
photo.image.attach(
  io: downloaded,
  filename: File.basename(source.photo_file_name),
  content_type: source.photo_content_type
)

# Verify attached
photo.image.attached?
# => true

# Test URL generation
photo.thumb_url
# => Should return ActiveStorage URL

exit
```

### Step 5.7: Run Full Photo Migration

```bash
# Set AWS credentials if not already in environment
export AWS_ACCESS_KEY_ID="your_key"
export AWS_SECRET_ACCESS_KEY="your_secret"
export AWS_BUCKET="streetprint-production"

# Run migration
rails photos:migrate

# This will take time depending on photo count
# Monitor progress bar
```

### Step 5.8: Verify Migration

```bash
rails console
```

```ruby
# Check migration status
total = Photo.count
migrated = Photo.joins(:image_attachment).count
unmigrated = total - migrated

puts "Total photos: #{total}"
puts "Migrated: #{migrated}"
puts "Unmigrated: #{unmigrated}"

# Test a few photos
Photo.limit(5).each do |photo|
  puts "Photo #{photo.id}: #{photo.image.attached? ? '✅' : '❌'}"
end

# Test URL generation
photo = Photo.joins(:image_attachment).first
puts photo.thumb_url
puts photo.large_url
puts photo.original_url

exit
```

### Step 5.9: Update Image Processing Configuration

```ruby
# config/environments/production.rb
config.active_storage.variant_processor = :vips  # Or :mini_magick
```

```bash
# Install libvips (faster than ImageMagick)
# macOS:
brew install vips

# Linux:
apt-get install libvips-dev
```

### Common Issues

**Issue:** OpenURI::HTTPError: 403 Forbidden  
**Solution:** S3 bucket permissions, ensure public-read or use signed URLs

**Issue:** Images too large, timeout  
**Solution:** Increase timeout, process in batches, use background job

**Issue:** Wrong image URLs generated  
**Solution:** Check `config.active_storage.service`, verify storage.yml

---

## PHASE 6: Model Porting

**Objective:** Port and update all models to Rails 7 syntax

**Duration:** 6-10 hours  
**Prerequisites:** Phase 5 complete, photos working

### Step 6.1: Copy All Models

```bash
# Copy models from old app
cp ../sp5/app/models/*.rb app/models/

# Check count
ls app/models/*.rb | wc -l
```

### Step 6.2: Update Core Models

**Site Model:**
```ruby
# app/models/site.rb
class Site < ApplicationRecord
  # Associations
  has_many :items, dependent: :destroy
  has_many :photos, through: :items
  has_many :authors, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :document_types, dependent: :destroy
  has_many :narratives, dependent: :destroy
  has_many :news_posts, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  belongs_to :site_theme, optional: true
  
  # ActiveStorage
  has_one_attached :logo
  
  # Validations (updated syntax)
  validates :name, presence: true, uniqueness: true
  
  # Methods
  def to_liquid
    {
      'id' => id,
      'name' => name,
      'title' => title,
      'welcome_blurb' => welcome_blurb,
      'logo_url' => logo.attached? ? Rails.application.routes.url_helpers.rails_blob_url(logo, only_path: true) : nil
    }
  end
end
```

**Item Model:**
```ruby
# app/models/item.rb
class Item < ApplicationRecord
  # Associations
  belongs_to :site
  belongs_to :document_type, optional: true
  has_many :photos, dependent: :destroy
  has_many :media_files, dependent: :destroy
  has_many :authored, dependent: :destroy
  has_many :authors, through: :authored
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  has_many :custom_datas, as: :data_targetable, dependent: :destroy
  
  # Validations (updated syntax)
  validates :title, :site_id, presence: true
  validates :year, numericality: { only_integer: true }, allow_nil: true
  validates :month, numericality: { only_integer: true, in: 1..12 }, allow_nil: true
  validates :day, numericality: { only_integer: true, in: 1..31 }, allow_nil: true
  
  # Callbacks
  before_save :set_date_from_fields
  
  # Nested attributes
  accepts_nested_attributes_for :authors,
    allow_destroy: true,
    reject_if: ->(attrs) { attrs['name'].blank? }
    
  accepts_nested_attributes_for :photos,
    allow_destroy: true
    
  accepts_nested_attributes_for :custom_datas,
    allow_destroy: true,
    reject_if: ->(attrs) { attrs['data'].blank? }
  
  # Scopes
  scope :published, -> { where(published: true) }
  scope :by_year, ->(year) { where(year: year) }
  
  # Liquid template support
  def to_liquid
    {
      'id' => id.to_s,
      'title' => title,
      'year' => year,
      'month' => month ? Date::MONTHNAMES[month] : nil,
      'day' => day,
      'location' => location,
      'publisher' => publisher,
      'notes' => notes,
      'full_text' => full_text,
      'date' => pretty_date,
      'authors' => authors.map(&:to_liquid),
      'categories' => categories.map(&:to_liquid),
      'images' => photos.map(&:to_liquid),
      'first_image' => photos.first&.to_liquid,
      'path' => Rails.application.routes.url_helpers.item_path(self)
    }
  end
  
  def pretty_date
    parts = [year, month ? Date::MONTHNAMES[month] : nil, day].compact
    parts.join(" ")
  end
  
  def first_image
    photos.first
  end
  
  # Navigation
  def previous_by_id
    self.class.where(site_id: site_id, published: true)
             .where('id < ?', id)
             .order(id: :desc)
             .first
  end
  
  def next_by_id
    self.class.where(site_id: site_id, published: true)
             .where('id > ?', id)
             .order(id: :asc)
             .first
  end
  
  private
  
  def set_date_from_fields
    return unless year
    self.date = Date.new(year, month || 1, day || 1)
  rescue ArgumentError
    # Invalid date, skip
  end
end
```

**Author Model:**
```ruby
# app/models/author.rb
class Author < ApplicationRecord
  belongs_to :site
  has_many :authored, dependent: :destroy
  has_many :items, through: :authored
  
  validates :name, presence: true
  
  def to_liquid
    {
      'id' => id,
      'name' => name,
      'description' => description,
      'gender' => gender
    }
  end
end
```

**Category Model:**
```ruby
# app/models/category.rb
class Category < ApplicationRecord
  belongs_to :site
  has_many :categorizations, dependent: :destroy
  has_many :items, through: :categorizations
  
  validates :name, presence: true
  
  def to_liquid
    {
      'id' => id,
      'name' => name,
      'description' => description
    }
  end
end
```

### Step 6.3: Add String Extensions

```ruby
# config/initializers/string_extensions.rb
class String
  def sanitize
    ActionController::Base.helpers.sanitize(self, tags: [])
  end
end
```

### Step 6.4: Test Models in Console

```bash
rails console
```

```ruby
# Test Site
site = Site.first
site.valid?
site.items.count

# Test Item
item = Item.first
item.valid?
item.photos.count
item.authors.count
item.to_liquid

# Test associations
item.photos.each do |photo|
  puts photo.thumb_url
end

# Test Liquid serialization
item.to_liquid.keys

exit
```

### Step 6.5: Remove Deprecated Code

Search for and remove:
- `validates_presence_of` → `validates :field, presence: true`
- `validates_numericality_of` → `validates :field, numericality: true`
- `has_attached_file` → Already replaced with ActiveStorage
- `define_index` (Sphinx) → Remove for now, add search later

### Common Issues

**Issue:** `sanitize` method undefined  
**Solution:** Add string_extensions.rb initializer

**Issue:** Liquid rendering fails  
**Solution:** Ensure all `to_liquid` methods return simple types (strings, arrays, hashes)

**Issue:** Validation errors  
**Solution:** Check syntax, Rails 7 may be stricter

---

## PHASE 7: Views (Read-Only)

**Objective:** Get public-facing pages working

**Duration:** 8-16 hours  
**Prerequisites:** Phase 6 complete, models working

*[Abbreviated for space - full details would continue with routes, controllers, views setup]*

### Step 7.1: Create Routes

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root "sites#index"
  
  resources :sites, only: [:index, :show] do
    resources :items, only: [:index, :show]
  end
  
  resources :items, only: [:index, :show]
  resources :authors, only: [:index, :show]
  resources :categories, only: [:index, :show]
end
```

### Step 7.2: Create Controllers

```ruby
# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  def index
    @items = Item.includes(:photos, :authors)
                 .published
                 .page(params[:page])
  end
  
  def show
    @item = Item.includes(:photos, :authors, :categories)
                .find(params[:id])
  end
end
```

### Step 7.3: Create Views

```erb
<!-- app/views/items/show.html.erb -->
<article class="item">
  <h1><%= @item.title %></h1>
  
  <% if @item.photos.any? %>
    <div class="photos">
      <% @item.photos.each do |photo| %>
        <%= image_tag photo.large, alt: photo.caption %>
      <% end %>
    </div>
  <% end %>
  
  <div class="metadata">
    <% if @item.authors.any? %>
      <p>By: <%= @item.authors.map(&:name).join(', ') %></p>
    <% end %>
    
    <p>Date: <%= @item.pretty_date %></p>
  </div>
  
  <% if @item.notes.present? %>
    <div class="notes">
      <%= simple_format(@item.notes) %>
    </div>
  <% end %>
</article>
```

---

*[Continuing with remaining phases...]*

This implementation guide is getting quite long. Let me create the final two critical documents (Data Migration and Testing/Validation) in separate files:
