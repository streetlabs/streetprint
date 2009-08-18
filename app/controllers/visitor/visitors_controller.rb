class Visitor::VisitorsController < ApplicationController
  
  def show
  end
  
  def index
    @sites = Site.any(9)
  end
  
end