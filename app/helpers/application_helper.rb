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
    return sanitize(trim(string, length))
  end
  
  def trim(string, length=30)
    return string unless string
    return string if string.size < length
    string[0..length-4] + '...'
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
  
  # add some commone values
  def add_common_liquid_args(hash={})
    # the site
    hash['site'] = @site
    
    hash['now'] = Time.now
    
    # random artifacts and narratives
    hash['random_narrative'] = @site.random_narrative
    hash['random_item'] = @site.random_item
    
    # path helpers
    hash['home_path']   = root_url(:subdomain => @site.title)
    hash['browse_path'] = new_browse_path(:subdomain => @site.title)
    hash['search_path'] = items_path(:subdomain => @site.title)
    hash['news_path']   = news_posts_path(:subdomain => @site.title)
    hash['about_path']  = about_path(:subdomain => @site.title)

    # stats
    hash['item_count']  = Item.count(:conditions => {:site_id => @site.id})
    items = @site.items.map {|i| i.id }.join(', ')
    hash['image_count'] = items.blank? ? 0 : Photo.count(:conditions => ["item_id in (#{@site.items.map { |s| s.id }.join(', ')})"])
    hash['media_count'] = items.blank? ? 0 : MediaFile.count(:conditions => ["item_id in (#{@site.items.map { |s| s.id }.join(', ')})"])
    
    hash['singular'] = @singular
    hash['plural'] = @plural
    
    # params for maintaining search
    hash['search_query_string'] = get_search_params(params).to_param
    hash['search_params'] = Marshal.dump(get_search_params(params))
    
    return hash
  end
  
end