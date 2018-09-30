$(document).ready(function(){
  $('.bg-white').click(function(e) {
    e.preventDefault();
    $('#all-videos .video-content').hide();
    $('#video-' + $(this).data('type')).show();
  });

  $('#notify_records').on('click', '.illness-btn', function (e) {
    $.get('/manager/illness_guides/content', {
      'illness_name': $(this).data('illness'), 'target-role': $(this).data('targetRole')
    }, null, 'script');
  });
});
