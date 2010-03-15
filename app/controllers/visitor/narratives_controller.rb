class Visitor::NarrativesController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base
  add_crumb("Narratives") { |instance| instance.send :narratives_path }
  layout 'site'

  def index
    @narratives = @site.narratives
  end
  
  def show
    @narrative = @site.narratives.find(params[:id])
    add_crumb(h @narrative.title)
    @sections = @narrative.sections.paginate_by_site_id @site.id, :page => params[:page], :per_page => 1
  end

end
