class User::DocumentTypesController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base_admin
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end
  
  def index
    add_crumb("Document types")
    @document_types = @site.document_types.all
  end
  
  def show
    @document_type = @site.document_types.find(params[:id])
    
    add_crumb("Document types", document_types_path(:subdomain => @site.title))
    add_crumb(@document_type.name)
  end
  
  def new
    add_crumb("Document types", document_types_path(:subdomain => @site.title))
    add_crumb("New document type")
    
    @document_type = @site.document_types.new
  end
  
  def create
    @document_type = @site.document_types.new(params[:document_type])
    if @document_type.save
      flash[:notice] = "Successfully created document type."
      redirect_to document_type_path(@document_type, :subdomain => @site.title)
    else
      render :action => 'new'
    end
  end
  
  def edit
    add_crumb("Document types", document_types_path(:subdomain => @site.title))
    add_crumb('Edit document type')
    
    @document_type = @site.document_types.find(params[:id])
  end
  
  def update
    @document_type = @site.document_types.find(params[:id])
    if @document_type.update_attributes(params[:document_type])
      flash[:notice] = "Successfully updated document type."
      redirect_to document_type_path(@document_type, :subdomain => @site.title)
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
end
