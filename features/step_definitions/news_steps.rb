Given /^"([^\"]*)" has the following news posts$/ do |site, table|
  table.hashes.each do |hash|
    hash[:site_id] = @site.id
    Factory(:news_post, hash)
  end
end