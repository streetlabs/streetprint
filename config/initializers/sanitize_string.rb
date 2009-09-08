class String
  def sanitize(options={})
    ActionController::Base.helpers.sanitize(self, options)
  end
end

class NilClass
  def sanitize(options={})
  end
end
