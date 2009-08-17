class AuthorsController < ApplicationController
  
  before_filter :get_site
  before_filter :breadcrumb_base
  add_crumb("Author")
  
  access_control do
    allow all
  end
    
  def show
    @author = Author.find(params[:id])
    add_crumb @author.name
    render :layout => "site"
  end
  
end
