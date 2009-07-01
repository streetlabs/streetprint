require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsPost do

  it "should create a new instance given valid attributes" do
    site = Factory.create(:site)
    NewsPost.create!(Factory.attributes_for(:news_post, :site_id => site.id))
  end
  
  it "should require a title" do
    news_post = Factory.build(:news_post, :title => nil)
    news_post.should have(1).error_on(:title)
  end
  
  it "should require content" do
    news_post = Factory.build(:news_post, :content => nil)
    news_post.should have(1).error_on(:content)
  end
  
  it "should require a site" do
    news_post = Factory.build(:news_post)
    news_post.should have(1).error_on(:site_id)
  end
  
  it 'should be able to get its site' do
    site = Factory.create(:site)
    news = Factory.create(:news_post, :site_id => site.id)
    news.site.should == site
  end
end