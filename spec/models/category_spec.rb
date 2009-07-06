require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do

  it "should create a new instance given valid attributes" do
    site = Factory.create(:site)
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
  
end