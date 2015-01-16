/*
 * jElysium 1.0
 *
 * Elysium Javascript library
 * This library heavily based upon jQuery by John Resig
 */

var __global = this;

(function() {
 var jElysium = __global.jElysium = __global.$ = function( selector ) {
   return new jElysium.fn.init( selector );
 };
 
 jElysium.fn = jElysium.prototype = {
   init: function( selector ) {
     return this.setArray( jElysium.makeArray( [1,2,3] ) )
     // return jElysium().find( selector );
   },
   
   size: function() {
     return this.length;
   },
   
   length: 0,
   
   get: function( index ) {
     if( num == undefined ) {
       return jElysium.makeArray( this )
     } else {
       return this[index];
     }
   },
   
   pushStack: function( elems ) {
     var ret = jElysium( elems );
     ret.prevObject = this;
     return ret;
   },
   
   setArray: function( elems ) {
     this.length = 0;
     Array.prototype.push.apply( this, elems );
     return this;
   },
   
   each: function( callback, args ) {
     NSLog( 'Called jFoofle.each' );
     return jElysium.each( this, callback, args );
   },
   
   end: function() {
     return this.prevObject || jElysium( [] );
   },
   
   find: function( selector ) {
     var elems = jElysium.map( this, function( elem ) {
       return jElysium.find( selector, elem );
     });
     
     if( /[^+>] [^+>]/.test( selector ) || selector.indexOf( ".." ) > -1 ) {
       return this.pushStack( jElysium.unique( elems ) );
     } else {
       return this.pushStack( elems );
     }
   }
 };
 
 jElysium.extend = jElysium.fn.extend = function() {
  // copy reference to target object
  var target = arguments[0] || {}, i = 1, length = arguments.length, deep = false, options;

  // Handle a deep copy situation
  if ( target.constructor == Boolean ) {
    deep = target;
    target = arguments[1] || {};
    // skip the boolean and the target
    i = 2;
  }

  // Handle case when target is a string or something (possible in deep copy)
  if ( typeof target != "object" && typeof target != "function" )
    target = {};

  // extend jQuery itself if only one argument is passed
  if ( length == i ) {
    target = this;
    --i;
  }

  for ( ; i < length; i++ )
    // Only deal with non-null/undefined values
    if ( (options = arguments[ i ]) != null )
      // Extend the base object
      for ( var name in options ) {
        var src = target[ name ], copy = options[ name ];

        // Prevent never-ending loop
        if ( target === copy )
          continue;

        // Recurse if we're merging object values
        if ( deep && copy && typeof copy == "object" && !copy.nodeType )
          target[ name ] = jElysium.extend( deep, 
            // Never move original objects, clone them
            src || ( copy.length != null ? [ ] : { } )
          , copy );

        // Don't bring in undefined values
        else if ( copy !== undefined )
          target[ name ] = copy;

      }

  // Return the modified object
  return target;
 };
 
 jElysium.extend( {
   find: function( selector ) {
     
     NSLog( "player = %@", __player );
     
     return [1,2,3];
     // return __player.layers;
   }
 })
 
 jElysium.extend( {
   // args is for internal usage only
  each: function( object, callback, args ) {
    var name, i = 0, length = object.length;

    if ( args ) {
      if ( length == undefined ) {
        for ( name in object )
          if ( callback.apply( object[ name ], args ) === false )
            break;
      } else
        for ( ; i < length; )
          if ( callback.apply( object[ i++ ], args ) === false )
            break;

    // A special, fast, case for the most common use of each
    } else {
      if ( length == undefined ) {
        for ( name in object )
          if ( callback.call( object[ name ], name, object[ name ] ) === false )
            break;
      } else
        for ( var value = object[0];
          i < length && callback.call( value, i, value ) !== false; value = object[++i] ){}
    }

    return object;
  },
  
  makeArray: function( array ) {
    var ret = [];

    if( array != null ){
      var i = array.length;
      //the window, strings and functions also have 'length'
      if( i == null || array.split || array.setInterval || array.call )
        ret[0] = array;
      else
        while( i )
          ret[--i] = array[i];
    }

    return ret;
  },

  inArray: function( elem, array ) {
    for ( var i = 0, length = array.length; i < length; i++ )
    // Use === because on IE, window == document
      if ( array[ i ] === elem )
        return i;

    return -1;
  },

  merge: function( first, second ) {
    // We have to loop this way because IE & Opera overwrite the length
    // expando of getElementsByTagName
    var i = 0, elem, pos = first.length;
    // Also, we need to make sure that the correct elements are being returned
    // (IE returns comment nodes in a '*' query)
    if ( jQuery.browser.msie ) {
      while ( elem = second[ i++ ] )
        if ( elem.nodeType != 8 )
          first[ pos++ ] = elem;

    } else
      while ( elem = second[ i++ ] )
        first[ pos++ ] = elem;

    return first;
  },

  unique: function( array ) {
    var ret = [], done = {};

    try {

      for ( var i = 0, length = array.length; i < length; i++ ) {
        var id = jQuery.data( array[ i ] );

        if ( !done[ id ] ) {
          done[ id ] = true;
          ret.push( array[ i ] );
        }
      }

    } catch( e ) {
      ret = array;
    }

    return ret;
  },

  grep: function( elems, callback, inv ) {
    var ret = [];

    // Go through the array, only saving the items
    // that pass the validator function
    for ( var i = 0, length = elems.length; i < length; i++ )
      if ( !inv != !callback( elems[ i ], i ) )
        ret.push( elems[ i ] );

    return ret;
  },

  map: function( elems, callback ) {
    var ret = [];

    // Go through the array, translating each of the items to their
    // new value (or values).
    for ( var i = 0, length = elems.length; i < length; i++ ) {
      var value = callback( elems[ i ], i );

      if ( value != null )
        ret[ ret.length ] = value;
    }

    return ret.concat.apply( [], ret );
  }
   
 });
 
 
})();

$( "foofle" ).each( function( elem ) {
  NSLog( 'We have a %@', elem );
});

