//
//  ELInspectorViewController.h
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELInspectorController;

@interface ELInspectorViewController : NSViewController {
  ELInspectorController *inspectorController;
  NSObjectController    *objectController;
}

@property (assign)    ELInspectorController *inspectorController;
@property (assign)    NSObjectController    *objectController;

- (id)initWithInspectorController:(ELInspectorController *)controller nibName:(NSString *)nibName target:(id)target path:(NSString *)path;

- (void)bindControl:(NSString *)dialName;
- (void)bindMode:(NSString *)dialName;
- (void)bindOsc:(NSString *)dialName;
- (void)bindScript:(NSString *)scriptName;

@end
