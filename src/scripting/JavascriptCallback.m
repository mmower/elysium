//
//  JavascriptCallback.m
//  Elysium
//
//  Created by Matt Mower on 09/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "JavascriptCallback.h"

#import "ScriptInspectorController.h"

@implementation JavascriptCallback

- (void)compileSource {
  JSValueRefAndContextRef fdef = [[JSCocoa sharedController] evalJSString:[NSString stringWithFormat:@"var f = %@; f;",[self source]]];
  ctx = fdef.ctx;
  function = JSValueToObject( ctx, fdef.value, NULL );
  JSValueProtect( ctx, function );
}


- (id)eval {
  return [self evalWithArgs:[NSArray array]];
}

- (id)evalWithArg:(id)_arg_ {
  return [self evalWithArgs:[NSArray arrayWithObject:_arg_]];
}

- (id)evalWithArg:(id)_arg1_ arg:(id)_arg2_ {
  return [self evalWithArgs:[NSArray arrayWithObjects:_arg1_,_arg2_,nil]];
}

- (id)evalWithArg:(id)_arg1_ arg:(id)_arg2_ arg:(id)_arg3_ {
  return [self evalWithArgs:[NSArray arrayWithObjects:_arg1_,_arg2_,_arg3_,nil]];
}

- (id)evalWithArgs:(NSArray *)_args_ {
  JSValueRef rval;
  rval = [[JSCocoa sharedController] callJSFunction:function withArguments:_args_];
  
  id obj;
  [JSCocoaFFIArgument unboxJSValueRef:rval toObject:&obj inContext:ctx];
  
  return obj;
}



@end
