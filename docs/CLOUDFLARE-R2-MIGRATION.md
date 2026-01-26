# Migrating Existing Rails 2.3.3 App to Cloudflare R2

**Goal:** Switch from Rackspace CloudFiles to Cloudflare R2 (S3-compatible API)

**Estimated Time:** 2-4 hours

---

## Current Setup

Your app uses:
- `paperclip-cloudfiles` gem (v2.3.1.1.4)
- Paperclip storage: `:cloud_files`
- Credentials from: `config/rackspace_cloudfiles.yml` or database
- Files already copied to Cloudflare R2 ✅

---

## What Needs to Change

Since Cloudflare R2 uses S3-compatible API, we need to:

1. **Replace** `paperclip-cloudfiles` gem with `aws-s3` gem (S3 compatible)
2. **Change** storage from `:cloud_files` to `:s3`
3. **Update** configuration to use R2 credentials/endpoint
4. **Update** `StreetprintSettings` model logic
5. **Keep** existing file paths/names (already in R2)

---

## Step-by-Step Instructions

### Step 1: Update Gemfile/Environment Config

Since Rails 2.3.3 uses `config.gem`, we need to update `config/environment.rb`:

**BEFORE:**
```ruby
config.gem "paperclip-cloudfiles",
  :lib => 'paperclip',
  :version => '2.3.1.1.4',
  :source => "http://gemcutter.org/"

config.gem 'cloudfiles'
```

**AFTER:**
```ruby
config.gem "paperclip",
  :version => '2.3.1'

config.gem "aws-s3",
  :lib => 'aws/s3'
```

### Step 2: Install New Gems

```bash
# Remove old gems
gem uninstall paperclip-cloudfiles cloudfiles

# Install new gems
gem install paperclip -v 2.3.1
gem install aws-s3

# Or if using rake gems:install
rake gems:install
```

### Step 3: Create R2 Configuration File

Cloudflare R2 needs S3-compatible configuration:

```yaml
# config/cloudflare_r2.yml
development:
  bucket: streetprint-photos  # Your R2 bucket name
  access_key_id: YOUR_R2_ACCESS_KEY_ID
  secret_access_key: YOUR_R2_SECRET_ACCESS_KEY
  endpoint: https://ACCOUNT_ID.r2.cloudflarestorage.com
  # Optional: if you have a custom domain setup
  # url: https://photos.yourdomain.com

test:
  bucket: streetprint-test-photos
  access_key_id: YOUR_R2_ACCESS_KEY_ID
  secret_access_key: YOUR_R2_SECRET_ACCESS_KEY
  endpoint: https://ACCOUNT_ID.r2.cloudflarestorage.com

production:
  bucket: streetprint-photos
  access_key_id: YOUR_R2_ACCESS_KEY_ID
  secret_access_key: YOUR_R2_SECRET_ACCESS_KEY
  endpoint: https://ACCOUNT_ID.r2.cloudflarestorage.com
  # For production, use custom domain or R2 public URL
  url: https://pub-XXXXX.r2.dev  # Or custom domain
```

**How to get R2 credentials:**
1. Go to Cloudflare Dashboard → R2
2. Click "Manage R2 API Tokens"
3. Create API token with Read & Write permissions
4. Note the Access Key ID and Secret Access Key
5. Your endpoint is: `https://ACCOUNT_ID.r2.cloudflarestorage.com`
   (ACCOUNT_ID is your Cloudflare account ID)

### Step 4: Update CloudfilePhoto Model

```ruby
# app/models/cloudfile_photo.rb
class CloudfilePhoto < ActiveRecord::Base
  belongs_to :parent_photo, :class_name => :photo
  
  liquid_methods :original_url, :large_url, :thumb_url
  
  has_attached_file :photo,
    :styles => {
        :thumb => ["50x50#", :jpg],
        :large => ["550x420>", :jpg]
      },
    :storage => :s3,  # CHANGED from :cloud_files
    :s3_credentials => StreetprintSettings.s3_credentials,  # CHANGED
    :s3_options => StreetprintSettings.s3_options,  # NEW
    :path => ":attachment/:id/:style/:filename",  # Keep existing path structure
    :url => ":s3_domain_url"  # Use S3 URL generation
                    
  def original_url
    self.photo.url
  end
  def large_url
    self.photo.url(:large)
  end
  def thumb_url
    self.photo.url(:thumb)
  end
end
```

