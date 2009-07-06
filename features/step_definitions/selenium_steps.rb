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

When /^I click remove for the first category$/ do
  selenium.click "xpath=//div[@id='categories']/p/a"
end

When /^I click the remove user link for "([^\"]*)"$/ do |user_email|
  user = User.find_by_email(user_email)
  selenium.click "xpath=//div[@id='existing_user_#{user.id}']/a"
end

When /^I select "([^\"]*)" from the "([^\"]*)" author dropdown$/ do |label, pos|
  # need a way to tell the new author selects apart...
  selenium.select "xpath=//select[@id='new_author_select']", label
end
  
When /^I select "([^\"]*)" from the "([^\"]*)" category dropdown$/ do |label, pos|
  # need a way to tell the new category selects apart...
  selenium.select "xpath=//select[@id='new_category_select']", label
end

When /^I fill in the (\S*) user field with "([^\"]*)"$/ do |pos, value|
  case pos
  when 'first'
    pos = 0
  when 'second'
    pos = 1
  when 'third'
    pos = 2
  else
    pos = 0
  end
  
  selenium.type "xpath=//div[@id='new_user_#{pos}']/p/input", value
end
