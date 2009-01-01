//
//  ScriptInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class RubyBlock;

@interface ScriptInspectorController : NSWindowController {
  NSMutableAttributedString *editableSource;
  RubyBlock                 *block;
  IBOutlet NSTextView       *sourceEditor;
  IBOutlet NSScrollView     *scrollView;
}

@property RubyBlock *block;
@property (readonly) NSMutableAttributedString *editableSource;

- (id)initWithBlock:(RubyBlock *)block;

- (IBAction)close:(id)sender;
- (IBAction)saveScript:(id)sender;
- (IBAction)cancelEditScript:(id)sender;

@end
