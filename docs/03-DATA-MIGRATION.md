# StreetPrint 5 - Data Migration Specification

**Document Version:** 1.0  
**Date:** January 2026

---

## Overview

This document specifies the complete data migration strategy from the legacy Rails 2.3.3 application to the new Rails 7.2 application.

---

## Database Schema Mapping

### Tables to Migrate (37 total)

| Table | Records (est.) | Priority | Dependencies |
|-------|---------------|----------|--------------|
| sites | ~10-50 | P0 | None |
| users | ~50-200 | P1 | None |
| document_types | ~10-30 | P0 | sites |
| categories | ~20-100 | P0 | sites |
| authors | ~100-500 | P0 | sites |
| items | ~1000-10000 | P0 | sites, document_types |
| photos | ~5000-50000 | P0 | items |
| cloudfile_photos | ~5000-50000 | P0 | photos |
| local_photos | ~100-1000 | P0 | photos |
| media_files | ~100-1000 | P1 | items |
| authored | ~1000-10000 | P0 | items, authors |
| categorizations | ~2000-20000 | P0 | items, categories |
| custom_datas | ~100-1000 | P1 | items |
| custom_data_types | ~10-50 | P1 | sites |
| narratives | ~10-100 | P1 | sites |
| sections | ~50-500 | P1 | narratives |
| news_posts | ~10-100 | P1 | sites |
| memberships | ~50-200 | P1 | sites, users |
| roles | ~5-20 | P1 | None |
| roles_users | ~50-200 | P1 | users, roles |
| site_themes | ~10-50 | P1 | users |
| *_templates (8 types) | ~80-400 | P1 | site_themes |
| theme_images | ~50-200 | P1 | site_themes |
| streetprint_settings | 1 | P2 | None |
| pages | ~5-20 | P2 | None |

---

## Data Export Strategy

### Export Script

```bash
#!/bin/bash
# scripts/export_data.sh

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups/${TIMESTAMP}"
mkdir -p "${BACKUP_DIR}"

echo "Exporting data to ${BACKUP_DIR}"

# Full database backup (schema + data)
mysqldump -u root streetprint_production > "${BACKUP_DIR}/full_backup.sql"

# Data only (for import to new schema)
mysqldump -u root \
  --no-create-info \
  --skip-triggers \
  --complete-insert \
  --extended-insert=FALSE \
  streetprint_production > "${BACKUP_DIR}/data_only.sql"

# Per-table exports (for granular import)
TABLES="sites users document_types categories authors items photos cloudfile_photos local_photos media_files"

for table in $TABLES; do
  mysqldump -u root \
    --no-create-info \
    --complete-insert \
    streetprint_production $table > "${BACKUP_DIR}/${table}.sql"
  echo "Exported ${table}"
done

# Export counts for validation
mysql -u root streetprint_production -e "
SELECT 'items' as table_name, COUNT(*) as count FROM items
UNION ALL SELECT 'photos', COUNT(*) FROM photos
UNION ALL SELECT 'sites', COUNT(*) FROM sites
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'authors', COUNT(*) FROM authors
UNION ALL SELECT 'categories', COUNT(*) FROM categories;
" > "${BACKUP_DIR}/record_counts.txt"

echo "Export complete: ${BACKUP_DIR}"
```

---

## Image Asset Migration

### Current Image Storage

**CloudFile Photos:**
- Stored in: Rackspace Cloud Files (deprecated)
- Migrated to: AWS S3 / Cloudflare R2
- URL pattern: `https://s3.amazonaws.com/streetprint-production/[filename]`
- Count: Majority of photos

**Local Photos:**
- Stored in: `public/system/local/photo/[env]/[id]/[style]/[filename]`
- Migration: Copy to ActiveStorage blob storage
- Count: Smaller subset

### Image Migration Process

```
┌────────────────────────────────────────────┐
│ 1. URL Update (Phase 1)                    │
│    Rackspace → S3/Cloudflare URLs          │
└─────────────────┬──────────────────────────┘
                  │
┌─────────────────▼──────────────────────────┐
│ 2. Data Import (Phase 4)                   │
│    CloudfilePhoto records with new URLs    │
└─────────────────┬──────────────────────────┘
                  │
┌─────────────────▼──────────────────────────┐
│ 3. ActiveStorage Migration (Phase 5)       │
│    Download from S3 → ActiveStorage blobs  │
│    Create active_storage_blobs records     │
│    Create active_storage_attachments       │
└────────────────────────────────────────────┘
```

### Image Migration Rake Task

See Phase 5 in Implementation Guide for full `photos:migrate` task.

**Key Operations:**
1. Iterate through Photo records
2. Find CloudfilePhoto or LocalPhoto source
3. Download/read image file
4. Attach to ActiveStorage
5. Generate variants (thumb, large)
6. Verify attachment successful

---

## Data Import Process

### Import Order (Critical)

Import must follow dependency order:

