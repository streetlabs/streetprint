class Visitor::NewsPostsController < ApplicationController
  before_action :get_site

  access_control do
    allow all
  end

  def index
    # Rails 4.2: Use new finder syntax
    @news_posts = @site.news_posts.order('created_at DESC')
    render :layout => 'site'
  end

end
