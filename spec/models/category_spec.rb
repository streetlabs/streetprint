require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do

  it "should create a new instance given valid attributes" do
    user = Factory.create(:user)
    site = Factory.create(:site, :user_id => user.id)
    category = Category.create!(Factory.attributes_for(:category, :site_id => site.id))
  end
  
  it "should require a name" do
    category = Factory.build(:category, :name => nil)
    category.should have(1).error_on(:name)
  end
  
  it "should require a site" do
    category = Factory.build(:category)
    category.should have(1).error_on(:site_id)
  end
  
  it "should be able to get all associated items" do
    user = Factory.create(:user)
    site = Factory.create(:site, :user_id => user.id)
    category = Category.create!(Factory.attributes_for(:category, :site_id => site.id))
    i1 = Factory.create(:item, :site_id => site.id, :category_id => category.id)
    i2 = Factory.create(:item, :site_id => site.id, :category_id => category.id)
    i3 = Factory.create(:item, :site_id => site.id, :category_id => category.id)
    
    category.items.should include(i1)
    category.items.should include(i2)
    category.items.should include(i3)
  end
  
end