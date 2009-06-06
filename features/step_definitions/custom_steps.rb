Then /^debug$/ do
  save_and_open_page
  breakpoint
  0
end

When /^I follow "([^\"]*)" within "([^\"]*)"$/ do |link, selector|
  click_link_within selector, link
end


Given /^"([^\"]*)" has the following items$/ do |site, table|
  table.hashes.each do |hash|
    hash[:site_id] = @site.id
    item = Factory.create(:item, hash)
  end
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
