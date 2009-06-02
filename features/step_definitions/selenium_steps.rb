Then /^I fill in "([^\"]*)" with the file "([^\"]*)"$/ do |field, file|
  selenium.wait_for_page_to_load(5.seconds)
  selenium.attach_file(field, "file://#{RAILS_ROOT}/#{file}")
end

When /^I check the box for the first photo$/ do
  @photo = @item.photos.first
  selenium.check "xpath=//input[@name='photo_ids[]' and @value='#{@photo.id}']"
end

When /^I press "([^\"]*)" and wait for the page to load$/ do |button|
  click_button(button)
  selenium.wait_for_page_to_load(5.seconds)
end