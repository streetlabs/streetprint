class Admin::GoogleLocationsController < ApplicationController
  
  before_filter :get_site
  before_filter :breadcrumb_base
  
  access_control do
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

    redirect_to item_path(@item, :subdomain => @site.title)
  end
  
end
