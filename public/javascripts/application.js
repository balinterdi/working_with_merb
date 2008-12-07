// Common JavaScript code across your application goes here.
function addAjaxUpdater() {
	$("#recommendation_recommendee_name").keyup(function() {
		$.get("/users/user_names", { 'name' : this.value }, function(data) {
			if (data) $("ul#recommendee_names").html("<li>"+data+"</li>");	
		});
	});
}

function addSimpleUpdater() {
	$("#recommendation_recommendee_name").keyup(function() {
		$("ul#recommendee_names").append("<li>"+this.value+"</li>");
	});
}


$(document).ready(function(){
	addAjaxUpdater();
	// addSimpleUpdater();
})