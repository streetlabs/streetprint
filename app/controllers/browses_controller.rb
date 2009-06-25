class BrowsesController < ApplicationController
  before_filter :get_site
  layout 'site'
  
  def show
    conditions = Hash.new
    by = params[:by]
    value = params[:value]
    
    reverse = params[:reverse] ? "DESC" : ""
    
    if(by && value) # if we have a value do a search
      conditions[by.to_sym] = value
      @items = Item.search params[:search], :conditions => conditions, :page => params[:page], :per_page => 10
    elsif by # no value, just find all and order by column
      @items = Item.paginate(:all, :order => "#{by} #{reverse}", :page => params[:page], :per_page => 10)
    else
      @items = Item.paginate(:all, :page => params[:page], :per_page => 10)
    end
  end
  
  def new
    if @by = params[:by]
      case @by
      when "category"
        @options = @site.categories.all.map { |c| c.name }
      when "authors"
        @options = @site.authors.all.map { |a| a.name }
      when "document_type"
        @options = @site.document_types.all.map { |dt| dt.name }
      when "publisher"
        @options = @site.items.find(:all, :select => 'DISTINCT publisher')
        @options = @options.map {|i| i.publisher}
        @options.delete(nil)
        @options.delete('')
      when "city"
        @options = @site.items.find(:all, :select => 'DISTINCT city')
        @options = @options.map {|i| i.city}
        @options.delete(nil)
        @options.delete('')
      end
    end
  end
  
end

