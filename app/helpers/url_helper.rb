# frozen_string_literal: false

module UrlHelper
  def self.tld_length
    case Rails.env.to_sym
    when :development, :test
      0  # localhost (example.localhost -> example subdomain, localhost domain)
    when :production
      1  # .com, .org, etc.
    else
      1
    end
  end

  def with_subdomain(subdomain)
    domain = request.domain(UrlHelper.tld_length).to_s
    port = request.port_string.to_s

    # Handle the case where subdomain is false (remove subdomain)
    if subdomain == false || subdomain == ""
      return domain + port
    end

    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    subdomain + domain + port
  end

  def subdomain_url(subdomain, path = "/")
    # Helper to build URLs with subdomains, avoiding frozen string issues
    protocol = request.ssl? ? "https://" : "http://"
    if subdomain && subdomain != false && subdomain != ""
      host = "#{subdomain}.#{request.domain(UrlHelper.tld_length)}#{request.port_string}"
    else
      host = "#{request.domain(UrlHelper.tld_length)}#{request.port_string}"
    end
    protocol + host + path
  end

  def current_subdomain
    request.subdomain(UrlHelper.tld_length)
  end

  def current_domain
    request.domain(UrlHelper.tld_length)
  end
end
