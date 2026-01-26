class User::SiteThemesController < ApplicationController

  before_action :get_site_theme, :only => [:edit, :update, :destroy]

  access_control do
    allow logged_in, :to => [:index, :new, :create]
    allow :creator, :of => :site_theme
    allow :superadmin
  end

  def index
    @site_themes_global = SiteTheme.global
    @site_themes_owned = current_user.site_themes

  end

  def new
    @site_theme = current_user.site_themes.new

  end

  def create
    @site_theme = current_user.site_themes.new(site_theme_params)
    @site_theme.user = current_user
    if @site_theme.save
      current_user.has_role!(:creator, @site_theme)
      flash[:notice] = "Successfully created theme."
      redirect_to edit_site_theme_url(@site_theme)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @site_theme.update(site_theme_params)
      flash[:notice] = "Successfully updated template."
      redirect_to edit_site_theme_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @site_theme.destroy
    flash[:notice] = "Successfully deleted template"
    redirect_to site_themes_path
  end

  private
    def get_site_theme
      @site_theme = SiteTheme.find(params[:id])
    end

    def site_theme_params
      params.require(:site_theme).permit(:name, :user_id, :icon)
    end
end
