Given /^"([^\"]*)" has the following document types$/ do |site, table|
  table.hashes.each do |hash|
    hash[:site_id] = @site.id
    @document_type = Factory.create(:document_type, hash)
  end
end

Given /^"([^\"]*)" has a document type with name "([^\"]*)"$/ do |site_name, name|
  unless site = Site.find_by_name(site_name)
    raise "Site with name #{site_name} does not exist"
  end
  @document_type = Factory.create(:document_type, :name => name, :site_id => site.id)
end