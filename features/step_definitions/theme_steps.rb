Given /^I have the following themes?$/ do |table|
  table.hashes.each do |hash|
    theme_hash = hash.dup
    
    if theme_hash[:icon]
      icon = File.new("#{RAILS_ROOT}/features/test_files/#{hash[:icon]}")
      theme_hash[:icon] = icon
    end
    if images = theme_hash[:images]
      theme_hash.delete "images"
      theme_hash[:image_attributes] = []
      images = images.split(", ").map { |i| "#{RAILS_ROOT}/features/test_files/#{i}" }
      for image in images
        theme_hash[:image_attributes] << {"image" => File.new(image)}
      end
    end
    user = User.find_by_email(theme_hash[:user])
    theme_hash[:user] = user
    theme = Factory(:site_theme, theme_hash)
    user.has_role!(:creator, theme) if user
  end
end


Then /^the following themes? should exist$/ do |table|
  table.hashes.each do |hash|
    raise "Expected theme with with name #{hash[:name]} to exist" unless theme = SiteTheme.find_by_name(hash[:name])
    theme.send("#{hash[:page]}_template").template.should == hash[:template] if hash[:template]
    theme.send("#{hash[:page]}_template").css.should == hash[:css] if hash[:css]
    theme.icon_file_name.should == hash[:icon] if hash[:icon]
  end
end

Then /^the theme "([^\"]*)" should not exist$/ do |name|
  theme = SiteTheme.find_by_name(name)
  raise "Expected theme #{name} to not exist" if theme
end

Then /^theme "([^\"]*)" should have image "([^\"]*)"$/ do |theme_name, image|
  theme = SiteTheme.find_by_name(theme_name)
  
  unless theme.theme_images.map{ |ti| ti.image_file_name }.include?(image)
    raise "Expected #{theme_name} to have image #{image}"
  end
end

Then /^there should be a link to "([^\"]*)"$/ do |link|
  assert_have_xpath("//a[text() = '#{link}']")
end

Then /^I click the remove image link for "([^\"]*)"$/ do |image|
  img = ThemeImage.find_by_image_file_name(image)
  click_button("delete_image_#{img.id}")
end

Then /^theme "([^\"]*)" should not have any images$/ do |theme_name|
  SiteTheme.find_by_name(theme_name).theme_images.should be_empty
end

Then /^I should see the path to the image "([^\"]*)" for theme "([^\"]*)"$/ do |file_name, theme_name|
  t = SiteTheme.find_by_name(theme_name)
  i = t.theme_images.find_by_image_file_name(file_name)
  response.should contain(i.image.url)
end
