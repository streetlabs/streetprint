require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SiteTheme do

  it "should create a new instance given valid attributes" do
    template = SiteTheme.create!(Factory.attributes_for(:site_theme))
  end
  
  it "should require a name" do
    template = Factory.build(:site_theme, :name => nil)
    template.should have(1).error_on(:name)
  end
  
  it "should belong to a user" do
    template = Factory(:site_theme)
    template.should respond_to('user')
  end
  
  it "should copy the default template if none is set on creation" do
    site_theme = Factory(:site_theme)
    site_theme.reload
    
    [
      [:layout_template,                LayoutTemplate],
      [:show_site_template,             ShowSiteTemplate],
      [:show_about_template,            ShowAboutTemplate],
      [:show_news_posts_template,       ShowNewsPostsTemplate],
      [:show_artifact_template,         ShowArtifactTemplate],
      [:browse_artifacts_template,      BrowseArtifactsTemplate],
      [:index_artifacts_template,       IndexArtifactsTemplate],
      [:show_author_template,           ShowAuthorTemplate],
      [:show_full_text_template,        ShowFullTextTemplate],
      [:show_google_location_template,  ShowGoogleLocationTemplate]
    ].each do |page_template, cls|
      site_theme.should respond_to(page_template)
      site_theme.send(page_template).template.should == File.read(File.join(RAILS_ROOT, 'config', 'themes', 'default', page_template.to_s[0..-10], 'template.liquid'))
      site_theme.send(page_template).css.should == File.read(File.join(RAILS_ROOT, 'config', 'themes', 'default', page_template.to_s[0..-10], 'css.css'))
    end
  end
  
end