class User::CustomDataTypesController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base_admin
  
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end

  def index
    add_crumb("Custom Data types")
    @custom_data_types = @site.custom_data_types.all
  end

  def show
    @custom_data_type = @site.custom_data_types.find(params[:id])

    add_crumb("Custom Data types", custom_data_types_path(:subdomain => @site.title))
    add_crumb(@custom_data_type.name)
  end

  def new
    add_crumb("Custom Data Types", custom_data_types_path(:subdomain => @site.title))
    add_crumb("New Custom Data Type")

    @custom_data_type = @site.custom_data_types.new
  end

  def create
    @custom_data_type = @site.custom_data_types.new(params[:custom_data_type])
    if @custom_data_type.save
      flash[:notice] = "Successfully created Custom Data Type."
      redirect_to custom_data_types_url(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end

  def edit
    add_crumb("Custom Data Types", custom_data_types_path(:subdomain => @site.title))
    add_crumb('Edit Custom Data Type')

    @custom_data_type = @site.custom_data_types.find(params[:id])
  end

  def update
    @custom_data_type = @site.custom_data_types.find(params[:id])
    if @custom_data_type.update_attributes(params[:custom_data_type])
      flash[:notice] = "Successfully updated Custom Data Type."
      redirect_to custom_data_types_url(:subdomain => @site.title)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @custom_data_type = @site.custom_data_types.find(params[:id])
    @custom_data_type.destroy
    flash[:notice] = "Successfully destroyed Custom Data Type."
    redirect_to custom_data_types_url(:subdomain => @site.title)
  end
end
