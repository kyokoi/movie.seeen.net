$(function() {
  $('.opener_closer').bind(
    'click',
    function() {
      console.log($(this).next());
      $(this).next().toggle();
    }
  )
})
