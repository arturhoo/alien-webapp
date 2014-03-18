var client = new Faye.Client('//localhost:9000/faye')
var subscription = undefined;

function enableSubscription() {
  subscription = client.subscribe('/alien', function(message) {
    handleMessage(message);
  });
}

function handleMessage(message) {
  if(message.text.indexOf('disabled') != -1) {
    $('#auto-button').prop('value', 'Disabled');
    $('#after-auto-button').html('');
    subscription.cancel();
  } else {
    $('#auto-tags').append(message.text + '\n');
  }
}

function enableAutoMode() {
  $.post('/job', function(data) {
    console.log(data);
  });
  $('#auto-button').removeClass('btn-primary')
                   .prop('value', 'Enabled')
                   .addClass('btn-default')
                   .addClass('active')
                   .attr('disabled', 'disabled')
  $('#after-auto-button').html('<i class="fa fa-refresh fa-spin"></i>');
  enableSubscription();
}

function getTags() {
  $('#manual-tags').empty();
  $.getJSON('/tags.json', function(data) {
    $.each(data, function(key, val) {
      $('#manual-tags').append(val + '\n');
    });
  });
}
