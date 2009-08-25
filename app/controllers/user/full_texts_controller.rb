class User::FullTextsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base_admin
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
  end
  
  def show
    @item = Item.find(params[:itemadmin_id])
    @full_text = @item.full_text
    
    add_crumb("Search", itemadmin_index_path(get_search_params(params), :subdomain => @site.title))
    add_crumb(@item.title, itemadmin_path(@item, get_search_params(params).merge(:subdomain => @site.title)))
    add_crumb('Fulltext')
  end
end
