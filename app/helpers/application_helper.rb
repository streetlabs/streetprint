# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def sort_link_helper(text, value=text)
    key = value.downcase
    key += '_reverse' if params[:sort] == value.downcase
    new_params = params.clone
    new_params = new_params.merge(:sort => key)
    new_params = new_params.merge(:subdomain => @site.title) if @site
    return link_to( text, url_for(new_params))
  end

  def sanitize_and_trim(string, length=30)
    return string unless string
    return sanitize(string) if string.size < length
    sanitize(string[0..length-4] + '...')
  end
  
end
