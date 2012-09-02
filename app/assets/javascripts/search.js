// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(function(){
  $('#next_page').live(
    "ajax:success",
    function(data, status, xhr) {
      $('#next_page').remove();
      $('#search_items').append($(status));
    }
  );
  $('#next_page').live(
    "ajax:beforeSend",
    function(xhr) {
      //$('#next_page_button').remove();
      var s = '<div style="width: 100%;"><img src="/assets/layout/loading.gif" /></div>';
      $('#next_page_button').html(s);
    }
  );
});
