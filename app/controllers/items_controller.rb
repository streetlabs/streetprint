class ItemsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base
  
  access_control do
    allow all, :to => [:show, :index]
    allow :owner, :of => :site
  end
  
  def index
    @items = Item.search_from_params(params)
    add_crumb("Search") #if params.size > 0
    store_location :items_return
    render :layout => "site"
  end
  
  def show
    @item = @site.items.find(params[:id])
    add_crumb("Search", site_items_path(@site, params)) #if params.size > 0
    add_crumb @item.title
    store_location :items_return
    render :layout => "site"
  end
  
  def new
    @item = @site.items.new
    1.times { @item.photos.build }
  end
  
  def create
    @item = Item.new(params[:item])
    @item.site = @site
    if @item.save
      flash[:notice] = "Successfully created item."
      redirect_to site_item_path(@site, @item)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @item = Item.find(params[:id])
    1.times { @item.photos.build }
  end
  
  def update
    params[:photo_ids] ||= []
    @item = Item.find(params[:id])
    
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated item."
      redirect_to site_item_url(@site, @item)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed item."
    redirect_to site_items_url(@site)
  end
end
