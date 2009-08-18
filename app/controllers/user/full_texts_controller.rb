class User::FullTextsController < ApplicationController
  before_filter :get_site
  
  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
  end
  
  def show
    @item = Item.find(params[:itemadmin_id])
    @full_text = @item.full_text
  end
end
