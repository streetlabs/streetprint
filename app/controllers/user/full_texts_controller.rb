class User::FullTextsController < ApplicationController
  before_action :get_site
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end
  
  def show
    @item = Item.find(params[:itemadmin_id])
    @full_text = @item.full_text
    
  end
end
