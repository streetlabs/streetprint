class Visitor::NarrativesController < ApplicationController
  before_action :get_site
  layout 'site'

  def index
    @narratives = @site.narratives
    # Breadcrumbs are set in view with: breadcrumb :narratives, @site
  end

  def show
    @narrative = @site.narratives.find(params[:id])
    # Rails 4.2: paginate_by_* removed, use where + paginate
    @sections = @narrative.sections.where(:site_id => @site.id).paginate(:page => params[:page], :per_page => 1)
    # Breadcrumbs are set in view with: breadcrumb :narrative, @narrative, @site
  end

end
