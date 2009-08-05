Given /^"([^\"]*)" has the following news posts$/ do |site, table|
  table.hashes.each do |hash|
    Factory(:news_post, hash.merge(:site_id => @site.id))
  end
end