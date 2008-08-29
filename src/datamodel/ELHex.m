//
//  ELHex.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import <HoneycombView/LMHoneycombView.h>

#import "ELHex.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ELTool.h"
#import "ELPlayhead.h"

#import "ELStartTool.h"

@implementation ELHex

- (id)initWithLayer:(ELLayer *)_layer note:(ELNote *)_note column:(int)_col row:(int)_row {
  if( self = [super initWithColumn:_col row:_row] ) {
    layer     = _layer;
    note      = _note;
    tools     = [[NSMutableDictionary alloc] init];
    playheads = [[NSMutableArray alloc] init];
    
    [self connectNeighbour:nil direction:N];
    [self connectNeighbour:nil direction:NE];
    [self connectNeighbour:nil direction:SE];
    [self connectNeighbour:nil direction:S];
    [self connectNeighbour:nil direction:SW];
    [self connectNeighbour:nil direction:NW];
  }
  
  return self;
}

// Private method for connecting hexes without setting the inverse
- (void)connectToHex:(ELHex *)_hex direction:(Direction)_direction {
  neighbours[_direction] = _hex;
}

- (void)connectNeighbour:(ELHex *)_hex direction:(Direction)_direction {
  [self connectToHex:_hex direction:_direction];
  // [_hex connectToHex:self direction:INVERSE_DIRECTION(_direction)];
}

- (ELNote *)note {
  return note;
}

- (ELHex *)neighbour:(Direction)_direction {
  return neighbours[_direction];
}

- (void)addTool:(ELTool *)_tool {
  [tools setObject:_tool forKey:[_tool toolType]];
  [_tool addedToLayer:layer atPosition:self];
}

- (void)removeTool:(NSString *)_type {
  ELTool *tool = [self toolOfType:_type];
  [tool removedFromLayer:layer];
  [tools removeObjectForKey:_type];
}

- (NSArray *)tools {
  return [tools allValues];
}

- (BOOL)hasStartTool {
  return [self toolOfType:@"start"] != nil;
}

- (BOOL)hasToolOfType:(NSString *)type {
  return [self toolOfType:type] != nil;
}

- (ELTool *)toolOfType:(NSString *)_type {
  return [tools objectForKey:_type];
}

- (NSArray *)toolsExceptType:(NSString *)_type {
  NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"toolType != %@",_type];
  return [[tools allValues] filteredArrayUsingPredicate:typePredicate];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Pos(%d,%d):%@",col,row,note];
}

// Playheads

- (void)playheadEntering:(ELPlayhead *)_playhead {
  [playheads addObject:_playhead];
}

- (void)playheadLeaving:(ELPlayhead *)_playhead {
  [playheads removeObject:_playhead];
}

// Drawing

- (void)drawText:(NSString *)_text {
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:[NSFont fontWithName:@"Helvetica" size:9]
                 forKey:NSFontAttributeName];
  [attributes setObject:[NSColor whiteColor]
                 forKey:NSForegroundColorAttributeName];
  
  NSSize strSize = [_text sizeWithAttributes:attributes];
  
  NSPoint strOrigin;
  strOrigin.x = [path bounds].origin.x + ( [path bounds].size.width - strSize.width ) / 2;
  strOrigin.y = [path bounds].origin.y + ( [path bounds].size.height - strSize.height ) / 2;
  
  [_text drawAtPoint:strOrigin withAttributes:attributes];
}

  // [[NSColor whiteColor] set];
  // 
  // NSRect bounds = [path bounds];
  // float l = bounds.size.width / 5;
  // 
  // NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  // 
  // NSAffineTransform *transform = [NSAffineTransform transform];
  // [transform translateXBy:centre.x yBy:centre.y];
  // [transform rotateByDegrees:d * 60];
  // [transform translateXBy:-centre.x yBy:-centre.y];
  // 
  // NSPoint p1 = NSMakePoint( bounds.origin.x + ( bounds.size.width - l ) / 2, bounds.origin.y + 2*l );
  // NSPoint p2 = NSMakePoint( bounds.origin.x + ( bounds.size.width + l ) / 2, bounds.origin.y + 2*l );
  // NSPoint p3 = NSMakePoint( bounds.origin.x + bounds.size.width / 2, bounds.origin.y + 3*l );
  // 
  // [symbolPath moveToPoint:p1];
  // [symbolPath lineToPoint:p2];
  // [symbolPath lineToPoint:p3];
  // [symbolPath lineToPoint:p1];
  // [symbolPath closePath];
  // [symbolPath stroke];
  // [symbolPath fill];
  // 
  // 
  // [self drawText:@"P"];
  
