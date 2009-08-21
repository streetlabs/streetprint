class Visitor::VisitorsController < ApplicationController
  
  def show
  end
  
  def index
    @sites = Site.approved.first(9)
  end
  
end