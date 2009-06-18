class SitesController < ApplicationController
  before_filter :require_user, :except => [:show]
  before_filter :require_site_owner, :only => [:edit, :update]
  
  def show
    @site = Site.find(params[:id])
    @items = Item.paginate :per_page => 1, :page => params[:page], :conditions => { :site_id => @site.id }
    render :layout => "site"
  end
  
  def new
    @site = Site.new
  end
  
  def create
    @site = Site.new(params[:site])
    if @site.save
      @site.memberships.create(:user => current_user, :owner => true)
      flash[:notice] = "Successfully created site."
      redirect_to account_path
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
      redirect_to account_path
    else
      render :action => 'edit'
    end
  end
  
end
