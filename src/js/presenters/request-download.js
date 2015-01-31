(function(global, $) {
    
  function make(model) {
    var widgets;
    
    function onRequestDownloadClicked(event) {
      global.alert('*FU!*');  
    }
    
    function attach() {
      if (!widgets) {
        widgets = {
          view: $('#frmdls-request-download-view'),
          eMailInput: $('#frmdls-e-mail-input'),
          requestDownloadButton: $('#frmdls-request-download-button'),
          storeEMailCheckbox: $('#frmdls-store-e-mail-checkbox')
        };
        widgets.requestDownloadButton.click(onRequestDownloadClicked);
      }
    }
    
    function detach() {
      if (widgets) {
        widgets.requestDownloadButton.off('click');
        widgets = undefined;
      }
    }
    
    return {
      attach: attach,
      detach: detach
    };
  }
    
  $.fm.core.ns('frmdls.controllers.requestDownload').make = make;
})(this, (this.jQuery || this));

