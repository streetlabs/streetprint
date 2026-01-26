class User::NewsPostsController < ApplicationController
  before_action :get_site

  access_control do
    allow all, :to => :index
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end

  def index
    # Rails 4.2: Use new finder syntax
    @news_posts = @site.news_posts.order('created_at DESC')
  end

  def new

    @news_post = @site.news_posts.new
  end

  def edit

    @news_post = @site.news_posts.find(params[:id])
  end

  def create
    @news_post = @site.news_posts.new(news_post_params)
    if @news_post.save
      flash[:notice] = "Successfully created post."
      redirect_to newsadmin_index_path(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end

  def update
    @news_post = @site.news_posts.find(params[:id])

    if @news_post.update(news_post_params)
      flash[:notice] = "Successfully updated post."
      redirect_to newsadmin_index_url(:subdomain => @site.title)
    else
      render :action => 'edit'
    end
  end


  def destroy
    @news_post = @site.news_posts.find(params[:id])
    @news_post.destroy
    flash[:notice] = "Successfully destroyed post."
    redirect_to newsadmin_index_url(:subdomain => @site.title)
  end

  private

  def news_post_params
    params.require(:news_post).permit(:title, :content, :site_id)
  end

end
