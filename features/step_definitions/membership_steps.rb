Then /^I should be an owner for the site "(.+)"$/ do |site_name|
  raise "Expected site #{site_name} to exists" unless site = Site.find_by_name(site_name)
  raise "Expected #{@user.email} to be an owner of #{site_name}" unless site.owner?(@user)
end

Then /^there should be no remove link for myself$/ do
  assert_have_no_selector( "a#remove_user_#{@user.id}")
end