```
1. Sites (no dependencies)
2. Users (no dependencies)
3. Roles (no dependencies)
4. SiteThemes (depends on users)
5. DocumentTypes (depends on sites)
6. Categories (depends on sites)
7. Authors (depends on sites)
8. CustomDataTypes (depends on sites)
9. Items (depends on sites, document_types)
10. Photos (depends on items)
11. CloudfilePhotos (depends on photos)
12. LocalPhotos (depends on photos)
13. MediaFiles (depends on items)
14. Authored (depends on items, authors)
15. Categorizations (depends on items, categories)
16. CustomDatas (depends on items, custom_data_types)
17. Narratives (depends on sites)
18. Sections (depends on narratives, items as polymorphic media)
19. NewsPosts (depends on sites)
20. Memberships (depends on sites, users)
21. RolesUsers (depends on users, roles)
22. *Templates (depends on site_themes)
23. ThemeImages (depends on site_themes)
```

### Import Script

```bash
#!/bin/bash
# scripts/import_data.sh

BACKUP_DIR=$1

if [ -z "$BACKUP_DIR" ]; then
  echo "Usage: $0 <backup_directory>"
  exit 1
fi

DB_NAME="streetprint_new_development"

echo "Importing data from ${BACKUP_DIR} to ${DB_NAME}"

# Disable foreign key checks during import
mysql -u root $DB_NAME -e "SET FOREIGN_KEY_CHECKS=0;"

# Import in dependency order
TABLES=(
  "sites"
  "users"
  "roles"
  "site_themes"
  "document_types"
  "categories"
  "authors"
  "custom_data_types"
  "items"
  "photos"
  "cloudfile_photos"
  "local_photos"
  "media_files"
  "authored"
  "categorizations"
  "custom_datas"
  "narratives"
  "sections"
  "news_posts"
  "memberships"
  "roles_users"
)

for table in "${TABLES[@]}"; do
  if [ -f "${BACKUP_DIR}/${table}.sql" ]; then
    echo "Importing ${table}..."
    mysql -u root $DB_NAME < "${BACKUP_DIR}/${table}.sql"
  else
    echo "Warning: ${table}.sql not found, skipping"
  fi
done

# Import template tables (STI)
for template in browse_artifacts index_artifacts show_artifact show_author show_about \
                show_site show_full_text show_google_location show_news_posts \
                show_narrative index_narratives layout; do
  table="${template}_templates"
  if [ -f "${BACKUP_DIR}/${table}.sql" ]; then
    echo "Importing ${table}..."
    mysql -u root $DB_NAME < "${BACKUP_DIR}/${table}.sql"
  fi
done

# Re-enable foreign key checks
mysql -u root $DB_NAME -e "SET FOREIGN_KEY_CHECKS=1;"

echo "Import complete"
```

---

## Data Transformation Requirements

### Minimal Transformations

Most data can be imported as-is since we're maintaining schema compatibility.

**Required Transformations:**

1. **Image URLs** (Done in Phase 1)
   - CloudfilePhoto.photo_file_name: Rackspace → S3/Cloudflare

2. **User Passwords** (If migrating auth)
   - Authlogic → Devise password hash format
   - May require password resets for all users

3. **Timestamps** (Automatic)
   - Rails 7 may use more precise timestamp format
   - Should be compatible

**No Transformation Needed:**
- Primary keys (preserved)
- Foreign keys (preserved)
- Text content (UTF-8 compatible)
- Dates (DATE/DATETIME compatible)
- Boolean values (compatible)

---

## Data Validation

### Validation Queries

```sql
-- Record count comparison
SELECT 'items' as tbl, COUNT(*) FROM items UNION ALL
SELECT 'photos', COUNT(*) FROM photos UNION ALL
SELECT 'sites', COUNT(*) FROM sites UNION ALL
SELECT 'users', COUNT(*) FROM users UNION ALL
SELECT 'authors', COUNT(*) FROM authors UNION ALL
SELECT 'categories', COUNT(*) FROM categories;

-- Check for orphaned records
SELECT COUNT(*) as orphaned_photos 
FROM photos 
WHERE item_id NOT IN (SELECT id FROM items);

SELECT COUNT(*) as orphaned_items
FROM items
WHERE site_id NOT IN (SELECT id FROM sites);

-- Check for null critical fields
SELECT COUNT(*) as items_without_title FROM items WHERE title IS NULL;
SELECT COUNT(*) as items_without_site FROM items WHERE site_id IS NULL;

-- Date range validation
SELECT MIN(created_at) as earliest, MAX(created_at) as latest FROM items;
SELECT MIN(year) as earliest_year, MAX(year) as latest_year FROM items WHERE year IS NOT NULL;

-- Junction table validation
SELECT COUNT(*) as items_with_authors FROM items WHERE id IN (SELECT item_id FROM authored);
SELECT COUNT(*) as items_with_categories FROM items WHERE id IN (SELECT item_id FROM categorizations);
```

### Validation Rake Task

