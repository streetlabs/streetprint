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

Then /^the item should have (\d+) photos?$/ do |num|
  num = Integer(num)
  unless @item.photos.count == num
    raise "Expected the item to have #{num} photos."
  end
  if num == 1
    @photo = @item.photos.first
  else
    @photos = @item.photos
  end
end