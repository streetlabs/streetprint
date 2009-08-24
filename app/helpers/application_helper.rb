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
  
  # creates hidden field tags for all of the persistent search parameters
  # feels like there should be a better way to do this but I have wasted to much time looking
  # love, Cody
  def persistent_search_form_tags(params) 
    tags = ''
    tags << hidden_field_tag('persistent_search[search]',         params[:search])        if params[:search]
    tags << hidden_field_tag('persistent_search[sort]',           params[:sort])          if params[:sort]
    tags << hidden_field_tag('persistent_search[authors]',        params[:authors])       if params[:authors]
    tags << hidden_field_tag('persistent_search[categories]',     params[:categories])    if params[:categories]
    tags << hidden_field_tag('persistent_search[document_type]',  params[:document_type]) if params[:document_type]
    tags << hidden_field_tag('persistent_search[publisher]',      params[:publisher])     if params[:publisher]
    tags << hidden_field_tag('persistent_search[city]',           params[:city])          if params[:city]
    tags << hidden_field_tag('persistent_search[page]',           params[:page])          if params[:page]
    tags
  end
end
