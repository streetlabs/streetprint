# StreetPrint 5 - Implementation Guide

**Document Version:** 1.0  
**Date:** January 2026  
**For:** Implementation Team

---

## How to Use This Guide

This document provides **step-by-step instructions** for each phase of the migration. Follow the phases sequentially. Each phase includes:

- **Objective:** What you're accomplishing
- **Prerequisites:** What must be completed first
- **Steps:** Detailed instructions
- **Validation:** How to verify success
- **Common Issues:** Troubleshooting tips

---

## Prerequisites

### Required Software

- Ruby 3.3.7 (use rbenv or rvm)
- Rails 7.2.x
- MySQL 8.x
- Docker & Docker Compose
- Git
- ImageMagick or libvips (for image processing)

### Development Environment Setup

```bash
# Install Ruby 3.3.7
rbenv install 3.3.7
rbenv global 3.3.7

# Verify Ruby version
ruby --version
# => ruby 3.3.7

# Install Rails 7.2
gem install rails -v '~> 7.2.0'

# Verify Rails version
rails --version
# => Rails 7.2.x

# Install MySQL (macOS)
brew install mysql
brew services start mysql

# Install ImageMagick
brew install imagemagick

# Install Docker
# Download from: https://www.docker.com/products/docker-desktop
```

### Repository Access

```bash
# Clone existing repository
cd /Users/madsen/Developer/StreetLabs
git clone [repository-url] sp5
cd sp5

# Checkout working branch
git checkout -b rails-7-migration
```

---

## PHASE 1: Image URL Update

**Objective:** Update all Rackspace CloudFiles URLs to S3/Cloudflare URLs

**Duration:** 2-4 hours  
**Prerequisites:** Database backup, S3/Cloudflare bucket created

### Step 1.1: Backup Current Database

```bash
# Create backup directory
mkdir -p /Users/madsen/Developer/StreetLabs/sp5-backups

# Backup development database
mysqldump -u root streetprint_development > \
  sp5-backups/dev_$(date +%Y%m%d_%H%M%S).sql

# Backup production database (if accessible)
mysqldump -u root streetprint_production > \
  sp5-backups/prod_$(date +%Y%m%d_%H%M%S).sql

# Verify backups
ls -lh sp5-backups/
```

### Step 1.2: Analyze Current Image URLs

```bash
# Start Rails console
cd /Users/madsen/Developer/StreetLabs/sp5
rails console

# In Rails console:
```

```ruby
# Count photos
Photo.count
CloudfilePhoto.count
LocalPhoto.count

# Sample CloudFile URLs
CloudfilePhoto.first(5).each do |cf|
  puts cf.photo_file_name
end

# Check streetprint_settings
settings = StreetprintSettings.first
puts "Use CloudFiles: #{settings.use_cloudfiles}"
puts "Container: #{settings.cloudfiles_container}"

# Find any hardcoded URLs in content
Item.where("full_text LIKE ?", "%rackspace%").count
Item.where("notes LIKE ?", "%rackspace%").count
```

### Step 1.3: Document URL Pattern

Create a mapping document:

```bash
# Create docs directory
mkdir -p docs

# Create URL mapping file
cat > docs/url-mapping.txt << 'EOF'
OLD PATTERN:
https://[container].r.clouddrive.com/[path]
http://c[number].r.clouddrive.com/[path]

NEW PATTERN (S3):
https://s3.amazonaws.com/streetprint-production/[path]
OR
https://streetprint-production.s3.amazonaws.com/[path]

NEW PATTERN (Cloudflare R2):
https://[bucket-subdomain].r2.dev/[path]
OR
https://cdn.streetprint.org/[path] (with custom domain)
EOF
```

### Step 1.4: Create URL Update Script

