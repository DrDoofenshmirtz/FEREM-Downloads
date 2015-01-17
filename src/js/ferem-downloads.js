(function(global, $) {
  var widgets;

  function acquireWidgets() {
    return {
      viewContainer: $('#frmdls-view-container'),
      welcomeButton: $('#frmdls-welcome-button'),
      downloadButton: $('#frmdls-download-button'),
      unsubscribeButton: $('#frmdls-unsubscribe-button'),
      installationButton: $('#frmdls-installation-button')
    };
  }
 
  function onHashChange(event) {
    event = event.originalEvent;
    global.console.log('onHashChange: ' + event.newURL);  
  }
 
  function installListeners() {
    $(global).on('hashchange', onHashChange);  
  }
 
  function navigateTo(viewName) {
    $.ajax('/ferem-downloads/navigate-to/' + viewName)
     .done(function(response) {
       widgets.viewContainer.html(response);
       global.location.hash = '!download';    
     });  
  }
    
  function init() {
    widgets = acquireWidgets();
    installListeners();
    navigateTo('download');  
  }
    
  $(init);
})(this, (this.jQuery || this));

