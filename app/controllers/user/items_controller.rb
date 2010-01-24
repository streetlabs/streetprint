class User::ItemsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base_admin
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end
  
  def index
    #@items = Item.all_in_page(@site).paginate :page => params[:page], :order => 'created_at DESC'
    if  params[:search]
      @items = Item.search_all(get_search_params(params), @site.id)
    else
      @items = Item.paginate_by_site_id @site.id, :page => params[:page], :per_page => 20
    end
    
    @count = @site.items.count
    store_location :items_return
  end
  
  def show
    @item = @site.items.find(params[:id])
    # if a page paramenter exists then we know the item was from that page
    # so we can narrow the search to that page, otherwise we need all the items
    # from the site but will paginate needs a page size so... 1,000,000
    
    @items = Item.paginate_by_site_id @site.id, :page => params[:page], :per_page => 1
    
    add_crumb( "page " + (params[:page] ? params[:page] : "1" ) , itemadmin_index_path(get_search_params(params), :subdomain => @site.title))
    add_crumb @item.title
    store_location :items_return
  end
  
  def new
    add_crumb("Search", itemadmin_index_path(get_search_params(params), :subdomain => @site.title))
    add_crumb("New item")
    @item = @site.items.new
    1.times { @item.photos.build }
    1.times { @item.media_files.build }
  end
  
  def create
    @item = Item.new(params[:item])
    # Can't seem to specify select_month or select_day tags to user item[month] / item[day]
    @item.month = params[:date][:month]
    @item.day = params[:date][:day]
    @item.site = @site
    if @item.save
      flash[:notice] = "Successfully created #{@singular}."
      redirect_to itemadmin_index_url(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end
  
  def edit
    add_crumb("Search", itemadmin_index_path(get_search_params(params), :subdomain => @site.title))
    add_crumb("Edit item")
    @item = @site.items.find(params[:id])
    1.times { @item.photos.build }
    1.times { @item.media_files.build }
  end
  
  def update
    params[:photo_ids] ||= []
    @item = Item.find(params[:id])
    @item.attributes = params[:item]
    # Can't seem to specify select_month or select_day tags to user item[month] / item[day]
    @item.month = params[:date][:month]
    @item.day = params[:date][:day]
    
    if @item.save
      flash[:notice] = "Successfully updated #{@singular}."
      redirect_to itemadmin_index_url(:subdomain => @site.title)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = @site.items.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed #{@singular}."
    redirect_to itemadmin_index_url(:subdomain => @site.title)
  end
  
end
