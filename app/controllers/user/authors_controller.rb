class User::AuthorsController < ApplicationController

    before_action :get_site

    access_control do
      allow :owner, :of => :site
      allow :admin, :of => :site
      allow :editor, :of => :site
      allow :superadmin
    end

    def show
      @author = @site.authors.find(params[:id])

    end

    def index
      @authors = @site.authors
    end

    def new

      @author = @site.authors.new
    end

    def create
      @author = @site.authors.new(author_params)
      @author.site = @site
      if @author.save
        flash[:notice] = "Successfully created author."
        redirect_to authoradmin_index_path(:subdomain => @site.title)
      else
        render :action => 'new'
      end
    end

    def edit

      @author = @site.authors.find(params[:id])
    end

    def update
      @author = @site.authors.find(params[:id])
      if @author.update(author_params)
        flash[:notice] = "Successfully updated author."
        redirect_to authoradmin_index_path(:subdomain => @site.title)
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

    private

    def author_params
      params.require(:author).permit(:name, :bio)
    end

end
