# StreetPrint 5 - Technical Architecture

**Document Version:** 1.0  
**Date:** January 2026  
**Status:** Planning

---

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Application Layers](#application-layers)
3. [Data Model](#data-model)
4. [Storage Architecture](#storage-architecture)
5. [Authentication & Authorization](#authentication--authorization)
6. [Template System](#template-system)
7. [Search Architecture](#search-architecture)
8. [Deployment Architecture](#deployment-architecture)
9. [Technology Decisions](#technology-decisions)
10. [Migration Strategy](#migration-strategy)

---

## System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Load Balancer / CDN                   │
│                  (Cloudflare / CloudFront)               │
└────────────────────────┬────────────────────────────────┘
                         │
         ┌───────────────┴───────────────┐
         │                               │
┌────────▼────────┐            ┌─────────▼────────┐
│  Static Assets  │            │  Rails App       │
│  (S3/R2 + CDN)  │            │  (Docker)        │
└─────────────────┘            └─────────┬────────┘
                                         │
                    ┌────────────────────┼────────────────┐
                    │                    │                │
          ┌─────────▼────────┐  ┌───────▼──────┐  ┌──────▼──────┐
          │  MySQL Database  │  │  S3/R2       │  │  Search     │
          │  (Data)          │  │  (Images)    │  │  (Optional) │
          └──────────────────┘  └──────────────┘  └─────────────┘
```

### Components

1. **CDN Layer** - Cloudflare or AWS CloudFront
   - Static asset delivery
   - Image caching and optimization
   - DDoS protection
   - SSL/TLS termination

2. **Application Layer** - Rails 7.2
   - Web server (Puma)
   - Application logic
   - View rendering
   - API endpoints (future)

3. **Data Layer** - MySQL 8.x
   - Relational data storage
   - Full-text search (basic)
   - Transaction management

4. **Storage Layer** - AWS S3 or Cloudflare R2
   - Image storage
   - File attachments
   - Theme assets
   - Variant caching

5. **Search Layer** - Optional
   - Meilisearch (recommended)
   - Elasticsearch (enterprise)
   - MySQL fulltext (fallback)

---

## Application Layers

### MVC Architecture

```
┌──────────────────────────────────────────────────────┐
│                    Routes (config/routes.rb)          │
└────────────────────────┬─────────────────────────────┘
                         │
         ┌───────────────┴───────────────┐
         │                               │
┌────────▼────────┐            ┌─────────▼─────────┐
│   Controllers   │            │   API Controllers │
│   (HTML views)  │            │   (JSON)          │
└────────┬────────┘            └─────────┬─────────┘
         │                               │
         │     ┌─────────────────────────┘
         │     │
┌────────▼─────▼────────┐
│      Models           │
│  (Business Logic)     │
│  - Item               │
│  - Photo              │
│  - Site               │
│  - Author             │
└────────┬──────────────┘
         │
┌────────▼──────────────┐
│   ActiveRecord        │
│   (Data Access)       │
└────────┬──────────────┘
         │
┌────────▼──────────────┐
│   MySQL Database      │
└───────────────────────┘
```

### Layer Responsibilities

**Routes**
- URL mapping to controllers
- Subdomain routing (multi-tenant)
- Namespace organization
- RESTful resource routing

**Controllers**
- Request handling
- Parameter validation (strong params)
- Authorization checks
- Response rendering
- Session management

**Models**
- Business logic
- Data validation
- Associations
- Callbacks
- Liquid serialization
- Search integration

**Views**
- Template rendering (ERB)
- Liquid template execution
- Partial composition
- Helper methods
- Asset references

**Services** (Optional layer)
- Complex operations
- External API integration
- Photo migration scripts
- Data export/import

---

## Data Model

### Core Entities

```
┌─────────────────────────────────────────────────────────┐
│                         Site                             │
│  - name, title, description                              │
│  - theme settings                                        │
│  - multi-tenant root                                     │
└──────┬──────────────────────────────────────────────────┘
       │
       ├─── Items (documents, artifacts)
       │    └─── Photos (images)
       │    └─── MediaFiles (PDFs, docs)
       │    └─── Authored (authors junction)
       │    └─── Categorizations (categories junction)
       │    └─── CustomDatas (metadata)
       │
       ├─── Authors (creators, contributors)
       │
       ├─── Categories (classification)
       │
       ├─── DocumentTypes (artifact types)
       │
       ├─── Narratives (editorial content)
       │    └─── Sections (narrative parts)
       │
       ├─── NewsPosts (blog-style updates)
       │
       └─── SiteTheme (visual customization)
            └─── *Templates (Liquid templates via STI)
            └─── ThemeImages (theme assets)
```

### Entity Relationships

**Site (Hub)**
- `has_many :items`
- `has_many :authors`
- `has_many :categories`
- `has_many :document_types`
- `has_many :narratives`
- `has_many :news_posts`
- `has_many :memberships`
- `has_many :users, through: :memberships`
- `belongs_to :site_theme`
- `has_one_attached :logo` (ActiveStorage)

**Item (Core Content)**
- `belongs_to :site`
- `belongs_to :document_type, optional: true`
- `has_many :photos, dependent: :destroy`
- `has_many :media_files, dependent: :destroy`
- `has_many :authored, dependent: :destroy`
- `has_many :authors, through: :authored`
- `has_many :categorizations, dependent: :destroy`
- `has_many :categories, through: :categorizations`
- `has_many :custom_datas, as: :data_targetable`

**Photo (Image Management)**
- `belongs_to :item`
- `has_one_attached :image` (ActiveStorage)
- Properties: `caption`, `order`
- Legacy: `has_one :cloudfile_photo` (deprecated)
- Legacy: `has_one :local_photo` (deprecated)

**Author**
- `belongs_to :site`
- `has_many :authored`
- `has_many :items, through: :authored`
- Properties: `name`, `description`, `gender`

**Category**
- `belongs_to :site`
- `has_many :categorizations`
- `has_many :items, through: :categorizations`
- Properties: `name`, `description`

### Template Hierarchy (STI)

```
LayoutTemplate (base)
├── ShowArtifactTemplate
├── IndexArtifactsTemplate
├── BrowseArtifactsTemplate
├── ShowAuthorTemplate
├── ShowAboutTemplate
├── ShowSiteTemplate
├── ShowFullTextTemplate
├── ShowGoogleLocationTemplate
├── ShowNewsPostsTemplate
├── ShowNarrativeTemplate
└── IndexNarrativesTemplate
```

All templates:
- `belongs_to :site_theme`
- Store Liquid template code in `template` field
- Store CSS in `css` field
- Rendered dynamically based on context

---

## Storage Architecture

### ActiveStorage Integration

```
┌─────────────────────────────────────────────────────┐
│              Rails Application                       │
│                                                      │
│  Photo.image.attach(io: file, ...)                  │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│         ActiveStorage Framework                      │
│                                                      │
│  ┌──────────────────┐      ┌──────────────────┐    │
│  │ active_storage_  │      │ active_storage_  │    │
│  │    blobs         │      │   attachments    │    │
│  └──────────────────┘      └──────────────────┘    │
│  ┌──────────────────┐                              │
│  │ active_storage_  │                              │
│  │ variant_records  │                              │
│  └──────────────────┘                              │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│             Storage Service                          │
│                                                      │
│  Development:  Disk (local filesystem)              │
│  Staging:      S3 or R2 (test bucket)               │
│  Production:   S3 or R2 (production bucket)         │
└─────────────────────────────────────────────────────┘
```

### Storage Configuration

**Development:**
```yaml
# config/storage.yml
local:
  service: Disk
  root: <%= Rails.root.join("storage") %>
```

**Production (AWS S3):**
```yaml
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: us-east-1
  bucket: streetprint-production
```

**Production (Cloudflare R2):**
```yaml
cloudflare:
  service: S3
  access_key_id: <%= ENV['CF_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['CF_SECRET_ACCESS_KEY'] %>
  region: auto
  endpoint: https://<account-id>.r2.cloudflarestorage.com
  bucket: streetprint-production
```

### Image Variant Strategy

**Photo Model:**
```ruby
class Photo < ApplicationRecord
  has_one_attached :image
  
  # Variant definitions
  def thumb
    image.variant(resize_to_limit: [50, 50])
  end
  
  def large
    image.variant(resize_to_limit: [550, 420])
  end
  
  def original
    image
  end
end
```

**Variant Processing:**
- On-demand generation (first request)
- Cached in `active_storage_variant_records`
- Served via CDN after first generation
- Image processing via `image_processing` gem (ImageMagick/libvips)

### CDN Integration

```
User Request
    ↓
Cloudflare/CloudFront (CDN)
    ↓ (cache miss)
Rails Application
    ↓
ActiveStorage URL Generator
    ↓
S3/R2 Signed URL (or direct serve)
    ↓
CDN caches response
    ↓
Subsequent requests → CDN (cached)
```

---

## Authentication & Authorization

### Authentication Options

**Option 1: No Authentication (Read-Only)**
- Simplest approach
- Public archive access only
- Remove all user/session code
- Status: Recommended for initial launch

**Option 2: Devise (Full Auth)**
- Standard Rails authentication
- User registration, login, password reset
- Session management
- Remember me functionality
- Status: Optional if editing needed

**Option 3: Basic Auth (Simple Admin)**
- HTTP Basic Authentication
- Environment-based credentials
- No database requirements
- Status: Good for minimal admin access

### Authorization Options

**Option 1: No Authorization (Open)**
- All content publicly readable
- No role-based access control
- Status: Recommended for read-only

**Option 2: Pundit (Policy-Based)**
- Fine-grained authorization
- Policy objects per model
- Clear separation of concerns
- Status: Recommended if auth needed

**Option 3: Site-Based Ownership**
- Users can only edit their own sites
- Simple membership check
- Status: Good for multi-tenant editing

### Recommended Approach

```ruby
# For read-only application
class ApplicationController < ActionController::Base
  # No authentication needed
  # Public access to all content
end

# For admin-enabled application
class ApplicationController < ActionController::Base
  before_action :authenticate_user!, if: -> { editing_action? }
  
  private
  
  def editing_action?
    !['show', 'index'].include?(action_name)
  end
end
```

---

## Template System

### Liquid Template Architecture

**Purpose:** Allow site owners to customize page layouts without code access

**Components:**

1. **SiteTheme** - Theme container
   - Belongs to site
   - Has many template types
   - Stores theme-level assets

2. **Template Models** (STI)
   - Each template type for different page
   - Stores Liquid markup in `template` field
   - Stores CSS in `css` field
   - Polymorphic - same structure, different types

3. **Liquid Drops** - Data exposure
   - Models implement `to_liquid` method
   - Return hash of safe, public attributes
   - Used in template rendering

### Template Rendering Flow

```
Request → Controller
    ↓
Load Site + SiteTheme
    ↓
Determine Template Type
(e.g., ShowArtifactTemplate)
    ↓
Load Template Record
    ↓
Prepare Liquid Context
(item.to_liquid, site.to_liquid, etc.)
    ↓
Liquid::Template.parse(template.template)
    ↓
Render with context
    ↓
Inject CSS
    ↓
Response
```

### Liquid Context Example

```ruby
# Controller
def show
  @item = Item.find(params[:id])
  @template = @site.site_theme.show_artifact_template
  
  @liquid_context = {
    'item' => @item.to_liquid,
    'site' => @site.to_liquid,
    'categories' => @site.categories.map(&:to_liquid)
  }
  
  @rendered = Liquid::Template.parse(@template.template)
                               .render(@liquid_context)
end
```

### Security Considerations

**Liquid Sandboxing:**
- Liquid runs in restricted environment
- No Ruby code execution
- Safe for user-generated templates
- Custom filters must be explicitly registered

**XSS Prevention:**
- All Liquid output is HTML-escaped by default
- Use `| raw` filter only for trusted content
- Sanitize user input before storage

---

## Search Architecture

### Search Options Comparison

| Feature | MySQL Fulltext | pg_search | Meilisearch | Elasticsearch |
|---------|---------------|-----------|-------------|---------------|
| Setup Complexity | Low | Low | Medium | High |
| Performance | Poor | Fair | Excellent | Excellent |
| Features | Basic | Good | Excellent | Extensive |
| Relevance | Poor | Good | Excellent | Excellent |
| Typo Tolerance | No | No | Yes | Yes |
| Faceting | No | No | Yes | Yes |
| Cost | Free | Free | Free | Paid/Self-host |
| Maintenance | None | None | Low | High |

### Recommended: Meilisearch

**Why Meilisearch:**
- Fast, modern search engine
- Typo tolerance out of the box
- Easy setup (single binary)
- Great relevance ranking
- Low resource usage
- Good for small-to-medium datasets

**Architecture:**

```
┌─────────────────────────────────────────┐
│          Rails Application               │
│                                          │
│  Item.search(query)                      │
│     ↓                                    │
│  MeiliSearch::Rails                      │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│        Meilisearch Server                │
│        (Docker Container)                │
│                                          │
│  - Indexes: items, authors               │
│  - Auto-sync on create/update            │
│  - Faceted search support                │
└──────────────────────────────────────────┘
```

**Implementation:**

```ruby
# Gemfile
gem 'meilisearch-rails'

# config/initializers/meilisearch.rb
MeiliSearch::Rails.configuration = {
  meilisearch_url: ENV['MEILISEARCH_URL'] || 'http://localhost:7700',
  meilisearch_api_key: ENV['MEILISEARCH_API_KEY']
}

# app/models/item.rb
class Item < ApplicationRecord
  include MeiliSearch::Rails
  
  meilisearch do
    attribute :title, :location, :notes, :full_text
    attribute :author_names do
      authors.pluck(:name)
    end
    attribute :category_names do
      categories.pluck(:name)
    end
    
    searchable_attributes [
      'title', 'author_names', 'location', 
      'notes', 'full_text', 'category_names'
    ]
    
    filterable_attributes ['site_id', 'published', 'year']
  end
end
```

### Fallback: MySQL Fulltext

**For initial launch without external dependencies:**

```ruby
# db/migrate/xxx_add_fulltext_index.rb
add_index :items, [:title, :notes, :location], 
          type: :fulltext, name: 'items_fulltext_idx'

# app/models/item.rb
scope :search, ->(query) {
  where("MATCH(title, notes, location) AGAINST(? IN NATURAL LANGUAGE MODE)", query)
}
```

---

## Deployment Architecture

### Docker Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   docker-compose.yml                     │
└────┬────────────────────────────────┬────────────────────┘
     │                                │
     │                                │
┌────▼─────────────┐      ┌──────────▼──────────┐
│   web (Rails)    │      │   db (MySQL)        │
│   - Port: 3000   │◄─────┤   - Port: 3306      │
│   - Puma server  │      │   - Data volume     │
│   - App code     │      └─────────────────────┘
└────┬─────────────┘
     │
     │ (optional)
     │
┌────▼─────────────┐
│   search         │
│   (Meilisearch)  │
│   - Port: 7700   │
└──────────────────┘
```

### Container Specifications

**Web Container (Rails):**
```dockerfile
FROM ruby:3.3.7-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libmariadb-dev \
    imagemagick \
    libvips \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copy application
COPY . .

# Precompile assets (production)
RUN RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
```

**Database Container (MySQL):**
```yaml
db:
  image: mysql:8.0
  environment:
    MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
    MYSQL_DATABASE: streetprint_production
  volumes:
    - mysql_data:/var/lib/mysql
  ports:
    - "3306:3306"
  healthcheck:
    test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
    timeout: 20s
    retries: 10
```

### Environment Variables

```bash
# Database
DATABASE_HOST=db
DATABASE_USER=root
DATABASE_PASSWORD=secure_password
DATABASE_NAME=streetprint_production

# Storage
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_REGION=us-east-1
AWS_BUCKET=streetprint-production

# Search (optional)
MEILISEARCH_URL=http://search:7700
MEILISEARCH_API_KEY=master_key

# Rails
RAILS_ENV=production
SECRET_KEY_BASE=generated_secret
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true

# CDN (optional)
ASSET_HOST=https://cdn.streetprint.org
```

### Production Deployment

**Option 1: Self-Hosted (Docker Compose)**
- Simple VPS with Docker
- docker-compose for orchestration
- Nginx reverse proxy
- Let's Encrypt for SSL

**Option 2: AWS ECS/Fargate**
- Managed container orchestration
- Auto-scaling
- Load balancing
- RDS for MySQL

**Option 3: Railway/Render/Fly.io**
- Platform-as-a-Service
- Simplified deployment
- Automatic HTTPS
- Good for smaller scale

---

## Technology Decisions

### Why Rails 7.2?

✅ **Current and supported** (security patches until ~2027)  
✅ **Stable** (released August 2024, mature)  
✅ **Modern features** (Hotwire, import maps, ActiveStorage)  
✅ **Good gem ecosystem** (all needed gems available)  
✅ **Not bleeding edge** (Rails 8 is too new)  

### Why Ruby 3.3?

✅ **Supported until 2027**  
✅ **Performance improvements** over 2.x  
✅ **Compatible with Rails 7.2**  
✅ **YJIT enabled** (faster execution)  
✅ **Modern syntax** (pattern matching, etc.)  

### Why MySQL 8.x?

✅ **Continuity** (already using MySQL)  
✅ **No data conversion needed**  
✅ **Good Rails support** (mysql2 adapter)  
✅ **Mature and stable**  
✅ **Fulltext search** (basic fallback)  

Alternative: PostgreSQL 15+
- Better search (pg_search, pg_trgm)
- JSON support
- Would require data migration

### Why ActiveStorage?

✅ **Built into Rails** (no external gem)  
✅ **Well maintained** (core Rails team)  
✅ **Multiple storage backends** (S3, R2, Azure, GCS)  
✅ **Image variants** (on-demand resizing)  
✅ **Direct uploads** (client → storage)  
✅ **Replaces Paperclip** (1:1 replacement)  

### Why Liquid Templates?

✅ **Already in use** (preserve existing work)  
✅ **Safe templating** (no code injection)  
✅ **User-friendly** (non-developers can edit)  
✅ **Well-maintained** (Shopify gem)  
✅ **Good performance**  

### Why Docker?

✅ **Environment consistency** (dev = prod)  
✅ **Easy deployment** (portable containers)  
✅ **Dependency isolation** (no system conflicts)  
✅ **Scalability** (can add containers)  
✅ **Industry standard** (good tooling)  

---

## Migration Strategy

### Phase-Based Approach

**Foundation First:**
1. Database schema (migrations)
2. Data import (preserve everything)
3. Storage layer (ActiveStorage)

**Core Features:**
4. Models (business logic)
5. Read-only views (public access)
6. Search (basic first, enhance later)

**Enhanced Features:**
7. Authentication (if needed)
8. Editing (if needed)
9. Admin features (if needed)

**Optimization:**
10. Performance tuning
11. Caching
12. CDN configuration

### Parallel Operation

```
Old Rails 2.3.3 App          New Rails 7.2 App
(Production)                 (Development/Staging)
      │                             │
      │                             │
      ├─── Shared Database ─────────┤
      │    (Read access)            │
      │                             │
      └─── Images (S3) ─────────────┘
           (Shared storage)
```

**Benefits:**
- Zero downtime migration
- Gradual feature validation
- Easy rollback if needed
- Data stays synchronized

### Cutover Strategy

1. **Preparation**
   - Freeze content creation in old app
   - Final data sync to new app
   - DNS preparation

2. **Cutover**
   - Update DNS to point to new app
   - Monitor for issues
   - Old app remains accessible via direct IP

3. **Validation**
   - Verify all pages load
   - Check image serving
   - Test search functionality
   - Monitor error logs

4. **Rollback Plan**
   - Revert DNS if critical issues
   - Old app ready to take traffic
   - Document rollback procedure

---

## Performance Considerations

### Database Optimization

**Indexes:**
- Primary keys (auto-indexed)
- Foreign keys (site_id, item_id, etc.)
- Fulltext indexes (if using MySQL search)
- Composite indexes for common queries

**Query Optimization:**
- Use `includes` for N+1 prevention
- `select` specific columns when possible
- Pagination for large result sets
- Counter caches for association counts

### Caching Strategy

**Page Caching:**
- Static pages can be cached
- Liquid-rendered templates
- Cache invalidation on content update

**Fragment Caching:**
- Item lists
- Category navigation
- Site themes

**Low-Hanging Fruit:**
```ruby
# Russian Doll caching
<% cache @item do %>
  <% cache @item.photos do %>
    ...photo display...
  <% end %>
<% end %>
```

### CDN Configuration

**Cloudflare Settings:**
- Cache static assets (CSS, JS, images)
- Cache HTML pages (with proper invalidation)
- Image optimization (Polish feature)
- Brotli compression

**Cache Headers:**
```ruby
# config/environments/production.rb
config.public_file_server.headers = {
  'Cache-Control' => 'public, max-age=31536000',
  'Expires' => 1.year.from_now.httpdate
}
```

---

## Security Architecture

### Security Measures

**Application Security:**
- Strong parameters (no mass assignment)
- CSRF protection (Rails default)
- SQL injection prevention (ActiveRecord)
- XSS prevention (ERB auto-escaping)
- Content Security Policy (CSP headers)

**Infrastructure Security:**
- HTTPS only (SSL certificate)
- Secure cookie flags
- Environment variable secrets
- S3 bucket access control
- Database firewall rules

**Dependency Security:**
- Regular gem updates
- Bundler audit checks
- Brakeman security scans
- Dependabot alerts

### Audit Tools

```bash
# Security scanning
bundle exec brakeman

# Dependency vulnerabilities
bundle audit check --update

# Code quality
bundle exec rubocop
```

---

## Monitoring & Logging

### Application Monitoring

**Recommended Tools:**
- **Error Tracking:** Sentry, Honeybadger, Rollbar
- **Performance:** New Relic, Scout APM
- **Uptime:** UptimeRobot, Pingdom

**Rails Logging:**
- Structured logging (JSON format)
- Log levels by environment
- Request tracking (request IDs)
- Slow query logging

**Metrics to Track:**
- Request duration (p50, p95, p99)
- Database query time
- ActiveStorage upload/download time
- Search query performance
- Error rates
- User sessions (if auth enabled)

---

## Future Enhancements

### Short Term (3-6 months)

- Enhanced search (Meilisearch/Elasticsearch)
- Performance optimization
- Better caching
- Admin UI improvements
- Mobile responsiveness

### Medium Term (6-12 months)

- GraphQL API
- Modern frontend (React/Vue)
- Bulk operations (import/export)
- Advanced search filters
- Image optimization pipeline

### Long Term (12+ months)

- Static site generation option
- Multi-language support
- Accessibility improvements (WCAG 2.1)
- Progressive Web App (PWA)
- Machine learning (auto-tagging, OCR)

---

**Document Owner:** Implementation Team  
**Last Updated:** January 2026  
**Next Review:** After Phase 5 completion
