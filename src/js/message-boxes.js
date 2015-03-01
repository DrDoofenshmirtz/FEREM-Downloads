(function(global, $) {
  var messageType = {
        INFO: 'INFO',
        WARNING: 'WARNING',
        ERROR: 'ERROR'
      },
      defaultOptions = {
        messageType: messageType.INFO,
        title: 'Message',
        content: '...?',
        buttonLabel: 'Close'
      };
      
  function show(boxElement, options) {
    var widgets;
    
    if (!boxElement) {
      throw new Error('A valid box element must be specified!');  
    }
    
    options = $.extend(defaultOptions, options || {});
    widgets = {
      titleContainer: boxElement.find('.modal-title'),
      contentContainer: boxElement.find('.modal-body'),
      closeButton: boxElement.find('.modal-footer.btn')
    };
    
    widgets.titleContainer.text(options.title);
    widgets.contentContainer.text(options.content);
    widgets.closeButton.text(options.buttonLabel);
    boxElement.modal('show');
  }
      
  $.fm.core.ns('frmdls.mboxes').messageType = messageType;  
  $.fm.core.ns('frmdls.mboxes').show = show;    
})(this, (this.jQuery || this));