### Step 5: Update StreetprintSettings Model

```ruby
# app/models/streetprint_settings.rb
class StreetprintSettings < ActiveRecord::Base
  
  # Check if we should use cloud storage (now R2 instead of CloudFiles)
  def self.use_cloudfiles?
    instance = self.first
    return false if instance && !instance.use_cloudfiles
    return true if instance && !instance.cloudfiles_api_key.blank?
    return File.exists?("#{RAILS_ROOT}/config/cloudflare_r2.yml")
  end
  
  # Return S3-compatible credentials for Cloudflare R2
  def self.s3_credentials
    instance = self.first
    
    # Try database first (if you want to store credentials there)
    if instance && instance.cloudfiles_api_key
      {
        :access_key_id => instance.cloudfiles_username,  # Repurpose username field
        :secret_access_key => instance.cloudfiles_api_key,  # Repurpose api_key field
        :bucket => instance.cloudfiles_container  # Repurpose container field
      }
    else
      # Use YAML file
      "#{RAILS_ROOT}/config/cloudflare_r2.yml"
    end
  end
  
  # NEW: S3 options for R2 endpoint
  def self.s3_options
    config = load_r2_config
    options = {
      :endpoint => config['endpoint']
    }
    
    # Add custom URL if configured (for public access)
    options[:url] = config['url'] if config['url']
    
    options
  end
  
  private
  
  def self.load_r2_config
    config_file = "#{RAILS_ROOT}/config/cloudflare_r2.yml"
    if File.exists?(config_file)
      YAML.load_file(config_file)[RAILS_ENV]
    else
      {}
    end
  end
end
```

### Step 6: Update Paperclip S3 Backend (Monkey Patch)

Paperclip 2.3.1 might need a small patch to work with R2's S3-compatible endpoint:

```ruby
# config/initializers/paperclip_r2.rb
module Paperclip
  module Storage
    module S3
      def self.extended(base)
        base.instance_eval do
          @s3_credentials = parse_credentials(@options[:s3_credentials])
          @s3_options = @options[:s3_options] || {}
          @bucket_name = @s3_credentials[:bucket]
          @s3_permissions = @options[:s3_permissions] || 'public-read'
          @s3_protocol = @options[:s3_protocol] || 'https'
          @s3_headers = @options[:s3_headers] || {}
          @s3_host_alias = @options[:s3_host_alias]
          
          # Support custom endpoint for R2
          AWS::S3::Base.establish_connection!(
            :access_key_id => @s3_credentials[:access_key_id],
            :secret_access_key => @s3_credentials[:secret_access_key],
            :server => extract_host_from_endpoint(@s3_options[:endpoint])
          ) unless connected?
        end
      end
      
      def extract_host_from_endpoint(endpoint)
        return nil unless endpoint
        URI.parse(endpoint).host
      rescue
        nil
      end
    end
  end
end
```

Wait, actually for Rails 2.3.3 and old Paperclip, let me check if this approach will work...

### Step 6 (REVISED): Configure AWS-S3 Gem for R2

The `aws-s3` gem needs to be configured to use R2's endpoint. Add this initializer:

```ruby
# config/initializers/r2_storage.rb
if StreetprintSettings.use_cloudfiles?
  begin
    config = YAML.load_file("#{RAILS_ROOT}/config/cloudflare_r2.yml")[RAILS_ENV]
    
    # Extract endpoint details
    endpoint_uri = URI.parse(config['endpoint'])
    
    # Configure AWS::S3 to use R2 endpoint
    AWS::S3::Base.establish_connection!(
      :access_key_id     => config['access_key_id'],
      :secret_access_key => config['secret_access_key'],
      :server            => endpoint_uri.host,
      :port              => endpoint_uri.port || 443,
      :use_ssl           => true
    )
    
    puts "Connected to Cloudflare R2: #{config['bucket']}"
  rescue => e
    puts "Warning: Could not connect to R2: #{e.message}"
  end
end
```

### Step 7: Backup Database

```bash
# Always backup before making changes
mysqldump -u root streetprint_development > backup_before_r2.sql
mysqldump -u root streetprint_production > backup_production_before_r2.sql
```

### Step 8: Test in Development

