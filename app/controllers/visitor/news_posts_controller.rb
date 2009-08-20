class Visitor::NewsPostsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base
  add_crumb("News") { |instance| instance.send :news_posts_path }

  access_control do
    allow all
  end  
  
  def index
    @news_posts = @site.news_posts.find(:all, :order => 'created_at DESC')
    render :layout => 'site'
  end
    
end
