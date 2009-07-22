class NewsPostsController < ApplicationController
  before_filter :get_site
  before_filter :require_site_owner, :except => [:index]
  before_filter :breadcrumb_base
  add_crumb("News") { |instance| instance.send :site_news_posts_path }
  
  
  def index
    @news_posts = @site.news_posts.find(:all, :order => 'created_at DESC')
    render :layout => 'site'
  end
  
  def new
    @news_post = @site.news_posts.new
  end
  
  def edit
    @news_post = @site.news_posts.find(params[:id])
  end
  
  def create
    @news_post = @site.news_posts.new(params[:news_post])
    if @news_post.save
      flash[:notice] = "Successfully created post."
      redirect_to site_news_posts_path(@site)
    else
      render :action => 'new'
    end
  end
  
  def update
    @news_post = @site.news_posts.find(params[:id])
    
    if @news_post.update_attributes(params[:news_post])
      flash[:notice] = "Successfully updated post."
      redirect_to site_news_posts_url(@site)
    else
      render :action => 'edit'
    end
  end
  
end
