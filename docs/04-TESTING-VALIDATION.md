# StreetPrint 5 - Testing & Validation Checklist

**Document Version:** 1.0  
**Date:** January 2026

---

## Testing Strategy

This document provides comprehensive testing and validation procedures for each phase of the migration.

---

## Phase-by-Phase Testing

### Phase 1: Image URL Update

**Pre-Migration Tests:**
```bash
rails console
```

```ruby
# Count photos with old URLs
CloudfilePhoto.where("photo_file_name LIKE ?", "%rackspace%").count
CloudfilePhoto.where("photo_file_name LIKE ?", "%clouddrive%").count

# Sample URLs
CloudfilePhoto.first(3).pluck(:photo_file_name)
```

**Post-Migration Tests:**
```ruby
# Verify no old URLs remain
CloudfilePhoto.where("photo_file_name LIKE ?", "%rackspace%").count
# => Should be 0

# Verify new URLs
CloudfilePhoto.first.photo_file_name
# => Should contain s3.amazonaws.com or r2.dev

# Test image accessibility
require 'open-uri'
url = CloudfilePhoto.first.photo_file_name
URI.open(url)
# => Should download successfully (no 403/404)
```

**Checklist:**
- [ ] All Rackspace URLs updated
- [ ] All CloudDrive URLs updated
- [ ] Sample images accessible at new URLs
- [ ] No 403 Forbidden errors
- [ ] No 404 Not Found errors
- [ ] Database backup created

---

### Phase 2: New Rails Project

**Tests:**
```bash
# Ruby version correct
ruby --version
# => ruby 3.3.7

# Rails version correct
rails --version
# => Rails 7.2.x

# Database connection works
rails console
```

```ruby
ActiveRecord::Base.connection.execute("SELECT 1")
# => Should succeed

exit
```

```bash
# Rails server starts
rails server
# Visit http://localhost:3000
# Should see Rails welcome page
```

**Checklist:**
- [ ] Ruby 3.3.7 installed
- [ ] Rails 7.2.x installed
- [ ] MySQL connection working
- [ ] Databases created
- [ ] Rails server starts
- [ ] Gemfile has all required gems
- [ ] bundle install successful

---

### Phase 3: Migration Porting

**Pre-Migration Tests:**
```bash
# Count migrations
ls db/migrate/*.rb | wc -l
# Should be 109 (108 + ActiveStorage)

# Check first migration syntax
head -20 db/migrate/20090505193656_create_users.rb
# Should have < ActiveRecord::Migration[7.2]
```

**During Migration:**
```bash
# Run each migration individually
rails db:migrate:up VERSION=20090505193656

# Check for errors
# Fix and re-run if needed
```

**Post-Migration Tests:**
```bash
rails db:migrate:status
# All migrations should show "up"

# Generate schema
rails db:schema:dump

# Compare schemas
ruby scripts/compare_schemas.rb
```

```ruby
rails console

# Verify tables exist
ActiveRecord::Base.connection.tables.count
# => Should be ~37 + 3 ActiveStorage tables

# Check specific tables
ActiveRecord::Base.connection.tables.include?("items")
# => true

ActiveRecord::Base.connection.tables.include?("photos")
# => true

ActiveRecord::Base.connection.tables.include?("active_storage_blobs")
# => true

# Check table structure
ActiveRecord::Base.connection.columns(:items).map(&:name)
# => Should include: id, title, site_id, created_at, etc.
```

**Checklist:**
- [ ] All 108 migrations run successfully
- [ ] ActiveStorage migration ran
- [ ] All tables created
- [ ] Schema matches old database
- [ ] No migration errors
- [ ] Schema comparison reviewed

---

### Phase 4: Data Migration

**Pre-Import Tests:**
```bash
# Verify export file exists
ls -lh data_export.sql
# Should show file size

# Check export contents
head -100 data_export.sql
tail -100 data_export.sql
# Should show INSERT statements
```

**Post-Import Tests:**
```ruby
rails console

# Compare record counts
counts = {
  'Sites' => Site.count,
  'Items' => Item.count,
  'Photos' => Photo.count,
  'CloudfilePhotos' => CloudfilePhoto.count,
  'LocalPhotos' => LocalPhoto.count,
  'Users' => User.count,
  'Authors' => Author.count,
  'Categories' => Category.count,
  'MediaFiles' => MediaFile.count
}

counts.each { |k,v| puts "#{k}: #{v}" }

# Test associations
item = Item.first
item.photos.count
item.authors.count
item.site.name

# Test data integrity
Item.where(title: nil).count
# => Should be 0

Item.where.missing(:site).count
# => Should be 0

# Sample data looks correct
Item.first(3).each do |item|
  puts "#{item.id}: #{item.title}"
end
```

```bash
# Run validation rake task
rails data:validate
```

**Checklist:**
- [ ] All record counts match source database
- [ ] No orphaned records
- [ ] Associations work correctly
- [ ] No null critical fields
- [ ] Sample data looks correct
- [ ] Validation report passes

---

