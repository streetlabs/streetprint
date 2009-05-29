Given /^there is an item with title "([^\"]*)"$/ do |title|
  @item = Factory.create(:item, :title => title)
end

When /^I visit the item page for "([^\"]*)"$/ do |title|
  item = Item.find_by_title(title)
  visit item_path(item.id)
end

Then /^the item "([^\"]*)" should have a photo with file name "([^\"]*)"$/ do |title, file|
  item = Item.find_by_title(title)
  unless item
    raise "Expected item with title #{title} to exist."
  end
  unless item.photos.find_by_photo_file_name(file)
    raise "Expected item with title #{title} to have photo with file #{file} but it only had #{item.photos}"
  end
end

When /^I visit the item page for the item$/ do
  visit item_path(@item)
end

When /^I visit the edit page for the item$/ do
  visit edit_item_path(@item)
end

Then /^the item should have (\d+) photos?$/ do |num|
  num = Integer(num)
  unless @item.photos.count == num
    raise "Expected the item to have #{num} photos, but it had #{@item.photos.count}, #{@item.photos.inspect}"
  end
  if num == 1
    @photo = @item.photos.first
  else
    @photos = @item.photos
  end
end

Given /^the item has 3 photos$/ do
  3.times do
    When 'I visit the item page for the item'
      And 'I follow "Edit"'
      And 'I fill in "item_photo_attributes__photo" with the file "features/test_images/rails.png"'
      And 'I press "Submit"'
    Then 'I should see "Successfully updated item."'
  end
  Then 'the item should have 3 photos'
end

When /^I delete the item$/ do
  @item.destroy
end
