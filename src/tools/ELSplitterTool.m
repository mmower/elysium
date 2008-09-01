//
//  ELSplitterTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSplitterTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayhead.h"

@implementation ELSplitterTool

- (id)init {
  if( self = [super initWithType:@"splitter"] ) {
    // NOP
  }
  
  return self;
}

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    [_playhead setPosition:nil];
    for( int direction = N; direction <= NW; direction++ ) {
      if( direction != [_playhead direction] ) {
        [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                      direction:direction
                                                            TTL:[_playhead TTL]]];
      }
    }
    return YES;
  } else {
    return NO;
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];

  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  
  [symbolPath moveToPoint:NSMakePoint( centre.x - radius/3, centre.y )];
  [symbolPath lineToPoint:centre];
  [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y + radius/4 )];
  [symbolPath moveToPoint:centre];
  [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y - radius/4 )];
  
  [[_attributes_ objectForKey:ELToolColor] set];
  [symbolPath setLineWidth:2.0];
  [symbolPath stroke];
}

@end
