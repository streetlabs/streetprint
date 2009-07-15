module ItemsHelper
  
  def sort_link_helper(text, value=text)
    key = value.downcase
    key += '_reverse' if params[:sort] == value.downcase
    return link_to( text, url_for(params.merge(:sort => key)))
  end

  def sanitize_and_trim(string, length=30)
    return sanitize string if string.size < length
    sanitize(string[0..length-4] + '...')
  end
end
