//
//  ScriptInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELScript;

@interface ScriptInspectorController : NSWindowController {
    NSMutableAttributedString *editableSource;
    ELScript *block;
    IBOutlet NSTextView *sourceEditor;
    IBOutlet NSScrollView *scrollView;
}

@property (nonatomic, strong) ELScript *block;
@property (nonatomic, readonly,strong) NSMutableAttributedString *editableSource;

- (id)initWithBlock:(ELScript *)block;

- (IBAction)close:(id)sender;
- (IBAction)saveScript:(id)sender;
- (IBAction)cancelEditScript:(id)sender;

@end
