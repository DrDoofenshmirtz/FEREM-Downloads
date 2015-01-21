(function(global, $) {
  var constants = Object.create(null),
      makeTransaction,
      makeChangeEvent,
      makeChange,
      makeModel,
      isChangeEvent; 
  
  constants.CHANGE_EVENT_TYPE = 'fm.model.attributesChanged';    
      
  makeTransaction = function(attributes, methods) {
    var transaction = Object.create(null);
    
    transaction.changes = Object.create(null);
    transaction.events = [];
    transaction.context = Object.create(null);
    transaction.context.get = function(name) {
      if (name) {
        return attributes[name];
      }
      
      return attributes;
    };
    transaction.context.set = function() {
      var args,
          name,
          value,
          attributes;
      
      args = Array.prototype.slice.call(arguments);
      
      if (args.length === 1) {
        attributes = args[0];
        
        for (name in attributes) {
          if (attributes.hasOwnProperty(name)) {
            transaction.changes[name] = attributes[name];
          }
        }
      } else if (args.length === 2) {
        name = args[0];
        value = args[1];
        transaction.changes[name] = value;
      }
      
      return this;
    };
    transaction.context.post = function(event) {
      if (event) {
        transaction.events.push(event);
      }
      
      return this;
    };
    
    return transaction;
  };    
      
  makeChangeEvent = function() {
    var changeEvent = Object.create(null);
    
    changeEvent.type = constants.CHANGE_EVENT_TYPE;
    changeEvent.changes = Object.create(null);
    changeEvent.toString = function() {
      var string = constants.CHANGE_EVENT_TYPE + '[';
      
      string += Object.keys(this.changes).join(', ');
      string += ']';
      
      return string;
    };
    changeEvent.valueOf = function() {
      return this;
    };
    
    return changeEvent;
  };
  
  makeChange = function(name, oldValue, newValue) {
    var change = Object.create(null);
    
    change.name = name;
    change.oldValue = oldValue;
    change.newValue = newValue;
    
    return change;
  };
  
  makeModel = function(attributes) {
    var updates = [],
        listeners = [],
        model = Object.create(null),
        applyChanges,
        applyUpdates;
 
    attributes = (attributes || Object.create(null));
    applyChanges = function(transaction) {
      var changeEvent,
          oldValue,
          newValue;

      changeEvent = makeChangeEvent();
      
      Object.keys(transaction.changes).forEach(function(name) {
        oldValue = attributes[name];
        newValue = transaction.changes[name];
        attributes[name] = newValue;
        changeEvent.changes[name] = makeChange(name, oldValue, newValue);
      });
      
      transaction.events.unshift(changeEvent);
      
      listeners.slice().forEach(function(listener) {
        listener(transaction.events.slice(), model);
      });
    };
    applyUpdates = function() {
      var transaction,
          update;
          
      if (updates.length > 0) {
        update = updates[0];
        transaction = makeTransaction(attributes);
        update(transaction.context);
        applyChanges(transaction);
        updates.shift();
        applyUpdates();
      }  
    };
    model.get = function(name) {
      if (name) {
        return attributes[name];
      }
      
      return attributes;
    };
    model.update = function(update) {
      if (updates.push(update) === 1) {
        applyUpdates();  
      }
    };
    model.set = function() {
      var args = arguments;
      
      this.update(function(context) {
        context.set.apply(context, args);            
      });
      
      return this;
    };
    model.addListener = function(listener) {
      if (listener) {
        listeners.push(listener);
      }
    };
    model.removeListener = function(listener) {
      var index;
      
      if (listener) {
        index = listeners.indexOf(listener);
        
        if (index >= 0) {
          listeners.splice(index, 1);
        }
      }
    };
    model.toString = function() {
      var string = 'fm.model.model[';
      
      string += Object.keys(attributes).join(', ');
      string += ']';
      
      return string;
    };
    model.valueOf = function() {
      return this;
    };
    
    return model;
  };
  
  isChangeEvent = function(event) {
    return (event && (constants.CHANGE_EVENT_TYPE === event.type));
  };

  $.fm.core.ns('fm.model').constants = constants;  
  $.fm.core.ns('fm.model').makeModel = makeModel;
  $.fm.core.ns('fm.model').isChangeEvent = isChangeEvent;
})(this, (this.jQuery || this));

