# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include UrlHelper

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user_session, :current_user, :get_search_params, :default_theme, :current_subdomain, :current_domain
  # filter_parameter_logging moved to config.filter_parameters in Rails 3.1 (config/application.rb)

  rescue_from Acl9::AccessDenied, :with => :access_denied

  # Temporary: Log all exceptions to help debug 500 errors
  rescue_from StandardError, :with => :log_error if Rails.env.development?

  private
    def current_user_session
      return @current_user_session if instance_variable_defined?(:@current_user_session)
      begin
        @current_user_session = UserSession.find
      rescue => e
        Rails.logger.error "UserSession.find error: #{e.message}"
        @current_user_session = nil
      end
    end

    def current_user
      return @current_user if instance_variable_defined?(:@current_user)
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

    def log_error(exception)
      logger.error "EXCEPTION: #{exception.class}: #{exception.message}"
      logger.error exception.backtrace.join("\n")
      raise exception
    end

    def store_location(key = :return_to)
      session[key] = request.fullpath
    end

    def redirect_back_or_default(default, key = :return_to)
      redirect_to(session[key] || default)
      session[key] = nil
    end

    # exract the required parameters for searching for items
    def get_search_params(params)
      search_params = {}
      search_params[:search] =        params[:search]         unless params[:search].blank?
      search_params[:sort] =          params[:sort]           unless params[:sort].blank?
      search_params[:authors] =       params[:authors]        unless params[:authors].blank?
      search_params[:categories] =    params[:categories]     unless params[:categories].blank?
      search_params[:document_type] = params[:document_type]  unless params[:document_type].blank?
      search_params[:publisher] =     params[:publisher]      unless params[:publisher].blank?
      search_params[:city] =          params[:city]           unless params[:city].blank?
      search_params[:published] =     params[:published]      unless params[:published].blank?
      search_params[:page] =          params[:page]           unless params[:page].blank?
      search_params[:site_id] =       params[:site_id]        unless params[:site_id].blank?
      search_params[:subdomain] = false
      return search_params
    end

    def get_site_from_subdomain
      subdomain = current_subdomain
      Rails.logger.info "DEBUG: current_subdomain = #{subdomain.inspect} (#{subdomain.class})"
      @site = Site.find_by_title(subdomain)
      unless @site
        flash[:error] = "Site does not exist"
        redirect_to root_url(:subdomain => false)
      else
        @singular = @site.singular_item
        @plural = @site.plural_item
        return @site
      end
    end

    def get_site_from_params
      site_id = params[:id] if params[:id]
      site_id = params[:siteadmin_id] if params[:siteadmin_id]
      site_id = params[:site_id] if params[:site_id]
      @site ||= Site.find_by_id(site_id)
      if @site
        @singular = @site.singular_item
        @plural = @site.plural_item
        return @site
      else
        flash[:error] = "Invalid request"
        redirect_to root_url
      end
    end

    # get the site from the subdomain or the params hash
    def get_site
      if current_subdomain.present?
        get_site_from_subdomain
      else
        get_site_from_params
      end
    end

    # only approved sites available to the public
    def require_member_or_approved
      return if current_user.has_role?(:superadmin) if current_user
      return if @site && @site.approved
      return if @site && current_user && @site.users.include?(current_user)
      flash[:error] = "Site does not exist"
      redirect_to root_url(:subdomain => false)
    end

    # Gretel breadcrumbs are set in views, not controllers
    # See config/breadcrumbs.rb for breadcrumb definitions
end
