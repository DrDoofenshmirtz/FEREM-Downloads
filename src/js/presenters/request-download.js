(function(global, $) {
  var eMailRegex = /^.*\S+@\S+.*$/;
    
  function make(viewContainer, viewURL) {
    var presenter = $.frmdls.presenters.base.make(viewContainer, viewURL),
        widgets;
        
    function getEMailAddress() {
      var eMailAddress = (widgets.eMailInput.val() || '').toString().trim(),
          matches = eMailAddress.match(eMailRegex);
          
      if (!matches || (matches.length !== 1)) {
        return undefined;
      }
      
      return eMailAddress;
    }
    
    function getStoreEMail() {
      return !!widgets.storeEMailCheckbox.is(':checked');
    }
        
    function eMailChanged() {
      var eMailAddressIsValid = !!getEMailAddress();
    
      if (eMailAddressIsValid) {
        widgets.eMailGroup.removeClass('has-error');
        widgets.requestDownloadButton.prop('disabled', false);
      } else {
        widgets.eMailGroup.addClass('has-error');
        widgets.requestDownloadButton.prop('disabled', true);
      }
    }
    
    function onRequestDownloadClicked(event) {      
      var eMailAddress = getEMailAddress(),
          storeEMail,
          data;
      
      if (!eMailAddress) {
        return;
      }
      
      storeEMail = getStoreEMail();
      data = {'e-mail-address': eMailAddress, 'store-e-mail?': storeEMail};
      $.ajax({
        type: 'POST',    
        url: '/ferem-downloads/action/request-download', 
        data: JSON.stringify(data),
        contentType: 'text/plain; charset=utf-8' 
      }).done(function(response) {
        $.frmdls.mboxes.show(
          widgets.messageBox, 
          {
            title: 'Thank you!',
            messageType: $.frmdls.mboxes.messageType.INFO, 
            content: JSON.stringify(response)
          }
        ); 
      }).fail(function(response) { 
        $.frmdls.mboxes.show(
          widgets.messageBox, 
          {
            title: 'Sorry, something went wrong...',
            messageType: $.frmdls.mboxes.messageType.ERROR, 
            content: JSON.stringify(response)
          }
        ); 
      });
    }
    
    presenter.attachTo = function(viewContainer) {
      if (!widgets) {
        widgets = {
          view: $('#frmdls-request-download-view'),
          eMailGroup: $('#frmdls-e-mail-group'),
          eMailInput: $('#frmdls-e-mail-input'),
          requestDownloadButton: $('#frmdls-request-download-button'),
          storeEMailCheckbox: $('#frmdls-store-e-mail-checkbox'),
          messageBox: $('#frmdls-message-box')          
        };
        widgets.eMailInput.on('input', eMailChanged);
        widgets.requestDownloadButton.click(onRequestDownloadClicked);
        eMailChanged();
      }
    };
    presenter.detachFrom = function(viewContainer) {
      if (widgets) {
        widgets.eMailInput.off('input');
        widgets.requestDownloadButton.off('click');
        widgets = undefined;
      }
    };
    
    return presenter;
  }
    
  $.fm.core.ns('frmdls.presenters.request-download').make = make;
})(this, (this.jQuery || this));

