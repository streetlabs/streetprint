Given /^I have (?:a )?site(?:s)? named "([^\"]*)"$/ do |sites|
  sites = sites.split(",")
  sites.each do |site|
    Given "I have a site named \"#{site.strip}\" with description \"\""
  end
end

Given /^I have a site named "([^\"]*)" with description "([^\"]*)"$/ do |name, desc|
  Given 'I visit my account page'
  When 'I follow "Create a site"'
  And "I fill in \"Name\" with \"#{name}\""
  And "I fill in \"Description\" with \"#{desc}\""
  And 'I press "Create"'
  Then 'I should see "Successfully created site"'
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
