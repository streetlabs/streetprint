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
  
  it "should set the date correctly based on the year/month/day input" do
    site = Factory.create(:site)
    item = Item.new(Factory.attributes_for(:item, :year => 2000, :month => 4, :day => 12, :site_id => site.id))
    item.save!
    item.date.to_date.should == Date.new(2000, 4, 12)
    
    item = Item.new(Factory.attributes_for(:item, :year => 2000, :month => 4, :site_id => site.id))
    item.save!
    item.date.to_date.should == Date.new(2000, 4, 1)
  end
  
  it "should return a pretty date string based on what fields were specified" do
    site = Factory(:site)
    item = Item.new(Factory.attributes_for(:item, :year => 2000, :month => 4, :day => 12, :site_id => site.id))
    item.save!
    item.pretty_date.should == "2000 April 12"
    
    item = Item.new(Factory.attributes_for(:item, :year => 2000, :month => 4, :site_id => site.id))
    item.save!
    item.pretty_date.should == "2000 April"
    
    item = Item.new(Factory.attributes_for(:item, :year => 2000, :site_id => site.id))
    item.save!
    item.pretty_date.should == "2000"
    
    item = Item.new(Factory.attributes_for(:item, :month => 12, :site_id => site.id))
    item.save!
    item.pretty_date.should == "December"
    
    item = Item.new(Factory.attributes_for(:item, :day => 12, :site_id => site.id))
    item.save!
    item.pretty_date.should == "12"
  end

end