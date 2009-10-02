module ItemsHelper
  
  def add_person_link(name) 
    link_to_function name do |page|
      page.insert_html :bottom, :people, :partial => 'author', :object => Author.new
    end 
  end
  
  def add_new_person_link(name, parent_form) 
   link_to_function name do |page|
      page.insert_html :bottom, :new_people, :partial => 'new_author', :object => Author.new, :locals =>{ :author => Author.new, :parent_form => parent_form, :child_index => 'NEW_RECORD'}
    end 
  end
  
  def add_category_link(name) 
    link_to_function name do |page|
      page.insert_html :bottom, :categories, :partial => 'category', :object => Category.new
    end 
  end

  def add_photo_link(name) 
    link_to_function name do |page|
      page.insert_html :bottom, :photos, :partial => 'photo', :object => Photo.new
    end 
  end

  def add_media_link(name) 
    link_to_function name do |page|
      page.insert_html :bottom, :media_files, :partial => 'media_file', :object => MediaFile.new
    end 
  end
  
  
  def add_custom_data_link(name, parent_form)
   link_to_function name do |page|
      page.insert_html :bottom, :new_people, :partial => 'custom_data', :object => CustomData.new, :locals =>{ :custom_data => CustomData.new, :parent_form => parent_form, :child_index => 'NEW_RECORD'}
    end 
  end
  
  def toggle_advanced_fields(name) 
    link_to_function name do |page|
      page.visual_effect  :toggle_slide, 'advanced_properties', :duration => 1.0
    end 
  end
  
  def add_data_link(form_builder)
    link_to_function 'Add Custom Data' do |page|
      form_builder.fields_for :custom_datas, CustomData.new, :child_index => 'NEW_RECORD' do |form|
        html = render(:partial => 'custom_data', :locals => { :f => form })
        page << "$('#datas').append('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()) );"
      end
    end
  end
  
  def remove_data_link(form_builder)
    if form_builder.object.new_record?
      # If the task is a new record, we can just remove the div from the dom
      link_to_function("remove", "$(this).parent().remove()");
    else
      # However if it's a "real" record it has to be deleted from the database,
      # for this reason the new fields_for, accept_nested_attributes helpers give us _delete,
      # a virtual attribute that tells rails to delete the child record.
      form_builder.hidden_field(:_delete) +
      link_to_function("remove", "$(this).prev().val('1'); $(this).parent().hide();")
    end
  end
       
       
    
end
