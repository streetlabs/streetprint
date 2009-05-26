require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do

  it "should create a new instance given valid attributes" do
    Item.create!(Factory.attributes_for(:item))
  end
  
  it "should require a title" do
    item = Factory.build(:item, :title => nil)
    item.should have(1).error_on(:title)
  end
end