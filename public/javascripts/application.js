// Common JavaScript code across your application goes here.
function addAjaxAutoCompleter() {
	$("#recommendation_recommendee_name").autocomplete("/users/user_name_search");
}

$(document).ready(function(){
	addAjaxAutoCompleter();
})