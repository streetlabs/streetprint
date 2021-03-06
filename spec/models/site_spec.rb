require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site do

  it "should default to not being approved" do
    site = Factory(:site)
    site.should_not be_approved
  end

  it "should create a new instance given valid attributes" do
    site = Site.create!(Factory.attributes_for(:site))
  end
  
  it "should require the title to be at least 6 characters alphanumeric + _ exluding the list of words defined" do
    site = Factory.build(:site, :name => "mock site", :title => 'a'*5)
    site.should_not be_valid
    site = Factory.build(:site, :name => "mock site", :title => 'validuntilhere*')
    site.should_not be_valid
  end
  
  it "should require a unique title" do
    site = Factory.build(:site, :title => nil)
    site.should_not be_valid
    site = Factory.build(:site, :name => 'mock site', :title => 'mocksite')
    site.should be_valid
    site.save!
    site2 = Factory.build(:site, :name => 'mock site', :title => 'mocksite')
    site2.should_not be_valid
  end
  
  it "should require a name" do
    site = Factory.build(:site, :name => nil)
    site.should_not be_valid
  end
  
  it "should have a name between 5 and 100 chars" do
    site = Factory.build(:site, :name => "abcd")
    site.should_not be_valid
    site = Factory.build(:site, :name => "a"*101)
    site.should_not be_valid
  end
  
  it "should be able to get all of its categories" do
    site = Factory.create(:site)
    c1 = Factory.create(:category, :site_id => site.id)
    c2 = Factory.create(:category, :site_id => site.id)
    c3 = Factory.create(:category, :site_id => site.id)
    
    site.categories.should include(c1)
    site.categories.should include(c2)
    site.categories.should include(c3)
  end
  
  it "should be able to get all of its document types" do
    site = Factory.create(:site)
    dt1 = Factory.create(:document_type, :site_id => site.id)
    dt2 = Factory.create(:document_type, :site_id => site.id)
    dt3 = Factory.create(:document_type, :site_id => site.id)
    
    site.document_types.should include(dt1)
    site.document_types.should include(dt2)
    site.document_types.should include(dt3)
  end
  
  it "should be able to get all of its items" do
    site = Factory.create(:site)
    item_1 = Factory.create(:item, :site_id => site.id)
    item_2 = Factory.create(:item, :site_id => site.id)
    item_3 = Factory.create(:item, :site_id => site.id)
    site.items.should include(item_1)
    site.items.should include(item_2)
    site.items.should include(item_3)
  end
  
  it 'should be able to get all of its news posts' do
    site = Factory.create(:site)
    news_1 = Factory.create(:news_post, :site_id => site.id)
    news_2 = Factory.create(:news_post, :site_id => site.id)
    news_3 = Factory.create(:news_post, :site_id => site.id)
    site.news_posts.should include(news_1)
    site.news_posts.should include(news_2)
    site.news_posts.should include(news_3)
  end
  
  it 'should return a random list of unique sites' do
    site1 = Factory.create(:site, :name => "Site1")
    site2 = Factory.create(:site, :name => "Site2")
    site3 = Factory.create(:site, :name => "Site3")
    sites = Site.any(5)
    sites.should include(site1) 
    sites.should include(site2)
    sites.should include(site3)   
  end
  
  it "should have a site_theme on creation" do
    site = Factory(:site)
    site.should respond_to(:site_theme)
    site.site_theme.should_not be_nil
  end
  
end