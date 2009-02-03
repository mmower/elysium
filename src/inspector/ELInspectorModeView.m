//
//  ELInspectorModeView.m
//  Elysium
//
//  Created by Matt Mower on 03/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELInspectorModeView.h"

@implementation ELInspectorModeView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame mode:NSRadioModeMatrix cellClass:[NSButtonCell class] numberOfRows:1 numberOfColumns:7];
    if( self ) {
    }
    return self;
}

- (void)awakeFromNib {
  NSLog( @"Awake from Nib" );
}

// - (void)drawRect:(NSRect)rect {
//   NSLog( @"")
// }

@end
