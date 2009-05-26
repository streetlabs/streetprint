require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site do

  it "should create a new instance given valid attributes" do
    user = Factory.create(:user)
    site = Site.create!(Factory.attributes_for(:site, :user_id => user.id))
  end
  
  it "should require a user_id" do
    site = Factory.build(:site, :user_id => nil)
    site.should_not be_valid
  end
  
  it "should require a name" do
    user = Factory.create(:user)
    site = Factory.build(:site, :user_id => user.id, :name => nil)
    site.should_not be_valid
  end
  
  it "should have a name between 5 and 20 chars" do
    user = Factory.create(:user)
    site = Factory.build(:site, :user_id => user.id, :name => "abcd")
    site.should_not be_valid
    site = Factory.build(:site, :user_id => user.id, :name => "a"*21)
    site.should_not be_valid
  end
  
  it "should be able to get all sites from a user" do
    user = Factory.create(:user)
    site1 = Factory.create(:site, :user_id => user.id)
    site2 = Factory.create(:site, :user_id => user.id)
    user.sites.should include(site1)
    user.sites.should include(site2)
  end
  
end