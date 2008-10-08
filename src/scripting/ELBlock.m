//
//  ELBlock.m
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELBlock.h"

#import "ScriptInspectorController.h"

static BOOL macRubyInitialized = NO;
static ID internedCall;

@implementation ELBlock

+ (void)initialize {
  if( !macRubyInitialized ) {
    int argc = 0;
    char **argv = NULL;
    ruby_sysinit(&argc, &argv);
    RUBY_INIT_STACK;
    ruby_init();
    internedCall = rb_intern("call");
    macRubyInitialized = YES;
  }
}

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
  proc = (id)rb_eval_string( [[NSString stringWithFormat:@"proc %@", _source_] cStringUsingEncoding:NSASCIIStringEncoding] );
}

- (id)eval {
  return (id)rb_funcall( (VALUE)proc, internedCall, 0 );
}

- (id)evalWithArg:(id)_arg_ {
  return (id)rb_funcall( (VALUE)proc, internedCall, 1, _arg_ );
}

- (id)evalWithArg:(id)_arg1_ arg:(id)_arg2_ {
  return (id)rb_funcall( (VALUE)proc, internedCall, 2, _arg1_, _arg2_ );
}

- (id)evalWithArg:(id)_arg1_ arg:(id)_arg2_ arg:(id)_arg3_ {
  return (id)rb_funcall( (VALUE)proc, internedCall, 3, _arg1_, _arg2_, _arg3_ );
}

- (void)inspect {
  NSLog( @"Inspecting block: %@", self );
  [[[ScriptInspectorController alloc] initWithBlock:self] showWindow:self];
}

@end
