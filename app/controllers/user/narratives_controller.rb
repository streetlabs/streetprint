class User::NarrativesController < ApplicationController
  # GET /narratives
  # GET /narratives.xml

  before_action :get_site

  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end

  def show
    @narrative = @site.narratives.find(params[:id])

    # Rails 4.2: paginate_by_* removed, use where + paginate
    @sections = @narrative.sections.where(:site_id => @site.id).paginate(:page => params[:page], :per_page => 1)

  end

  def index
    @narratives = @site.narratives
  end

  def new

    @narrative = @site.narratives.new
  end

  def create
    @narrative = @site.narratives.new(narrative_params)
    @narrative.site = @site
    if @narrative.save
      flash[:notice] = "Narrative was successfully created."
      redirect_to narrativeadmin_index_path(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end

  def edit

    @narrative = @site.narratives.find(params[:id])

    if params[:search]
      @items = Item.search_all(get_search_params(params), @site.id)
    else
      # Rails 4.2: paginate_by_* removed, use where + paginate
      @items = Item.where(:site_id => @site.id).paginate(:page => 1, :per_page => 16)
    end

  end

  def search
    if params[:search]
      @items = Item.search_all(get_search_params(params), @site.id)
    else
      # Rails 4.2: paginate_by_* removed, use where + paginate
      @items = Item.where(:site_id => @site.id).paginate(:page => 1, :per_page => 16)
    end

  end

  def update
    @narrative = @site.narratives.find(params[:id])
    if @narrative.update(narrative_params)
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
      # Rails 4.2: paginate_by_* removed, use where + paginate
      @items = Item.where(:site_id => @site.id).paginate(:page => 1, :per_page => 20)
    end
  end

  private

  def narrative_params
    params.require(:narrative).permit(:site_id, :title, :description, :markdown)
  end

end
