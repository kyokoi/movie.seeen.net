
$(function() {
  if ($('#evaluation').val() == "83") {
    $('#stars_on').show();
    $('#stars_off').hide();
  } else {
    $('#stars_on').hide();
    $('#stars_off').show();
  }
  $('#seen_star').bind(
    'click',
    function() {
      if ($('#evaluation').val() == "83") {
        $('#evaluation').val("0");
        $('#stars_on').hide();
        $('#stars_off').show();
      } else {
        $('#evaluation').val("83");
        $('#stars_on').show();
        $('#stars_off').hide();
      }
    }
  )
})


$(function() {
  $('#watch_on_place').bind(
    'click',
    function() {
      $('#watch_area_cinemas ul').each(function() {
        $(this).hide();
        $(this).removeClass("selected_area");
      })
      $('#watch_areas').show();
    }
  );

  $('#watch_areas_close').bind(
    'click',
    function() {
      $('#watch_areas .areas li').each(function() {
        $(this).removeClass("selected_area");
      })
      $('#watch_areas').hide();
    }
  );

  $('#watch_area_used li').each(function() {
    var cinema_id = $(this).attr('id').split(/-/)[1];
    console.log(cinema_id);
    $(this).bind(
      'click',
      function() {
        $('#acondition').val(cinema_id);
        $('#acondition_value').text($(this).text());
        $('#watch_areas .areas li').each(function() {
          $(this).removeClass("selected_area");
        })
        $('#watch_areas').hide();
      }
    )
  });

  $('#watch_areas .areas li').each(
    function() {
      var watch_area = "watch_area-" + $(this).attr('id').split(/-/)[1];

      $(this).bind(
        'click',
        function() {
          $('#watch_areas .areas li').each(function() {
            $(this).removeClass("selected_area");
          })
          $(this).addClass("selected_area");
          $('#watch_area_cinemas ul').each(function() {
            $(this).hide();
          })

          var area_id = '#' + watch_area;
          $(area_id).show();
          $(area_id + " li").each(function() {
            var cinema_id = $(this).attr('id').split(/-/)[1];
            $(this).bind(
              'click',
              function() {
                $('#acondition').val(cinema_id);
                $('#acondition_value').text($(this).text());
                $('#watch_areas .areas li').each(function() {
                  $(this).removeClass("selected_area");
                })
                $('#watch_areas').hide();
              }
            )
          })
        }
      )
    }
  )
})
