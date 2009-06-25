Then /^debug$/ do
  save_and_open_page
  breakpoint
  0
end

When /^I follow "([^\"]*)" within "([^\"]*)"$/ do |link, selector|
  click_link_within selector, link
end


Then /^I should see each of "([^\"]*)"$/ do |elements_csv|
  elements_csv.split(',').each do |element|
    response.should contain(element.strip)
  end
end

Then /^I should not see each of "([^\"]*)"$/ do |elements_csv|
  elements_csv.split.each do |element|
    response.should_not contain(element)
  end
end


Given /^the 'admin' role is missing$/ do
  Role.find_by_name('admin').destroy
end
