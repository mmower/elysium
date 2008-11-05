//
//  ELBlock.m
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
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

- (id)initWithSource:(NSString *)_source_ {
  if( ( self = [super init] ) ) {
    [self setSource:_source_];
  }
  
  return self;
}

- (NSString *)source {
  return source;
}

- (NSString *)description {
  return source;
}

- (void)setSource:(NSString *)_source_ {
  source = _source_;
  proc = [[MacRuby sharedRuntime] evaluateString:[NSString stringWithFormat:@"proc %@", source]];
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

@end
