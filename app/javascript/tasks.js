document.addEventListener("turbolinks:load", function() {
    $('button[data-remote=true]').on('ajax:success', function(event) {
      var task = event.detail[0];  // The task returned in JSON format
      var button = $(this);
      if (task.is_completed) {
        button.closest('tr').find('td.status').text('Completed');
      } else {
        button.closest('tr').find('td.status').text('Incomplete');
      }
    });
  });
  