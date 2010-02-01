//
//  ELScript.h
//  Elysium
//
//  Created by Matt Mower on 10/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ScriptInspectorController;
@class ELScriptEngine;

@interface ELScript : NSObject <NSMutableCopying> {
  NSString                  *source;
  ELScriptEngine            *_scriptEngine;
  ScriptInspectorController *inspector;
}

- (id)initWithSource:(NSString *)source scriptEngine:(ELScriptEngine *)scriptEngine;

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
