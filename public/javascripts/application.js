// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

window.addEvent('domready', function(){
  set_featured_item_forms();
  set_publish_item_forms();
  setup_advanced_search();
  hide_advanced_tools();
});

function hide_advanced_tools(){
	var slide_status = {
		'true': '-',
		'false': '+'
	};
	
	if( $('advanced_properties') && $('advanced_properties') != null ){
		apSlide = new Fx.Slide('advanced_properties').hide('vertical');
		apSlide.addEvent('complete', function() { $('advanced_properties_status').set('html', slide_status[apSlide.open] ); } );
	}
}

function setup_advanced_search(){
  if($('authors') && $('authors').get('value') == '' && $('categories') && $('categories').get('value') == '' && $('publisher') && $('publisher').get('value') == '' && $('city') && $('city').get('value') == ''){
    $('advanced_search_fields').setStyle('display', 'none');
  }
  if($('advanced_search_link')){
    $('advanced_search_link').setStyle('display', 'inline');
    $('advanced_search_link').addEvent('click', function(event){
      var style = $('advanced_search_fields').getStyle('display');
      style = (style == 'none') ? 'block' : 'none';
      $('advanced_search_fields').setStyle('display', style);
      event.preventDefault();
    });
  }
}

function set_featured_item_forms(){
  $$("div.set_featured_item form").each(function(form){
    form.set('send', { url: form.get('action'), method: 'post'});
    form.addEvent('submit', function(event){
      form.send();
      event.preventDefault();
    });
  });
};

function set_publish_item_forms(){
  $$("div.publish_item form").each(function(form){
    form.set('send', { url: form.get('action'), method: 'post'});
    form.addEvent('submit', function(event){
      form.send();
      event.preventDefault();
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