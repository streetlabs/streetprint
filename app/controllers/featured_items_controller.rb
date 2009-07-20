class FeaturedItemsController < ApplicationController
before_filter :get_site  
  
  def update
    @site = Site.find(params[:site_id])
    
    @site.featured_item = params[:site]['featured_item']
    @site.save!
    flash[:notice] = "Updated featured item."
    
    respond_to do |format|
      format.html { redirect_to site_items_path(@site) }
      format.js
    end
  end
end
