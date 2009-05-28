require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do

  it "should create a new instance given valid attributes" do
    Item.create!(Factory.attributes_for(:item))
  end
  
  it "should require a title" do
    item = Factory.build(:item, :title => nil)
    item.should have(1).error_on(:title)
  end
  
  it "should destroy all associated photos when it is destroyed" do
    item = Factory.create(:item)
    photo_1 = Factory.create(:photo, :item_id => item.id)
    photo_2 = Factory.create(:photo, :item_id => item.id)
    item.destroy
    Photo.find_by_id(photo_1.id).should be_nil
    Photo.find_by_id(photo_2.id).should be_nil
  end
  
end