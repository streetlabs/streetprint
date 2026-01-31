# Configure Liquid template engine for better error handling

# Require LiquidFilters module explicitly for production
require_dependency 'liquid_filters'

# Custom error handler to show actual error messages
module CustomLiquidErrorHandler
  def handle_error(error, line_number = nil, markup_context = nil)
    # Always log to Rails logger
    Rails.logger.error "Liquid template error at line #{line_number}: #{error.class}: #{error.message}"
    Rails.logger.error error.backtrace.first(15).join("\n") if error.backtrace

    case error_mode
    when :strict
      raise error
    when :warn
      warn "Liquid error (line #{line_number}): #{error.message}"
    else
      # Return error message instead of "internal"
      "Liquid error: #{error.message}"
    end
  end
end

Liquid::Template.prepend(CustomLiquidErrorHandler)

# Monkey-patch Liquid::Template.parse to fix legacy syntax
class Liquid::Template
  class << self
    alias_method :original_parse, :parse

    def parse(source, options = {})
      # Fix legacy Liquid 2.x syntax for Liquid 4.0 compatibility
      # Old syntax: {{ variable || filter: arg }}
      # New syntax: {{ variable | filter: arg }}
      if source.is_a?(String)
        # Replace || with | in Liquid variable tags
        fixed_source = source.gsub(/\{\{([^}]*)\|\|([^}]*)\}\}/) do
          before_pipes = Regexp.last_match(1)
          after_pipes = Regexp.last_match(2)
          "{{ #{before_pipes.strip} | #{after_pipes.strip} }}"
        end

        original_parse(fixed_source, options)
      else
        original_parse(source, options)
      end
    end
  end
end
