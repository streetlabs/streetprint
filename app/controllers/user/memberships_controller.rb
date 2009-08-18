class User::MembershipsController < ApplicationController
  before_filter :get_site

  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
  end
  
  def index
    @memberships = @site.memberships
  end
  
  def new
    @membership = @site.memberships.new
  end
  
  def create
    @membership = @site.memberships.new(params[:membership])
    if @membership.save
      @membership.user.has_no_roles_for!(@membership.site)
      @membership.user.has_role!(params[:role], @membership.site)
      flash[:notice] = "Successfully added user."
      redirect_to memberships_path(:subdomain => @site.title)
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
      unless @membership.user.has_role?(:owner, @site)
        @membership.user.has_no_roles_for!(@membership.site)
        @membership.user.has_role!(params[:role], @membership.site)
        flash[:notice] = "Successfully updated membership."
      else
        flash[:error] = "Can not modify site owners role."
      end
      redirect_to memberships_path(:subdomain => @site.title)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @membership = @site.memberships.find(params[:id])
    if !@membership.user.has_role?(:owner, @site)
      @membership.destroy
      flash[:notice] = "Successfully removed user."
      redirect_to memberships_path(:subdomain => @site.title)
    else
      flash[:error] = "The owner of the site can not be deleted."
      redirect_to memberships_path(:subdomain => @site.title)
    end
  end
end
