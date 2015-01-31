(function(global, $) {
  var hashRegex = /.+\/ferem-downloads\/?#!(.+)$/,
      locations = [
        'welcome',
        'request-download',
        'perform-download',
        'unsubscribe',
        'installation'
      ],
      defaultLocation = 'welcome';
  
  function urlToLocation(url) {
    var matches = url.match(hashRegex),
        location = defaultLocation;
    
    if (matches && (matches.length > 1) && locations.indexOf(matches[1]) >= 0) {
      location = matches[1];  
    }
    
    return location;
  }

  function make() {
    var attachedTo,
        currentLocation,
        navigation = {
          onLocationChanged: function(location) {
            global.console.log('onLocationChanged: ' + location);
          }
        };
    
    function onHashChange(event) {
      navigateTo(urlToLocation(event.newURL));
    }
    
    function attachTo(emitter) {
      if (!attachedTo) {
        attachedTo = emitter;
        attachedTo.addEventListener('hashchange', onHashChange);
        navigateTo(urlToLocation(attachedTo.location.toString()));
      }
    }
    
    function detach() {
      if (attachedTo) {
        attachedTo.removeEventListener('hashchange', onHashChange);
        attachedTo = undefined;
      }
    }
    
    function changeLocation(location) {
      currentLocation = location;
      attachedTo.location.hash = '!' + location;
      navigation.onLocationChanged(location);
    }
    
    function navigateTo(location) {
      if (locations.indexOf(location) >= 0) {
        changeLocation(location);                   
      } 
    }
    
    navigation.attachTo = attachTo;
    navigation.detach = detach;
    navigation.navigateTo = navigateTo;
    
    return navigation;
  }
  
  $.fm.core.ns('frmdls.navigation').make = make;
})(this, (this.jQuery || this));

