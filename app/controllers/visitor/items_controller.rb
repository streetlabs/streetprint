class Visitor::ItemsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base
  
  access_control do
    allow all
  end
  
  def index
    @items = Item.search_from_params(get_search_params(params).merge(:published => true), @site.id)
    add_crumb("Search")
    store_location :items_return
    render :layout => "site"
  end
  
  def show
    @item = @site.items.find(params[:id], :conditions => {:published => true})
    # if a page paramenter exists then we know the item was from that page
    # so we can narrow the search to that page, otherwise we need all the items
    # from the site but will paginate needs a page size so... 1,000,000
    page_size = params[:page] ? 10 : 1000000 # 1 million results max...  Needs rethinking
    
    # get next/previous items in current context if they exist
    @items = Item.search_from_params(get_search_params(params).merge(:published => true), @site.id ,page_size)
    index = @items.index(@item)
    if index
      @next_item = @items[index + 1] if @items.size > (index+1)
      @previous_item = @items[index - 1] if (index > 0)
    end
    
    add_crumb("Search", items_path(get_search_params(params), :subdomain => @site.title))
    add_crumb @item.title
    store_location :items_return
    render :layout => "site"
  end
  
end
