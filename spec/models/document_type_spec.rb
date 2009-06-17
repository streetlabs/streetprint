require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DocumentType do

  it "should create a new instance given valid attributes" do
    user = Factory.create(:user)
    site = Factory.create(:site, :users => [user])
    category = Category.create!(Factory.attributes_for(:document_type, :site_id => site.id))
  end
  
  it "should require a name" do
    document_type = Factory.build(:document_type, :name => nil)
    document_type.should have(1).error_on(:name)
  end
  
  it "should require a site" do
    document_type = Factory.build(:document_type)
    document_type.should have(1).error_on(:site_id)
  end
  
  it "should be able to get all associated items" do
    user = Factory.create(:user)
    site = Factory.create(:site, :users => [user])
    document_type = DocumentType.create!(Factory.attributes_for(:document_type, :site_id => site.id))
    i1 = Factory.create(:item, :site_id => site.id, :document_type_id => document_type.id)
    i2 = Factory.create(:item, :site_id => site.id, :document_type_id => document_type.id)
    i3 = Factory.create(:item, :site_id => site.id, :document_type_id => document_type.id)
    
    document_type.items.should include(i1)
    document_type.items.should include(i2)
    document_type.items.should include(i3)
  end
  
end