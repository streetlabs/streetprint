Given /^"([^\"]*)" has the following authors$/ do |site, table|
  table.hashes.each do |hash|
    hash[:site_id] = @site.id
    author = Factory.create(:author, hash)
  end
end

Given /^"([^\"]*)" has an author with name "([^\"]*)"$/ do |site_name, name|
  unless site = Site.find_by_name(site_name)
    raise "Site with name #{site_name} does not exist"
  end
  @author = Factory.create(:author, :name => name, :site_id => site.id)
end

