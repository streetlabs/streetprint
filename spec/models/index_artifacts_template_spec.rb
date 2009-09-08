require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IndexArtifactsTemplate do

  it "should create a new instance given valid attributes" do
    template = IndexArtifactsTemplate.create!(Factory.attributes_for(:index_artifacts_template))
  end
  
  it "should belong to a site_theme" do
    template = Factory(:index_artifacts_template)
    template.should respond_to(:site_theme)
  end
  
  it "should have template and css members" do
    template = Factory(:index_artifacts_template)
    template.should respond_to(:template)
    template.should respond_to(:css)
  end
  
end
