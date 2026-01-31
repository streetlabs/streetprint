# Log Liquid errors to Rails logger for debugging
module LiquidErrorLogging
  def render(context)
    super
  rescue => e
    Rails.logger.error "Liquid rendering error: #{e.class}: #{e.message}"
    Rails.logger.error e.backtrace.first(10).join("\n")
    raise
  end
end

Liquid::Template.prepend(LiquidErrorLogging)

# Also configure Liquid to show full errors in production for debugging
Liquid::Template.error_mode = :warn
