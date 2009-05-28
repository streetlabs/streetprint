Given /^I have sites named "([^\"]*)"$/ do |sites|
  sites = sites.split(",")
  sites.each do |site|
    Given 'I visit my account page'
    When 'I follow "Create a site"'
    And "I fill in \"Name\" with \"#{site.strip}\""
    And 'I press "Create"'
    Then 'I should see "Successfully created site"'
  end
end

Then /^I should be at the site page for "([^\"]*)"$/ do |site_name|
  site = Site.find_by_name(site_name)
  URI.parse(current_url).path.should == site_path(site)
end

When /^I visit the site page for "([^\"]*)"$/ do |site_name|
  site = Site.find_by_name(site_name)
  visit site_path(site)
end
