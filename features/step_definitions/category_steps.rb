Given /^"([^\"]*)" has the following categories$/ do |site, table|
  table.hashes.each do |hash|
    @category = Factory.create(:category, hash.merge(:site_id => @site.id))
  end
end

Given /^"([^\"]*)" has a category with name "([^\"]*)"$/ do |site_name, name|
  unless site = Site.find_by_title(site_name)
    raise "Site with name #{site_name} does not exist"
  end
  @author = Factory.create(:category, :name => name, :site_id => site.id)
end
