//
//  ScriptInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RubyBlock;

@interface ScriptInspectorController : NSWindowController {
  NSString              *editableSource;
  RubyBlock             *block;
  IBOutlet NSTextView   *sourceEditor;
}

@property RubyBlock *block;
@property (copy,readwrite) NSString *editableSource;

- (id)initWithBlock:(RubyBlock *)block;

- (IBAction)saveScript:(id)sender;
- (IBAction)cancelEditScript:(id)sender;

@end
