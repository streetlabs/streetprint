class User::LayoutTemplateController < ApplicationController

  before_action :get_site_theme

  access_control do
    allow logged_in, :to => [:index, :new, :create]
    allow :creator, :of => :site_theme
    allow :superadmin
  end

  def edit
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @layout_template = @site_theme.layout_template

  end

  def update
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @layout_template = @site_theme.layout_template
    if @layout_template.update(layout_template_params)
      flash[:notice] = "Successfully updated layout."
      redirect_to edit_site_theme_layout_template_path(params[:site_theme_id])
    else
      render 'edit'
    end
  end

  private
    def get_site_theme
      @site_theme = SiteTheme.find(params[:site_theme_id])
    end

    def layout_template_params
      params.require(:layout_template).permit(:sp_template_id, :template, :css, :site_theme_id)
    end
end
