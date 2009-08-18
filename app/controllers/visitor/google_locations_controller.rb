class Visitor::GoogleLocationsController < ApplicationController
  
  before_filter :get_site
  before_filter :breadcrumb_base
  
  access_control do
    allow all
  end
  
  def show
    @item = Item.find(params[:item_id])
    
    add_crumb("Search", items_path(get_search_params(params)))
    add_crumb @item.title, item_path(@item, get_search_params(params))
    add_crumb "Map"
    
    render :layout => "site"
  end
  
end
