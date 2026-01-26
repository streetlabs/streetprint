module ItemsHelper

  def add_person_link(name)
    # Simplified version - just show a note for now
    # TODO: Convert to modern JavaScript
    link_to name, "#", onclick: "alert('This feature needs JavaScript modernization. For now, save the item and edit it to add authors.'); return false;", class: "add-link"
  end

  def add_new_person_link(name, parent_form)
    link_to name, "#", onclick: "alert('Save the item first, then edit to add authors'); return false;", class: "add-link"
  end

  def add_category_link(name)
    link_to name, "#", onclick: "alert('Save the item first, then edit to add categories'); return false;", class: "add-link"
  end

  def add_photo_link(name)
    link_to name, "#", onclick: "alert('Save the item first, then edit to add photos'); return false;", class: "add-link"
  end

  def add_media_link(name)
    link_to name, "#", onclick: "alert('Save the item first, then edit to add media files'); return false;", class: "add-link"
  end

  def add_custom_data_link(name, parent_form)
    link_to name, "#", onclick: "alert('Save the item first, then edit to add custom data'); return false;", class: "add-link"
  end

  def toggle_advanced_fields(name)
    link_to name, "#", onclick: "var el = document.getElementById('advanced_properties'); el.style.display = el.style.display === 'none' ? 'block' : 'none'; return false;"
  end

  def add_data_link(form_builder)
    link_to 'Add Custom Data', "#", onclick: "alert('Save the item first, then edit to add custom data'); return false;", class: "add-link"
  end

  def remove_data_link(form_builder)
    if form_builder.object.new_record?
      link_to("remove", "#", onclick: "this.parentElement.remove(); return false;")
    else
      form_builder.hidden_field(:_destroy) +
      link_to("remove", "#", onclick: "this.previousElementSibling.value='1'; this.parentElement.style.display='none'; return false;")
    end
  end

end
