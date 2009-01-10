//
//  ELBlock.m
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "RubyBlock.h"

#import "ScriptInspectorController.h"

static BOOL initialized = NO;
static SEL callSelector;

@implementation RubyBlock

+ (void)initialize {
  if( !initialized ) {
    callSelector = @selector(call:);
    initialized = YES;
  }
}

- (void)compileSource {
  proc = [[MacRuby sharedRuntime] evaluateString:[NSString stringWithFormat:@"proc %@", [self source]]];
}

- (id)eval {
  return [proc performRubySelector:callSelector];
}

- (id)evalWithArg:(id)_arg_ {
  return [proc performRubySelector:callSelector withArguments:_arg_,nil];
}

- (id)evalWithArg:(id)_arg1_ arg:(id)_arg2_ {
  return [proc performRubySelector:callSelector withArguments:_arg1_,_arg2_,nil];
}

- (id)evalWithArg:(id)_arg1_ arg:(id)_arg2_ arg:(id)_arg3_ {
  return [proc performRubySelector:callSelector withArguments:_arg1_,_arg2_,_arg3_,nil];
}

@end
