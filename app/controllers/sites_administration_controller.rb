class SitesAdministrationController < ApplicationController
  
  access_control do
    deny :all
    allow :superadmin
  end
  
  def show
    sort = params[:sort].gsub('_reverse', ' DESC') if params[:sort]
    @sites = Site.paginate(:page => params[:page], :order => sort)
  end
  
  def update
    site = Site.find(params[:site])
    site.approved = !site.approved
    site.save!
    redirect_to sites_administration_path(:sort => params[:sort])
  end
  
end
