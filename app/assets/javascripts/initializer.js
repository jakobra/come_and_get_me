jQuery.ajaxSetup({
  beforeSend: function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};