//
//  ELBlock.m
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "RubyBlock.h"

#import "MacRuby+Helper.h"

#import "ScriptInspectorController.h"

@implementation RubyBlock

- (id)initWithSource:(NSString *)_source_ {
  if( ( self = [super init] ) ) {
    [self setSource:_source_];
    NSLog( @"Block initialize with: %@", _source_ );
  }
  
  return self;
}

- (NSString *)source {
  return source;
}

- (NSString *)description {
  return source;
}

//
//
- (void)setSource:(NSString *)_source_ {
  source = _source_;
  NSString *procSource = [NSString stringWithFormat:@"proc %@", source];
  NSLog( @"proc source:\n%@", procSource );
  
  proc = [[MacRuby sharedRuntime] evaluateString:procSource];
}

- (id)eval {
  return [[MacRuby sharedRuntime] evalProc:proc];
}

- (id)evalWithArg:(id)_arg_ {
  return [[MacRuby sharedRuntime] evalProc:proc arg:_arg_];
}

- (id)evalWithArg:(id)_arg1_ arg:(id)_arg2_ {
  return [[MacRuby sharedRuntime] evalProc:proc arg:_arg1_ arg:_arg2_];
}

- (void)inspect {
  [[[ScriptInspectorController alloc] initWithBlock:self] showWindow:self];
}

@end
