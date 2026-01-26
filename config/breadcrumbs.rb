# Gretel breadcrumbs configuration
# See https://github.com/kzkn/gretel for more details

# Root breadcrumb
crumb :root do
  link "Home", root_url
end

# Site home breadcrumb
crumb :site_home do |site|
  link "Home", root_url(subdomain: site.title)
end

# Admin home breadcrumb
crumb :admin_home do
  link "Home", admin_url(subdomain: false)
end

# Admin site breadcrumb
crumb :admin_site do |site|
  link site.title
  parent :admin_home
end

# Narratives index
crumb :narratives do |site|
  link "Narratives", narratives_path
  parent :site_home, site
end

# Narrative show
crumb :narrative do |narrative, site|
  link narrative.title, narrative_path(narrative)
  parent :narratives, site
end

# Items/Artifacts index
crumb :items do |site|
  link site.plural_item, items_path
  parent :site_home, site
end

# Item/Artifact show
crumb :item do |item, site|
  link item.title, item_path(item)
  parent :items, site
end

# Authors index
crumb :authors do |site|
  link "Authors", authors_path
  parent :site_home, site
end

# Author show
crumb :author do |author, site|
  link author.display_name, author_path(author)
  parent :authors, site
end

# News posts index
crumb :news_posts do |site|
  link "News", news_posts_path
  parent :site_home, site
end

# News post show
crumb :news_post do |news_post, site|
  link news_post.title, news_post_path(news_post)
  parent :news_posts, site
end

# Browse
crumb :browse do |site|
  link "Browse", browse_index_path
  parent :site_home, site
end

# Google locations index
crumb :google_locations do |site|
  link "Locations", google_locations_path
  parent :site_home, site
end

# Google location show
crumb :google_location do |location, site|
  link location.name, google_location_path(location)
  parent :google_locations, site
end

# About pages
crumb :about do |site|
  link "About", about_path
  parent :site_home, site
end

# User/Admin sections (site management)
crumb :user_sites do
  link "My Sites", user_sites_path
  parent :admin_home
end

crumb :user_site do |site|
  link site.title, user_site_path(site)
  parent :user_sites
end

crumb :user_items do |site|
  link site.plural_item, user_site_items_path(site)
  parent :user_site, site
end

crumb :user_item do |item, site|
  link item.title, user_site_item_path(site, item)
  parent :user_items, site
end

crumb :user_narratives do |site|
  link "Narratives", user_site_narratives_path(site)
  parent :user_site, site
end

crumb :user_narrative do |narrative, site|
  link narrative.title, user_site_narrative_path(site, narrative)
  parent :user_narratives, site
end

crumb :user_authors do |site|
  link "Authors", user_site_authors_path(site)
  parent :user_site, site
end

crumb :user_author do |author, site|
  link author.display_name, user_site_author_path(site, author)
  parent :user_authors, site
end

crumb :user_news_posts do |site|
  link "News Posts", user_site_news_posts_path(site)
  parent :user_site, site
end

crumb :user_news_post do |news_post, site|
  link news_post.title, user_site_news_post_path(site, news_post)
  parent :user_news_posts, site
end

crumb :user_google_locations do |site|
  link "Google Locations", user_site_google_locations_path(site)
  parent :user_site, site
end

crumb :user_google_location do |location, site|
  link location.name, user_site_google_location_path(site, location)
  parent :user_google_locations, site
end

crumb :user_categories do |site|
  link "Categories", user_site_categories_path(site)
  parent :user_site, site
end

crumb :user_custom_data_types do |site|
  link "Custom Data Types", user_site_custom_data_types_path(site)
  parent :user_site, site
end

crumb :user_document_types do |site|
  link "Document Types", user_site_document_types_path(site)
  parent :user_site, site
end

crumb :user_full_texts do |site|
  link "Full Texts", user_site_full_texts_path(site)
  parent :user_site, site
end

crumb :user_memberships do |site|
  link "Memberships", user_site_memberships_path(site)
  parent :user_site, site
end

crumb :user_site_themes do |site|
  link "Site Themes", user_site_site_themes_path(site)
  parent :user_site, site
end
