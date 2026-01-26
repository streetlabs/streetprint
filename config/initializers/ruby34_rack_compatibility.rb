# Ruby 3.4 compatibility fix for ActionDispatch::Static middleware
# Ruby 3.4 changed how keyword arguments work with block parameters
# This causes issues with Rails 5.2's ActionDispatch::Static middleware

if RUBY_VERSION >= '3.4'
  module ActionDispatch
    class Static
      # Override initialize to handle Ruby 3.4's stricter argument handling
      # Rails passes path, index, headers as positional args but Ruby 3.4 expects keywords
      def initialize(app, path, index_or_options = 'index', headers = {})
        @app = app

        # Handle both old-style (3 args) and new-style (keyword args)
        if index_or_options.is_a?(Hash)
          options = index_or_options
          index = options[:index] || 'index'
          headers = options[:headers] || {}
        else
          index = index_or_options
        end

        @file_handler = FileHandler.new(path, index: index, headers: headers)
      end
    end
  end
end
