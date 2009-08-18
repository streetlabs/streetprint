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
    when /sign up/
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
      
      
    
    when /the site page for "(.*)"/
      site_path(Site.find_by_title($1))
    when /the subdomain site page for "(.*)"/
      root_path(:subdomain => $1)
      
    when /the sites page/
      admin_path
    when /the edit site page for "(.*)"/
      edit_siteadmin_path(Site.find_by_title($1))
    when /the create site page/
      new_siteadmin_path
      
      
    # Items public
    when /^the item page for "([^\"]*)" in "([^\"]*)"$/
      site = Site.find_by_title($2)
      @item = Item.find_by_title($1)
      site_item_path(site, @item)
    when /the items page for "(.*)"/
      site_items_path(Site.find_by_title($1))
    # Items private
    when /^the admin item page for "([^\"]*)" in "([^\"]*)"$/
      site = Site.find_by_title($2)
      @item = Item.find_by_title($1)
      siteadmin_itemadmin_path(site, @item)
    when /the admin items page for "(.*)"/
      siteadmin_itemadmin_index_path(Site.find_by_title($1))
    when /the create item page for "(.*)"/
      site = Site.find_by_title($1)
      new_siteadmin_itemadmin_path(site)
    when /the edit item page for "([^\"]*)" in "([^\"]*)"$/
      site = Site.find_by_title($2)
      item = Item.find_by_title($1)
      edit_siteadmin_itemadmin_path(site, item)
    
    # Items via subdomain public
    when /^the subdomain item page for "([^\"]*)" in "([^\"]*)"$/
      site = Site.find_by_title($2)
      @item = Item.find_by_title($1)
      item_path(@item, :subdomain => site.title)
    when /the subdomain items page for "(.*)"/
      site = Site.find_by_title($1)
      items_path(:subdomain => site.title)
    # Items via subdomain private
    when /^the admin subdomain item page for "([^\"]*)" in "([^\"]*)"$/
      site = Site.find_by_title($2)
      @item = Item.find_by_title($1)
      itemadmin_path(@item, :subdomain => site.title)
    when /the admin subdomain items page for "(.*)"/
      site = Site.find_by_title($1)
      itemadmin_index_path(:subdomain => site.title)
    when /the subdomain create item page for "(.*)"/
      site = Site.find_by_title($1)
      new_itemadmin_path(:subdomain => site.title)
    when /the subdomain edit item page for "([^\"]*)" in "([^\"]*)"$/
      site = Site.find_by_title($2)
      item = Item.find_by_title($1)
      edit_itemadmin_path(item, :subdomain => site.title)
      
    # Authors public
    when /the author page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      author = Author.find_by_name($1)
      site_author_path(site, author)
    # Authors private
    when /the admin author page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      author = Author.find_by_name($1)
      siteadmin_authoradmin_path(site, author)
    when /the authors page for "(.*)"/
      site = Site.find_by_title($1)
      siteadmin_authoradmin_index_path(site)
    when /the create authors page for "(.*)"/
      site = Site.find_by_title($1)
      new_siteadmin_authoradmin_path(site)
    when /the edit author page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      author = Author.find_by_name($1)
      edit_siteadmin_authoradmin_path(site, author)
      
    # Authors via subdomain public
    when /the subdomain author page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      author = Author.find_by_name($1)
      author_path(author, :subdomain => site.title)
    # Authors via subdomain private
    when /the admin subdomain author page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      author = Author.find_by_name($1)
      authoradmin_path(author, :subdomain => site.title)
    when /the subdomain authors page for "(.*)"/
      site = Site.find_by_title($1)
      authoradmin_index_path(:subdomain => site.title)
    when /the subdomain create authors page for "(.*)"/
      site = Site.find_by_title($1)
      new_authoradmin_path(:subdomain => site.title)
    when /the subdomain edit author page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      author = Author.find_by_name($1)
      edit_authoradmin_path(author, :subdomain => site.title)
      
    # Categories
    when /the categories page for "(.*)"/
      site = Site.find_by_title($1)
      siteadmin_categories_path(site)
    when /the create category page for "(.*)"/
      site = Site.find_by_title($1)
      new_siteadmin_category_path(site)
    when /the category page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      category = Category.find_by_name($1)
      siteadmin_category_path(site, category)
    when /the edit category page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      category = Category.find_by_name($1)
      edit_siteadmin_category_path(site, category)
    # Categories via subdomain
    when /the subdomain categories page for "(.*)"/
      site = Site.find_by_title($1)
      categories_path(:subdomain => site.title)
    when /the subdomain create category page for "(.*)"/
      site = Site.find_by_title($1)
      new_category_path(:subdomain => site.title)
    when /the subdomain category page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      category = Category.find_by_name($1)
      category_path(category, :subdomain => site.title)
    when /the subdomain edit category page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      category = Category.find_by_name($1)
      edit_category_path(category, :subdomain => site.title)
      
    # Document types
    when /the document types page for "(.*)"/
      site = Site.find_by_title($1)
      siteadmin_document_types_path(site)
    when /the create document type page for "(.*)"/
      site = Site.find_by_title($1)
      new_siteadmin_document_type_path(site)
    when /the document type page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      document_type = DocumentType.find_by_name($1)
      siteadmin_document_type_path(site, document_type)
    when /the edit document type page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      document_type = DocumentType.find_by_name($1)
      edit_siteadmin_document_type_path(site, document_type)
    # Document types via subdomain
    when /the subdomain document types page for "(.*)"/
      site = Site.find_by_title($1)
      document_types_path(:subdomain => site.title)
    when /the subdomain create document type page for "(.*)"/
      site = Site.find_by_title($1)
      new_document_type_path(:subdomain => site.title)
    when /the subdomain document type page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      document_type = DocumentType.find_by_name($1)
      document_type_path(document_type, :subdomain => site.title)
    when /the subdomain edit document type page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      document_type = DocumentType.find_by_name($1)
      edit_document_type_path(document_type, :subdomain => site.title)
    
    # Memberships
    when /the memberships page for "(.*)"/
      site = Site.find_by_title($1)
      siteadmin_memberships_path(site)
    when /the create membership page for "(.+)"/
      site = Site.find_by_title($1)
      new_siteadmin_membership_path(site)
    when /the edit membership page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      user = User.find_by_email($1)
      membership = site.memberships.find_by_user_id(user.id)
      edit_siteadmin_membership_path(site, membership)
    # Memberships via subdomain
    when /the subdomain memberships page for "(.*)"/
      site = Site.find_by_title($1)
      memberships_path(:subdomain => site.title)
    when /the subdomain create membership page for "(.+)"/
      site = Site.find_by_title($1)
      new_membership_path(:subdomain => site.title)
    when /the subdomain edit membership page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      user = User.find_by_email($1)
      membership = site.memberships.find_by_user_id(user.id)
      edit_membership_path(membership, :subdomain => site.title)
      
    # News public
    when /the news page for "(.*)"/
      site = Site.find_by_title($1)
      site_news_posts_path(site)
    # News private
    when /the admin news page for "(.*)"/
      site = Site.find_by_title($1)
      siteadmin_newsadmin_index_posts_path(site)
    when /the edit news page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      post = site.news_posts.find_by_title($1)
      edit_siteadmin_newsadmin_path(site, post)
    when /the create news page for "(.*)"/
      site = Site.find_by_title($1)
      new_siteadmin_newsadmin_path(site)
      
    # News public via subdomain
    when /the subdomain news page for "(.*)"/
      site = Site.find_by_title($1)
      news_posts_path(:subdomain => site.title)
    # News private via subdomain
    when /the admin subdomain news page for "(.*)"/
      site = Site.find_by_title($1)
      newsadmin_index_path(:subdomain => site.title)
    when /the subdomain edit news page for "(.*)" in "(.*)"/
      site = Site.find_by_title($2)
      post = site.news_posts.find_by_title($1)
      edit_newsadmin_path(post, :subdomain => site.title)
    when /the subdomain create news page for "(.*)"/
      site = Site.find_by_title($1)
      new_newsadmin_path(:subdomain => site.title)
      
      
    when /the browse page for "(.*)"/
      site = Site.find_by_title($1)
      new_site_browse_path(site)
    when /the subdomain browse page for "(.*)"/
      site = Site.find_by_title($1)
      new_browse_path(:subdomain => site.title)
    
    when /the about page for site "(.*)"/
      site = Site.find_by_title($1)
      site_about_path(site)
    when /the subdomain about page for site "(.*)"/
      site = Site.find_by_title($1)
      about_path(:subdomain => site.title)
      
    when /the style page for "(.*)"/
      site = Site.find_by_title($1)
      siteadmin_sitestyle_path(site)
    when /the subdomain style page for "(.*)"/
      site = Site.find_by_title($1)
      sitestyle_path(:subdomain => site.title)
      
    when /the sites administration page/
      sites_administration_path
      
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
