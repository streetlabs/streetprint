class Visitor::ItemsController < ApplicationController
  before_action :get_site

  access_control do
    allow all
  end

  def index
    @items = Item.search_from_params(get_search_params(params).merge(:published => true), @site.id)
    store_location :items_return
    render :layout => "site"
  end


  ## THIS METHOD IS KILLING THE LARGER SITES.
  ## WE NEED TO FIX THE PREVIOUS/NEXT LINKS AND ALLOW ANY RESULTS TO PAGINATE
  ## TEMP FIX -> CAP THE PAGE SIZE @ 10...
  ## UGH - this makes things U-G-L-Y and broken
  def show
    @item = @site.items.includes(:photos).where("published = ?", 1).where("id = ?", params[:id]).first

    unless @item
      flash[:error] = "Item not found"
      redirect_to items_path(:subdomain => @site.title)
      return
    end

    # if a page paramenter exists then we know the item was from that page
    # so we can narrow the search to that page, otherwise we need all the items
    # from the site but will paginate needs a page size so... 1,000,000
    page_size = 10 # 1 million results max...  Needs rethinking

    # get next/previous items in current context if they exist
    @items = Item.search_from_params(get_search_params(params).merge(:published => true), @site.id ,page_size)
    index = @items.index(@item)

    @next_item = @item.next_by_id
    @previous_item = @item.previous_by_id

    store_location :items_return
    render :layout => "site"
  end

end
