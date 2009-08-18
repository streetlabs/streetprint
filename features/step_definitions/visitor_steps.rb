Given /^"([^\"]*)" has created the following sites?$/ do |user_name, table|
  email_address = user_name + "@streetprint.org"
  @user = Factory.create(:active_user, :email => email_address)
  table.hashes.each do |hash|
    @site = Factory(:site, hash)
    membership = Factory.create(:membership, :site_id => @site.id, :user_id => @user.id)
    @user.has_role!(:admin, @site)
  end
end
