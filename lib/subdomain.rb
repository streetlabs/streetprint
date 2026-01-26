class Subdomain
  def self.matches?(request)
    case Rails.env.to_sym
    when :development, :test
      tld_length = 0  # localhost
    when :production
      tld_length = 1  # .com, .org, etc.
    else
      tld_length = 1
    end

    subdomain = request.subdomain(tld_length)
    subdomain.present? && subdomain != 'www'
  end
end
