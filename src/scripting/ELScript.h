//
//  ELScript.h
//  Elysium
//
//  Created by Matt Mower on 10/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ScriptInspectorController;

@interface ELScript : NSObject <NSMutableCopying> {
  NSString                  *source;
  ScriptInspectorController *inspector;
}

- (id)initWithSource:(NSString *)source;

- (NSString *)source;
- (void)setSource:(NSString *)source;

- (id)eval;
- (id)evalWithArg:(id)arg;
- (id)evalWithArg:(id)arg1 arg:(id)arg2;
- (id)evalWithArg:(id)arg1 arg:(id)arg2 arg:(id)arg3;

- (void)compileSource;

- (IBAction)closeInspector:(id)sender;
- (IBAction)inspect:(id)sender;

@end
