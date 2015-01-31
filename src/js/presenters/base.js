(function(global, $) {
  var failureContent = String( 
        '<div id="frmdls-error-view" class="container-fluid">' +
          '<div class="row">' +
            '<div class="col-md-12">' +
              '<h4>Something went wrong.</h4>' +
              '<p>' +
                'Please excuse.' +                                   
              '</p>' +
            '</div>' +
          '</div>' +
        '</div>');
          
  function make(viewContainerId, viewURL) {
    var viewContainer = $('#' + viewContainerId),
        activated = false,
        loading = false,
        ready = false,
        presenter = {
          onActivated: function() {
            global.console.log('onActivated: ' + viewURL);
          },
          onDeactivated: function() {
            global.console.log('onDeactivated: ' + viewURL);
          }
        };
    
    function viewLoaded(response) {
      loading = false;
      
      if (activated) {
        viewContainer.html(response);
        ready = true;
        presenter.onActivated();
      }      
    }
    
    function failedToLoadView(response) {
      loading = false;
      
      if (activated) {
        viewContainer.html(failureContent);
      }      
    }
    
    function loadView() {
      if (!loading) {
        loading = true;
        $.ajax(viewURL)
         .done(function(response) { viewLoaded(response); })
         .fail(function(response) { failedToLoadView(response); });
      }
    }

    function activate() {
      activated = true;
      
      if (!ready) {
        loadView();
      }
    }
    
    function deactivate() {
      if (activated) {
        activated = false;
        ready = false;
        presenter.onDeactivated();
      }
    }
    
    presenter.activate = activate;
    presenter.deactivate = deactivate;
    
    return presenter;
  }
    
  $.fm.core.ns('frmdls.presenters.base').make = make;
})(this, (this.jQuery || this));

