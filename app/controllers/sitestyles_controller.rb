class SitestylesController < ApplicationController
  before_filter :get_site
  
  access_control do
    allow :owner, :of => :site
  end
  
  def show
  end
  
  def update
    @site = Site.find(params[:site_id])
    
    @site.style = params[:site]['style']
    @site.save!
    flash[:notice] = "Successfully updated style."
    redirect_to site_sitestyle_path(@site)
    
  end
end
