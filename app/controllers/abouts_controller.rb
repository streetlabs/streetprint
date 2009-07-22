class AboutsController < ApplicationController
  before_filter :get_site
  before_filter :breadcrumb_base
  add_crumb("About") { |instance| instance.send :site_about_path }
  layout 'site'

  def show
  end

end
