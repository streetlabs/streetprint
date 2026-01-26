# Rails 4.0 removed link_to_function
# Add a simple replacement helper

module ActionView
  module Helpers
    module UrlHelper
      def link_to_function(name, function, html_options = {})
        onclick = "#{html_options[:onclick]}; " if html_options[:onclick]
        link_to(name, "#", html_options.merge(:onclick => "#{onclick}#{function}; return false;"))
      end
    end
  end
end
