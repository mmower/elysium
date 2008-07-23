//
//  ELLayerView.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELLayerView.h"

#import "ELRegularPolygon.h"

#define HEX_RADIUS 25.0
#define HEX_OFFSET 37.5

@implementation ELLayerView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
  NSRect bounds = [self bounds];
  
  [[NSColor redColor] set];
  [NSBezierPath fillRect:bounds];
  
  [[NSColor whiteColor] set];
  
  CGFloat hexDiameter = 2 * sqrt( 0.75 * pow( HEX_RADIUS, 2 ) );
  NSLog( @"Hex diameter = %f", hexDiameter );
  
  NSBezierPath *hexGrid = [NSBezierPath bezierPath];
  NSPoint hexCentre;
  for( int cols = 0; cols < HTABLE_COLS; cols++ ) {
    for( int rows = 0; rows < HTABLE_ROWS; rows ++ ) {
      hexCentre = NSMakePoint(
                    HEX_OFFSET + (cols * ( (3 * HEX_RADIUS ) / 2 ) ),
                    HEX_OFFSET + (rows * hexDiameter) + ( cols % 2 == 0 ? (hexDiameter / 2) : 0 )
                    );
      [hexGrid appendHexagonWithCentre:hexCentre radius:HEX_RADIUS];
    }
  }
  
  // [hexGrid setLineWidth:3.0];
  [hexGrid stroke];
  
}

@end
