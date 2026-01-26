# Rails 4.2: textilize helper for RedCloth with html_safe
module ActionView
  module Helpers
    module TextHelper
      def textilize(text)
        return '' if text.blank?
        require 'redcloth'
        RedCloth.new(text).to_html.html_safe
      end

      def textilize_without_paragraph(text)
        textilized = textilize(text)
        if textilized =~ /<p>(.*)<\/p>/m
          $1.html_safe
        else
          textilized
        end
      end
    end
  end
end
