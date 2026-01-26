# AWS S3 Migration for Existing Rails 2.3.3 App

**Goal:** Switch existing app to serve images from AWS S3 (bucket: streetprint5)

**Time:** 30 minutes - 1 hour

---

## Your S3 Setup

- **Bucket:** `streetprint5`
- **Region:** `us-east-1`
- **Access:** Public read ✅
- **Path pattern:** `photos/{photo_id}/{style}/{filename}`
- **Base URL:** `https://streetprint5.s3.us-east-1.amazonaws.com/`

**Example URL:**
```
https://streetprint5.s3.us-east-1.amazonaws.com/photos/1000/large/198-1958medium.jpg
```

---

## Simple Solution: Override URL Methods

Since the bucket is **public read** and files are already uploaded, we just need to point the photo URLs to S3.

### Step 1: Update CloudfilePhoto Model

```bash
# Edit the file
open app/models/cloudfile_photo.rb
```

**Replace entire file with:**

```ruby
# app/models/cloudfile_photo.rb
class CloudfilePhoto < ActiveRecord::Base
  belongs_to :parent_photo, :class_name => :photo
  
  liquid_methods :original_url, :large_url, :thumb_url
  
  # Keep Paperclip config (for backward compatibility / future use)
  has_attached_file :photo,
    :styles => {
        :thumb => ["50x50#", :jpg],
        :large => ["550x420>", :jpg]
      },
    :storage => :cloud_files,
    :cloudfiles_credentials => StreetprintSettings.cloudfiles_credentials
  
  # S3 Configuration
  S3_BUCKET = "streetprint5"
  S3_REGION = "us-east-1"
  S3_BASE_URL = "https://#{S3_BUCKET}.s3.#{S3_REGION}.amazonaws.com"
  
  # Override URL methods to point to S3
  def original_url
    return nil unless photo_file_name
    "#{S3_BASE_URL}/photos/#{photo_id}/original/#{photo_file_name}"
  end
  
  def large_url
    return nil unless photo_file_name
    "#{S3_BASE_URL}/photos/#{photo_id}/large/#{photo_file_name}"
  end
  
  def thumb_url
    return nil unless photo_file_name
    "#{S3_BASE_URL}/photos/#{photo_id}/thumb/#{photo_file_name}"
  end
end
```

### Step 2: Test in Rails Console

```bash
cd /Users/madsen/Developer/StreetLabs/sp5
ruby script/console
```

```ruby
# Load a photo
photo = CloudfilePhoto.find(1000)

# Check the photo_id and filename
puts "Photo ID: #{photo.photo_id}"
puts "Filename: #{photo.photo_file_name}"

# Test URL generation
puts photo.original_url
# => Should output: https://streetprint5.s3.us-east-1.amazonaws.com/photos/1000/original/198-1958medium.jpg

puts photo.large_url
# => Should output: https://streetprint5.s3.us-east-1.amazonaws.com/photos/1000/large/198-1958medium.jpg

puts photo.thumb_url
# => Should output: https://streetprint5.s3.us-east-1.amazonaws.com/photos/1000/thumb/198-1958medium.jpg

# Test via Photo model
photo_wrapper = Photo.find_by_id(1000)
if photo_wrapper
  puts photo_wrapper.photo.url
  puts photo_wrapper.thumb_url
  puts photo_wrapper.large_url
end

exit
```

### Step 3: Verify URLs in Browser

Copy one of the URLs from the console test and paste into your browser:

```
https://streetprint5.s3.us-east-1.amazonaws.com/photos/1000/large/198-1958medium.jpg
```

✅ **Should display the image**  
❌ If you get 403/404, check the S3 path structure

### Step 4: Start Rails Server and Test

```bash
# Start server
ruby script/server

# Visit your app
# http://localhost:3000
# Navigate to pages with images
```

**Check:**
- [ ] Images display correctly
- [ ] No broken image links
- [ ] Browser console shows no 404 errors
- [ ] All image sizes work (thumb, large, original)

---

## If Images Don't Display

### Check S3 Path Structure