int mapPathSection( Direction d ) {
  switch( d % 6 ) {
    case N:
    return 2;
    case NE:
    return 1;
    case SE:
    return 0;
    case S:
    return 5;
    case SW:
    return 4;
    case NW:
    return 3;
    default:
    NSLog( @"Well this shouldn't happen! (Direction = %d)", d );
    assert( NO );
  }
}

NSString* elementDescription( NSBezierPathElement elt ) {
  switch( elt ) {
    case NSMoveToBezierPathElement:
      return @"MOVE";
    case NSLineToBezierPathElement:
      return @"LINE";
    case NSCurveToBezierPathElement:
      return @"CURVE";
    case NSClosePathBezierPathElement:
      return @"CLOSE";
    default:
    NSLog( @"Well this shouldn't happen either" );
    assert( NO );
  }
}
  
- (void)drawTriangleInDirection:(Direction)_direction_ withAttributes:(NSDictionary *)_attributes_ {
  
  // Get the face of the hex path corresponding to the given direction
  NSPoint points[3];
  
  [[self path] elementAtIndex:mapPathSection(_direction_) associatedPoints:points];
  NSPoint anchor1 = NSMakePoint( points[0].x, points[0].y );
  
  [[self path] elementAtIndex:mapPathSection(_direction_+1) associatedPoints:points];
  NSPoint anchor2 = NSMakePoint( points[0].x, points[0].y );
  
  // NSPoint apex = NSMakePoint( ( anchor1.x + anchor2.x ) / 2, ( anchor1.y + anchor2.y ) / 2 );
  
  
  // NSPoint anchor3;
  // anchor3.x = anchor1.x + anchor2.x / 2;
  // anchor3.y = 
  
  NSBezierPath *trianglePath = [NSBezierPath bezierPath];
  [trianglePath moveToPoint:centre];
  [trianglePath lineToPoint:anchor1];
  [trianglePath lineToPoint:anchor2];
  [trianglePath lineToPoint:centre];
  [trianglePath closePath];
  
  [[NSColor yellowColor] set];
  [trianglePath fill];
  [trianglePath setLineWidth:3.0];
  
  // NSAffineTransform *transform = [NSAffineTransform transform];
  // [transform translateXBy:centre.x yBy:centre.y];
  // [transform rotateByDegrees:_direction_ * 60];
  // [transform translateXBy:-centre.x yBy:-centre.y];
}

- (void)drawOnHoneycombView:(LMHoneycombView *)_view_ withAttributes:(NSMutableDictionary *)_attributes_ {
  if( [playheads count] > 0 ) {
    // Modify attributes
    [_attributes_ setObject:[NSColor redColor] forKey:LMHoneycombViewDefaultColor];
  } else if( [[self tools] count] > 0 ) {
    [_attributes_ setObject:[NSColor colorWithDeviceRed:(40.0/255) green:(121.0/255) blue:(241.0/255) alpha:0.8] forKey:LMHoneycombViewDefaultColor];
  }
  
  [super drawOnHoneycombView:_view_ withAttributes:_attributes_];
  
  [[self tools] makeObjectsPerformSelector:@selector(drawWithAttributes:) withObject:_attributes_];
}

// Implementing the ELData protocol

- (NSXMLElement *)asXMLData {
  NSXMLElement *cellElement = [NSXMLNode elementWithName:@"cell"];
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:[NSNumber numberWithInt:col] forKey:@"col"];
  [attributes setObject:[NSNumber numberWithInt:row] forKey:@"row"];
  [cellElement setAttributesAsDictionary:attributes];
  
  for( ELTool *tool in [self tools] ) {
    [cellElement addChild:[tool asXMLData]];
  }
  
  return cellElement;
}

- (BOOL)fromXMLData:(NSXMLElement *)_xml_ {
  for( NSXMLNode *markerNode in [_xml_ nodesForXPath:@"marker" error:nil] ) {
    ELTool *tool = [ELTool fromXMLData:(NSXMLElement *)markerNode];
    if( !tool ) {
      NSLog( @"Unable to load tool configuration!" );
      return NO;
    }
    
    [self addTool:tool];
  }
  
  return YES;
}

@end
