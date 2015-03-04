(function(global, $) {
  var messageType = {
        INFO: 'INFO',
        WARNING: 'WARNING',
        ERROR: 'ERROR'
      },
      styles = [
        'message-box-info',
        'message-box-warning',
        'message-box-error'
      ],
      stylesByMessageType = {
        INFO: 'message-box-info',
        WARNING: 'message-box-warning',
        ERROR: 'message-box-error'
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
      messageBox: boxElement.find('.modal-content'),
      titleContainer: boxElement.find('.modal-title'),      
      contentContainer: boxElement.find('.modal-body'),
      closeButton: boxElement.find('.modal-footer.btn')
    };
    
    styles.forEach(function(style) {
      widgets.messageBox.removeClass(style);            
    });
    
    widgets.messageBox.addClass(stylesByMessageType[options.messageType]);
    widgets.titleContainer.text(options.title);
    widgets.contentContainer.text(options.content);
    widgets.closeButton.text(options.buttonLabel);
    boxElement.modal('show');
  }
      
  $.fm.core.ns('frmdls.mboxes').messageType = messageType;  
  $.fm.core.ns('frmdls.mboxes').show = show;    
})(this, (this.jQuery || this));

