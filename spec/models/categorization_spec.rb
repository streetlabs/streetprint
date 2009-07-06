require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Categorization do

  it "should create a relationship between categories and items" do
    site = Factory.create(:site)
    cat1 = Factory.create(:category, :site_id => site.id)
    cat2 = Factory.create(:category, :site_id => site.id)
    item1 = Factory.create(:item, :site_id => site.id)
    item2 = Factory.create(:item, :site_id => site.id)
    Factory.create(:categorization, :category_id => cat1.id, :item_id => item1.id)
    Factory.create(:categorization, :category_id => cat1.id, :item_id => item2.id)
    Factory.create(:categorization, :category_id => cat2.id, :item_id => item2.id)
    
    cat1.items.should include(item1)
    cat1.items.should include(item2)
    cat2.items.should include(item2)
    
    item1.categories.should include(cat1)
    item2.categories.should include(cat1)
    item2.categories.should include(cat2)
  end
  
  it "should require both a category and item" do
    site = Factory.create(:site)
    cat = Factory.create(:category, :site_id => site.id)
    item = Factory.create(:item, :site_id => site.id)
    
    categorization = Categorization.new(Factory.attributes_for(:categorization, :category_id => cat.id))
    categorization.should have(1).error_on(:item_id)
    
    categorization = Categorization.new(Factory.attributes_for(:categorization, :item_id => item.id))
    categorization.should have(1).error_on(:category_id)
    
  end
  
end