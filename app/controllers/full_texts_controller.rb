class FullTextsController < ApplicationController
  before_filter :get_site
  layout 'site'
  
  def show
    @item = Item.find(params[:item_id])
    @full_text = @item.full_text
  end
end
