module LiquidFilters

  def image_path(file_name, site)
    begin
      theme_id = site['theme']

      # In development, use S3 URLs directly
      # In production, use local system paths
      if Rails.env.development?
        "https://sp5-public.assets.streetprint.org/images/#{theme_id}/original/#{file_name}"
      else
        "/system/images/production/#{theme_id}/original/#{file_name}"
      end
    rescue => e
      Rails.logger.error "Error in image_path filter: #{e.message}"
      ""
    end
  end

  def image_url(file_name, site)
    path = image_path(file_name, site)
    path.present? ? "url(#{path})" : ""
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
    return "" if input.nil?

    # Log detailed debugging info
    Rails.logger.debug "=" * 80
    Rails.logger.debug "TEXTILIZE INPUT:"
    Rails.logger.debug "  Class: #{input.class}"
    Rails.logger.debug "  Length: #{input.length}"
    Rails.logger.debug "  Encoding: #{input.encoding}"
    Rails.logger.debug "  Full content: #{input.inspect}"

    # Process with RedCloth
    # Note: RedCloth may truncate text if it encounters parsing errors
    # Common issues: unmatched quotes, certain special characters
    result = RedCloth.new(input.to_s).to_html

    # Check if result was truncated (significantly shorter than input)
    if result.length < input.length * 0.5
      Rails.logger.warn "TEXTILIZE WARNING: Output significantly shorter than input!"
      Rails.logger.warn "  Input length: #{input.length}, Output length: #{result.length}"

      # Fallback: Try simple paragraph wrapping with line breaks
      # This preserves the content when RedCloth fails
      escaped = ERB::Util.html_escape(input.to_s)
      result = "<p>#{escaped.gsub(/\r?\n/, '<br />')}</p>"

      Rails.logger.warn "  Using fallback HTML wrapping instead"
    end

    Rails.logger.debug "TEXTILIZE OUTPUT:"
    Rails.logger.debug "  Length: #{result.length}"
    Rails.logger.debug "  Full content: #{result.inspect}"
    Rails.logger.debug "=" * 80

    result
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
