module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      '/'
    when /register/
      new_user_path
    when /the forgot password page/
      new_password_reset_path
    when /the login page/
      login_path
    when /the registration page/
      new_account_path
    when /my account page/
      account_path
    when /the admin page/
      admin_path
      
      
    when /the sites page/
      admin_path
    when /the site page for "(.*)"/
      site_path(Site.find_by_name($1))
    when /the edit site page for "(.*)"/
      edit_site_path(Site.find_by_name($1))
    when /the create site page/
      new_site_path
      
      
    when /the create item page for "(.*)"/
      site = Site.find_by_name($1)
      new_site_item_path(site)
    when /^the item page for "([^\"]*)" in "([^\"]*)"$/
      site = Site.find_by_name($2)
      item = Item.find_by_title($1)
      site_item_path(site, item)
    when /the edit item page for "([^\"]*)" in "([^\"]*)"$/
      site = Site.find_by_name($2)
      item = Item.find_by_title($1)
      edit_site_item_path(site, item)
    when /the items page for "(.*)"/
      site_items_path(Site.find_by_name($1))
      
    
    when /the authors page for "(.*)"/
      site = Site.find_by_name($1)
      site_authors_path(site)
    when /the create authors page for "(.*)"/
      site = Site.find_by_name($1)
      new_site_author_path(site)
    when /the author page for "(.*)" in "(.*)"/
      site = Site.find_by_name($2)
      author = Author.find_by_name($1)
      site_author_path(site, author)
    when /the edit author page for "(.*)" in "(.*)"/
      site = Site.find_by_name($2)
      author = Author.find_by_name($1)
      edit_site_author_path(site, author)
      
    when /the categories page for "(.*)"/
      site = Site.find_by_name($1)
      site_categories_path(site)
    when /the create category page for "(.*)"/
      site = Site.find_by_name($1)
      new_site_category_path(site)
    when /the category page for "(.*)" in "(.*)"/
      site = Site.find_by_name($2)
      category = Category.find_by_name($1)
      site_category_path(site, category)
    when /the edit category page for "(.*)" in "(.*)"/
      site = Site.find_by_name($2)
      category = Category.find_by_name($1)
      edit_site_category_path(site, category)
      
    when /the document types page for "(.*)"/
      site = Site.find_by_name($1)
      site_document_types_path(site)
    when /the create document type page for "(.*)"/
      site = Site.find_by_name($1)
      new_site_document_type_path(site)
    when /the document type page for "(.*)" in "(.*)"/
      site = Site.find_by_name($2)
      document_type = DocumentType.find_by_name($1)
      site_document_type_path(site, document_type)
    when /the edit document type page for "(.*)" in "(.*)"/
      site = Site.find_by_name($2)
      document_type = DocumentType.find_by_name($1)
      edit_site_document_type_path(site, document_type)
      
    when /the memberships page for "(.*)"/
      site = Site.find_by_name($1)
      site_memberships_path(site)
    when /the new membership page for "(.+)"/
      site = Site.find_by_name($1)
      new_site_membership_path(site)
    when /the edit membership page for "(.*)" in "(.*)"/
      site = Site.find_by_name($2)
      user = User.find_by_email($1)
      membership = site.memberships.find_by_user_id(user.id)
      edit_site_membership_path(site, membership)
      
    when /the news page for "(.*)"/
      site = Site.find_by_name($1)
      site_news_posts_path(site)
    when /the edit news page for "(.*)" in "(.*)"/
      site = Site.find_by_name($2)
      post = site.news_posts.find_by_title($1)
      edit_site_news_post_path(site, post)
    when /the new news page for "(.*)"/
      site = Site.find_by_name($1)
      new_site_news_post_path(site)
      
    when /the browse page for "(.*)"/
      site = Site.find_by_name($1)
      site_browse_path(site)
    
    when /the about page for site "(.*)"/
      site = Site.find_by_name($1)
      site_about_path(site)
      
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
