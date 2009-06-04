Then /^debug$/ do
  save_and_open_page
  breakpoint
  0
end

When /^I follow "([^\"]*)" within "([^\"]*)"$/ do |link, selector|
  click_link_within selector, link
end