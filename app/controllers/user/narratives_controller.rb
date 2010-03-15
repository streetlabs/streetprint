class User::NarrativesController < ApplicationController
  # GET /narratives
  # GET /narratives.xml
  
  before_filter :get_site
  before_filter :breadcrumb_base_admin

  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end

  def show
    @narrative = @site.narratives.find(params[:id])
    
    @sections = @narrative.sections.paginate_by_site_id @site.id, :page => params[:page], :per_page => 1
    
    add_crumb("Narratives", narrativeadmin_index_path(:subdomain => @site.title))
    add_crumb @narrative.title
  end

  def index
    add_crumb("Narratives")
    @narratives = @site.narratives
  end

  def new
    add_crumb("Narratives", narrativeadmin_index_path(:subdomain => @site.title))
    add_crumb("New Narrative")
    
    @narrative = @site.narratives.new
  end

  def create
    @narrative = @site.narratives.new(params[:narrative])
    @narrative.site = @site
    if @narrative.save
      flash[:notice] = "Narrative was successfully created."
      redirect_to narrativeadmin_index_path(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end
  
  def edit
    add_crumb("Narratives", narrativeadmin_index_path(:subdomain => @site.title))
    add_crumb("Edit Narrative")
    
    @narrative = @site.narratives.find(params[:id])    
    
    if params[:search]
      @items = Item.search_all(get_search_params(params), @site.id)
    else
      @items = Item.paginate_by_site_id @site.id, :page => 1, :per_page => 16
    end
    
  end

  def search    
    if params[:search]
      @items = Item.search_all(get_search_params(params), @site.id)
    else
      @items = Item.paginate_by_site_id @site.id, :page => 1, :per_page => 16
    end
    
  end

  def update
    @narrative = @site.narratives.find(params[:id])
    if @narrative.update_attributes(params[:narrative])
      flash[:notice] = "Successfully updated Narrative."
      redirect_to narrativeadmin_index_path(:subdomain => @site.title)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @narrative = @site.narratives.find(params[:id])
    @narrative.destroy
    flash[:notice] = "Successfully destroyed Narrative."
    redirect_to narrativeadmin_index_path(:subdomain => @site.title)
  end
  
  def media 
    if params[:search]
      @items = Item.search_all(get_search_params(params), @site.id)
    else
      @items = Item.paginate_by_site_id @site.id, :page => 1, :per_page => 20
    end
  end
  
end