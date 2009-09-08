class User::ShowSiteTemplateController < ApplicationController
  
  before_filter :get_site_theme

  access_control do
    allow logged_in, :to => [:index, :new, :create]
    allow :creator, :of => :site_theme
    allow :superadmin
  end

  def edit
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @show_site_template = @site_theme.show_site_template
    
    add_crumb('Home', admin_url(:subdomain => false))
    add_crumb('Themes', site_themes_url)
    add_crumb(@site_theme.name, edit_site_theme_path(params[:site_theme_id]))
    add_crumb('Home page')
  end

  def update
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @show_site_template = @site_theme.show_site_template
    if @show_site_template.update_attributes(params[:show_site_template])
      flash[:notice] = "Successfully updated home page."
      redirect_to edit_site_theme_show_site_template_path(params[:site_theme_id])
    else
      render 'edit'
    end
  end
  
  private
    def get_site_theme
      @site_theme = SiteTheme.find(params[:site_theme_id])
    end
end

