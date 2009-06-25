class ItemsController < ApplicationController
  before_filter :require_user, :except => [:show, :index]
  before_filter :require_site_owner, :except => [:show, :index]
  before_filter :get_site
  
  def index
    @items = Item.search params[:search], :conditions => { :site_id => @site.id }, :page => params[:page], :per_page => 10
    render :layout => "site"
  end
  
  def show
    @item = @site.items.find(params[:id])
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
