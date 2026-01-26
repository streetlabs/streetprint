# Ruby 3.2+ compatibility: File.exists? was removed, use File.exist? instead
# Add exists? as an alias for older gems that haven't been updated

class File
  class << self
    alias_method :exists?, :exist? unless method_defined?(:exists?)
  end
end

class Dir
  class << self
    alias_method :exists?, :exist? unless method_defined?(:exists?)
  end
end
