class SitestylesController < ApplicationController
  before_filter :get_site
  
  def show
  end
  
  def update
    @site = Site.find(params[:site_id])
    success_path = site_sitestyle_path(@site) if params[:site]['style']
    fail_path = site_sitestyle_path(@site) if params[:site]['style']
    
    @site.style = params[:site]['style']
    @site.save!
    flash[:notice] = "Successfully updated style."
    redirect_to site_sitestyle_path(@site)
    
  end
end
