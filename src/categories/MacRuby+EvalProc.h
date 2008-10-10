//
//  MacRuby+Helper.h
//  Elysium
//
//  Created by Matt Mower on 08/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

struct eval_proc_call
{
  VALUE proc;
  int   argc;
  VALUE *argv;
};

@interface MacRuby (MacRuby_EvalProc)

// - (ID)intern:(NSString *)symbol;

- (id)evalProc:(id)proc;
- (id)evalProc:(id)proc arg:(id)arg;
- (id)evalProc:(id)proc arg:(id)arg arg:(id)arg;

@end
