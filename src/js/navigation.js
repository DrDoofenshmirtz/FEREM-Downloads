(function(global, $) {
  var hashRegex = /.+\/ferem-downloads\/?#!(.+)$/,
      hashes = [
        'welcome',
        'request-download',
        'perform-download',
        'unsubscribe',
        'installation'
      ],
      defaultLocation = makeLocation('welcome');
  
  function makeLocation(hash, args) {
    var location = {
          hash: hash,
          args: (args || {})
        },
        locationString = JSON.stringify(location);
    
    location.toString = function() {
      return locationString;
    };
        
    return location;
  }
            
  function parseArgs(argsString) {
    var nameValueStrings = argsString.split(/\s*\:\s*/),
        args = {};
    
    nameValueStrings.forEach(function (nameValueString) {
      var nameAndValue = nameValueString.split(/\s*=\s*/),
          name,
          value;

      if (nameAndValue.length === 2) {
        name = nameAndValue[0].trim();
        
        if (name.length > 0) {
          value = nameAndValue[1].trim();
          
          if (value.length > 0) {
            args[name] = value;
          }
        }        
      }
    });

    return args;
  }
    
  function parseLocation(hashAndArgsString) {
    var separatorIndex,
        hash,
        args;
        
    hashAndArgsString = (hashAndArgsString || '').toString();    
    separatorIndex = hashAndArgsString.indexOf(':');
    
    if (separatorIndex > 0) {
      hash = hashAndArgsString.substring(0, separatorIndex);
      
      if (hashes.indexOf(hash) >= 0) {
        args = parseArgs(hashAndArgsString.substring(separatorIndex + 1));
        
        return makeLocation(hash, args);  
      }       
    } else {
      hash = hashAndArgsString;
      
      if (hashes.indexOf(hash) >= 0) {
        return makeLocation(hash);   
      }
    }  
    
    return defaultLocation;  
  }
    
  function extractHashAndArgsFrom(url) {
    var matches = url.match(hashRegex);
    
    if (matches && (matches.length > 1)) {
      return matches[1];  
    }
    
    return undefined;  
  }
  
  function make() {
    var attachedTo,
        currentLocation,
        navigation = {
          onLocationChanged: function(location) {
            global.console.log('onLocationChanged: ' + location);
          }
        };
            
    function navigateToURL(url) {
      navigateTo(extractHashAndArgsFrom(url));
    }
        
    function onHashChange(event) {
      navigateToURL(event.newURL);
    }
    
    function attachTo(emitter) {
      if (!attachedTo) {
        attachedTo = emitter;
        attachedTo.addEventListener('hashchange', onHashChange);
        navigateToURL(attachedTo.location.toString());
      }
    }
    
    function detach() {
      if (attachedTo) {
        attachedTo.removeEventListener('hashchange', onHashChange);
        attachedTo = undefined;
      }
    }
        
    function navigateTo(hashAndArgsString) {
      var location = parseLocation(hashAndArgsString);
      
      if (hashes.indexOf(location.hash) >= 0) {
        attachedTo.location.hash = '!' + hashAndArgsString;
        navigation.onLocationChanged(location);                          
      } 
    }
        
    navigation.attachTo = attachTo;
    navigation.detach = detach;
    navigation.navigateTo = navigateTo;
    
    return navigation;
  }
  
  $.fm.core.ns('frmdls.navigation').make = make;
})(this, (this.jQuery || this));

