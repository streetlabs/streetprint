// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

window.addEvent('domready', function(){
  set_featured_item_forms();
});

function set_featured_item_forms(){
  $$("div.set_featured_item form").each(function(form){
    form.set('send', { url: form.get('action'), method: 'post'});
    form.addEvent('submit', function(){
      form.send();
      return false;
    });
  });
};


function remove_parent_element(element){
  element.getParent().dispose();
};

function remove_parent_2_element(element){
  element.getParent().getParent().dispose();
};


function add_p_to_element(html, element){
  e = new Element("p");
  e.set('html', html);
  e.inject($(element));
};


var user_count = 0
function add_user_div_to_element(html, element){
  e = new Element("div");
  e.set('id', 'new_user_'+user_count++)
  e.set('html', html);
  e.inject($(element));
};

function update_current_photo(html){
  $('current_photo').set('html', html);
};