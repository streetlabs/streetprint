Given /^I have the following sites?$/ do |table|
  table.hashes.each do |hash|
    @site = Factory(:site, hash)
    membership = Factory.create(:membership, :site_id => @site.id, :user_id => @user.id)
    @user.has_role!(:owner, @site)
  end
end

Given /^I have (?:a )?site(?:s)? named "([^\"]*)"$/ do |sites|
  sites = sites.split(",")
  sites.each do |site|
    @site = Factory.create(:site, :name => site)
    membership = Factory.create(:membership, :site_id => @site.id, :user_id => @user.id)
    @user.has_role!(:owner, @site)
  end
end

Then /^I should be at the site page for "([^\"]*)"$/ do |site_name|
  site = Site.find_by_name(site_name)
  URI.parse(current_url).path.should == site_path(site)
end

Then /^I should see the site information for "([^\"]*)"$/ do |site|
  site = Site.find_by_name(site)
  Then "I should see \"#{site.name}\""
  Then "I should see \"#{site.welcome_blurb}\""
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
    site.memberships.build(:user => user)
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

When /^I press the set featured button for "([^\"]*)"$/ do |item|
  item = Item.find_by_title(item).id
  click_button "set_featured_item_#{item}"
end

When /^I bring up the photo "([^\"]*)"$/ do |photo|
  photo = @item.photos.find_by_photo_file_name(photo)
  click_link "photo_link_#{photo.id}"
end

Then /^the featured item for "([^\"]*)" should be "([^\"]*)"$/ do |site, item|
  site = Site.find_by_name(site)
  item = Item.find_by_title(item)
  assert_equal site.featured_item, item.id
end

Then /^the featured item and photo for "([^\"]*)" should be "([^\"]*)" and "([^\"]*)"$/ do |site, item, photo|
  site = Site.find_by_name(site)
  item = Item.find_by_title(item)
  photo = item.photos.find_by_photo_file_name(photo)
  assert_equal site.featured_item, item.id
  assert_equal site.featured_image, photo.id
end

Then /^I should see a preview of "([^\"]*)" with image "([^\"]*)"$/ do |item, image|
  item = Item.find_by_title(item)
  image = item.photos.find_by_photo_file_name(image)
  
  response.should contain(item.title)
  assert_have_selector "img#item_#{item.id}_photo_#{image.id}"
end

Then /^the site "([^\"]*)" field "([^\"]*)" should be "([^\"]*)"$/ do |site, field, value|
  @site = Site.find_by_name(site)
  assert_equal value, @site.send(field)
end


Then /^the site "([^\"]*)" should have the logo "([^\"]*)"$/ do |site, file|
  site = Site.find_by_name(site)
  raise "Expected site #{site} to have a logo" if site.logo_file_name.blank?
  
  prefix = "#{RAILS_ROOT}/public/system/logos/test/#{site.id}/"
  types = ["small"]
  dirs = []
  types.each do |type|
    dirs << prefix + type
  end
  
  dirs.each do |dir|
    raise "Expected logo to be created in #{dir}" unless File.exist? dir
  end
end