//
//  ScriptInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ScriptInspectorController.h"

#import "RubyBlock.h"

@implementation ScriptInspectorController

@synthesize block;
@synthesize editableSource;

- (id)initWithBlock:(RubyBlock *)_block_ {
  if( ( self = [super initWithWindowNibName:@"ScriptInspector"] ) ) {
    [self setBlock:_block_];
    NSLog( @"Source = %@", block );
    [self setEditableSource:[_block_ source]];
  }
  
  return self;
}

- (void)awakeFromNib {
  [sourceEditor setFont:[NSFont fontWithName:@"Monaco" size:9.0]];
}

- (IBAction)saveScript:(id)sender {
  [[self window] performClose:self];
  [block setSource:editableSource];
}

- (IBAction)cancelEditScript:(id)sender {
  [[self window] performClose:self];
}

@end
