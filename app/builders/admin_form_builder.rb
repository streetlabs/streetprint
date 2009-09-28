class AdminFormBuilder < ActionView::Helpers::FormBuilder
  
  %w[password_field text_area ].each do |method_name|
    define_method(method_name) do |field_name, *args|
      @template.content_tag(:p, field_label_with_colon(field_name, *args) + super)
    end
  end
  
  def check_box(field_name, *args)
    @template.content_tag(:p,  field_label_with_colon(field_name, *args) + " " + super)
  end
  
  def legend(field_name, *args)
    options = args.extract_options!
    type_description = options[:new] ? "New " : "Edit "
    @template.content_tag(:legend, type_description + field_name)
  end
    
  def field_label(field_name, *args)
    options = args.extract_options!
    label(field_name, options[:label], :class => options[:label_class])
  end
  
  def field_label_with_colon(field_name, *args)
    options = args.extract_options!
    #options[:label_class] = "required" if options[:required]
    label_text = options[:label] ? options[:label] + ":" : field_name.to_s.capitalize + ":"
    label(field_name, label_text, :class => options[:label_class])
  end
  
  def collection_select_labeled(field_name, *args)
    @template.content_tag(:p, field_label_with_colon(field_name, *args) + collection_select(field_name, *args))
  end
  
  def text_field(field_name, *args)
    options = args.extract_options!
    strip = options[:strip]
    if strip
      super
    else
      @template.content_tag(:p, field_label_with_colon(field_name, *args) + super)
    end
  end
  
end