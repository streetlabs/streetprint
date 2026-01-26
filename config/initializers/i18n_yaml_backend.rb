# Fix for i18n YAML loading in Rails 2.3.18 with Ruby 2.7
# The vendored i18n 0.4.1 doesn't know about YAML files by default

require 'yaml'

module I18n
  module Backend
    class Simple
      # Override to use YAML parser
      def load_file(filename)
        type = File.extname(filename).tr('.', '').downcase
        raise UnknownFileType.new(type, filename) unless type == 'yml' || type == 'yaml' || type == 'rb'

        if type == 'rb'
          eval(IO.read(filename), binding, filename)
        else
          YAML.load_file(filename)
        end
      end
    end
  end
end
