//
//  ScriptInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELBlock;

@interface ScriptInspectorController : NSWindowController {
  NSString  *editableSource;
  ELBlock   *block;
}

@property ELBlock *block;
@property (copy,readwrite) NSString *editableSource;

- (id)initWithBlock:(ELBlock *)block;

- (IBAction)saveScript:(id)sender;
- (IBAction)cancelEditScript:(id)sender;

@end
