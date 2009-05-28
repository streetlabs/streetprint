Then /^I fill in "([^\"]*)" with the file "([^\"]*)"$/ do |field, file|
  selenium.wait_for_page_to_load(5.seconds)
  selenium.attach_file(field, "file://#{RAILS_ROOT}/#{file}")
end