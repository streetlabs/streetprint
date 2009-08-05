class ItemsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base
  
  access_control do
    allow all, :to => [:show, :index]
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
  end
  
  def index
    @items = Item.search_from_params(params)
    add_crumb("Search")
    store_location :items_return
    render :layout => "site"
  end
  
  def show
    @item = Item.find(params[:id])
    # if a page paramenter exists then we know the item was from that page
    # so we can narrow the search to that page, otherwise we need all the items
    # from the site but will paginate needs a page size so... 1,000,000
    page_size = params[:page] ? 10 : 1000000 # 1 million results max...  Needs rethinking
    @items = Item.search_from_params(params, page_size)
    index = @items.index(@item)
    if index
      @next_item = @items[index + 1] if @items.size > (index+1)
      @previous_item = @items[index - 1] if (index > 0)
    end
    add_crumb("Search", site_items_path(@site, params.merge(:id => nil)))
    add_crumb @item.title
    store_location :items_return
    render :layout => "site"
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
      redirect_to site_item_path(@site, @item)
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
      redirect_to site_item_url(@site, @item)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed #{@singular}."
    redirect_to site_items_url(@site)
  end
end
