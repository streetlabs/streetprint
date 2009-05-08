class ItemsController < ApplicationController
  def index
    @items = Item.all
  end
  
  def show
    @item = Item.find(params[:id])
  end
  
  def new
    @item = Item.new
    1.upto(3) { @item.photos.build }
  end
  
  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = "Successfully created item."
      redirect_to @item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @item = Item.find(params[:id])
    if @item.photos.first.nil?
      1.upto(3) { @item.photos.build }
    end
  end
  
  def update
    params[:photo_ids] ||= []
    @item = Item.find(params[:id])
    unless params[:photo_ids].empty?
      Photo.destroy_pics(params[:id], params[:photo_ids])
    end
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated item."
      redirect_to @item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed item."
    redirect_to items_url
  end
end
