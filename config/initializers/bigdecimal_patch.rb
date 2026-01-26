# Patch for Ruby 2.6+ compatibility with Rails 3.2
# BigDecimal.new was deprecated in Ruby 2.6 in favor of BigDecimal()
# Rails 3.2 ActiveSupport tries to use BigDecimal.new

if RUBY_VERSION >= '2.6.0'
  require 'bigdecimal'

  class BigDecimal
    class << self
      alias_method :new, :BigDecimal unless method_defined?(:new)
    end
  end
end
