---
---

function init() {

  var monthNames = ["January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  var map, bounds;
  var startDate, endDate;
  var today = moment.utc();
  var dateRegex = /^20[0-9]{2}\-[0-9]{2}\-[0-9]{2}$/;

  loadStartDate();
  build();

  $('.js-calendar-prev').on('click', function (event) {
    event.preventDefault();
    previousMonth();
  });

  $('.js-calendar-next').on('click', function (event) {
    event.preventDefault();
    nextMonth();
  });

  $('#js-events-form').on('submit', function (event) {
    $('#form-errors').html('').hide().removeClass('alert--success').removeClass('alert--error');

    event.preventDefault();
    var submission = {};
    submission.title = $('#event-title').val();
    submission.description = $('#event-description').val();
    submission.location = { text: $('#event-location').val() };
    submission.type = $('#event-type').val();
    submission.website = $('#event-website').val();
    submission.submission = {
      name: $('#event-name').val(),
      email: $('#event-email').val()
    };
    submission.startDate = moment.utc($('#event-start-date').val(), 'YYYY-MM-DD').toDate();
    submission.endDate = moment.utc($('#event-end-date').val(), 'YYYY-MM-DD').toDate();
    submission.isAllDay = true;
    if (!dateRegex.test($('#event-start-date').val())) {
      return setError('Start date is not valid', 'Please use the format YYYY-MM-DD', 'alert--error');
    }
    if (!dateRegex.test($('#event-end-date').val())) {
      return setError('End date is not valid', 'Please use the format YYYY-MM-DD', 'alert--error');
    }
    if (submission.startDate < new Date()) {
      return setError('Start date is not valid', 'Please enter a start date that is in the future', 'alert--error');
    }
    if (submission.endDate < new Date()) {
      return setError('End date is not valid', 'Please enter a end date that is in the future', 'alert--error');
    }
    $.post('{{ site.external_server }}/events/submit.json', submission, function (res) {
      if (res && res.message) {
        setError(res.message, 'We will review the details of your event and contact you when it has been approved for inclusion on our site.', 'alert--success');
        $('#js-events-form').get(0).reset();
      }
      else {
        console.log(res);
      }
    }).fail(function (res) {
      console.log(res.responseJSON);
      if (res.responseJSON && res.responseJSON.error && res.responseJSON.error.name == 'ValidationError') {
        $('#form-errors').append($('<p/>').text(res.responseJSON.error.details[0].message));
      }
      else if (res.responseJSON && res.responseJSON.error && res.responseJSON.error.details) {
        $('#form-errors').text(res.responseJSON.error.details.messsage).show();
      }
      else {
        $('#form-errors').append($('<p/>').text('An unknown error has occurred!'));
      }
      $('#form-errors').addClass('alert--error').show();
    });
  });

  window.addEventListener('hashchange', function () {
    loadStartDate();
    build();
  });

  function setError(title, body, cssClass) {
    $('#form-errors').append($('<h4/>').text(title));
    $('#form-errors').append($('<p/>').text(body));
    $('#form-errors').addClass(cssClass).show();
  }

  function loadStartDate() {
    var monthStr = location.hash.substr(1);
    startDate = moment.utc().startOf('month');
    if (monthStr && monthStr.length) {
      try {
        var monthBits = monthStr.split('-');
        startDate = moment.utc([ monthBits[0], (parseInt(monthBits[1], 10) - 1) ]);
      }
      catch (ex) { }
    }
    endDate = moment.utc(startDate).add(1, 'month');
  }

  function previousMonth() {
    startDate.subtract(1, 'month');
    update();
  }

  function nextMonth() {
    startDate.add(1, 'month');
    update();
  }

  function update() {
    window.location.hash = '#' + startDate.format('YYYY-MM');
  }

  function build() {
    buildCalendar();
    // Get a list of Meetup locations
    loadLocations();
    // Get a list of Meetup events
    loadEvents();

    $(".pagetitle").each(function(idx, title) {
      title.innerText = monthNames[startDate.month()] + " Events";
    });
  }

  function buildCalendar() {
    $('.js-events__calendar tbody').html('');
    $('.js-calendar-month').text(startDate.format('MMMM YYYY'));
    var calendarStart = moment.utc(startDate);
    calendarStart.subtract(startDate.day() - 1, 'days');
    var calendarEnd = moment.utc(startDate).add(1, 'months').date(0);
    var $row = $('<tr>');
    for (var d = 0; d < 42; d += 1) {
      $row.append(buildCalendarDay(calendarStart));
      calendarStart.add(1, 'day');
      if (d % 7 == 6) {
        $('.js-events__calendar tbody').append($row);
        $row = $('<tr>');
        if (calendarStart.dayOfYear() > calendarEnd.dayOfYear()) {
          break;
        }
      }
    }
    if (('td', $row).length) {
      $('.js-events__calendar tbody').append($row);
    }
    $('.js-events__calendar').css('display', '');

    function buildCalendarDay(date) {
      var $cell = $('<td>');
      if (date.month() === startDate.month()) {
        $cell.text(date.date());
        $cell.attr('data-calendar-date', date.format('YYYY-MM-DD'));
        if (date < today) {
          $cell.addClass('calendar__day--past');
        }
        if (date.dayOfYear() === moment.utc().dayOfYear()) {
          $cell.addClass('calendar__day--today');
        }
      }
      return $cell;
    }
  }

  function addEventToCalendar(event) {
    var start = moment.utc(event.startDate);
    var end = moment.utc(event.endDate);
    while (start.dayOfYear() <= end.dayOfYear()) {
      var dateStr = start.format('YYYY-MM-DD');
      var $cell = $('.js-events__calendar td[data-calendar-date="' + dateStr + '"]');
      $cell.addClass(start.date() < today.date() ? 'calendar__day--past-event' : 'calendar__day--event');
      start.add(1, 'day');
    }
  }

  function loadLocations() {
    var locationsUrl = '{{ site.external_server }}/events/locations';
    $.getJSON(locationsUrl, function (locations) {
      if (locations && locations.length > 0) {
        buildMap(locations);
      }
    });
  }

  function loadEvents() {
    $('.js-events__list').html('<span class="spinner spinner--padded spinner--large spinner--center"></span>');
    var tplInfo = Handlebars.templates['events-info'];
    var eventsUrl = '{{ site.external_server }}/events/upcoming.json?limit=60&start=' +
                    startDate.format('YYYY/MM/DD') + '&end=' + endDate.format('YYYY/MM/DD');

    $.getJSON(eventsUrl, function (events) {
      if (events.length === 0) {
        $('.js-events__list').html(Handlebars.templates['events-info-none']({ month: startDate.format('MMMM YYYY') }));
      }
      else {
        $('.js-events__list').html('');
        var today = new Date(); today.setHours(0,0,0,0);

        events.forEach(function (event, index) {
          var eventDate = new moment(event.startDate);

          event.number = index + 1;
          event.description = event.description.replace(/\n\n\n/g, '<br><br>');
          event.description = event.description.replace(/\n/g, '<br>');
          event.dateString = eventDate.format("YYYY-MM-DD");

          var $event = $(tplInfo(event));

          if (index % 2 === 0 && index > 0) $event.addClass('reset-m');
          if (eventDate < today) $event.children('article').addClass("event--past");

          var descToggle = $event.find(".event__toggle");
          descToggle.click(function(e) {
            e.preventDefault();

            var desc = $event.find(".event__description");
            if (desc.attr("hidden")) {
              desc.removeAttr("hidden");
              desc.removeClass("hidden");

              this.innerText = "Less..";
            } else {
              desc.attr("hidden", "true");
              desc.addClass("hidden");

              this.innerText = "More..";
            }
          });

          $('.js-events__list').append($event);
          addEventToCalendar(event);
        });
      }
      buildMap(events);
    });
  }

  function buildMap(events) {
    if (!map) {
      var mapOptions = {
        center: new google.maps.LatLng(37.442362, -122.162224),
        zoom: 8,
        maxZoom: 8,
        streetViewControl: false,
        scrollwheel: false
      };
      bounds = new google.maps.LatLngBounds();
      map = new google.maps.Map(document.getElementById('js-events__map'), mapOptions);
    }
    events.forEach(function (event) {
      if (event.latitude && event.longitude) {
        var loc = new google.maps.LatLng(event.latitude, event.longitude);
        var infoWindow = new google.maps.InfoWindow({
          content: event.title
        });
        var icon = 'http://maps.google.com/mapfiles/ms/icons/purple-dot.png';
        if (!event.startDate) {
          // It's a group, geocode the location
          icon = 'http://maps.google.com/mapfiles/ms/icons/yellow.png';
          $.getJSON('http://maps.googleapis.com/maps/api/geocode/json?address='+escape(event.location)+'&sensor=false', null, function (data) {
              var loc = data.results[0].geometry.location;
              var marker = new google.maps.Marker({
                position: loc,
                map: map,
                title: event.website + ' : ' + event.title,
                icon: icon,
                size: new google.maps.Size(32, 32),
                zIndex: 1
              });
              google.maps.event.addListener(marker, 'click', function() {
                window.open('https://www.meetup.com/' + event.website);
              });
              fitMap(map, loc, bounds);
          });
        } else {
          // It's an event
          var marker = new google.maps.Marker({
            position: loc,
            map: map,
            title: event.location + ' : ' + event.title,
            icon: icon,
            size: new google.maps.Size(32, 32),
            zIndex: 2
          });
          google.maps.event.addListener(marker, 'click', function() {
            scrollToEvent(event);
          });
          fitMap(map, loc, bounds);
        }
      }
    });
    $('.js-events__map').css('display', 'block');
  }

  function fitMap(map, loc, bounds) {
    bounds.extend(loc);
    map.fitBounds(bounds);
    map.panToBounds(bounds);
  }

  function scrollToEvent(event) {
    var $event = $('.event[data-event-number="' + event.number + '"]');
    $('.event.event--highlighted').removeClass('event--highlighted');
    $event.addClass('event--highlighted');
    $('body').scrollTo($event.get(0), 200, {
      offset: function () {
        return {
          left: 0,
          top: (-1 * parseInt($('body').css('padding-top'), 10)) - 20
        };
      }
    });
  }
};

var script = document.createElement('script');
script.type = 'text/javascript';
script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&callback=init';
document.body.appendChild(script);
