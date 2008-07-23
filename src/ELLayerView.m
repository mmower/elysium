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
  NSLog( @"Width = %f", bounds.size.width );
  CGFloat radius = bounds.size.width / 27;
  NSLog( @"Hex Radius = %f", radius );
  CGFloat offset = ( 3 * radius ) / 2;
  NSLog( @"Offset = %f", offset );
    
  [[NSColor redColor] set];
  [NSBezierPath fillRect:bounds];
  
  [[NSColor whiteColor] set];
  
  CGFloat hexDiameter = 2 * sqrt( 0.75 * pow( radius, 2 ) );
  NSLog( @"Hex diameter = %f", hexDiameter );
  
  NSBezierPath *hexGrid = [NSBezierPath bezierPath];
  NSPoint hexCentre;
  for( int cols = 0; cols < HTABLE_COLS; cols++ ) {
    for( int rows = 0; rows < HTABLE_ROWS; rows ++ ) {
      hexCentre = NSMakePoint(
                    offset + (cols * ( (3 * radius ) / 2 ) ),
                    offset + (rows * hexDiameter) + ( cols % 2 == 0 ? (hexDiameter / 2) : 0 )
                    );
      [hexGrid appendHexagonWithCentre:hexCentre radius:radius];
    }
  }
  
  // [hexGrid setLineWidth:3.0];
  [hexGrid stroke];
  
}

@end
