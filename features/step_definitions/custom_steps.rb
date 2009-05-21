Given /^I have an active account with email "([^\"]*)"$/ do |email|
  Factory.create(:active_user, :email => email)
end

Given /^I have an active account with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  Factory.create(:active_user, :email => email, :password => password)
end

Then /^I should be logged in as "([^\"]*)"$/ do |email|
  unless User.logged_in.find_by_email(email)
    raise "Expected #{email} to be logged in but they were not"
  end
end

Given /^I am logged in$/ do
  user = Factory.create(:active_user)
  Given 'I am on the homepage'
  Given "I fill in \"email\" with \"#{user.email}\""
  Given 'I fill in "password" with "secret"'
  Given 'I press "Login"'
  Then "I should see \"Login successful\""
end

Given /^there is an item with title "([^\"]*)"$/ do |title|
  Factory.create(:item, :title => title)
end

When /^I visit the item page for "([^\"]*)"$/ do |title|
  item = Item.find_by_title(title)
  visit item_path(item.id)
end

When /^I type "([^\"]*)" into "([^\"]*)"$/ do |value, locator|
  selenium.type(locator, value)
end

Then /^the item "([^\"]*)" should have a photo with file name "([^\"]*)"$/ do |title, file|
  item = Item.find_by_title(title)
  unless item
    raise "Expected item with title #{title} to exist."
  end
  unless item.photos.find_by_photo_file_name(file)
    raise "Expected item with title #{title} to have photo with file #{file} but it only had #{item.photos}"
  end
end
