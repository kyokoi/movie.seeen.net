// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(function(){
  $('#next_page').bind(
    function(data, status, xhr) {
      $('#next_page').remove();
      $('#search_items').append($(status));
    }
  );
});
