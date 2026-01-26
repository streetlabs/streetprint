class String
  def sanitize(options={})
    # In Rails 3.1+, we need to specify which tags are allowed
    # If no tags specified, allow all common HTML tags
    if options.empty?
      # Allow common HTML tags by default
      options = {
        :tags => %w(a abbr acronym address article aside audio b bdi bdo big blockquote br caption center cite code col colgroup dd del details dfn div dl dt em figcaption figure font h1 h2 h3 h4 h5 h6 hr i img ins kbd li mark ol p pre q rp rt ruby s samp section small span strike strong sub summary sup table tbody td tfoot th thead time tr tt u ul var video),
        :attributes => %w(abbr align alt axis border cellpadding cellspacing char charoff cite class colspan datetime dir headers height href hreflang id lang longdesc name rel rev rowspan scope span src start style summary target title type valign vspace width xml:lang)
      }
    end
    ActionController::Base.helpers.sanitize(self, options).html_safe
  end
end

class NilClass
  def sanitize(options={})
  end
end
