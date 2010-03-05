class Visitor::BrowsesController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base
  add_crumb("Browse") { |instance| instance.send(:new_browse_path) }
  layout 'site'
  
  def new
    if @by = params[:by]
      case @by
      when "categories"
        add_crumb("Category")
        @options = @site.categories.find(:all, :order => "name ASC" ).map { |c| c.name }
      when "authors"
        add_crumb "Author"
        @options = @site.authors.find(:all, :order => "name ASC" ).map { |a| a.name }
      when "document_type"
        add_crumb "Document Type"
        @options = @site.document_types.find(:all, :order => "name ASC" ).map { |dt| dt.name }
      when "publisher"
        add_crumb "Publisher"
        @options = @site.items.find(:all, :order => "publisher ASC", :select => 'DISTINCT publisher')
        @options = @options.map {|i| i.publisher}
        @options.delete(nil)
        @options.delete('')
      when "city"
        add_crumb "City"
        @options = @site.items.find(:all, :order => "city ASC", :select => 'DISTINCT city')
        @options = @options.map {|i| i.city}
        @options.delete(nil)
        @options.delete('')
      end
    end
  end
  
end

