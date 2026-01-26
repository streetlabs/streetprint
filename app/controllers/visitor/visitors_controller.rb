class Visitor::VisitorsController < ApplicationController

  def show
  end

  def index
    @sites = Site.where(:approved => true).limit(15).to_a
  end

end
