Given /^"([^\"]*)" has an item with title "([^\"]*)"$/ do |site_name, title|
  unless site = Site.find_by_name(site_name)
    raise "Site with name #{site_name} does not exist"
  end
  @item = Factory.create(:item, :title => title, :site_id => site.id)
end

Given /^"([^\"]*)" has an item with title "([^\"]*)" and author "([^\"]*)"$/ do |site_name, item_title, author_name|
  unless site = Site.find_by_name(site_name)
    raise "Site with name #{site_name} does not exist"
  end
  unless author = Author.find_by_name(author_name)
    author = Factory.create(:author, :site_id => site.id, :name => author_name)
  end
  @item = Factory.create(:item, :title => item_title, :site_id => site.id, :authors => [author])
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
    When "I go to the item page for \"#{@item.title}\" in \"#{@item.site.name}\""
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

Given /^"([^\"]*)" has (\d+) photos$/ do |item_name, num|
  item = @item
  @photos = []
  Integer(num).times do
    @photos << Factory.create(:photo, :item_id => item.id)
  end
end


Then /^the page should contain the item info$/ do
  response.should contain(@item.title)
  photos = @item.photos.map {|p| p.id}
  photos.each do |id|
    tag = /<img[^>]+src=\"\/system\/photos\/test\/#{id}/
    raise "Expected the response_body to match #{tag}" unless response_body =~ tag
  end
end

Then /^the page should contain the item info for "([^\"]*)"$/ do |item_title|
  @item = Item.find_by_title(item_title)
  Then 'the page should contain the item info'
end
