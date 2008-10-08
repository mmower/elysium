//
//  ScriptInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ScriptInspectorController.h"

#import "ELBlock.h"

@implementation ScriptInspectorController

@synthesize block;
@synthesize editableSource;

- (id)initWithBlock:(ELBlock *)_block_ {
  if( ( self = [super initWithWindowNibName:@"ScriptInspector"] ) ) {
    [self setBlock:_block_];
    NSLog( @"Source = %@", block );
    [self setEditableSource:[_block_ source]];
  }
  
  return self;
}

- (IBAction)saveScript:(id)sender {
  [[self window] performClose:self];
  [block setSource:editableSource];
}

- (IBAction)cancelEditScript:(id)sender {
  [[self window] performClose:self];
}

@end
