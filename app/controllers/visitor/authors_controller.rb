class Visitor::AuthorsController < ApplicationController
  
  before_action :get_site
  
  access_control do
    allow all
  end
    
  def show
    @author = Author.find(params[:id])
    render :layout => "site"
  end
  
end
