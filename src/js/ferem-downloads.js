(function(global, $) {
  var widgets,
      locations = [
        'welcome',
        'download',
        'unsubscribe',
        'installation',
        'error'
      ],
      locationRegex = /.+\/ferem-downloads\/?#!(.+)$/,
      currentLocation,
      failureResponse = String( 
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

  function acquireWidgets() {
    return {
      viewContainer: $('#frmdls-view-container'),
      welcomeButton: $('#frmdls-welcome-button'),
      downloadButton: $('#frmdls-download-button'),
      unsubscribeButton: $('#frmdls-unsubscribe-button'),
      installationButton: $('#frmdls-installation-button')
    };
  }
  
  function locationToHash(validLocation) {
    return '!' + validLocation;  
  }

  function navigateTo(validLocation) {
    $.ajax('/ferem-downloads/navigate-to/' + validLocation)
     .done(function(response) {
       widgets.viewContainer.html(response);
       currentLocation = validLocation;
       global.location.hash = locationToHash(validLocation);    
     })
     .fail(function() {
       widgets.viewContainer.html(failureResponse);
       currentLocation = 'error';
       global.location.hash = locationToHash('error');
     });  
  }
  
  function changeLocationTo(validLocation) {
    if (validLocation !== currentLocation) {
      navigateTo(validLocation);
    }
  }
  
  function urlToLocation(url) {
    var matches = url.match(locationRegex),
        validLocation = 'welcome';
    
    if (matches && (matches.length > 1) && locations.indexOf(matches[1]) > 0) {
      validLocation = matches[1];  
    }
    
    return validLocation;
  }
  
  function onHashChange(event) {
    changeLocationTo(urlToLocation(event.originalEvent.newURL));
  }
   
  function navigationAction(location) {
    return changeLocationTo.bind(null, location);
  }
  
  function installListeners() {
    $(global).on('hashchange', onHashChange);
    widgets.welcomeButton.click(navigationAction('welcome'));
    widgets.downloadButton.click(navigationAction('download'));
    widgets.unsubscribeButton.click(navigationAction('unsubscribe'));
    widgets.installationButton.click(navigationAction('installation'));
  }
    
  function init() {
    widgets = acquireWidgets();
    installListeners();
    changeLocationTo(urlToLocation(global.location.toString()));  
  }
    
  $(init);
})(this, (this.jQuery || this));

