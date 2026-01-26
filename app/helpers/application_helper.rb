# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # RDFa helper - returns opening HTML tag with RDFa attributes
  def rdfa_html
    '<html xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:foaf="http://xmlns.com/foaf/0.1/">'
  end

  def sort_link_helper(text, value=text)
    key = value.downcase
    key += '_reverse' if params[:sort] == value.downcase
    new_params = params.to_unsafe_h.clone
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
    # the site - convert to Liquid format
    hash['site'] = @site.to_liquid

    hash['now'] = Time.now

    # random artifacts and narratives - convert to Liquid format
    hash['random_narrative'] = @site.random_narrative&.to_liquid
    hash['random_item'] = @site.random_item&.to_liquid

    # path helpers
    hash['home_path']   = root_url(:subdomain => @site.title)
    hash['browse_path'] = new_browse_path(:subdomain => @site.title)
    hash['search_path'] = items_path(:subdomain => @site.title)
    hash['news_path']   = news_posts_path(:subdomain => @site.title)
    hash['about_path']  = about_path(:subdomain => @site.title)

    # stats - use connection.select_value to avoid Arel Integer visitor issues
    hash['item_count']  = ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM items WHERE site_id = #{@site.id}").to_i
    hash['image_count'] = ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM photos WHERE item_id IN (SELECT id FROM items WHERE site_id = #{@site.id})").to_i
    hash['media_count'] = ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM media_files WHERE item_id IN (SELECT id FROM items WHERE site_id = #{@site.id})").to_i

    hash['singular'] = @singular
    hash['plural'] = @plural

    # params for maintaining search
    hash['search_query_string'] = get_search_params(params).to_param
    hash['search_params'] = Marshal.dump(get_search_params(params))

    return hash
  end

  # Shim for old link_to_function helper (Rails 2/3)
  # This is a temporary fix - ideally these should be converted to unobtrusive JavaScript
  def link_to_function(name, function = nil, html_options = {}, &block)
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function || capture(&block)}; return false;"
    href = html_options[:href] || '#'
    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

end
