class ItemsController < ApplicationController
  before_filter :require_user
  before_filter :get_site
  
  def index
    @items = @site.items
  end
  
  def show
    @item = @site.items.find(params[:id])
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
    
    unless params[:photo_ids].empty?
      Photo.destroy_pics(params[:id], params[:photo_ids])
    end
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated item."
      redirect_to site_items_url(@site)
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
  
  private
    def get_site
      @site = Site.find(params[:site_id])
    end
end
