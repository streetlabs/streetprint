$(function () {  
  $('a.media_search').live("click", function () {  
    $(this).next().html('Search results are loading...');
    $(this).next().attr("id", "results")
	var data = $(this).parent().children(".search").val()
	if (data)
    	$.get(this.href+"?search="+data, null, null, 'script');  
	else
   		$.get(this.href, null, null, 'script');
    return false;  
  });  

  $('input.search').keyup(function(eventObj){	
		eventObj.preventDefault();
		eventObj.stopImmediatePropagation();
		
		if (eventObj.keyCode == 13){
		 $(this).next().click();
		}
		
	});
	
	$("form").bind("keypress", function(e) {
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
