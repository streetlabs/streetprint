class User::GoogleLocationsController < ApplicationController
  
  before_action :get_site
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end

  def show
    @item = Item.find(params[:itemadmin_id])
    
    
  end
  
  def edit
    @item = Item.find(params[:itemadmin_id])
    
  end

  def update
    @item = Item.find(params[:itemadmin_id])
    @item.google_location = params[:location]
    @item.save

    redirect_to itemadmin_path(@item, :subdomain => @site.title)
  end
  
end
