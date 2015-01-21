(function(global, $) {
  var locations = [
        'welcome',
        'download',
        'unsubscribe',
        'installation',
        'error'
      ],
      locationRegex = /.+\/ferem-downloads\/?#!(.+)$/,
      failureContent = String( 
        '<div class="container-fluid">' +
          '<div class="row">' +
            '<div class="col-md-12">' +
              '<h4>Something went wrong.</h4>' +
              '<p>' +
                'Please excuse.' +                                   
              '</p>' +
            '</div>' +
          '</div>' +
        '</div>');
  
  function urlToLocation(url) {
    var matches = url.match(locationRegex),
        location = 'welcome';
    
    if (matches && (matches.length > 1) && locations.indexOf(matches[1]) >= 0) {
      location = matches[1];  
    }
    
    return location;
  }
  
  function makeNavigation(model) {
    var attachedTo,
        currentLocation;
    
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
    
    function locationChanged(location, content) {
      currentLocation = location;
      attachedTo.location.hash = '!' + location;
      model.set({location: location, content: content});
    }
    
    function navigateTo(location) {
      if ((location != currentLocation) && (locations.indexOf(location) >= 0)) {
        $.ajax('/ferem-downloads/navigate-to/' + location)
         .done(function(response) { locationChanged(location, response); })
         .fail(function() { locationChanged('error', failureContent); });          
      } 
    }
    
    return {
      attachTo: attachTo,
      detach: detach,
      navigateTo: navigateTo
    };
  }
  
  $.fm.core.ns('frmdls.navigation').make = makeNavigation;
})(this, (this.jQuery || this));

