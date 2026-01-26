class Visitor::SitesController < ApplicationController

  before_action :get_site
  before_action :require_member_or_approved

  access_control do
    allow all
  end

  def show
    # Rails 4.2: Use new finder syntax with paginate
    @items = Item.where(:site_id => @site.id).paginate(:per_page => 1, :page => params[:page])
    render :layout => "site"
  end

end
