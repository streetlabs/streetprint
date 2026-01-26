class User::ShowFullTextTemplateController < ApplicationController

  before_action :get_site_theme

  access_control do
    allow logged_in, :to => [:index, :new, :create]
    allow :creator, :of => :site_theme
    allow :superadmin
  end

  def edit
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @show_full_text_template = @site_theme.show_full_text_template

  end

  def update
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @show_full_text_template = @site_theme.show_full_text_template
    if @show_full_text_template.update(show_full_text_template_params)
      flash[:notice] = "Successfully updated full text page."
      redirect_to edit_site_theme_show_full_text_template_path(params[:site_theme_id])
    else
      render 'edit'
    end
  end

  private
    def get_site_theme
      @site_theme = SiteTheme.find(params[:site_theme_id])
    end

    def show_full_text_template_params
      params.require(:show_full_text_template).permit(:site_theme_id, :template, :css)
    end
end
