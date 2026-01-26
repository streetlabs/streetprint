# StreetPrint 5 - Rails Migration Overview

**Project:** StreetPrint 5 (SP5)  
**Current State:** Rails 2.3.3 (2009) with vendored Rails  
**Target State:** Rails 7.2 with Ruby 3.3  
**Migration Strategy:** Controlled Rewrite with Data Preservation  
**Document Version:** 1.0  
**Date:** January 2026

---

## Executive Summary

This document outlines the migration strategy for StreetPrint 5, a legacy Rails 2.3.3 application that has been in production since 2009. The application manages digital archives with multi-tenant sites, user-generated content, and extensive image management capabilities.

### Key Challenges

1. **Age Gap:** 17-year gap between Rails 2.3.3 (2009) and Rails 7.2 (2024)
2. **Abandoned Dependencies:** All major gems are deprecated (Authlogic, Paperclip, ACL9, Thinking Sphinx)
3. **Pre-Bundler Era:** Application uses vendored Rails and config.gem declarations
4. **Storage Migration:** Moving from Rackspace CloudFiles to AWS S3/Cloudflare
5. **JavaScript Modernization:** Heavy use of Prototype.js (removed in Rails 5.1)

### Migration Approach

**Rejected Approach:** Incremental upgrades (Rails 2.3 → 3.x → 4.x → 5.x → 6.x → 7.x)
- Too fragile with 17 years of breaking changes
- Risk of getting stuck between versions
- Requires maintaining compatibility with deprecated APIs

**Chosen Approach:** Controlled Rewrite
- Build new Rails 7.2 application in parallel
- Port database migrations one-by-one
- Verify schema matches exactly
- Import data wholesale
- Rewrite application code with modern patterns
- Preserve all data and functionality

---

## Project Scope

### In Scope

✅ All database schema and data preservation  
✅ All image assets (migration to S3/Cloudflare)  
✅ Core functionality: sites, items, photos, authors, categories  
✅ Read-only public views  
✅ Admin editing capabilities (optional)  
✅ Liquid template system preservation  
✅ Multi-tenant architecture  
✅ Search functionality (modern replacement)  
✅ Docker containerization  

### Out of Scope

❌ User account migration (read-only target, auth optional)  
❌ Sphinx search index (will be replaced)  
❌ Exact UI/UX replication (can be modernized)  
❌ Internet Explorer support  
❌ Legacy admin features (can be simplified)  

### Future Considerations

🔮 Static site generation for archival purposes  
🔮 API endpoints for external access  
🔮 Modern frontend framework (React/Vue)  
🔮 Enhanced search with Elasticsearch/Meilisearch  

---

## Technology Stack Comparison

### Current Stack (Rails 2.3.3)

| Component | Technology | Status |
|-----------|-----------|--------|
| Framework | Rails 2.3.3 | EOL 2013 |
| Ruby | 2.3-2.4 required | EOL 2020 |
| Database | MySQL 5.x | Legacy |
| Authentication | Authlogic 2.1.1 | Abandoned |
| Authorization | ACL9 0.10.0 | Abandoned |
| File Upload | Paperclip 2.3.x | Deprecated |
| Storage | Rackspace CloudFiles | Deprecated |
| Search | Thinking Sphinx 1.3.x | Needs update |
| Pagination | will_paginate 2.3.x | Works but old |
| Templates | Liquid | Still viable |
| JavaScript | Prototype.js | Removed from Rails |
| Deployment | Manual/Capistrano | Legacy |

### Target Stack (Rails 7.2)

| Component | Technology | Status |
|-----------|-----------|--------|
| Framework | Rails 7.2 | Current (2024) |
| Ruby | 3.3.7 | Supported until 2027 |
| Database | MySQL 8.x | Modern |
| Authentication | Devise 4.x (optional) | Active |
| Authorization | Pundit 2.x (optional) | Active |
| File Upload | ActiveStorage | Built-in |
| Storage | AWS S3 / Cloudflare R2 | Modern |
| Search | pg_search / Meilisearch | Modern |
| Pagination | Pagy | Modern, fast |
| Templates | Liquid 5.x | Updated |
| JavaScript | Hotwire/Stimulus | Modern |
| Deployment | Docker + Docker Compose | Modern |

---

## Database Overview

### Schema Statistics

- **37 tables** in production schema
- **108 migrations** spanning 2009-2010
- **Primary models:** Items, Photos, Sites, Users, Authors, Categories
- **Template system:** 8 Single Table Inheritance (STI) template types
- **Storage models:** Dual photo storage (CloudFiles + Local)

### Critical Tables

1. **items** - Core content (documents, artifacts)
2. **photos** - Photo metadata and relationships
3. **cloudfile_photos** - Paperclip attachments (Rackspace)
4. **local_photos** - Paperclip attachments (local storage)
5. **sites** - Multi-tenant site configuration
6. **users** - User accounts (Authlogic)
7. **authors** - Document authors/creators
8. **categories** - Content categorization
9. **media_files** - Additional file attachments
10. **site_themes** - Theme/template customization

