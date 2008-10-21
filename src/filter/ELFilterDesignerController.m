//
//  ELFilterDesignerController.m
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELFilterDesignerController.h"

#import "ELKnob.h"

@implementation ELFilterDesignerController

- (id)initWithKnob:(ELKnob *)_knob_ {
  if( ( self = [self initWithWindowNibName:@"FilterDesigner"] ) ) {
    knob = _knob_;
  }
  
  return self;
}

@synthesize knob;

@end