```bash
# Create migration script
mkdir -p lib/tasks
cat > lib/tasks/update_image_urls.rake << 'RUBY'
namespace :images do
  desc "Update Rackspace URLs to S3/Cloudflare"
  task update_urls: :environment do
    # Configuration
    old_domain = ENV['OLD_DOMAIN'] || 'c12345.r.clouddrive.com'
    new_domain = ENV['NEW_DOMAIN'] || 's3.amazonaws.com/streetprint-production'
    
    dry_run = ENV['DRY_RUN'] != 'false'
    
    puts "="*60
    puts "Image URL Update Script"
    puts "="*60
    puts "Old domain: #{old_domain}"
    puts "New domain: #{new_domain}"
    puts "Mode: #{dry_run ? 'DRY RUN' : 'LIVE UPDATE'}"
    puts "="*60
    puts
    
    # Update CloudfilePhotos
    puts "Updating CloudfilePhotos..."
    cloudfile_photos = CloudfilePhoto.where("photo_file_name LIKE ?", "%#{old_domain}%")
    puts "Found #{cloudfile_photos.count} records to update"
    
    cloudfile_photos.find_each do |photo|
      old_url = photo.photo_file_name
      new_url = old_url.gsub(old_domain, new_domain)
      
      puts "  #{photo.id}: #{old_url} → #{new_url}"
      
      unless dry_run
        photo.update_column(:photo_file_name, new_url)
      end
    end
    
    # Update Items with URLs in text fields
    puts "\nUpdating Item text fields..."
    items_with_urls = Item.where(
      "full_text LIKE ? OR notes LIKE ?",
      "%#{old_domain}%",
      "%#{old_domain}%"
    )
    puts "Found #{items_with_urls.count} items to update"
    
    items_with_urls.find_each do |item|
      changes = []
      
      if item.full_text&.include?(old_domain)
        changes << "full_text"
        new_text = item.full_text.gsub(old_domain, new_domain)
        item.full_text = new_text unless dry_run
      end
      
      if item.notes&.include?(old_domain)
        changes << "notes"
        new_notes = item.notes.gsub(old_domain, new_domain)
        item.notes = new_notes unless dry_run
      end
      
      if changes.any?
        puts "  Item #{item.id}: updating #{changes.join(', ')}"
        item.save(validate: false) unless dry_run
      end
    end
    
    # Update StreetprintSettings
    puts "\nUpdating StreetprintSettings..."
    settings = StreetprintSettings.first
    if settings
      puts "  Setting use_cloudfiles to false"
      settings.update(use_cloudfiles: false) unless dry_run
    end
    
    puts "\n" + "="*60
    if dry_run
      puts "DRY RUN COMPLETE - No changes were made"
      puts "Run with DRY_RUN=false to apply changes"
    else
      puts "UPDATE COMPLETE"
    end
    puts "="*60
  end
end
RUBY
```

### Step 1.5: Run URL Update (Dry Run First)

```bash
# Dry run first
DRY_RUN=true \
OLD_DOMAIN="c12345.r.clouddrive.com" \
NEW_DOMAIN="s3.amazonaws.com/streetprint-production" \
rails images:update_urls

# Review output carefully

# If looks good, run for real
DRY_RUN=false \
OLD_DOMAIN="c12345.r.clouddrive.com" \
NEW_DOMAIN="s3.amazonaws.com/streetprint-production" \
rails images:update_urls
```

### Step 1.6: Validation

```bash
rails console
```

```ruby
# Verify no old URLs remain
CloudfilePhoto.where("photo_file_name LIKE ?", "%rackspace%").count
# => Should be 0

CloudfilePhoto.where("photo_file_name LIKE ?", "%clouddrive%").count
# => Should be 0

Item.where("full_text LIKE ? OR notes LIKE ?", "%rackspace%", "%rackspace%").count
# => Should be 0

# Check a few records
CloudfilePhoto.first(3).each { |p| puts p.photo_file_name }
# => Should show new S3/Cloudflare URLs

# Check settings
StreetprintSettings.first.use_cloudfiles
# => Should be false
```

### Step 1.7: Test Image Access

```ruby
# In Rails console, test image URLs
photo = Photo.joins(:cloudfile_photo).first
url = photo.photo.url

# Visit URL in browser or curl
puts "Test this URL: #{url}"

# If using S3, ensure bucket is public or use signed URLs
# If using Cloudflare R2, ensure public access is configured
```

### Common Issues

**Issue:** Images return 403 Forbidden  
**Solution:** Check S3/R2 bucket permissions, ensure public read access or configure signed URLs

**Issue:** URLs still contain old domain  
**Solution:** Check for escaped URLs, URL-encoded strings, or JSON-stored URLs

**Issue:** Settings table doesn't exist  
**Solution:** This is from older migration, safe to skip if table missing

---

## PHASE 2: New Rails Project Setup

**Objective:** Create new Rails 7.2 application with correct configuration

**Duration:** 1 hour  
**Prerequisites:** Ruby 3.3.7 installed, MySQL running

### Step 2.1: Generate New Rails Application

```bash
cd /Users/madsen/Developer/StreetLabs

# Generate new Rails app
rails new sp5-new \
  --database=mysql \
  --skip-javascript \
  --skip-test \
  --skip-system-test \
  --skip-jbuilder

cd sp5-new
```

### Step 2.2: Configure Ruby Version