### Data Relationships

```
Site (1) ──┬── (many) Items
           ├── (many) Authors  
           ├── (many) Categories
           ├── (many) DocumentTypes
           └── (many) Users (through Memberships)

Item (1) ──┬── (many) Photos
           ├── (many) MediaFiles
           ├── (many) Authors (through Authored)
           ├── (many) Categories (through Categorizations)
           └── (many) CustomDatas

Photo (1) ──┬── (one) CloudfilePhoto
            └── (one) LocalPhoto
```

---

## Migration Phases

### Phase 1: Image URL Update (2-4 hours)
- Export current database
- Update Rackspace URLs to S3/Cloudflare URLs
- Verify image accessibility
- Document URL patterns

### Phase 2: New Rails Project (1 hour)
- Generate Rails 7.2 application
- Configure Ruby 3.3
- Set up MySQL2 adapter
- Configure base dependencies

### Phase 3: Migration Porting (8-16 hours)
- Copy 108 migrations to new app
- Update syntax for Rails 7.2
- Run migrations one-by-one
- Verify final schema matches original

### Phase 4: Data Migration (2-4 hours)
- Export data from old database
- Import to new database
- Validate record counts
- Check data integrity

### Phase 5: ActiveStorage Setup (12-20 hours)
- Install ActiveStorage
- Configure S3/Cloudflare storage
- Migrate Paperclip attachments
- Update Photo/MediaFile models
- Test image serving

### Phase 6: Model Porting (6-10 hours)
- Port 37 models
- Update validations syntax
- Update callbacks
- Remove deprecated code
- Test in Rails console

### Phase 7: Views - Read Only (8-16 hours)
- Port layouts and partials
- Update image display helpers
- Remove Prototype.js
- Create basic controllers
- Test public pages

### Phase 8: Authentication & Edit (8-16 hours)
- Install Devise (if needed)
- Migrate user accounts
- Add edit controllers
- Create forms with ActiveStorage
- Implement strong parameters

### Phase 9: Remaining Features (12-20 hours)
- Port additional controllers
- Update helpers
- Liquid template integration
- Template model updates
- Admin interfaces

### Phase 10: Search (4-8 hours)
- Choose search solution
- Configure search
- Update search controllers
- Test search functionality

### Phase 11: Docker (4-6 hours)
- Create Dockerfile
- Create docker-compose.yml
- Configure environment variables
- Test containerized deployment

### Phase 12: Testing & Validation (8-12 hours)
- Data validation
- Feature testing
- Performance testing
- Security audit
- Documentation

---

## Success Criteria

### Must Have (P0)

✅ All 37 tables migrated with identical schema  
✅ All data imported (zero data loss)  
✅ All images accessible from S3/Cloudflare  
✅ Public item pages render correctly  
✅ Site themes/templates work  
✅ Application runs in Docker  
✅ No security vulnerabilities  

### Should Have (P1)

✅ Edit functionality for items, sites, authors  
✅ Search functionality (any implementation)  
✅ User authentication (if maintaining admin)  
✅ Image upload working  
✅ Responsive design  

### Nice to Have (P2)

✅ Modern UI improvements  
✅ Enhanced search (Elasticsearch/Meilisearch)  
✅ API endpoints  
✅ Performance optimizations  
✅ Comprehensive test coverage  

---

## Risk Assessment

### High Risk Areas

1. **ActiveStorage Migration** - Complex, affects core functionality
   - Mitigation: Dual-system support during transition
   - Mitigation: Comprehensive testing of image serving

2. **Data Integrity** - 17 years of production data
   - Mitigation: Multiple backups before any changes
   - Mitigation: Validation scripts at each step
   - Mitigation: Parallel operation of old system

3. **Schema Differences** - Subtle migration issues
   - Mitigation: Automated schema comparison
   - Mitigation: One-by-one migration verification
   - Mitigation: Test data imports before production

### Medium Risk Areas

4. **Liquid Template Compatibility** - May have breaking changes
   - Mitigation: Test with production templates early
   - Mitigation: Update Liquid gem incrementally

5. **Search Functionality** - Complete replacement needed
   - Mitigation: Multiple fallback options
   - Mitigation: Can launch without search initially

6. **Performance** - Rails 7 may behave differently
   - Mitigation: Benchmark critical paths
   - Mitigation: Database query optimization

### Low Risk Areas

7. **Docker Deployment** - Well-understood technology
8. **Database Adapter** - mysql2 is mature and stable
9. **ActiveRecord Changes** - Well-documented upgrade path

---

## Timeline Estimates

**Note:** These are effort estimates, not calendar time. Actual timeline depends on team size and availability.

