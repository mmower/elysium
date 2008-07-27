//
//  ELLayerView.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELLayerView.h"

#import "ELHex.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ELHexCell.h"
#import "ELRegularPolygon.h"

@implementation ELLayerView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      hexes    = nil;
      selected = nil;
    }
    return self;
}

- (void)finalize {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super finalize];
}

- (id)delegate {
  return delegate;
}

- (void)setDelegate:(id)_delegate {
  delegate = _delegate;
}

- (ELLayer *)dataLayer {
  return dataLayer;
}

- (void)setDataLayer:(ELLayer *)_layer {
  dataLayer = _layer;
}

// View methods

- (void)viewDidMoveToWindow {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(windowResized:)
                                               name:NSWindowDidResizeNotification
                                             object:[self window]];
}

- (NSColor *)defaultColor {
  return [NSColor grayColor];
}

- (NSColor *)selectedColor {
  return [NSColor blueColor];
}

- (CGFloat)hexRadius {
  return [self bounds].size.width / 27;
}

- (CGFloat)hexOffset {
  return ( 3 * [self hexRadius] ) / 2;
}

- (CGFloat)hexDiameter {
  return 2 * sqrt( 0.75 * pow( [self hexRadius], 2 ) );
}

- (CGFloat)idealHeight {
  return [self hexOffset] + ( 12 * [self hexDiameter] );
}

// - (CGFloat)idealWidth {
//   [self hexOffset] + ( 17 * [self hexDiameter] )
// }

- (void)generateCells {
  hexes = [[NSMutableArray alloc] initWithCapacity:HTABLE_SIZE];
  
  // Create the set of Hex cells that will represent the honeycomb
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row++ ) {
      ELHexCell *cell = [[ELHexCell alloc] initWithLayerView:self
                                                      column:col
                                                         row:row];
      [hexes insertObject:cell atIndex:COL_ROW_OFFSET(col,row)];
    }
  }
}

- (void)calculateCellPaths:(NSRect)__bounds {
  NSLog( @"Bounds = %f,%f", __bounds.size.width, __bounds.size.height );
  
  NSPoint hexCentre;
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row ++ ) {
      ELHexCell *cell = [hexes objectAtIndex:COL_ROW_OFFSET(col,row)];
      
      hexCentre = NSMakePoint(
                    [self hexOffset] + (col * ( (3 * [self hexRadius] ) / 2 ) ),
                    [self hexOffset] + (row * [self hexDiameter]) + ( col % 2 == 0 ? ([self hexDiameter] / 2) : 0 )
                    );
      
      NSBezierPath *hexPath = [NSBezierPath bezierPath];
      [hexPath appendHexagonWithCentre:hexCentre radius:[self hexRadius]];
      [cell setPath:hexPath];
    }
  }
}

- (void)drawRect:(NSRect)rect {
  if( !hexes ) {
    [self generateCells];
    [self calculateCellPaths:[self bounds]];
  }
  
  for( ELHexCell *cell in hexes ) {
    
    if( cell == selected ) {
      [[self selectedColor] set];
    } else {
      [[self defaultColor] set];
    }
    
    [[cell path] fill];
    
    [[NSColor blackColor] set];
    [[cell path] setLineWidth:2.0];
    [[cell path] stroke];
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

- (ELHexCell *)selected {
  return selected;
}

- (void)setSelected:(ELHexCell *)_selected {
  NSLog( @"Selection = %@", _selected );
  
  selected = _selected;
  if( [delegate respondsToSelector:@selector(layerView:hexSelected:)] ) {
    [delegate layerView:self hexSelected:selected];
  }
  [self setNeedsDisplay:YES];
  
  if( dataLayer ) {
    ELHex *hex = [dataLayer hexAtCol:[_selected column] row:[_selected row]];
    ELNote *note = [hex note];
    
    [dataLayer playNote:note
               velocity:100
               duration:0.8];
  }
}

- (void)mouseDown:(NSEvent *)_event {
  NSLog( @"mouse = %f,%f", [_event locationInWindow].x, [_event locationInWindow].y );
  [self setSelected:[self findHexAtPoint:[self convertPoint:[_event locationInWindow] fromView:nil]]];
}

// Notifications

- (void)windowResized:(NSNotification *)notification;
{
  NSLog( @"New bounds = %f,%f Ideal bounds = %f,%f", [self bounds].size.width, [self bounds].size.height, [self bounds].size.width, [self idealHeight] );
  [self calculateCellPaths:[self bounds]];
}

@end
