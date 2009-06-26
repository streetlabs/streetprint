class BrowsesController < ApplicationController
  before_filter :get_site
  layout 'site'
  
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

