class User::SitesController < ApplicationController

  before_action :get_site, :except => [:new, :create]
  before_action :require_member_or_approved, :except => [:new, :create]

  access_control do
    allow logged_in, :to => [:new, :create]
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :superadmin
  end

  def new
    # text values can not have defaults in mysql so...
    @site = Site.new(:singular_item => 'artifact', :plural_item => 'artifacts')
  end

  def create
    @site = Site.new(site_params)
    if @site.save
      # add current user as member
      membership = @site.memberships.build(:user => current_user)
      @site.save
      # give current user owner role
      current_user.has_role!(:owner, @site)
      flash[:notice] = "Successfully created site."
      redirect_to admin_path
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @site.update(site_params)
      flash[:notice] = "Successfully updated site."
      redirect_to admin_path
    else
      render :action => 'edit'
    end
  end

  private

  def site_params
    params.require(:site).permit(:name, :title, :welcome_blurb, :featured_image, :about_project,
                                  :about_procedures, :singular_item, :plural_item, :fine_print,
                                  :featured_item, :style, :logo, :approved, :site_theme_id, :generic_forms)
  end

end
