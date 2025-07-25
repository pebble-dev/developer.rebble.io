---
---

var contactType = queryString.parse(location.search).type;
switch (contactType) {
  case '404':
    $('#contact-form #type').val('Website Issue');
    break;
  case 'event':
    $('#contact-form #type').val('Event Sponsorship');
    break;
  case 'documentation':
    $('#contact-form #type').val('Documentation Feedback');
    break;
}

// Grab the users details from the external server.
$.ajax('{{ site.external_server }}/auth/profile.json', {
  crossDomain: true,
  xhrFields: {
    withCredentials: true
  },
  success: function (data, responseType) {
    if ('success' === responseType) {
      $('#contact-form #name').val(data.name)
      $('#contact-form #email').val(data.email)
    }
    else {
      console.log(data);
    }
  }
});

// Handle submision of the form.
$('#contact-form').on('submit', function (event) {
  event.preventDefault();

  var $form = $(this);
  var errors = [];
  var message = {};

  var $formMessages = $('.js-form-messages');

  var block = $('#contact-form #block').val();
  if (block && block.length) {
    errors.push('If you are not a robot, do not fill out the block field.');
  }

  message.name    = $('#contact-form #name').val() || '';
  message.email   = $('#contact-form #email').val() || '';
  message.type    = $('#contact-form #type').val() || '';
  message.subject = $('#contact-form #subject').val() || '';
  message.content = $('#contact-form #message').val() || '';

  if (message.name.length === 0) {
    errors.push('You must provide your name.');
  }
  if (message.email.length === 0) {
    errors.push('You must provide your email address.');
  }
  if (message.type.length === 0) {
    errors.push('You must specify the type of contact message.');
  }
  if (message.subject.length === 0) {
    errors.push('You must provide a subject for the message.');
  }
  if (message.content.length === 0) {
    errors.push('You must enter some content for the message.');
  }

  if (errors.length) {
    $formMessages.html('');
    $formMessages.append($('<div class="alert alert--error"><ul>' + errors.map(function (err) { return '<li>' + err + '</li>' }).join('') + '</ul></div>'));
  }
  else {
    var request = $.post('{{ site.external_server }}/contact/message.json', message);
    request.done(function (response) {
      $formMessages.html('');
      var message = 'Message sent to Pebble developer support!';
      $formMessages.append($('<div class="alert alert--success alert--padded"><p>' + message + '</p></div>'));
      $form.get(0).reset();
    });
    request.fail(function (response) {
      $formMessages.html('');
      var message = 'Error ' + response.status + ': ' + response.statusText;
      $formMessages.append($('<div class="alert alert--error"><p>' + message + '</p></div>'));
    });
  }

});