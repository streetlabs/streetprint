# Add sanitize method to String for backward compatibility with Liquid templates
# This was previously provided by an older Rails plugin
class String
  def sanitize
    # Use ActionView's sanitize helper if available, otherwise just return the string
    # Liquid templates will handle escaping when rendering
    if defined?(ActionController::Base)
      # Strip potentially harmful HTML tags
      ActionController::Base.helpers.sanitize(self)
    else
      self
    end
  end
end
