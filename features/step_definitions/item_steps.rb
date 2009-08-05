Given /^"([^\"]*)" has the following items$/ do |site, table|
  table.hashes.each do |hash|
    item_hash = hash.dup
    item_hash[:site_id] = @site.id
    
    if photos = hash[:photos]
      item_hash.delete "photos"
      item_hash[:photo_attributes] = []
      photos = photos.split(", ").map { |p| "#{RAILS_ROOT}/features/test_files/#{p.strip}" }
      for photo in photos
        item_hash[:photo_attributes] << {"photo" => File.new(photo)}
      end
    end

    if authors = hash[:authors]
      item_hash.delete "authors"
      item_hash[:authors_list] = authors.split(", ").map { |a| @site.authors.find_by_name(a).id }
    end
    
    if categories = hash[:categories]
      item_hash.delete "categories"
      item_hash[:categories_list] = categories.split(", ").map { |c| @site.categories.find_by_name(c).id }
    end
    
    if dt = hash[:document_type]
      item_hash.delete "document_type"
      item_hash[:document_type_id] = @site.document_types.find_by_name(dt).id
    end
    
    @item = Factory(:item, item_hash)
  end
end

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

Then /^the item should have (\d+) media files?$/ do |num|
  num = Integer(num)
  unless @item.media_files.count == num
    raise "Expected the item to have #{num} media files, but it had #{@item.media_files.count}"
  end
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

Then /^I should see the first image for "([^\"]*)" in "([^\"]*)"$/ do |item, site|
  @site = Site.find_by_name(site)
  @item = @site.items.find_by_title(item)
  @photo = @item.photos.first
  assert_have_selector "img", {:id => "item_#{@item.id}_photo_#{@photo.id}"}
end


Then /^the items should appear in order "([^\"]*)"$/ do |items|
  items = items.split(", ")
  items = items.map { |i| Item.find_by_title(i) }
  starting_position = 1
  
  0.upto(items.size-1) do |i|
    id = items[i].id
    position = i + starting_position
    assert_have_xpath("//table[@id='items']/span[@about='/sites/#{@site.id}/items/#{id}' and position()=#{position}]")
  end
end

Given /^I set the items created_at to have order "([^\"]*)"$/ do |items|
  items = items.split(", ")
  items = items.map { |i| Item.find_by_title(i) }
  t = DateTime.now
  (items.size-1).downto(0) do |i|
    items[i].created_at = t - i.hours
    items[i].save!
  end
end

Given /^I set the items updated_at to have order "([^\"]*)"$/ do |items|
  items = items.split(", ")
  items = items.map { |i| Item.find_by_title(i) }
  for item in items
    item.save!
    sleep(1)
  end
end

Then /^I should see items? "([^\"]*)"$/ do |items|
  items = items.split(", ")
  items = items.map { |i| Item.find_by_title(i) }
  for item in items
    assert_have_selector("table#items tr#item_row_#{item.id}")
  end
end

Then /^I should not see items? "([^\"]*)"$/ do |items|
  items = items.split(", ")
  items = items.map { |i| Item.find_by_title(i) }
  for item in items
    assert_have_no_selector("table#items tr#item_row_#{item.id}")
  end
end