class SitesController < ApplicationController
  
  access_control do
    allow all, :to => :show
    allow logged_in, :to => [:new, :create]
    allow :owner, :of => :site
    allow :admin, :of => :site
  end
  
  def show
    if(current_subdomain)
      get_site_from_subdomain
    else
      @site = Site.find(params[:id])
    end
    if @site
      @items = Item.paginate :per_page => 1, :page => params[:page], :conditions => { :site_id => @site.id }
      render :layout => "site"
    end
  end
  
  def new
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
  
  def edit
    @site = Site.find(params[:id])
  end
  
  def update
    @site = Site.find(params[:id])
    
    if @site.update_attributes(params[:site])
      flash[:notice] = "Successfully updated site."
      redirect_to admin_path
    else
      render :action => 'edit'
    end
  end
  
end
