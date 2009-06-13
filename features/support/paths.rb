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
      user_path(UserSession.find.record)
      
      
    when /the sites page/
      account_path
    when /the site page for "(.*)"/
      site_path(Site.find_by_name($1))
    when /the edit site page for "(.*)"/
      edit_site_path(Site.find_by_name($1))
      
      
    when /the new item page for "(.*)"/
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

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
