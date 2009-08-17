class Admin::ItemsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
  end
  
  def new
    @item = @site.items.new
    1.times { @item.photos.build }
    1.times { @item.media_files.build }
  end
  
  def create
    @item = Item.new(params[:item])
    @item.site = @site
    if @item.save
      flash[:notice] = "Successfully created #{@singular}."
      redirect_to item_path(@item, :subdomain => @site.title)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @item = Item.find(params[:id])
    1.times { @item.photos.build }
    1.times { @item.media_files.build }
  end
  
  def update
    params[:photo_ids] ||= []
    @item = Item.find(params[:id])
    
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated #{@singular}."
      redirect_to item_url(@item, :subdomain => @site.title)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed #{@singular}."
    redirect_to items_url(:subdomain => @site.title)
  end
end