### Phase 5: ActiveStorage Migration

**Pre-Migration Tests:**
```ruby
rails console

# ActiveStorage tables exist
ActiveRecord::Base.connection.tables.include?("active_storage_blobs")
# => true

# Photo model updated
photo = Photo.first
photo.respond_to?(:image)
# => true

# Source photos exist
photo.source_photo.present?
# => true
```

**During Migration:**
```bash
# Test single photo first
rails console
```

```ruby
photo = Photo.first
source = photo.source_photo

# Manual test
require 'open-uri'
file = URI.open(source.photo_file_name)
photo.image.attach(
  io: file,
  filename: File.basename(source.photo_file_name),
  content_type: source.photo_content_type
)

photo.image.attached?
# => true

photo.thumb_url
# => Should return URL
```

```bash
# Run full migration
rails photos:migrate
```

**Post-Migration Tests:**
```ruby
rails console

# Check migration stats
total = Photo.count
migrated = Photo.joins(:image_attachment).count
puts "#{migrated} of #{total} photos migrated (#{(migrated.to_f/total*100).round(1)}%)"

# Test URLs
photo = Photo.joins(:image_attachment).first
puts photo.thumb_url
puts photo.large_url
puts photo.original_url

# Test variants
photo.thumb
# => Should return variant

# Test rendering
# In a view or Rails console:
Rails.application.routes.url_helpers.rails_blob_url(photo.image, only_path: true)
# => Should return path

# Check blob storage
ActiveStorage::Blob.count
# => Should match migrated photo count

# Test a few images in browser
# Visit the URLs from thumb_url, large_url
```

**Checklist:**
- [ ] ActiveStorage tables populated
- [ ] 95%+ photos migrated
- [ ] Blob records created
- [ ] Attachment records created
- [ ] Image URLs generate correctly
- [ ] Sample images display in browser
- [ ] Variants generate correctly
- [ ] No 404 errors on images

---

### Phase 6: Model Porting

**Tests:**
```ruby
rails console

# Models load without errors
Site
Item
Photo
Author
Category
User

# Validations work
item = Item.new
item.valid?
# => false
item.errors.messages
# => Should show title and site_id required

# Associations work
site = Site.first
site.items.count
site.authors.count

item = Item.first
item.photos.count
item.authors.count
item.categories.count

# Callbacks work
item = Item.create!(
  title: "Test",
  site: Site.first,
  year: 2020,
  month: 6,
  day: 15
)
item.date
# => Should be Date object: 2020-06-15

# Liquid serialization works
item.to_liquid.class
# => Hash

item.to_liquid.keys
# => Should include: id, title, authors, images, etc.

# Navigation methods
item.next_by_id
item.previous_by_id
```

**Checklist:**
- [ ] All models load without errors
- [ ] Validations enforced
- [ ] Associations configured correctly
- [ ] Callbacks execute
- [ ] Scopes work
- [ ] to_liquid methods return valid data
- [ ] No deprecated syntax warnings

---

### Phase 7: Views (Read-Only)

**Tests:**
```bash
# Start server
rails server

# Visit pages:
# http://localhost:3000
# http://localhost:3000/sites
# http://localhost:3000/sites/1
# http://localhost:3000/items
# http://localhost:3000/items/1
# http://localhost:3000/authors
# http://localhost:3000/authors/1
```

**Manual Testing:**
- [ ] Homepage loads
- [ ] Sites index shows list
- [ ] Site show page displays
- [ ] Items index shows list
- [ ] Item show page displays
- [ ] Images display correctly
- [ ] No broken image links
- [ ] Authors display
- [ ] Categories display
- [ ] Navigation links work
- [ ] Pagination works
- [ ] No JavaScript errors in console
- [ ] Responsive design works

**Performance Tests:**
```ruby
# Check for N+1 queries
# Install bullet gem (development)

# In browser, check Rails logs for:
# - Number of queries per request
# - Query execution time
# - Total request time
```

**Checklist:**
- [ ] All public pages render
- [ ] Images display from ActiveStorage
- [ ] No 500 errors
- [ ] No N+1 queries
- [ ] Reasonable page load times (<1s)
- [ ] CSS loads correctly
- [ ] Mobile responsive

---

### Phase 8: Authentication & Edit

**If Implementing Auth:**

```ruby
rails console

# User model works
User.first

# Devise methods available
user = User.first
user.respond_to?(:valid_password?)
# => true
```

**Manual Testing:**
- [ ] Login page displays
- [ ] Can log in with test user
- [ ] Can log out
- [ ] Password reset works (if enabled)
- [ ] Unauthorized redirects work

**Edit Functionality:**
```bash
# Visit edit pages:
# http://localhost:3000/items/1/edit
# http://localhost:3000/items/new
```

- [ ] Edit form displays
- [ ] Can update item
- [ ] Validations work on update
- [ ] Nested attributes work (authors, photos)
- [ ] Image upload works
- [ ] Strong parameters enforced
- [ ] CSRF protection works
- [ ] Flash messages display

---

