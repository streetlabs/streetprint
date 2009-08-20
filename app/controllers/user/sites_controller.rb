class User::SitesController < ApplicationController
  
  before_filter :get_site, :except => [:new, :create]
  before_filter :require_member_or_approved, :except => [:new, :create]
  
  access_control do
    allow logged_in, :to => [:new, :create]
    allow :owner, :of => :site
    allow :admin, :of => :site
  end
  
  def new
    # text values can not have defaults in mysql so...
    @site = Site.new(:singular_item => 'artifact', :plural_item => 'artifacts')
  end
  
  def create
    @site = Site.new(params[:site])
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
  
  
  def update
    if @site.update_attributes(params[:site])
      flash[:notice] = "Successfully updated site."
      redirect_to admin_path
    else
      render :action => 'edit'
    end
  end
  
end