```bash
# Set Ruby version
echo "3.3.7" > .ruby-version

# Verify
cat .ruby-version
# => 3.3.7
```

### Step 2.3: Update Gemfile

```ruby
# Gemfile
source "https://rubygems.org"

ruby "3.3.7"

# Rails
gem "rails", "~> 7.2.0"

# Database
gem "mysql2", "~> 0.5"

# Server
gem "puma", ">= 5.0"

# Assets
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Storage
gem "image_processing", "~> 1.2"
gem "aws-sdk-s3", require: false

# Application gems
gem "liquid", "~> 5.0"
gem "pagy", "~> 6.0"
gem "redcarpet", "~> 3.6"

# Optional: Authentication & Authorization
# gem "devise", "~> 4.9"
# gem "pundit", "~> 2.3"

# Optional: Search
# gem "meilisearch-rails", "~> 0.12"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "brakeman", require: false
  gem "rubocop-rails", require: false
end

group :development do
  gem "web-console"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
```

### Step 2.4: Install Dependencies

```bash
bundle install
```

### Step 2.5: Configure Database

```yaml
# config/database.yml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: <%= ENV.fetch("DB_PASSWORD", "") %>
  socket: /tmp/mysql.sock
  # Or host: 127.0.0.1 / port: 3306

development:
  <<: *default
  database: streetprint_new_development

test:
  <<: *default
  database: streetprint_new_test

production:
  <<: *default
  database: <%= ENV.fetch("DATABASE_NAME", "streetprint_production") %>
  username: <%= ENV.fetch("DATABASE_USER", "root") %>
  password: <%= ENV["DATABASE_PASSWORD"] %>
  host: <%= ENV.fetch("DATABASE_HOST", "localhost") %>
```

### Step 2.6: Create Databases

```bash
rails db:create
# => Created database 'streetprint_new_development'
# => Created database 'streetprint_new_test'
```

### Step 2.7: Configure ActiveStorage

```bash
# Install ActiveStorage
rails active_storage:install

# This creates migration for ActiveStorage tables
# We'll run it in Phase 3
```

### Step 2.8: Configure Storage Backends

```yaml
# config/storage.yml
local:
  service: Disk
  root: <%= Rails.root.join("storage") %>

# For development testing with S3
amazon_dev:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV.fetch('AWS_REGION', 'us-east-1') %>
  bucket: <%= ENV.fetch('AWS_BUCKET', 'streetprint-dev') %>

# Production S3
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV.fetch('AWS_REGION', 'us-east-1') %>
  bucket: <%= ENV.fetch('AWS_BUCKET', 'streetprint-production') %>

# Cloudflare R2
cloudflare:
  service: S3
  access_key_id: <%= ENV['CLOUDFLARE_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['CLOUDFLARE_SECRET_ACCESS_KEY'] %>
  region: auto
  endpoint: <%= ENV['CLOUDFLARE_ENDPOINT'] %>
  bucket: <%= ENV['CLOUDFLARE_BUCKET'] %>
  public: true
```

```ruby
# config/environments/development.rb
config.active_storage.service = :local

# config/environments/production.rb
config.active_storage.service = :amazon  # or :cloudflare
```

### Step 2.9: Initialize Git

```bash
git init
git add .
git commit -m "Initial Rails 7.2 setup"
```

### Step 2.10: Validation

```bash
# Verify Rails app works
rails server

# Visit http://localhost:3000
# Should see Rails welcome page

# Stop server (Ctrl+C)

# Verify database connection
rails console
```

```ruby
ActiveRecord::Base.connection.execute("SELECT 1")
# => Should return result without error

exit
```

---

## PHASE 3: Migration Porting

**Objective:** Port all 108 migrations to new app and verify schema matches

**Duration:** 8-16 hours  
**Prerequisites:** New Rails app created, databases created

### Step 3.1: Copy Migration Files

```bash
# From sp5-new directory
cp ../sp5/db/migrate/*.rb db/migrate/

# Verify count
ls db/migrate/*.rb | wc -l
# => Should show 109 (108 original + 1 ActiveStorage)
```

### Step 3.2: Create Migration Update Script