| Phase | Optimistic | Realistic | Conservative |
|-------|-----------|-----------|--------------|
| 1. Image URLs | 2 hrs | 4 hrs | 8 hrs |
| 2. Project Setup | 1 hr | 2 hrs | 4 hrs |
| 3. Migrations | 8 hrs | 12 hrs | 16 hrs |
| 4. Data Import | 2 hrs | 4 hrs | 8 hrs |
| 5. ActiveStorage | 12 hrs | 16 hrs | 20 hrs |
| 6. Models | 6 hrs | 8 hrs | 10 hrs |
| 7. Views | 8 hrs | 12 hrs | 16 hrs |
| 8. Auth/Edit | 8 hrs | 12 hrs | 16 hrs |
| 9. Features | 12 hrs | 16 hrs | 20 hrs |
| 10. Search | 4 hrs | 6 hrs | 8 hrs |
| 11. Docker | 4 hrs | 6 hrs | 8 hrs |
| 12. Testing | 8 hrs | 12 hrs | 16 hrs |
| **Total** | **75 hrs** | **110 hrs** | **150 hrs** |

**For a 2-person team:** 2-3 weeks of focused work  
**For a 1-person team:** 3-4 weeks of focused work

---

## Team Requirements

### Minimum Team

- **1 Senior Rails Developer** with experience in:
  - Rails 2.x → 7.x migrations
  - ActiveStorage / Paperclip
  - MySQL database administration
  - Docker containerization

### Recommended Team

- **1 Senior Rails Developer** (lead)
- **1 Mid-level Rails Developer** (implementation)
- **1 DevOps Engineer** (part-time, Docker/deployment)
- **1 QA Engineer** (part-time, validation/testing)

### Required Skills

✅ Rails 7.x expertise  
✅ ActiveRecord migrations  
✅ ActiveStorage configuration  
✅ MySQL/database management  
✅ Docker & docker-compose  
✅ AWS S3 or Cloudflare R2  
✅ Git version control  

### Nice-to-Have Skills

✅ Experience with legacy Rails upgrades  
✅ Liquid templating knowledge  
✅ Search implementation (Sphinx/Elasticsearch)  
✅ Frontend JavaScript (Hotwire/Stimulus)  
✅ Security auditing (Brakeman)  

---

## Communication Plan

### Status Updates

- **Daily:** Stand-up or async update on progress
- **Weekly:** Phase completion review
- **Blockers:** Immediate communication when stuck

### Deliverables

1. **Phase 3 Complete:** Schema comparison report
2. **Phase 4 Complete:** Data validation report
3. **Phase 5 Complete:** Image migration report
4. **Phase 7 Complete:** Demo of read-only site
5. **Phase 12 Complete:** Full handoff documentation

### Decision Points

- **After Phase 5:** Confirm ActiveStorage working before proceeding
- **After Phase 7:** Decide if authentication is needed
- **After Phase 10:** Choose final search solution

---

## Next Steps

### Immediate Actions

1. ✅ Read and approve this migration overview
2. ⏭️ Review technical architecture document
3. ⏭️ Review phase-by-phase implementation guide
4. ⏭️ Assemble implementation team
5. ⏭️ Set up development environment

### Pre-Migration Checklist

- [ ] Backup production database (multiple copies)
- [ ] Backup all production images
- [ ] Document current S3/Cloudflare URLs
- [ ] Set up development MySQL instance
- [ ] Install Ruby 3.3.7
- [ ] Install Rails 7.2
- [ ] Clone sp5 repository
- [ ] Review all 108 migrations

---

## Document References

- `01-ARCHITECTURE.md` - Technical architecture and design decisions
- `02-IMPLEMENTATION-GUIDE.md` - Detailed phase-by-phase instructions
- `03-DATA-MIGRATION.md` - Database and storage migration specifications
- `04-TESTING-VALIDATION.md` - Testing procedures and validation checklists
- `05-DEPLOYMENT.md` - Docker and production deployment guide

---

## Questions & Assumptions

### Assumptions

1. Production data is valid and consistent
2. All images are accessible in S3/Cloudflare
3. MySQL 8.x will be used for new application
4. Application will be read-only or limited editing
5. Users do not need to be migrated (can be recreated)

### Open Questions

1. **Authentication:** Do we need to preserve user accounts and login?
   - If yes: Migrate to Devise
   - If no: Remove authentication entirely

2. **Search:** What is the priority for search functionality?
   - High: Implement Meilisearch/Elasticsearch immediately
   - Medium: Use basic MySQL fulltext initially
   - Low: Launch without search, add later

3. **Features:** Which admin features must be preserved?
   - All editing capabilities?
   - Simplified content management?
   - Read-only only?

4. **Deployment:** What is the target hosting environment?
   - Self-hosted Docker
   - AWS ECS/Fargate
   - Heroku/Platform-as-a-Service
   - Other

---

**Document Owner:** [Your Name]  
**Last Updated:** January 2026  
**Next Review:** After Phase 3 completion
