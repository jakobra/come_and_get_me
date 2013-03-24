jQuery.ajaxSetup({
  beforeSend: function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

function initialize(container) {
	if (container.data("initialized"))
		return false;
	
	container.data("initialized", true);
	
	//$("a[rel=popup]", container).popup();
}