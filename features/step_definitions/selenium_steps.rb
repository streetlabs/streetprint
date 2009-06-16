Then /^I fill in "([^\"]*)" with the file "([^\"]*)"$/ do |field, file|
  selenium.wait_for_page_to_load(5.seconds)
  selenium.attach_file(field, "file://#{RAILS_ROOT}/#{file}")
end

When /^I remove the first photo$/ do
  @photo = @item.photos.first
  selenium.click "xpath=//div[@id='photo_#{@photo.id}']/a"
end

When /^I press "([^\"]*)" and wait for the page to load$/ do |button|
  click_button(button)
  selenium.wait_for_page_to_load(5.seconds)
end

When /^I click remove for the first author$/ do
  selenium.click "xpath=//div[@id='authors']/p/a"
end

When /^I select "([^\"]*)" from the "([^\"]*)" author dropdown$/ do |label, pos|
  # need a way to tell the new author selects apart...
  selenium.select "xpath=//select[@id='new_author_select']", label
end
    