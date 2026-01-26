class User::IndexArtifactsTemplateController < ApplicationController

  before_action :get_site_theme

  access_control do
    allow logged_in, :to => [:index, :new, :create]
    allow :creator, :of => :site_theme
    allow :superadmin
  end

  def edit
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @index_artifacts_template = @site_theme.index_artifacts_template

  end

  def update
    @site_theme = SiteTheme.find(params[:site_theme_id])
    @index_artifacts_template = @site_theme.index_artifacts_template
    if @index_artifacts_template.update(index_artifacts_template_params)
      flash[:notice] = "Successfully updated search artifacts page."
      redirect_to edit_site_theme_index_artifacts_template_path(params[:site_theme_id])
    else
      render 'edit'
    end
  end

  private
    def get_site_theme
      @site_theme = SiteTheme.find(params[:site_theme_id])
    end

    def index_artifacts_template_params
      params.require(:index_artifacts_template).permit(:site_theme_id, :template, :css)
    end
end
