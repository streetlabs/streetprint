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
  
  def toggle_advanced_fields(name) 
    link_to_function name do |page|
      page.visual_effect  :toggle_slide, 'advanced_properties', :duration => 1.0
    end 
  end
       
    
end
