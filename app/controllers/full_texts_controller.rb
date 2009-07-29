class FullTextsController < ApplicationController
  before_filter :get_site
  layout 'site'
  
  access_control do
    allow :owner, :of => :site
  end
  
  def show
    @item = Item.find(params[:item_id])
    @full_text = @item.full_text
  end
end
