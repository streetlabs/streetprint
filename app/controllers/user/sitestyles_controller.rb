class User::SitestylesController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base_admin
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
  end
  
  def show
    add_crumb('Edit site style')
  end
  
  def update
    @site = get_site
    
    @site.style = params[:site]['style']
    @site.save!
    flash[:notice] = "Successfully updated style."
    redirect_to sitestyle_path(:subdomain => @site.title)
    
  end
end
