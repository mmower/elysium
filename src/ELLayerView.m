//
//  ELLayerView.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELLayerView.h"

#import "ELHexCell.h"
#import "ELRegularPolygon.h"

@implementation ELLayerView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      hexes     = [[NSMutableArray alloc] initWithCapacity:HTABLE_SIZE];
      selection = nil;
    }
    return self;
}

- (id)delegate {
  return delegate;
}

- (void)setDelegate:(id)_delegate {
  delegate = _delegate;
}

- (void)drawRect:(NSRect)rect {
  NSRect bounds = [self bounds];
  // NSLog( @"Width = %f", bounds.size.width );
  CGFloat radius = bounds.size.width / 27;
  // NSLog( @"Hex Radius = %f", radius );
  CGFloat offset = ( 3 * radius ) / 2;
  // NSLog( @"Offset = %f", offset );
    
  CGFloat hexDiameter = 2 * sqrt( 0.75 * pow( radius, 2 ) );
  // NSLog( @"Hex diameter = %f", hexDiameter );
  
  NSPoint hexCentre;
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row ++ ) {
      NSBezierPath *hex = [NSBezierPath bezierPath];
      hexCentre = NSMakePoint(
                    offset + (col * ( (3 * radius ) / 2 ) ),
                    offset + (row * hexDiameter) + ( col % 2 == 0 ? (hexDiameter / 2) : 0 )
                    );
      [hex appendHexagonWithCentre:hexCentre radius:radius];
      
      if( selection != nil && col == [selection column] && row == [selection row] ) {
        [[NSColor blueColor] set];
      } else {
        [[NSColor grayColor] set];
      }
      [hex fill];
      
      [[NSColor blackColor] set];
      [hex setLineWidth:2.0];
      [hex stroke];
      
      [hexes insertObject:[[ELHexCell alloc] initWithLayerView:self path:hex column:col row:row] atIndex:COL_ROW_OFFSET(col,row)];
    }
  }
}

- (ELHexCell *)findHexAtPoint:(NSPoint)_point {
  // Find the Bezier containing this click
  for( ELHexCell *cell in hexes ) {
    if( [[cell path] containsPoint:_point] ) {
      return cell;
    }
  }
  
  return nil;
}

- (void)mouseDown:(NSEvent *)_event {
  NSLog( @"mouse = %f,%f", [_event locationInWindow].x, [_event locationInWindow].y );

  selection = [self findHexAtPoint:[self convertPoint:[_event locationInWindow] fromView:nil]];
  
  [self setNeedsDisplay:YES];
  
  if( [delegate respondsToSelector:@selector(layerView:hexSelected:)] ) {
    [delegate layerView:self hexSelected:selection];
  }
}

@end
