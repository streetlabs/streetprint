Given /^I have (?:a )?site(?:s)? named "([^\"]*)"$/ do |sites|
  sites = sites.split(",")
  sites.each do |site|
    Factory.create(:site, :name => site, :user_id => @user.id)
  end
end

Given /^I have a site named "([^\"]*)" with description "([^\"]*)"$/ do |name, desc|
  Factory.create(:site, :name => name, :description => desc, :user_id => @user.id)
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
