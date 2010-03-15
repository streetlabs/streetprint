$(function () {  

  $('input.search').keyup(function(eventObj){	
		eventObj.preventDefault();
		eventObj.stopImmediatePropagation();
		
		if (eventObj.keyCode == 13){
		 $(this).next().click();
		}
		
	});
	
	$("form.edit_narrative").bind("keypress", function(e) {
	 if (e.keyCode == 13) return false;
	});
	
	
	$("form.new_narrative").bind("keypress", function(e) {
	 if (e.keyCode == 13) return false;
	});
	
});

function set_hidden_fields (link, id, type, index, image_path) 
{
	$(link).parents('fieldset:first').children('.media_id').val(id);
	$(link).parents('fieldset:first').children('.media_type').val(type);
	$(link).parents('fieldset:first').children('.media_index').val(index);
	$(link).parents('fieldset:first').children('.section_media').html(image_path);
    $(link).parent().parent().parent().attr("class", "empty_media_list");
    $(link).parent().parent().parent().html("");

}

function search_media (link, url) {  
   $(link).next().html('Search results are loading...');
   $(link).next().attr("id", "results")
	var data = $(link).parent().children(".search").val()
	/* not happy with this hack, but... */
	if (data)
   		$.get(url+"?search="+data, null, null, 'script');  
	else
  		$.get(url, null, null, 'script');
   return false;
}