//
//  ELScript.m
//  Elysium
//
//  Created by Matt Mower on 10/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELScript.h"

#import "ELScriptEngine.h"
#import "ScriptInspectorController.h"

@implementation ELScript

- (id)initWithSource:(NSString *)_source_ scriptEngine:(ELScriptEngine *)scriptEngine {
  if( ( self = [super init] ) ) {
    _scriptEngine = scriptEngine;
    [self setSource:_source_];
  }
  
  return self;
}

- (NSString *)description {
  return source;
}

- (NSString *)source {
  return source;
}

- (void)setSource:(NSString *)_source_ {
  source = _source_;
  [self compileSource];

}

- (IBAction)inspect:(id)_sender_ {
  inspector = [[ScriptInspectorController alloc] initWithBlock:self];
  [inspector showWindow:self];
}

- (IBAction)closeInspector:(id)_sender_ {
  [inspector close:_sender_];
  inspector = nil;
}

// Implementing copying

- (id)copyWithZone:(NSZone *)_zone_ {
  return [self mutableCopyWithZone:_zone_];
}

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithSource:[self source]];
}

// Evaluation (implement in subclasses)

- (void)compileSource {
}

- (id)eval {
  return nil;
}

- (id)evalWithArg:(id)_arg_ {
  return nil;
}

- (id)evalWithArg:(id)_arg1_ arg:(id)_arg2_ {
  return nil;
}

- (id)evalWithArg:(id)_arg1_ arg:(id)_arg2_ arg:(id)_arg3_ {
  return nil;
}

@end
