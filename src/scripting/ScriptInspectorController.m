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
    editableSource = [[NSMutableAttributedString alloc] initWithString:[_block_ source]];
  }
  
  return self;
}

- (void)awakeFromNib {
  NSFont *scriptFont = [NSFont fontWithName:@"Monaco" size:10.0];
  
  [sourceEditor setFont:scriptFont];
  
  NSDictionary *sizeAttribute = [[NSDictionary alloc] initWithObjectsAndKeys:scriptFont, NSFontAttributeName, nil];
  CGFloat tabSize = [@"  " sizeWithAttributes:sizeAttribute].width;
  
  NSMutableParagraphStyle *style = [[sourceEditor defaultParagraphStyle] mutableCopy];
  NSArray *array = [style tabStops];
  for( id item in array ) {
    [style removeTabStop:item];
  }
  [style setDefaultTabInterval:tabSize];
  // [sourceEditor setDefaultParagraphStyle:style];
  // NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:style, NSParagraphStyleAttributeName, nil];
  // [sourceEditor setTypingAttributes:attributes];
}

- (IBAction)close:(id)_sender_ {
  [[self window] performClose:self];
}

- (IBAction)saveScript:(id)_sender_ {
  [block setSource:[editableSource string]];
  [block closeInspector:_sender_];
}

- (IBAction)cancelEditScript:(id)_sender_ {
  [block closeInspector:_sender_];
}

@end
