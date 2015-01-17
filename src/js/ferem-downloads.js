(function(global, $) {
  var widgets,
      locations = [
        'welcome',
        'download',
        'unsubscribe',
        'installation'
      ],
      locationRegex = /.+\/ferem-downloads#!(.+)$/,
      currentLocation;

  function acquireWidgets() {
    return {
      viewContainer: $('#frmdls-view-container'),
      welcomeButton: $('#frmdls-welcome-button'),
      downloadButton: $('#frmdls-download-button'),
      unsubscribeButton: $('#frmdls-unsubscribe-button'),
      installationButton: $('#frmdls-installation-button')
    };
  }

  function navigateTo(location) {
    $.ajax('/ferem-downloads/navigate-to/' + location)
     .done(function(response) {
       widgets.viewContainer.html(response);
       currentLocation = location;
       global.location.hash = '!' + location;    
     });  
  }
  
  function changeLocationTo(location) {
    if (locations.indexOf(location) < 0) {
      location = 'welcome';
    }
    
    if (location !== currentLocation) {
      navigateTo(location);
    }
  }
  
  function onHashChange(event) {
    var url = event.originalEvent.newURL,
        matches = url.match(locationRegex);
    
    if (matches && matches.length > 1) {
      changeLocationTo(matches[1]);
    }
  }
   
  function installListeners() {
    $(global).on('hashchange', onHashChange);  
  }
    
  function init() {
    widgets = acquireWidgets();
    installListeners();
    changeLocationTo('download');  
  }
    
  $(init);
})(this, (this.jQuery || this));

