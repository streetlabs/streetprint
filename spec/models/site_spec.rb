require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site do

  it "should create a new instance given valid attributes" do
    site = Site.create!(Factory.attributes_for(:site))
  end
  
  it "should require a name" do
    site = Factory.build(:site, :name => nil)
    site.should_not be_valid
  end
  
  it "should have a name between 5 and 20 chars" do
    site = Factory.build(:site, :name => "abcd")
    site.should_not be_valid
    site = Factory.build(:site, :name => "a"*21)
    site.should_not be_valid
  end
  
  it "should be able to get all of its categories" do
    site = Factory.create(:site)
    c1 = Factory.create(:category, :site_id => site.id)
    c2 = Factory.create(:category, :site_id => site.id)
    c3 = Factory.create(:category, :site_id => site.id)
    
    site.categories.should include(c1)
    site.categories.should include(c2)
    site.categories.should include(c3)
  end
  
  it "should be able to get all of its document types" do
    site = Factory.create(:site)
    dt1 = Factory.create(:document_type, :site_id => site.id)
    dt2 = Factory.create(:document_type, :site_id => site.id)
    dt3 = Factory.create(:document_type, :site_id => site.id)
    
    site.document_types.should include(dt1)
    site.document_types.should include(dt2)
    site.document_types.should include(dt3)
  end
  
  it "should be able to get all of its items" do
    site = Factory.create(:site)
    item_1 = Factory.create(:item, :site_id => site.id)
    item_2 = Factory.create(:item, :site_id => site.id)
    item_3 = Factory.create(:item, :site_id => site.id)
    site.items.should include(item_1)
    site.items.should include(item_2)
    site.items.should include(item_3)
  end
  
  it "should be able to get the role of a specific user" do
    user = Factory.create(:user)
    site = Factory.create(:site)
    role = Factory.create(:role, :name => 'admin')
    membership1 = Factory.create(:membership, :user_id => user.id, :site_id => site.id, :role_id => role.id)
    site.role_of(user).should == 'admin'
  end
end