class CategoriesController < ApplicationController
  before_filter :get_site
  
  access_control do
    allow :owner, :of => :site
  end
  
  def index
    @categories = @site.categories.all
  end
  
  def show
    @category = @site.categories.find(params[:id])
  end
  
  def new
    @category = @site.categories.new
  end
  
  def create
    @category = @site.categories.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created category."
      redirect_to site_category_path(@site, @category)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @category = @site.categories.find(params[:id])
  end
  
  def update
    @category = @site.categories.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = "Successfully updated category."
      redirect_to site_category_path(@site, @category)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Successfully destroyed category."
    redirect_to site_categories_url(@site)
  end
end
