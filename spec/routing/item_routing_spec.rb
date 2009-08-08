require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "items", :action => "index", :site_id => "1").should == "/sites/1/items"
    end

    it "maps #new" do
      route_for(:controller => "items", :action => "new", :site_id => "1").should == "/sites/1/items/new"
    end

    it "maps #show" do
      route_for(:controller => "items", :action => "show", :id => "1", :site_id => "1").should == "/sites/1/items/1"
    end

    it "maps #edit" do
      route_for(:controller => "items", :action => "edit", :id => "1", :site_id => "1").should == "/sites/1/items/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "items", :action => "create", :site_id => "1").should == {:path => "/sites/1/items", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "items", :action => "update", :id => "1", :site_id => "1").should == {:path =>"/sites/1/items/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "items", :action => "destroy", :id => "1", :site_id => "1").should == {:path =>"/sites/1/items/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/sites/1/items").should == {:controller => "items", :action => "index", :site_id => "1"}
    end

    it "generates params for #new" do
      params_from(:get, "/sites/1/items/new").should == {:controller => "items", :action => "new", :site_id => "1"}
    end

    it "generates params for #create" do
      params_from(:post, "/sites/1/items").should == {:controller => "items", :action => "create", :site_id => "1"}
    end

    it "generates params for #show" do
      params_from(:get, "/sites/1/items/1").should == {:controller => "items", :action => "show", :id => "1", :site_id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/sites/1/items/1/edit").should == {:controller => "items", :action => "edit", :id => "1", :site_id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/sites/1/items/1").should == {:controller => "items", :action => "update", :id => "1", :site_id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/sites/1/items/1").should == {:controller => "items", :action => "destroy", :id => "1", :site_id => "1"}
    end
  end
end
