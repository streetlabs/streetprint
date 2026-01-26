class User::CustomDataTypesController < ApplicationController
  before_action :get_site


  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end

  def index
    @custom_data_types = @site.custom_data_types.all
  end

  def show
    @custom_data_type = @site.custom_data_types.find(params[:id])

  end

  def new

    @custom_data_type = @site.custom_data_types.new
  end

  def create
    @custom_data_type = @site.custom_data_types.new(custom_data_type_params)
    if @custom_data_type.save
      flash[:notice] = "Successfully created Custom Data Type."
      redirect_to custom_data_types_url(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end

  def edit

    @custom_data_type = @site.custom_data_types.find(params[:id])
  end

  def update
    @custom_data_type = @site.custom_data_types.find(params[:id])
    if @custom_data_type.update(custom_data_type_params)
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

  private

  def custom_data_type_params
    params.require(:custom_data_type).permit(:name, :description, :site_id)
  end
end