Your S3 path should be:
```
photos/{photo_id}/{style}/{filename}
```

**Verify in console:**

```ruby
cf_photo = CloudfilePhoto.find(1000)
puts "Photo ID: #{cf_photo.photo_id}"
puts "Filename: #{cf_photo.photo_file_name}"
puts "Expected path: photos/#{cf_photo.photo_id}/large/#{cf_photo.photo_file_name}"
```

Then check if that exact path exists in S3.

### Check S3 Bucket Permissions

Ensure bucket policy allows public read:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::streetprint5/*"
    }
  ]
}
```

---

## Update LocalPhoto Too (If You Have Local Photos)

```ruby
# app/models/local_photo.rb
class LocalPhoto < ActiveRecord::Base
  belongs_to :parent_photo, :class_name => :photo
  
  liquid_methods :original_url, :large_url, :thumb_url
  
  has_attached_file :photo, 
    :path => ":rails_root/public/system/local/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "/system/local/:attachment/:rails_env/:id/:style/:basename.:extension",
    :styles => {
      :thumb => ["50x50#", :jpg],
      :large => ["550x420>", :jpg]
    }
  
  # These can stay the same (serving from local filesystem)
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

Or if you've also moved local photos to S3, update them similarly.

---

## Optional: Environment-Specific Configuration

If you want different S3 buckets per environment:

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
    :storage => :cloud_files,
    :cloudfiles_credentials => StreetprintSettings.cloudfiles_credentials
  
  # S3 Configuration per environment
  S3_CONFIG = {
    'development' => {
      bucket: 'streetprint5-dev',
      region: 'us-east-1'
    },
    'production' => {
      bucket: 'streetprint5',
      region: 'us-east-1'
    },
    'test' => {
      bucket: 'streetprint5-test',
      region: 'us-east-1'
    }
  }
  
  def self.s3_base_url
    config = S3_CONFIG[RAILS_ENV] || S3_CONFIG['production']
    "https://#{config[:bucket]}.s3.#{config[:region]}.amazonaws.com"
  end
  
  def original_url
    return nil unless photo_file_name
    "#{self.class.s3_base_url}/photos/#{photo_id}/original/#{photo_file_name}"
  end
  
  def large_url
    return nil unless photo_file_name
    "#{self.class.s3_base_url}/photos/#{photo_id}/large/#{photo_file_name}"
  end
  
  def thumb_url
    return nil unless photo_file_name
    "#{self.class.s3_base_url}/photos/#{photo_id}/thumb/#{photo_file_name}"
  end
end
```

---

## Deploy to Production

Once tested in development:

1. **Commit changes**
```bash
git add app/models/cloudfile_photo.rb
git commit -m "Switch to AWS S3 for image serving"
```

2. **Deploy** (using your deployment method)
```bash
# Example if using Capistrano:
cap production deploy

# Or manual:
# - SSH to server
# - Pull code
# - Restart Rails app
```

3. **Verify production**
- Visit production site
- Check images display
- Test a few different items with photos

---

## Rollback Plan

If something goes wrong:

```bash
# Revert the change
git revert HEAD

# Or restore from backup
git checkout HEAD~1 app/models/cloudfile_photo.rb

# Redeploy
```

---

## Success Checklist

- [ ] CloudfilePhoto model updated
- [ ] Rails console test successful
- [ ] URLs generate correctly
- [ ] Images display in browser
- [ ] No 404/403 errors
- [ ] All image styles work (original, large, thumb)
- [ ] Development environment working
- [ ] Production deployment successful
- [ ] Production site images display

---

## That's It!

This is the minimal change needed. You're just:
1. Overriding the URL methods
2. Pointing to S3 instead of Rackspace
3. Everything else stays the same

**Time to implement:** ~30 minutes  
**Risk level:** Very low (just URL generation)  
**Rollback:** Easy (revert one file)

---

## Questions?

- Are all photos following the `photos/{id}/{style}/{filename}` pattern?
- Do you have both CloudfilePhoto and LocalPhoto records?
- Do you need different buckets for dev/staging/production?
