(function(global, $) {
  var viewContainer;
    
  function navigateTo(viewName) {
    $.ajax('/ferem-downloads/navigate-to/' + viewName)
     .done(function(response) {
       viewContainer.html(response);   
     });  
  }
    
  function init() {
    viewContainer = $('#view-container');
    navigateTo('request-download');  
  }
    
  $(init);
})(this, (this.jQuery || this));

