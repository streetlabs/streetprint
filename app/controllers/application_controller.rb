# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user_session, :current_user, :get_search_params
  filter_parameter_logging :password, :password_confirmation
  
  rescue_from Acl9::AccessDenied, :with => :access_denied

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def access_denied
      if current_user
        flash[:error] = "Access denied"
        redirect_to admin_path
      else
        store_location
        flash[:error] = 'Access denied. Try to log in first.'
        redirect_to login_path
      end
    end
      
    def store_location(key = :return_to)
      session[key] = request.request_uri
    end

    def redirect_back_or_default(default, key = :return_to)
      redirect_to(session[key] || default)
      session[key] = nil
    end
    
    def get_search_params(params)
      search_params = {}
      search_params[:search] = params[:search]
      search_params[:sort] = params[:sort]
      search_params[:authors] = params[:authors]
      search_params[:category] = params[:category]
      search_params[:document_type] = params[:document_type]
      search_params[:publisher] = params[:publisher]
      search_params[:city] = params[:city]
      return search_params
    end
    
    def get_site
      site_id = params[:id] if params[:id]
      site_id = params[:site_id] if params[:site_id]
      @site ||= Site.find(site_id)
      @singular = @site.singular_item
      @plural = @site.plural_item
    end
    
    def breadcrumb_base
      add_crumb('Home', site_path(@site))
    end
end
