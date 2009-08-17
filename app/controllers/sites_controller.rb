class SitesController < ApplicationController
  
  before_filter :get_site
  before_filter :require_member_or_approved
  
  access_control do
    allow all
  end
  
  def show
    @items = Item.paginate :per_page => 1, :page => params[:page], :conditions => { :site_id => @site.id }
    render :layout => "site"
  end

end
