class User::CategoriesController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base_admin
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end
  
  def index
    add_crumb("Categories")
    @categories = @site.categories.all
  end
  
  def show
    @category = @site.categories.find(params[:id])
  
    add_crumb("Categories", categories_path(:subdomain => @site.title))
    add_crumb(@category.name)
  end
  
  def new
    add_crumb("Categories", categories_path(:subdomain => @site.title))
    add_crumb("New category")
    
    @category = @site.categories.new
  end
  
  def create
    @category = @site.categories.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created category."
      redirect_to categories_url(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end
  
  def edit
    add_crumb("Categories", categories_path(:subdomain => @site.title))
    add_crumb("Edit category")
    
    @category = @site.categories.find(params[:id])
  end
  
  def update
    @category = @site.categories.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = "Successfully updated category."
      redirect_to categories_url(:subdomain => @site.title)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Successfully destroyed category."
    redirect_to categories_url(:subdomain => @site.title)
  end
end
