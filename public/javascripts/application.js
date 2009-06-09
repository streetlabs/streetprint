// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function remove_parent_element(element){
  element.getParent().dispose();
};


function add_p_to_element(html, element){
  e = new Element("p");
  e.set('html', html);
  e.inject($(element));
};
