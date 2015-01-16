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

@property  (nonatomic,assign)     ELInspectorController *inspectorController;
@property  (nonatomic,assign)     NSObjectController    *objectController;

- (id)initWithInspectorController:(ELInspectorController *)controller nibName:(NSString *)nibName target:(id)target path:(NSString *)path;

- (void)bindDial:(NSString *)dialName;
- (void)bindDial:(NSString *)dialName hasOscillator:(BOOL)hasOscillator;
- (void)bindControl:(NSString *)dialName;
- (void)bindMode:(NSString *)dialName;
- (void)bindOsc:(NSString *)dialName;
- (void)bindScript:(NSString *)scriptName;

@end
