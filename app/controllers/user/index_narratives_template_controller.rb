class User::IndexNarrativesTemplateController < ApplicationController

  before_action :get_site_theme

  access_control do
    allow logged_in, :to => [:index, :new, :create]
    allow :creator, :of => :site_theme
    allow :superadmin
  end

  def edit
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @index_narratives_template = @site_theme.index_narratives_template

  end

  def update
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @index_narratives_template = @site_theme.index_narratives_template
    if @index_narratives_template.update(index_narratives_template_params)
      flash[:notice] = "Successfully updated the narratives page."
      redirect_to edit_site_theme_index_narratives_template_path(params[:site_theme_id])
    else
      render 'edit'
    end
  end

  private
    def get_site_theme
      @site_theme = SiteTheme.find(params[:site_theme_id])
    end

    def index_narratives_template_params
      params.require(:index_narratives_template).permit(:site_theme_id, :template, :css)
    end
end
