class User::BrowseArtifactsTemplateController < ApplicationController
  
  before_filter :get_site_theme

  access_control do
    allow logged_in, :to => [:index, :new, :create]
    allow :creator, :of => :site_theme
    allow :superadmin
  end

  def edit
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @browse_artifacts_template = @site_theme.browse_artifacts_template
    
    add_crumb('Home', admin_url(:subdomain => false))
    add_crumb('Themes', site_themes_url)
    add_crumb(@site_theme.name, edit_site_theme_path(params[:site_theme_id]))
    add_crumb('Browse artifacts page')
  end

  def update
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @browse_artifacts_template = @site_theme.browse_artifacts_template
    if @browse_artifacts_template.update_attributes(params[:browse_artifacts_template])
      flash[:notice] = "Successfully updated browse artifacts page."
      redirect_to edit_site_theme_browse_artifacts_template_path(params[:site_theme_id])
    else
      render 'edit'
    end
  end
  
  private
    def get_site_theme
      @site_theme = SiteTheme.find(params[:site_theme_id])
    end
end

