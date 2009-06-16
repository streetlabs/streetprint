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
  
  it "should be able to get all of its categories" do
    user = Factory.create(:user)
    site = Factory.create(:site, :user_id => user.id)
    c1 = Factory.create(:category, :site_id => site.id)
    c2 = Factory.create(:category, :site_id => site.id)
    c3 = Factory.create(:category, :site_id => site.id)
    
    site.categories.should include(c1)
    site.categories.should include(c2)
    site.categories.should include(c3)
  end
  
  it "should be able to get all of its document types" do
    user = Factory.create(:user)
    site = Factory.create(:site, :user_id => user.id)
    dt1 = Factory.create(:document_type, :site_id => site.id)
    dt2 = Factory.create(:document_type, :site_id => site.id)
    dt3 = Factory.create(:document_type, :site_id => site.id)
    
    site.document_types.should include(dt1)
    site.document_types.should include(dt2)
    site.document_types.should include(dt3)
  end
end