class MembershipsController < ApplicationController
  before_filter :require_site_owner
  before_filter :get_site
    
  def index
    @memberships = @site.memberships
  end
  
  
  def new
    @membership = @site.memberships.new
  end
  
  def create
    @membership = @site.memberships.new(params[:membership])
    if @membership.save
      flash[:notice] = "Successfully added user."
      redirect_to site_memberships_path(@site)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @membership = @site.memberships.find(params[:id])
  end
  
  def update
    @membership = @site.memberships.find(params[:id])
    if @membership.update_attributes(params[:membership])
      flash[:notice] = "Successfully updated membership."
      redirect_to site_memberships_path(@site)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @membership = @site.memberships.find(params[:id])
    @membership.destroy
    flash[:notice] = "Successfully removed user."
    redirect_to site_memberships_path(@site)
  end
end
