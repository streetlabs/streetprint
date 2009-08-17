class Admin::AuthorsController < ApplicationController

    before_filter :get_site
    before_filter :breadcrumb_base
    add_crumb("Author")

    access_control do
      allow :owner, :of => :site
      allow :admin, :of => :site
      allow :editor, :of => :site
    end

    def index
      @authors = Author.all
    end

    def new
      @author = Author.new
    end

    def create
      @author = Author.new(params[:author])
      @author.site = @site
      if @author.save
        flash[:notice] = "Successfully created author."
        redirect_to author_path(@author, :subdomain => @site.title)
      else
        render :action => 'new'
      end
    end

    def edit
      @author = Author.find(params[:id])
    end

    def update
      @author = Author.find(params[:id])
      if @author.update_attributes(params[:author])
        flash[:notice] = "Successfully updated author."
        redirect_to author_url(@author, :subdomain => @site.title)
      else
        render :action => 'edit'
      end
    end

    def destroy
      @author = Author.find(params[:id])
      @author.destroy
      flash[:notice] = "Successfully destroyed author."
      redirect_to admin_authors_path(:subdomain => @site.title)
    end
  
end
