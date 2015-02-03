(function(global, $) {
    
  function make(viewContainer, viewURL) {
    var presenter = $.frmdls.presenters.base.make(viewContainer, viewURL),
        widgets;
        
    function eMailChanged(event) {
      global.console.log('eMailChanged');  
    }
    
    function onRequestDownloadClicked(event) {
      var data = {'e-mail-address': 'perry@deinc.evil'};
      
      global.console.log('onRequestDownloadClicked');
      
      $.post('/ferem-downloads/action/request-download', data)
       .done(function(response) { 
         global.alert(JSON.stringify(response)); 
       })
       .fail(function(response) { 
         global.alert('FAILED!'); 
       });
    }
    
    presenter.attachTo = function(viewContainer) {
      if (!widgets) {
        widgets = {
          view: $('#frmdls-request-download-view'),
          eMailInput: $('#frmdls-e-mail-input'),
          requestDownloadButton: $('#frmdls-request-download-button'),
          storeEMailCheckbox: $('#frmdls-store-e-mail-checkbox')
        };
        widgets.eMailInput.on('change', eMailChanged);
        widgets.requestDownloadButton.click(onRequestDownloadClicked);
      }
    };
    presenter.detachFrom = function(viewContainer) {
      if (widgets) {
        widgets.eMailInput.off('change');
        widgets.requestDownloadButton.off('click');
        widgets = undefined;
      }
    };
    
    return presenter;
  }
    
  $.fm.core.ns('frmdls.presenters.request-download').make = make;
})(this, (this.jQuery || this));

