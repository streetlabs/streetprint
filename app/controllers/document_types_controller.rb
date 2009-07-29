class DocumentTypesController < ApplicationController
  before_filter :get_site
  
  access_control do
    allow :owner, :of => :site
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
    @document_type = @site.document_types.new(params[:document_type])
    if @document_type.save
      flash[:notice] = "Successfully created document type."
      redirect_to site_document_type_path(@site, @document_type)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @document_type = @site.document_types.find(params[:id])
  end
  
  def update
    @document_type = @site.document_types.find(params[:id])
    if @document_type.update_attributes(params[:document_type])
      flash[:notice] = "Successfully updated document type."
      redirect_to site_document_type_path(@site, @document_type)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @document_type = @site.document_types.find(params[:id])
    @document_type.destroy
    flash[:notice] = "Successfully destroyed document type."
    redirect_to site_document_types_url(@site)
  end
end