```ruby
# scripts/update_migration_syntax.rb
#!/usr/bin/env ruby

Dir.glob("db/migrate/*.rb").each do |file|
  # Skip ActiveStorage migration
  next if file.include?("active_storage")
  
  content = File.read(file)
  original = content.dup
  
  # Update class inheritance
  content.gsub!(/class (\w+) < ActiveRecord::Migration\s*$/, 
                'class \1 < ActiveRecord::Migration[7.2]')
  
  # Update hash syntax
  content.gsub!(/:(\w+)\s*=>/, '\1:')
  
  # Update table options
  content.gsub!(/:force\s*=>\s*true/, 'force: :cascade')
  
  # Update column definitions
  content.gsub!(/,\s*:null\s*=>/, ', null:')
  content.gsub!(/,\s*:default\s*=>/, ', default:')
  content.gsub!(/,\s*:limit\s*=>/, ', limit:')
  
  if content != original
    File.write(file, content)
    puts "Updated: #{file}"
  end
end

puts "Migration syntax update complete!"
```

```bash
# Make executable
chmod +x scripts/update_migration_syntax.rb

# Run script
ruby scripts/update_migration_syntax.rb
```

### Step 3.3: Run Migrations One at a Time

```bash
# Get list of migration versions
ls db/migrate/*.rb | sed 's/.*\///;s/_.*//' | sort > migration_versions.txt

# Run first migration
rails db:migrate:up VERSION=$(head -1 migration_versions.txt)

# Check for errors
# If successful, continue with next
```

**For each migration error:**

1. Open the migration file
2. Fix the syntax issue
3. Check for deprecated methods
4. Re-run the migration
5. Document the fix

### Step 3.4: Common Migration Fixes

**Fix 1: Change force option**
```ruby
# BEFORE
create_table :items, :force => true do |t|

# AFTER  
create_table :items, force: :cascade do |t|
```

**Fix 2: Update column syntax**
```ruby
# BEFORE
t.string :name, :null => false, :default => ""

# AFTER
t.string :name, null: false, default: ""
```

**Fix 3: Add inheritance version**
```ruby
# BEFORE
class CreateItems < ActiveRecord::Migration

# AFTER
class CreateItems < ActiveRecord::Migration[7.2]
```

**Fix 4: Remove deprecated methods**
```ruby
# BEFORE (if exists)
t.references :item, :foreign_key => true

# AFTER
t.references :item, foreign_key: true
```

### Step 3.5: Run All Migrations

```bash
# After fixing individual migrations, run all
rails db:migrate

# Check status
rails db:migrate:status

# Should show all migrations as "up"
```

### Step 3.6: Compare Schemas

```bash
# Generate new schema
rails db:schema:dump

# Compare with old schema
diff ../sp5/db/schema.rb db/schema.rb > schema_comparison.txt

# Review differences
cat schema_comparison.txt
```

### Step 3.7: Create Schema Comparison Report

```bash
# scripts/compare_schemas.rb
#!/usr/bin/env ruby

old_schema = File.read("../sp5/db/schema.rb")
new_schema = File.read("db/schema.rb")

puts "="*70
puts "SCHEMA COMPARISON REPORT"
puts "="*70

# Extract table names
old_tables = old_schema.scan(/create_table "(\w+)"/).flatten.sort
new_tables = new_schema.scan(/create_table "(\w+)"/).flatten.sort

missing_tables = old_tables - new_tables
extra_tables = new_tables - old_tables

puts "\nTables in OLD schema: #{old_tables.count}"
puts "Tables in NEW schema: #{new_tables.count}"

if missing_tables.any?
  puts "\n⚠️  MISSING TABLES:"
  missing_tables.each { |t| puts "  - #{t}" }
else
  puts "\n✅ All tables present"
end

if extra_tables.any?
  puts "\n📝 EXTRA TABLES (expected):"
  extra_tables.each { |t| puts "  - #{t}" }
end

# Common tables
common_tables = old_tables & new_tables

puts "\n"
puts "="*70
puts "Detailed comparison for #{common_tables.count} common tables:"
puts "="*70

common_tables.each do |table|
  old_def = old_schema[/create_table "#{table}".*?end/m]
  new_def = new_schema[/create_table "#{table}".*?end/m]
  
  if old_def == new_def
    puts "✅ #{table}"
  else
    puts "⚠️  #{table} - DIFFERS"
    # Could add more detailed column comparison here
  end
end

puts "\n" + "="*70
puts "Review complete. Check for ⚠️  warnings above."
puts "="*70
```

```bash
ruby scripts/compare_schemas.rb
```

### Step 3.8: Validation

```ruby
rails console

# Check all tables exist
ActiveRecord::Base.connection.tables.sort
# => Should include: items, photos, sites, users, authors, etc.

# Check active_storage tables exist
ActiveRecord::Base.connection.tables.include?("active_storage_blobs")
# => true

# Check a few table structures
ActiveRecord::Base.connection.columns(:items).map(&:name)
# => Should match old schema

ActiveRecord::Base.connection.columns(:photos).map(&:name)
# => Should match old schema

exit
```