```ruby
# lib/tasks/validate_data.rake
namespace :data do
  desc "Comprehensive data validation"
  task validate: :environment do
    puts "="*70
    puts "DATA VALIDATION REPORT"
    puts "Generated: #{Time.current}"
    puts "="*70
    
    # Record counts
    puts "\n1. RECORD COUNTS"
    puts "-"*70
    [Site, Item, Photo, CloudfilePhoto, LocalPhoto, Author, Category,
     User, Narrative, NewsPost, MediaFile].each do |model|
      printf "%-25s %10d\n", model.name, model.count
    end
    
    # Orphaned records
    puts "\n2. ORPHANED RECORDS CHECK"
    puts "-"*70
    
    orphaned_photos = Photo.where.missing(:item).count
    puts "Photos without items: #{orphaned_photos}"
    
    orphaned_items = Item.where.missing(:site).count
    puts "Items without sites: #{orphaned_items}"
    
    orphaned_authors = Author.where.missing(:site).count
    puts "Authors without sites: #{orphaned_authors}"
    
    # Null checks
    puts "\n3. NULL VALUE CHECKS"
    puts "-"*70
    
    items_no_title = Item.where(title: nil).count
    puts "Items without title: #{items_no_title}"
    
    items_no_site = Item.where(site_id: nil).count
    puts "Items without site_id: #{items_no_site}"
    
    # Association counts
    puts "\n4. ASSOCIATION STATISTICS"
    puts "-"*70
    
    items_with_photos = Item.joins(:photos).distinct.count
    printf "Items with photos: %d of %d (%.1f%%)\n", 
      items_with_photos, Item.count, 
      (items_with_photos.to_f / Item.count * 100)
    
    items_with_authors = Item.joins(:authored).distinct.count
    printf "Items with authors: %d of %d (%.1f%%)\n",
      items_with_authors, Item.count,
      (items_with_authors.to_f / Item.count * 100)
    
    # Date ranges
    puts "\n5. DATE RANGES"
    puts "-"*70
    
    earliest_item = Item.minimum(:created_at)
    latest_item = Item.maximum(:created_at)
    puts "Items created between: #{earliest_item} and #{latest_item}"
    
    earliest_year = Item.where.not(year: nil).minimum(:year)
    latest_year = Item.where.not(year: nil).maximum(:year)
    puts "Item years range: #{earliest_year} to #{latest_year}"
    
    # ActiveStorage migration status
    puts "\n6. ACTIVESTORAGE MIGRATION"
    puts "-"*70
    
    total_photos = Photo.count
    migrated_photos = Photo.joins(:image_attachment).count
    percent_migrated = total_photos > 0 ? (migrated_photos.to_f / total_photos * 100) : 0
    
    printf "Photos migrated: %d of %d (%.1f%%)\n",
      migrated_photos, total_photos, percent_migrated
    
    # Errors and warnings
    puts "\n7. ERRORS & WARNINGS"
    puts "-"*70
    
    errors = []
    warnings = []
    
    errors << "Orphaned photos found!" if orphaned_photos > 0
    errors << "Orphaned items found!" if orphaned_items > 0
    errors << "Items without title!" if items_no_title > 0
    errors << "Items without site_id!" if items_no_site > 0
    
    warnings << "No photos migrated to ActiveStorage" if migrated_photos == 0
    warnings << "Some items missing photos" if items_with_photos < Item.count
    
    if errors.any?
      puts "❌ ERRORS:"
      errors.each { |e| puts "   - #{e}" }
    else
      puts "✅ No errors found"
    end
    
    if warnings.any?
      puts "\n⚠️  WARNINGS:"
      warnings.each { |w| puts "   - #{w}" }
    else
      puts "✅ No warnings"
    end
    
    puts "\n" + "="*70
    puts "VALIDATION COMPLETE"
    puts "="*70
  end
end
```

---

## Rollback Plan

### If Data Import Fails

```bash
# Drop and recreate database
rails db:drop db:create db:migrate

# Re-import from backup
./scripts/import_data.sh ./backups/[timestamp]
```

### If ActiveStorage Migration Fails

```bash
# Rollback ActiveStorage attachments
rails photos:rollback

# Keep legacy CloudfilePhoto/LocalPhoto working
# Photo model already has fallback to legacy system
```

### If Critical Data Missing

```bash
# Re-export from production
./scripts/export_data.sh

# Compare with previous export
diff backups/[old]/record_counts.txt backups/[new]/record_counts.txt

# Identify missing records and investigate
```

---

## Performance Considerations

### Import Optimization

```ruby
# Disable callbacks during import
Item.skip_callback(:save, :before, :set_date_from_fields)

# Bulk import with activerecord-import gem
gem 'activerecord-import'

# Import in batches
items_data.each_slice(1000) do |batch|
  Item.import batch, validate: false
end

# Re-enable callbacks
Item.set_callback(:save, :before, :set_date_from_fields)
```

### ActiveStorage Migration Optimization

- Process in background with Sidekiq
- Parallel processing (use multiple workers)
- Resume from failures (track migrated IDs)
- Use direct S3 to S3 copy (avoid downloading)

---

## Success Metrics

✅ 100% of records imported  
✅ 0 orphaned records  
✅ 0 null critical fields  
✅ 95%+ photos migrated to ActiveStorage  
✅ All associations intact  
✅ Date ranges match source  
✅ Sample content renders correctly  

---

**Document Owner:** Implementation Team  
**Last Updated:** January 2026
