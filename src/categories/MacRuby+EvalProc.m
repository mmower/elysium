//
//  MacRuby+Helper.m
//  Elysium
//
//  Created by Matt Mower on 08/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "MacRuby+EvalProc.h"

@implementation MacRuby (MacRuby_EvalProc)

// - (ID)intern:(NSString *)symbol {
//   return rb_intern( [symbol UTF8String] );
// }

static VALUE rescueEvalProc( VALUE unused ) {
  VALUE ex, ex_name, ex_message, ex_backtrace;
  NSException *ocex;
  static ID name_id = 0;
  static ID message_id = 0;
  static ID backtrace_id = 0;
  
  if (name_id == 0) {
    name_id = rb_intern("name");
    message_id = rb_intern("message");
    backtrace_id = rb_intern("backtrace");
  }
  
  ex = rb_errinfo();
  ex_name = rb_funcall(CLASS_OF(ex), name_id, 0);
  ex_message = rb_funcall(ex, message_id, 0);
  ex_backtrace = rb_funcall(ex, backtrace_id, 0);
  
  ocex = [NSException exceptionWithName:(id)ex_name
                                 reason:(id)ex_message
                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:(id)ex, @"object",(id)ex_backtrace, @"backtrace",NULL]];
                               
  [ocex raise];
  
  return Qnil;
}

static VALUE evalProc( VALUE args ) {
  static ID call = 0;
  if( call == 0 ) {
    call = rb_intern( "call" );
  }
  
  struct eval_proc_call *epc = (struct eval_proc_call *)args;
  NSLog( @"proc = %@", (id)epc->proc );
  for( int i = 0; i < epc->argc; i++ ) {
    NSLog( @"arg<%d> = %@", i, (id)epc->argv[i] );
  }
  
  return rb_funcall2( epc->proc, call, epc->argc, epc->argv );
}

static inline id callEvalProc( struct eval_proc_call *epc )
{
  return RB2OC( rb_rescue2( evalProc, (VALUE)epc, rescueEvalProc, Qnil, rb_eException, (VALUE)0 ) );
}

- (id)evalProc:(id)proc {
  struct eval_proc_call epc;
  epc.proc = (VALUE)proc;
  epc.argc = 0;
  return callEvalProc( &epc );
}

- (id)evalProc:(id)proc arg:(id)arg {
  struct eval_proc_call epc;
  epc.proc = (VALUE)proc;
  epc.argc = 1;
  
  VALUE args[2] = { (VALUE)arg, (VALUE)NULL };
  epc.argv = args;
  return callEvalProc( &epc );
}

- (id)evalProc:(id)proc arg:(id)arg1 arg:(id)arg2 {
  struct eval_proc_call epc;
  epc.proc = (VALUE)proc;
  epc.argc = 2;
  
  VALUE args[3] = { (VALUE)arg1, (VALUE)arg2, (VALUE)NULL };
  epc.argv = args;
  return callEvalProc( &epc );
}

@end
