require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Author do

  it "should create a new instance given valid attributes" do
    user = Factory.create(:user)
    site = Factory.create(:site, :users => [user])
    author = Author.create!(Factory.attributes_for(:author, :site_id => site.id))
  end
  
  it "should require a name" do
    author = Factory.build(:author, :name => nil)
    author.should have(1).error_on(:name)
  end
  
  it "should require a site" do
    author = Factory.build(:author)
    author.should have(1).error_on(:site_id)
  end
  
end