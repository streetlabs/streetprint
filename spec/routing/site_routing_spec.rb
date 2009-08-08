require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SitesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "sites", :action => "index").should == "/sites"
    end

    it "maps #new" do
      route_for(:controller => "sites", :action => "new").should == "/sites/new"
    end

    it "maps #show" do
      route_for(:controller => "sites", :action => "show", :id => "1").should == "/sites/1"
    end

    it "maps #edit" do
      route_for(:controller => "sites", :action => "edit", :id => "1").should == "/sites/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "sites", :action => "create").should == {:path => "/sites", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "sites", :action => "update", :id => "1").should == {:path =>"/sites/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "sites", :action => "destroy", :id => "1").should == {:path =>"/sites/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/sites").should == {:controller => "sites", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/sites/new").should == {:controller => "sites", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/sites").should == {:controller => "sites", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/sites/1").should == {:controller => "sites", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/sites/1/edit").should == {:controller => "sites", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/sites/1").should == {:controller => "sites", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/sites/1").should == {:controller => "sites", :action => "destroy", :id => "1"}
    end
  end
end
