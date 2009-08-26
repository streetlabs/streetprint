class User::GoogleLocationsController < ApplicationController
  
  before_filter :get_site
  before_filter :breadcrumb_base_admin
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
  end

  def show
    @item = Item.find(params[:itemadmin_id])
    
    add_crumb("Search", itemadmin_index_path(get_search_params(params)))
    add_crumb @item.title, itemadmin_path(@item, get_search_params(params))
    add_crumb "Map"
    
  end
  
  def edit
    @item = Item.find(params[:itemadmin_id])
    
    add_crumb("Search", itemadmin_index_path(get_search_params(params)))
    add_crumb @item.title, itemadmin_path(@item, get_search_params(params))
    add_crumb "Edit Map"
  end

  def update
    @item = Item.find(params[:itemadmin_id])
    @item.google_location = params[:location]
    @item.save

    redirect_to itemadmin_path(@item, :subdomain => @site.title)
  end
  
end
