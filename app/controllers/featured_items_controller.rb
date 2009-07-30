class FeaturedItemsController < ApplicationController
  before_filter :get_site  

  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
  end
  
  def update
    @site = Site.find(params[:site_id])
    
    @site.featured_item = params[:site]['featured_item'] if params[:site]['featured_item']
    @site.featured_image = params[:site]['featured_image'] if params[:site]['featured_image']
    
    @site.save!
    flash[:notice] = "Updated featured item."
    
    respond_to do |format|
      format.html { redirect_back_or_default site_items_path(@site), :items_return }
      format.js
    end
  end
end
