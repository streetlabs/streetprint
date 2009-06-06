Given /^I have an active account with email "([^\"]*)"$/ do |email|
  Factory.create(:active_user, :email => email)
end

Given /^I have an active account with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  Factory.create(:active_user, :email => email, :password => password)
end

Given /^I have an account with email "([^\"]*)"$/ do |email|
  Factory.create(:user, :email => email)
end

When /^I visit the account page for "([^\"]*)"$/ do |email|
  user = User.find_by_email(email)
  visit user_path(user)
end

Then /^I should be logged in as "([^\"]*)"$/ do |email|
  unless User.logged_in.find_by_email(email)
    raise "Expected #{email} to be logged in but they were not"
  end
end

Then /^I should not be logged in$/ do
  if UserSession.find && (user = UserSession.find.user)
    raise "Expected to not be logged in but logged in as #{user.email}"
  end
end

Given /^I am logged in$/ do
  @user = Factory.create(:active_user)
  Given 'I am on the homepage'
  Given "I fill in \"email\" with \"#{@user.email}\""
  Given 'I fill in "password" with "secret"'
  Given 'I press "Login"'
  Then "I should see \"Login successful\""
end

Given /^I am logged in as "([^\"]*)"$/ do |email|
  @user = Factory.create(:active_user, :email => email)
  Given 'I am on the homepage'
  Given "I fill in \"email\" with \"#{@user.email}\""
  Given 'I fill in "password" with "secret"'
  Given 'I press "Login"'
  Then "I should see \"Login successful\""
end

Then /^I should be able to login as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  Given 'I am logged out'
  Given 'I am on the homepage'
  Given "I fill in \"email\" with \"#{email}\""
  Given "I fill in \"password\" with \"#{password}\""
  Given 'I press "Login"'
  Then "I should see \"Login successful\""
end

Then /^I am logged out|I log out$/ do
  if UserSession.find
    Given 'I am on the homepage'
    Given "I follow \"logout\""
  end
end

When /^I am inactive for (\d+) minutes$/ do |time|
  user = UserSession.find.user
  user.last_request_at = user.last_request_at - 45.minutes
  user.save!
end

Given /^the perishable token for "([^\"]*)" is reset$/ do |email|
  user = User.find_by_email(email)
  user.reset_perishable_token!
end