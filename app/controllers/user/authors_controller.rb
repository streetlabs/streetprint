class User::AuthorsController < ApplicationController

    before_filter :get_site
    before_filter :breadcrumb_base_admin

    access_control do
      allow :owner, :of => :site
      allow :admin, :of => :site
      allow :editor, :of => :site
      allow :superadmin
    end
    
    def show
      @author = @site.authors.find(params[:id])
      
      add_crumb("Authors", authoradmin_index_path(:subdomain => @site.title))
      add_crumb @author.name
    end

    def index
      add_crumb("Authors")
      @authors = @site.authors
    end

    def new
      add_crumb("Authors", authoradmin_index_path(:subdomain => @site.title))
      add_crumb("New author")
      
      @author = @site.authors.new
    end

    def create
      @author = @site.authors.new(params[:author])
      @author.site = @site
      if @author.save
        flash[:notice] = "Successfully created author."
        redirect_to authoradmin_path(@author, :subdomain => @site.title)
      else
        render :action => 'new'
      end
    end

    def edit
      add_crumb("Authors", authoradmin_index_path(:subdomain => @site.title))
      add_crumb("Edit author")
      
      @author = @site.authors.find(params[:id])
    end

    def update
      @author = @site.authors.find(params[:id])
      if @author.update_attributes(params[:author])
        flash[:notice] = "Successfully updated author."
        redirect_to authoradmin_url(@author, :subdomain => @site.title)
      else
        render :action => 'edit'
      end
    end

    def destroy
      @author = @site.authors.find(params[:id])
      @author.destroy
      flash[:notice] = "Successfully destroyed author."
      redirect_to authoradmin_index_path(:subdomain => @site.title)
    end
  
end
