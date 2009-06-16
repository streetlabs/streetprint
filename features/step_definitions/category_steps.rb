Given /^"([^\"]*)" has the following categories$/ do |site, table|
  table.hashes.each do |hash|
    hash[:site_id] = @site.id
    @category = Factory.create(:category, hash)
  end
end

Given /^"([^\"]*)" has a category with name "([^\"]*)"$/ do |site_name, name|
  unless site = Site.find_by_name(site_name)
    raise "Site with name #{site_name} does not exist"
  end
  @author = Factory.create(:category, :name => name, :site_id => site.id)
end
