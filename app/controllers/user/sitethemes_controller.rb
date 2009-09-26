class User::SitethemesController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base_admin

  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :superadmin
  end
  
  def edit
    @site_themes = SiteTheme.global
    @site_themes += current_user.site_themes
  end
  
  def update
    @site.site_theme_id = params[:site]['site_theme']
    @site.save!
    flash[:notice] = "Successfully updated theme."
    redirect_to edit_sitestyle_path(:subdomain => @site.title)
  end

end
