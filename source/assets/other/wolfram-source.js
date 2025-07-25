var ui = require('ui');
var ajax = require('ajax');

var base = 'https://www.wolframcloud.com/objects/user-7053ce31-817f-4643-aec1-eda27051bba6/pebble/';

var main = new ui.Card({
  title: ' Wolfram',
  icon: 'images/wolfram.png',
  subtitle: 'Cloud App',
  body: 'Press SELECT'
});

main.show();

main.on('click', 'select', function(e) {
  var menu = new ui.Menu({
    sections: [{
      items: [
        { title: 'DateString[]', subtitle: 'get the date' }, 
        { title: '$RequesterAddress', subtitle: 'get the ip' }, 
        { title: '$GeoLocation', subtitle: 'get the location' }, 
        { title: 'WeatherData[]', subtitle: 'get the temperature' }, 
        { title: '$Version', subtitle: 'get the version' },
        { title: 'Sunset[]', subtitle: 'get the sunset' }, 
        { title: 'FinancialData', subtitle: 'get a stock' }]
    }]
  });

  menu.show();
  
  menu.on('select', function(e) {
    switch(e.itemIndex) {
      case 0: displayResults( base + 'date', 'DateString[]' ); break;
      case 1: displayResults( base + 'address', '$RequesterAddress' ); break;
      case 2: displayResults( base + 'location', '$GeoLocation' ); break;
      case 3: displayResults( base + 'weather', 'WeatherData[Here,"Temperature"]' ); break;
      case 4: displayResults( base + 'version', '$Version'); break;
      case 5: displayResults( base + 'sunset', 'Sunset[]'); break;
      case 6: displayResults( base + 'stock', 'FinancialData["GE"]'); break;
      default: 
        console.log('e.itemIndex is out of bounds: ' + e.itemIndex);
    } 
  });
});

function displayResults(url, title) {
  var wait = new ui.Card({title: 'Loading...', subtitle: 'Please wait'});
  wait.show();
  ajax( { url: url, type:'json' }, 
    // success
    function(json) {
      var result = new ui.Card({ title: title, body: json.result });
      result.show();
      wait.hide();
    }, 
    // error
    function(error) {
      console.log('Error during displayResults');
      console.log(url);
      console.log(title);
    });
}