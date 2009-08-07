class GoogleLocationsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base
  
  access_control do
    allow all, :to => [:show]
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
  end
  
  def edit
    @item = Item.find(params[:item_id])
  end

  def update
    @item = Item.find(params[:item_id])
    @item.google_location = params[:location]
    @item.save

    redirect_to site_item_path(@site, @item)
  end
  
  def show
    @item = Item.find(params[:item_id])
    
    add_crumb("Search", site_items_path(@site, get_search_params(params)))
    add_crumb @item.title, site_item_path(@site, @item, get_search_params(params))
    add_crumb "Map"
    
    render :layout => "site"
  end
  
end
