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
  Given 'I press "login"'
end

Given /^there is an item with title "([^\"]*)"$/ do |title|
  Factory.create(:item, :title => title)
end

Given /^I am on the item page for "([^\"]*)"$/ do |title|
  item = Item.find_by_title(title)
  visit item_path(item.id)
end