```bash
# Start Rails console
ruby script/console

# Test configuration
StreetprintSettings.use_cloudfiles?
# => Should return true

StreetprintSettings.s3_credentials
# => Should show your R2 credentials

# Test loading a photo
photo = Photo.first
photo.photo.url
# => Should return R2 URL

# Try to actually fetch the image URL
# Visit the URL in browser to verify it works
```

### Step 9: Test Photo Upload (Optional)

If you're testing uploads:

```ruby
# In Rails console
item = Item.first
photo = item.photos.build
photo.photo = File.open("/path/to/test/image.jpg")
photo.save

# Check if it uploaded to R2
photo.photo.url
# Visit URL to verify
```

---

## Alternative: Simple Approach (If Above is Too Complex)

If Paperclip 2.3.1 doesn't play nice with R2, here's a **simpler fallback**:

### Update CloudfilePhoto to Generate R2 URLs Directly

```ruby
# app/models/cloudfile_photo.rb
class CloudfilePhoto < ActiveRecord::Base
  belongs_to :parent_photo, :class_name => :photo
  
  liquid_methods :original_url, :large_url, :thumb_url
  
  # Keep Paperclip config but override URL methods
  has_attached_file :photo,
    :styles => {
        :thumb => ["50x50#", :jpg],
        :large => ["550x420>", :jpg]
      },
    :storage => :cloud_files,  # Keep as-is, but won't be used for reads
    :cloudfiles_credentials => StreetprintSettings.cloudfiles_credentials
  
  # Override URL methods to point to R2
  def original_url
    generate_r2_url(:original)
  end
  
  def large_url
    generate_r2_url(:large)
  end
  
  def thumb_url
    generate_r2_url(:thumb)
  end
  
  private
  
  def generate_r2_url(style)
    return nil unless photo_file_name
    
    # Get R2 public URL from settings
    base_url = StreetprintSettings.r2_public_url
    
    # Construct path (matches Paperclip's default path)
    path = "photo/#{id}/#{style}/#{photo_file_name}"
    
    "#{base_url}/#{path}"
  end
end
```

```ruby
# app/models/streetprint_settings.rb
class StreetprintSettings < ActiveRecord::Base
  
  # ... existing methods ...
  
  def self.r2_public_url
    # Option 1: Custom domain
    "https://photos.yourdomain.com"
    
    # Option 2: R2 public URL
    # "https://pub-XXXXX.r2.dev"
    
    # Option 3: From config file
    # config = YAML.load_file("#{RAILS_ROOT}/config/cloudflare_r2.yml")[RAILS_ENV]
    # config['url'] || config['endpoint']
  end
end
```

This approach:
- ✅ Doesn't require changing Paperclip storage backend
- ✅ Just overrides URL generation
- ✅ Works immediately for serving files from R2
- ❌ Won't handle new uploads to R2 (but you said it's read-only anyway)

---

## Testing Checklist

- [ ] R2 credentials configured
- [ ] Gems installed successfully
- [ ] Rails console loads without errors
- [ ] Photo URLs generate correctly
- [ ] Photos display in browser
- [ ] No 403/404 errors on images
- [ ] All image styles work (original, large, thumb)
- [ ] Production-like test successful

---

## Rollback Plan

If something goes wrong:

```bash
# Restore database
mysql -u root streetprint_development < backup_before_r2.sql

# Revert code changes
git checkout config/environment.rb
git checkout app/models/cloudfile_photo.rb
git checkout app/models/streetprint_settings.rb

# Reinstall old gems
gem install paperclip-cloudfiles -v 2.3.1.1.4
```

---

## Which Approach Should You Use?

**Use SIMPLE APPROACH if:**
- ✅ Site is read-only (no new photo uploads)
- ✅ Files already in R2 with same paths
- ✅ Just need to serve existing images
- ✅ Want minimal code changes

**Use FULL APPROACH if:**
- ✅ Need to upload new photos to R2
- ✅ Want proper S3 integration
- ✅ Planning to stay on this stack longer-term

Given you said it's read-only, I'd recommend the **SIMPLE APPROACH**.

---

## Need Help?

Questions to answer:
1. What's your R2 public URL or custom domain?
2. Are you uploading new files, or just serving existing?
3. Do you have R2 API credentials ready?
