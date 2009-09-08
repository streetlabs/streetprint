class User::PublishItemsController < ApplicationController
  before_filter :get_site  

  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :superadmin
  end
  
  def update
    @item = @site.items.find(params[:id])
    @item.published = params[:published]
    @item.save!
    
    publish = @item.published? ? "" : "un"
    flash[:notice] = "Successfully #{publish}published item."
    
    
    respond_to do |format|
      format.html do
        redirect_params = {:subdomain => @site.title}
        redirect_params = redirect_params.merge(params[:persistent_search]) if params[:persistent_search]
        redirect_to itemadmin_index_path(redirect_params)
      end
      format.js do
        @publish = @item.published? ? "unpublish" : "publish"
      end
    end
  end
end
