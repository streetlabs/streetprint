Given /seleniumtest/ do
  Given "I am on the homepage"
  3.times do
    Factory.create(:item)
  end
  puts selenium.get_html_source
  puts selenium.get_location
  
end
  