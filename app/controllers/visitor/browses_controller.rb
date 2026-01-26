class Visitor::BrowsesController < ApplicationController
  before_action :get_site
  layout 'site'

  def new
    if @by = params[:by]
      case @by
      when "categories"
        # Rails 4.2: Use new finder syntax
        @options = @site.categories.order("name ASC").map { |c| c.name }
      when "authors"
        # Rails 4.2: Use new finder syntax
        @options = @site.authors.order("name ASC").map { |a| a.name }
      when "document_type"
        # Rails 4.2: Use new finder syntax
        @options = @site.document_types.order("name ASC").map { |dt| dt.name }
      when "publisher"
        # Rails 4.2: Use new finder syntax
        @options = @site.items.select('DISTINCT publisher').order("publisher ASC")
        @options = @options.map {|i| i.publisher}
        @options.delete(nil)
        @options.delete('')
      when "city"
        # Rails 4.2: Use new finder syntax
        @options = @site.items.select('DISTINCT city').order("city ASC")
        @options = @options.map {|i| i.city}
        @options.delete(nil)
        @options.delete('')
      end
    end
  end

end
