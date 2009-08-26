class Visitor::VisitorsController < ApplicationController
  
  def show
  end
  
  def index
    @sites = Site.approved.first(10)
  end
  
end