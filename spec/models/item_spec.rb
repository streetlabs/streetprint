require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do

  it "should create a new instance given valid attributes" do
    site = Factory.create(:site)
    Item.create!(Factory.attributes_for(:item, :site_id => site.id))
  end
  
  it "should require a title" do
    item = Factory.build(:item, :title => nil)
    item.should have(1).error_on(:title)
  end
  
  it "should require a site" do
    item = Factory.build(:item)
    item.should have(1).error_on(:site_id)
  end
  
  it "should destroy all associated photos when it is destroyed" do
    site = Factory.create(:site)
    item = Factory.create(:item, :site_id => site.id)
    photo_1 = Factory.create(:photo, :item_id => item.id)
    photo_2 = Factory.create(:photo, :item_id => item.id)
    item.destroy
    Photo.find_by_id(photo_1.id).should be_nil
    Photo.find_by_id(photo_2.id).should be_nil
  end

end