require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User::ItemsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "user/items", :action => "index", :siteadmin_id => "1").should == "/siteadmin/1/itemadmin"
    end

    it "maps #new" do
      route_for(:controller => "user/items", :action => "new", :siteadmin_id => "1").should == "/siteadmin/1/itemadmin/new"
    end

    it "maps #show" do
      route_for(:controller => "user/items", :action => "show", :id => "1", :siteadmin_id => "1").should == "/siteadmin/1/itemadmin/1"
    end

    it "maps #edit" do
      route_for(:controller => "user/items", :action => "edit", :id => "1", :siteadmin_id => "1").should == "/siteadmin/1/itemadmin/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "user/items", :action => "create", :siteadmin_id => "1").should == {:path => "/siteadmin/1/itemadmin", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "user/items", :action => "update", :id => "1", :siteadmin_id => "1").should == {:path =>"/siteadmin/1/itemadmin/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "user/items", :action => "destroy", :id => "1", :siteadmin_id => "1").should == {:path =>"/siteadmin/1/itemadmin/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/siteadmin/1/itemadmin").should == {:controller => "user/items", :action => "index", :siteadmin_id => "1"}
    end

    it "generates params for #new" do
      params_from(:get, "/siteadmin/1/itemadmin/new").should == {:controller => "user/items", :action => "new", :siteadmin_id => "1"}
    end

    it "generates params for #create" do
      params_from(:post, "/siteadmin/1/itemadmin").should == {:controller => "user/items", :action => "create", :siteadmin_id => "1"}
    end

    it "generates params for #show" do
      params_from(:get, "/siteadmin/1/itemadmin/1").should == {:controller => "user/items", :action => "show", :id => "1", :siteadmin_id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/siteadmin/1/itemadmin/1/edit").should == {:controller => "user/items", :action => "edit", :id => "1", :siteadmin_id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/siteadmin/1/itemadmin/1").should == {:controller => "user/items", :action => "update", :id => "1", :siteadmin_id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/siteadmin/1/itemadmin/1").should == {:controller => "user/items", :action => "destroy", :id => "1", :siteadmin_id => "1"}
    end
  end
end