### Common Issues

**Issue:** Migration fails with "Table already exists"  
**Solution:** Drop and recreate database, run migrations fresh

**Issue:** Column type mismatch  
**Solution:** Check old migration, ensure correct type in Rails 7

**Issue:** Index creation fails  
**Solution:** Check for duplicate index definitions, remove duplicates

---

*[Continuing in next message due to length...]*

---

## PHASE 4: Data Migration

**Objective:** Import all data from old database to new database

**Duration:** 2-4 hours  
**Prerequisites:** Phase 3 complete, schemas match

### Step 4.1: Export Data from Old Database

```bash
# Export data only (no schema)
mysqldump -u root \
  --no-create-info \
  --skip-triggers \
  --complete-insert \
  streetprint_development > data_export.sql

# Verify export
ls -lh data_export.sql
# Should be substantial size

# Check contents
head -100 data_export.sql
```

### Step 4.2: Import Data to New Database

```bash
# Import data
mysql -u root streetprint_new_development < data_export.sql

# Check for errors in import
# If errors, review and fix, then re-import
```

### Step 4.3: Validate Record Counts

```ruby
rails console

# Compare counts with old database
puts "Items: #{Item.count}"
puts "Photos: #{Photo.count}"
puts "CloudfilePhotos: #{CloudfilePhoto.count}"
puts "LocalPhotos: #{LocalPhoto.count}"
puts "Sites: #{Site.count}"
puts "Users: #{User.count}"
puts "Authors: #{Author.count}"
puts "Categories: #{Category.count}"
puts "MediaFiles: #{MediaFile.count}"
puts "Narratives: #{Narrative.count}"
puts "NewsPosts: #{NewsPost.count}"

# Test associations
item = Item.first
puts "Item #{item.id} has #{item.photos.count} photos"
puts "Item #{item.id} has #{item.authors.count} authors"

site = Site.first
puts "Site #{site.id} has #{site.items.count} items"
```

### Step 4.4: Create Validation Script

```ruby
# lib/tasks/validate_data.rake
namespace :data do
  desc "Validate data migration"
  task validate: :environment do
    puts "="*70
    puts "DATA VALIDATION REPORT"
    puts "="*70
    
    tables = {
      'Items' => Item,
      'Photos' => Photo,
      'CloudfilePhotos' => CloudfilePhoto,
      'LocalPhotos' => LocalPhoto,
      'Sites' => Site,
      'Users' => User,
      'Authors' => Author,
      'Categories' => Category,
      'DocumentTypes' => DocumentType,
      'MediaFiles' => MediaFile,
      'Narratives' => Narrative,
      'NewsPosts' => NewsPost,
      'SiteThemes' => SiteTheme
    }
    
    puts "\nRecord Counts:"
    tables.each do |name, model|
      count = model.count
      puts "  #{name.ljust(20)} #{count.to_s.rjust(8)}"
    end
    
    puts "\nAssociation Tests:"
    
    # Test Item associations
    item = Item.first
    if item
      puts "  ✅ Items → Photos: #{item.photos.count}"
      puts "  ✅ Items → Authors: #{item.authors.count}"
      puts "  ✅ Items → Categories: #{item.categorizations.count}"
    else
      puts "  ⚠️  No items found!"
    end
    
    # Test Site associations
    site = Site.first
    if site
      puts "  ✅ Sites → Items: #{site.items.count}"
      puts "  ✅ Sites → Authors: #{site.authors.count}"
    else
      puts "  ⚠️  No sites found!"
    end
    
    # Check for orphaned records
    puts "\nOrphan Check:"
    orphaned_photos = Photo.where.missing(:item).count
    puts "  Photos without items: #{orphaned_photos}"
    
    orphaned_items = Item.where.missing(:site).count
    puts "  Items without sites: #{orphaned_items}"
    
    puts "\n" + "="*70
    puts "Validation complete"
    puts "="*70
  end
end
```

```bash
rails data:validate
```

### Common Issues

**Issue:** Foreign key constraint errors  
**Solution:** Import data in dependency order or disable foreign key checks temporarily

**Issue:** Character encoding issues  
**Solution:** Ensure both databases use utf8mb4, re-export with charset flag

**Issue:** Missing records  
**Solution:** Check export SQL, verify WHERE clauses didn't filter data

---

*This is just the first part of the implementation guide. Would you like me to continue with the remaining phases (5-12)?*
