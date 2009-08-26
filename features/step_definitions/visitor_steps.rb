Given /^"([^\"]*)" has created the following sites?$/ do |user_name, table|
  email_address = user_name + "@streetprint.org"
  @user = Factory.create(:active_user, :email => email_address)
  table.hashes.each do |hash|
    logo = File.new("#{RAILS_ROOT}/features/test_files/#{hash['logo']}") unless hash['logo'].blank?
    @site = Factory(:site, hash.merge('logo' => logo))
    membership = Factory.create(:membership, :site_id => @site.id, :user_id => @user.id)
    @user.has_role!(:admin, @site)
  end
end

Then /^I should see the logo for "([^\"]*)"$/ do |site|
  site = Site.find_by_title(site)
  unless response.body =~ /<img([^>])*src=\"\/system\/logos\/test\/#{site.id}\/small_wide\//
    raise "Expected page to contain logo for #{site.title}. \n\n #{response.body}"
  end
end

Then /^I should not see the logo for "([^\"]*)"$/ do |site|
  site = Site.find_by_title(site)
  unless response.body !~ /<img([^>])*src=\"\/system\/logos\/test\/#{site.id}\/small_wide\//
    raise "Expected page to not contain logo for #{site.title}. \n\n #{response.body}"
  end
end