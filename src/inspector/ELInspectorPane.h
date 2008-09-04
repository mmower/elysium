//
//  ELInspectorPane.h
//  Elysium
//
//  Created by Matt Mower on 10/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELInspectorPane : NSObject {
  IBOutlet NSView *paneView;
  NSString        *label;
  NSString        *nibName;
  IBOutlet id     inspectee;
}

- (id)initWithLabel:(NSString *)label nibName:(NSString *)nibName;

@property (readonly) NSView *paneView;
@property (readonly) NSString *label;
@property (readonly) NSString *nibName;
@property id inspectee;

- (void)closeView;
- (void)viewDidLoad;
- (void)viewWillClose;

- (Class)willInspect;

- (id)narrowInspectionFocus:(id)object;
- (void)inspect:(id)focusedObject;
// - (void)updateBindings;

- (void)hideIfNecessary;
- (void)showIfNecessary;

@end
