// Common JavaScript code across your application goes here.
function addAjaxAutoCompleter() {
	$("#recommendation_recommendee_name").autocomplete("/users/user_names");
}

$(document).ready(function(){
	addAjaxAutoCompleter();
})