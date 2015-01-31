(function(global, $) {
  var widgets,
      navigation,
      presenters;
 
  function acquireWidgets() {
    return {
      welcomeButton: $('#frmdls-welcome-button'),
      downloadButton: $('#frmdls-download-button'),
      unsubscribeButton: $('#frmdls-unsubscribe-button'),
      installationButton: $('#frmdls-installation-button')
    };
  }
  
  function makeNavigation() {
    var navigation = $.frmdls.navigation.make(),
        activePresenter;
    
    navigation.onLocationChanged = function(location) {      
      var hash = location.hash,
          args = location.args,
          presenterForLocation = presenters[hash];
      
      global.console.log('Location changed to: ' + location);

      if (activePresenter !== presenterForLocation) {
        if (activePresenter) {
          global.console.log('Deactivate active presenter.');        
          activePresenter.deactivate();
        }
        
        activePresenter = presenterForLocation;  
      }
      
      if (activePresenter) {
        global.console.log('Activate presenter for view: ' + hash);
        activePresenter.activate(args);  
      } else {
        global.console.log('No presenter found for view: ' + hash);
      }
    };
    
    return navigation;
  }
  
  function makePresenter(viewName) {
    var viewURL = '/ferem-downloads/view/' + viewName,
        presenterNamespace = $.frmdls.presenters.base,
        makePresenter = presenterNamespace.make;
    
    presenterNamespace = ($.frmdls.presenters[viewName] || presenterNamespace)     
    makePresenter = (presenterNamespace.make || makePresenter);
        
    return makePresenter('frmdls-view-container', viewURL);
  }
  
  function makePresenters() {
    return {
      'welcome': makePresenter('welcome'),
      'request-download': makePresenter('request-download'),
      'perform-download': makePresenter('perform-download'),
      'unsubscribe': makePresenter('unsubscribe'),
      'installation': makePresenter('installation')      
    };
  }
  
  function navigationAction(location) {
    return navigation.navigateTo.bind(navigation, location);    
  }

  function installListeners() {
    widgets.welcomeButton.click(navigationAction('welcome'));
    widgets.downloadButton.click(navigationAction('request-download'));
    widgets.unsubscribeButton.click(navigationAction('unsubscribe'));
    widgets.installationButton.click(navigationAction('installation'));
    navigation.attachTo(global);
  }
    
  function init() {
    widgets = acquireWidgets();
    navigation = makeNavigation();
    presenters = makePresenters();
    installListeners();  
  }
    
  $(init);
})(this, (this.jQuery || this));

