class User::ShowGoogleLocationTemplateController < ApplicationController

  before_action :get_site_theme

  access_control do
    allow logged_in, :to => [:index, :new, :create]
    allow :creator, :of => :site_theme
    allow :superadmin
  end

  def edit
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @show_google_location_template = @site_theme.show_google_location_template

  end

  def update
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @show_google_location_template = @site_theme.show_google_location_template
    if @show_google_location_template.update(show_google_location_template_params)
      flash[:notice] = "Successfully updated google location page."
      redirect_to edit_site_theme_show_google_location_template_path(params[:site_theme_id])
    else
      render 'edit'
    end
  end

  private
    def get_site_theme
      @site_theme = SiteTheme.find(params[:site_theme_id])
    end

    def show_google_location_template_params
      params.require(:show_google_location_template).permit(:site_theme_id, :template, :css)
    end
end