## Integration Testing

### Critical User Flows

**Flow 1: Browse Items**
1. Visit homepage
2. Click on site
3. Browse items list
4. Click on item
5. View item details
6. Click on author
7. View author's items

**Flow 2: Search (if implemented)**
1. Enter search query
2. View results
3. Filter by category
4. Sort results
5. Click result

**Flow 3: View Item Details**
1. Navigate to item
2. View all photos
3. Click photo to enlarge
4. Read full text
5. Click next/previous item

### Browser Testing Matrix

| Browser | Version | Status |
|---------|---------|--------|
| Chrome | Latest | [ ] |
| Firefox | Latest | [ ] |
| Safari | Latest | [ ] |
| Edge | Latest | [ ] |
| Mobile Safari | iOS 15+ | [ ] |
| Mobile Chrome | Latest | [ ] |

---

## Performance Testing

### Page Load Benchmarks

| Page | Target | Actual |
|------|--------|--------|
| Homepage | <500ms | ___ ms |
| Site index | <1s | ___ ms |
| Item show | <1s | ___ ms |
| Item index | <2s | ___ ms |
| Search results | <2s | ___ ms |

### Database Query Benchmarks

```ruby
# Use bullet gem to detect N+1 queries

# Measure query counts
Item.first.photos.count
# Should use: 2 queries (Item + Photos)
# Not: N+1 queries per photo

Site.first.items.count
# Should use: 2 queries (Site + Items count)
```

### Image Loading

- [ ] Images lazy load
- [ ] Variants generated on-demand
- [ ] CDN delivers images (if configured)
- [ ] Image optimization works

---

## Security Testing

### Security Checklist

**Application Security:**
- [ ] CSRF protection enabled
- [ ] SQL injection protection (ActiveRecord)
- [ ] XSS prevention (ERB auto-escaping)
- [ ] Mass assignment protection (strong params)
- [ ] Secure session cookies
- [ ] HTTPS enforced (production)
- [ ] Content Security Policy configured

**Dependency Security:**
```bash
# Run security audit
bundle audit check --update

# Run Brakeman
bundle exec brakeman -q

# Check for known vulnerabilities
```

- [ ] No known vulnerabilities in gems
- [ ] Brakeman passes (or reviewed/ignored)
- [ ] Secrets not committed to git
- [ ] Environment variables used for credentials

**Access Control:**
- [ ] Unauthenticated users can't edit
- [ ] Users can only edit their content
- [ ] Admin functions protected
- [ ] File upload restrictions work

---

## Data Validation Final Check

### Complete Data Audit

```bash
rails data:validate
```

**Expected Results:**
```
✅ All record counts match
✅ No orphaned records
✅ No null critical fields
✅ 95%+ photos migrated
✅ All associations intact
✅ Date ranges match source
✅ Liquid serialization works
```

### Sample Content Review

Manually review 10-20 items:
- [ ] Titles display correctly
- [ ] Dates show properly
- [ ] Images match original
- [ ] Authors listed correctly
- [ ] Categories assigned correctly
- [ ] Full text readable
- [ ] Links work
- [ ] Metadata preserved

---

## Load Testing (Optional)

### Using Apache Bench

```bash
# Test homepage
ab -n 1000 -c 10 http://localhost:3000/

# Test item page
ab -n 1000 -c 10 http://localhost:3000/items/1

# Analyze results:
# - Requests per second
# - Average response time
# - 95th percentile
```

### Database Connection Pool

```ruby
# config/database.yml
pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

# Monitor during load test
rails console
```

```ruby
ActiveRecord::Base.connection_pool.stat
# => Check: size, connections, busy, idle
```

---

## Acceptance Criteria

### Must Pass

✅ All phases complete without critical errors  
✅ Data validation passes 100%  
✅ All core features functional  
✅ No security vulnerabilities (high/critical)  
✅ Images display correctly  
✅ Performance within targets  
✅ Mobile responsive  
✅ Browser compatibility verified  

### Should Pass

✅ Search functionality works  
✅ Edit functionality works (if implemented)  
✅ All tests green  
✅ Code quality checks pass  
✅ Documentation complete  

---

## Sign-Off Checklist

### Technical Sign-Off

- [ ] Lead Developer approves code
- [ ] Database migrations verified
- [ ] Security audit passed
- [ ] Performance benchmarks met
- [ ] All critical bugs resolved

### Business Sign-Off

- [ ] Content displays correctly
- [ ] User workflows function
- [ ] Data integrity verified
- [ ] No data loss
- [ ] Ready for production

---

## Rollback Criteria

**Rollback if:**
- Data loss detected (>1% records)
- Critical security vulnerability
- Performance degradation >50%
- Core functionality broken
- Majority of images not displaying
- Database corruption

**Rollback Procedure:**
1. Switch DNS back to old application
2. Restore database from pre-migration backup
3. Document issues encountered
4. Plan fixes before retry

---

**Document Owner:** QA Lead / Implementation Team  
**Last Updated:** January 2026  
**Status:** Ready for Use
