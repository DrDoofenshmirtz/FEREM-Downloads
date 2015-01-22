(function(global, $) {
  var model,
      widgets,
      navigation;
 
  function acquireWidgets() {
    return {
      viewContainer: $('#frmdls-view-container'),
      welcomeButton: $('#frmdls-welcome-button'),
      downloadButton: $('#frmdls-download-button'),
      unsubscribeButton: $('#frmdls-unsubscribe-button'),
      installationButton: $('#frmdls-installation-button')
    };
  }
  
  function navigationAction(location) {
    return navigation.navigateTo.bind(navigation, location);    
  }
  
  function onModelChange(events, model) {
    global.console.log('Bang!');
  }
  
  function installListeners() {
    model.addListener(onModelChange);
    widgets.welcomeButton.click(navigationAction('welcome'));
    widgets.downloadButton.click(navigationAction('download'));
    widgets.unsubscribeButton.click(navigationAction('unsubscribe'));
    widgets.installationButton.click(navigationAction('installation'));
    navigation.attachTo(global);
  }
    
  function init() {
    model = $.fm.model.makeModel();
    widgets = acquireWidgets();
    navigation = $.frmdls.navigation.make(model);
    installListeners();  
  }
    
  $(init);
})(this, (this.jQuery || this));

