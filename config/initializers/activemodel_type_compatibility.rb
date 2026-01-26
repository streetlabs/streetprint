# Ruby 3.4 compatibility fix for ActiveModel::Type classes
# Ruby 3.4 changed how keyword arguments work, affecting ActiveModel type initialization

if RUBY_VERSION >= '3.4'
  module ActiveModel
    module Type
      class Value
        # Override initialize to handle Ruby 3.4's stricter argument handling
        # Accept any arguments to maintain compatibility
        def initialize(*args, **kwargs)
          # Handle both positional and keyword arguments
          if args.empty?
            @precision = kwargs[:precision]
            @limit = kwargs[:limit]
            @scale = kwargs[:scale]
          else
            # Old-style positional arguments
            @precision = args[0]
            @limit = args[1]
            @scale = args[2]
          end
        end
      end

      class Integer < Value
        # Override to handle Ruby 3.4 compatibility
        def initialize(*args, range: nil, **kwargs)
          super(*args, **kwargs)
          @range = range
        end
      end
    end
  end
end
