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
          
  function make(viewContainer, viewURL) {
    var activated = false,
        loading = false,
        ready = false,
        presenter = {
          attachTo: function(viewContainer) {
            global.console.log('presenter.attachTo: ' + viewURL);
          },
          detachFrom: function(viewContainer) {
            global.console.log('presenter.detachFrom: ' + viewURL);
          },
          activated: function(args) {
            var argsString = ' (args = ' + JSON.stringify(args || {}) + ')';
            
            global.console.log('presenter.activated: ' + viewURL + argsString);                        
          }
        };
    
    function viewLoaded(response, args) {
      loading = false;
      
      if (activated) {
        ready = true;
        viewContainer.html(response);
        presenter.attachTo(viewContainer);        
        presenter.activated(args);
      }      
    }
    
    function failedToLoadView(response) {
      loading = false;
      
      if (activated) {
        viewContainer.html(failureContent);
      }      
    }
    
    function loadView(args) {
      if (!loading) {
        loading = true;
        $.ajax(viewURL)
         .done(function(response) { viewLoaded(response, args); })
         .fail(function(response) { failedToLoadView(response); });
      }
    }

    function activate(args) {
      activated = true;
      
      if (!ready) {
        loadView(args);
      } else {
        presenter.activated(args);
      }
    }
    
    function deactivate() {
      if (activated) {
        activated = false;
        
        if (ready) {
          ready = false;
          presenter.detachFrom(viewContainer);
        }
      }
    }
    
    presenter.activate = activate;
    presenter.deactivate = deactivate;
    
    return presenter;
  }
    
  $.fm.core.ns('frmdls.presenters.base').make = make;
})(this, (this.jQuery || this));

