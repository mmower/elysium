//
//  ELKnobView.m
//  Elysium
//
//  Created by Matt Mower on 22/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELKnobView.h"

@implementation ELKnobView

- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    subviewController = [[NSViewController alloc] initWithNibName:@"KnobView" bundle:nil];
    
    
      // Initialization code here.
  }
  return self;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
}

@end
