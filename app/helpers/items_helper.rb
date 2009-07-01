module ItemsHelper
  
  def sort_link_helper(text)
    key = text.downcase
    key += '_reverse' if params[:sort] == text.downcase
    return link_to( text, url_for(params.merge(:sort => key)))
  end

end
