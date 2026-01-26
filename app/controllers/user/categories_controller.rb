class User::CategoriesController < ApplicationController
  before_action :get_site

  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
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
    @category = @site.categories.new(category_params)
    if @category.save
      flash[:notice] = "Successfully created category."
      redirect_to categories_url(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end

  def edit

    @category = @site.categories.find(params[:id])
  end

  def update
    @category = @site.categories.find(params[:id])
    if @category.update(category_params)
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

  private

  def category_params
    params.require(:category).permit(:name, :description, :site_id)
  end
end
