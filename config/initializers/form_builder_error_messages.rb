# Add error_messages method back to FormBuilder for Rails 5 compatibility
# This method was removed in Rails 3.0 but many old views still use it

class ActionView::Helpers::FormBuilder
  def error_messages(options = {})
    return '' unless object.respond_to?(:errors) && object.errors.any?

    @template.content_tag(:div, class: 'error_messages') do
      @template.content_tag(:h2) do
        "#{@template.pluralize(object.errors.count, 'error')} prohibited this from being saved:"
      end +
      @template.content_tag(:ul) do
        object.errors.full_messages.map { |msg|
          @template.content_tag(:li, msg)
        }.join.html_safe
      end
    end
  end
end
