require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Authored do

  it "should create a relationship between authors and items" do
    site = Factory.create(:site)
    author1 = Factory.create(:author, :site_id => site.id)
    author2 = Factory.create(:author, :site_id => site.id)
    item1 = Factory.create(:item, :site_id => site.id)
    item2 = Factory.create(:item, :site_id => site.id)
    Factory.create(:authored, :author_id => author1.id, :item_id => item1.id)
    Factory.create(:authored, :author_id => author1.id, :item_id => item2.id)
    Factory.create(:authored, :author_id => author2.id, :item_id => item2.id)
    
    author1.items.should include(item1)
    author1.items.should include(item2)
    author2.items.should include(item2)
    
    item1.authors.should include(author1)
    item2.authors.should include(author1)
    item2.authors.should include(author2)
  end
  
  it "should require both an author and item" do
    site = Factory.create(:site)
    author = Factory.create(:author, :site_id => site.id)
    item = Factory.create(:item, :site_id => site.id)
    
    authored = Authored.new(Factory.attributes_for(:authored, :author_id => author.id))
    authored.should have(1).error_on(:item_id)
    
    authored = Authored.new(Factory.attributes_for(:authored, :item_id => item.id))
    authored.should have(1).error_on(:author_id)
    
  end
  
end