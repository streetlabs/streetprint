class Visitor::GoogleLocationsController < ApplicationController
  
  before_action :get_site
  
  access_control do
    allow all
  end
  
  def show
    @item = Item.find(params[:item_id])
    
    
    render :layout => "site"
  end
  
end
