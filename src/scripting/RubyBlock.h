//
//  ELBlock.h
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

@class ScriptInspectorController;

@interface RubyBlock : NSObject <NSMutableCopying> {
  NSString                  *source;
  id                        proc;
  ScriptInspectorController *inspector;
}

- (id)initWithSource:(NSString *)source;

- (NSString *)source;
- (void)setSource:(NSString *)source;

- (id)eval;
- (id)evalWithArg:(id)arg;
- (id)evalWithArg:(id)arg1 arg:(id)arg2;
- (id)evalWithArg:(id)arg1 arg:(id)arg2 arg:(id)arg3;

- (IBAction)closeInspector:(id)sender;
- (IBAction)inspect:(id)sender;

@end
