//
//  JavascriptCallback.m
//  Elysium
//
//  Created by Matt Mower on 09/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "JavascriptCallback.h"

#import "ELScriptEngine.h"
#import "ScriptInspectorController.h"

@implementation JavascriptCallback

- (void)compileSource {
  JSValueRefAndContextRef fdef = [[_scriptEngine js] evalJSString:[NSString stringWithFormat:@"var f = %@; f;",[self source]]];
  ctx = fdef.ctx;
  function = JSValueToObject( ctx, fdef.value, NULL );
  JSValueProtect( ctx, function );
}


- (id)eval {
  return [self evalWithArgs:[NSArray array]];
}


- (id)evalWithArg:(id)arg {
  return [self evalWithArgs:[NSArray arrayWithObject:arg]];
}


- (id)evalWithArg:(id)arg1 arg:(id)arg2 {
  return [self evalWithArgs:[NSArray arrayWithObjects:arg1,arg2,nil]];
}


- (id)evalWithArg:(id)arg1 arg:(id)arg2 arg:(id)arg3 {
  return [self evalWithArgs:[NSArray arrayWithObjects:arg1,arg2,arg3,nil]];
}


- (id)evalWithArgs:(NSArray *)args {
  JSValueRef rval;
  rval = [[_scriptEngine js] callJSFunction:function withArguments:args];
  
  id obj;
  [JSCocoaFFIArgument unboxJSValueRef:rval toObject:&obj inContext:ctx];
  
  return obj;
}


@end
