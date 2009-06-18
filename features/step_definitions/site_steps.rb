Given /^I have (?:a )?site(?:s)? named "([^\"]*)"$/ do |sites|
  sites = sites.split(",")
  sites.each do |site|
    @site = Factory.create(:site, :name => site)
    membership = Factory.create(:membership, :site_id => @site.id, :user_id => @user.id, :owner => true)
  end
end

Given /^I have a site named "([^\"]*)" with description "([^\"]*)"$/ do |name, desc|
  @site = Factory.create(:site, :name => name, :description => desc, :users => [@user])
end

Then /^I should be at the site page for "([^\"]*)"$/ do |site_name|
  site = Site.find_by_name(site_name)
  URI.parse(current_url).path.should == site_path(site)
end

Then /^I should see the site information for "([^\"]*)"$/ do |site|
  site = Site.find_by_name(site)
  Then "I should see \"#{site.name}\""
  Then "I should see \"#{site.description}\""
end

When /^I follow "([^\"]*)" for site "([^\"]*)"$/ do |link, site|
  site = Site.find_by_name(site)
  raise "Site with name #{site} did not exist" unless site
  selector = "#site_#{site.id}"
  click_link_within selector, link
end

Given /^"([^\"]*)" has an item "([^\"]*)"$/ do |site, item_title|
  site = Site.find_by_name(site)
  @item = Factory.create(:item, :title => item_title, :site_id => site.id)
end

Given /^"([^\"]*)" has the users "([^\"]*)"$/ do |site_name, users|
  users = users.split(',').map { |u| u.strip }
  site = Site.find_by_name(site_name)
  users.each do |user_email|
    user = User.find_by_email(user_email)
    raise "Expected user #{user_email} to exist." unless user
    site.users << user
  end
end

Then /^"([^\"]*)" should have users "([^\"]*)"$/ do |site_name, users|
  users = users.split(',').map { |u| u.strip }
  site = Site.find_by_name(site_name)
  users.each do |user|
    user = User.find_by_email(user)
    raise "Expected #{site_name} to have user #{user.email}." unless site.users.include? user
  end
end
