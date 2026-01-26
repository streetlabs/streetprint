class User::DocumentTypesController < ApplicationController
  before_action :get_site

  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end

  def index
    @document_types = @site.document_types.all
  end

  def show
    @document_type = @site.document_types.find(params[:id])

  end

  def new

    @document_type = @site.document_types.new
  end

  def create
    @document_type = @site.document_types.new(document_type_params)
    if @document_type.save
      flash[:notice] = "Successfully created document type."
      redirect_to document_types_url(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end

  def edit

    @document_type = @site.document_types.find(params[:id])
  end

  def update
    @document_type = @site.document_types.find(params[:id])
    if @document_type.update(document_type_params)
      flash[:notice] = "Successfully updated document type."
      redirect_to document_types_url(:subdomain => @site.title)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @document_type = @site.document_types.find(params[:id])
    @document_type.destroy
    flash[:notice] = "Successfully destroyed document type."
    redirect_to document_types_url(:subdomain => @site.title)
  end

  private

  def document_type_params
    params.require(:document_type).permit(:name, :description, :site_id, :reference_id)
  end
end
