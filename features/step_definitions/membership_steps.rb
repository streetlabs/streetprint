Given /^"([^\"]*)" has the user "([^\"]*)"$/ do |site, user|
  site = Site.find_by_title(site)
  raise "Expected site #{site} to exist" unless site
  user = User.find_by_email(user)
  raise "Expected user '#{user}' to exist" unless user
  membership = Factory(:membership, :user_id => user.id, :site_id => site.id)
end

Given /^"([^\"]*)" has the user "([^\"]*)" with role "([^\"]*)"$/ do |site, user, role|
  site = Site.find_by_title(site)
  raise "Expected site #{site} to exist" unless site
  user = User.find_by_email(user)
  raise "Expected user '#{user}' to exist" unless user
  membership = Factory(:membership, :user_id => user.id, :site_id => site.id)
  user.has_role!(role, site)
end

Then /^there should be no remove link for myself$/ do
  assert_have_no_selector( "a#remove_user_#{@user.id}")
end

Then /^"([^\"]*)" should have user "([^\"]*)" with role "([^\"]*)"$/ do |site, email, role|
  site = Site.find_by_title(site)
  raise "Expected site #{site} to exist" unless site
  user = User.find_by_email(email)
  raise "Expected user '#{email}' to exist" unless user
  raise "Expected #{email} to be a member of #{site}" unless site.users.include? user
  raise "Expected #{email} to have role #{role}" unless user.has_role?(role, site)
end


Then /^"([^\"]*)" should not have the user "([^\"]*)"$/ do |site, user|
  site = Site.find_by_title(site)
  raise "Expected site #{site} to exist" unless site
  user = User.find_by_email(user)
  raise "Expected user '#{user}' to exist" unless user
  raise "Expected #{user} not to belong to #{site}" if site.users.include? user
end

When /^I follow remove for the user "([^\"]*)"$/ do |user|
  user = User.find_by_email(user)
  click_link "remove_user_#{user.id}"
end

