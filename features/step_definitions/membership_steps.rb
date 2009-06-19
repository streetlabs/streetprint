Given /^"(.+)" has the user "(.+)" with role "(.+)"$/ do |site, user, role|
  site = Site.find_by_name(site)
  raise "Expected site #{site} to exist" unless site
  user = User.find_by_email(user)
  raise "Expected user '#{user}' to exist" unless user
  role = Role.find_by_name(role)
  raise "Expected role '#{role}' to exist" unless role
  membership = Factory(:membership, :user_id => user.id, :site_id => site.id, :role_id => role.id )
end

Then /^I should be an owner for the site "(.+)"$/ do |site_name|
  raise "Expected site '#{site_name}' to exist" unless site = Site.find_by_name(site_name)
  raise "Expected '#{@user.email}' to be an owner of '#{site_name}'" unless site.owner?(@user)
end

Then /^there should be no remove link for myself$/ do
  assert_have_no_selector( "a#remove_user_#{@user.id}")
end

Then /^"(.+)" should have user "(.+)" with role "(.+)"$/ do |site, user, role|
  site = Site.find_by_name(site)
  raise "Expected site #{site} to exist" unless site
  user = User.find_by_email(user)
  raise "Expected user '#{user}' to exist" unless user
  raise "Expected #{user} to be a member of #{site}" unless site.users.include? user
  membership = site.memberships.find_by_user_id(user.id)
  raise "Expected #{user} to be #{role} of site" unless membership.role.name == role
end

When /^"(.+)" has the user "(\S+)"$/ do |site, user|
  site = Site.find_by_name(site)
  user = User.find_by_email(user)
  role = Role.find_by_name('admin')
  Factory.create(:membership, :site_id => site.id, :user_id => user.id, :role_id => role.id)
end

Then /^"(.+)" should not have the user "(.+)"$/ do |site, user|
  site = Site.find_by_name(site)
  raise "Expected site #{site} to exist" unless site
  user = User.find_by_email(user)
  raise "Expected user '#{user}' to exist" unless user
  raise "Expected #{user} not to belong to #{site}" if site.users.include? user
end

