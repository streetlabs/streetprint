module LiquidFilters
  
  def image_path(file_name, site)
    theme = SiteTheme.find(site['theme'])
    img = theme.theme_images.find_by_image_file_name(file_name)
    img.image.url
  end
  
  def blank_target_link(title, target, params=nil)
    params = hash_to_query(params)
    "<a href='#{target}#{params}' target='_blank'>#{title}</a>"
  end

  def link_to(title, target, params=nil)
    params = hash_to_query(params)
    "<a href='#{target}#{params}'>#{title}</a>"
  end
  
  def link_with_sort(title, target, key, params)
    hash = Marshal.load(params)
    key += '_reverse' if hash[:sort] == key
    query = hash_to_query(hash.merge(:sort => key))
    "<a href='#{target}#{query}'>#{title}</a>"
  end
  
  def textilize(input)
    RedCloth.new(input).to_html
  end
  
  def hash_to_query(hash)
    return nil unless hash.present?
    if hash.is_a?(String)
      params = Marshal.load(hash)
    elsif hash.is_a?(Hash)
      params = hash
    end
    if params.size > 0
      params = '?' + params.to_param
    else
      params = ''
    end
    params
  end
  
end
