class User::NewsPostsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base_admin

  access_control do
    allow all, :to => :index
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end  
  
  def index
    add_crumb("News")
    @news_posts = @site.news_posts.find(:all, :order => 'created_at DESC')
  end
  
  def new
    add_crumb("News", newsadmin_index_path(:subdomain => @site.title))
    add_crumb("New post")
    
    @news_post = @site.news_posts.new
  end
  
  def edit
    add_crumb("News", newsadmin_index_path(:subdomain => @site.title))
    add_crumb("Edit post")
    
    @news_post = @site.news_posts.find(params[:id])
  end
  
  def create
    @news_post = @site.news_posts.new(params[:news_post])
    if @news_post.save
      flash[:notice] = "Successfully created post."
      redirect_to newsadmin_index_path(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end
  
  def update
    @news_post = @site.news_posts.find(params[:id])
    
    if @news_post.update_attributes(params[:news_post])
      flash[:notice] = "Successfully updated post."
      redirect_to newsadmin_index_url(:subdomain => @site.title)
    else
      render :action => 'edit'
    end
  end
  
end
