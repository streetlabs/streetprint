# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        store_location
        flash[:error] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        redirect_to admin_url
        return false
      end
    end

    def require_site_owner
      site_id = params[:id] if params[:id]
      site_id = params[:site_id] if params[:site_id]
      site = Site.find_by_id(site_id)
      unless site && current_user && (site.users.include? current_user)
        flash[:error] = "You do not have permission to access this page"
        redirect_to admin_url
        return false
      end
    end

    def store_location(key = :return_to)
      session[key] = request.request_uri
    end

    def redirect_back_or_default(default, key = :return_to)
      redirect_to(session[key] || default)
      session[key] = nil
    end
    
    def get_site
      site_id = params[:id] if params[:id]
      site_id = params[:site_id] if params[:site_id]
      @site ||= Site.find(  site_id)
    end
    
    def breadcrumb_base
      add_crumb('Home', site_path(@site))
    end
end
