(function(global, $) {
    
  function make(viewContainer, viewURL) {
    var presenter = $.frmdls.presenters.base.make(viewContainer, viewURL),
        widgets;
        
    function eMailChanged(event) {
      global.console.log('eMailChanged');  
    }
    
    function onRequestDownloadClicked(event) {      
      var eMailAddress = (widgets.eMailInput.val() || '').toString(),
          storeEMail = !!widgets.storeEMailCheckbox.is(':checked'),
          data = {
            'e-mail-address': eMailAddress,
            'store-e-mail?': storeEMail
          };
      
      global.console.log('onRequestDownloadClicked');
      
      $.ajax({
        type: 'POST',    
        url: '/ferem-downloads/action/request-download', 
        data: JSON.stringify(data),
        contentType: 'text/plain; charset=utf-8' 
      }).done(function(response) { 
        global.alert(JSON.stringify(response)); 
      }).fail(function(response) { 
        global.alert('>> FAILED! <<'); 
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

