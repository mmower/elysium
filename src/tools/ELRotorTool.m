//
//  ELRotorTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRotorTool.h"

#import "ELHex.h"
#import "ELConfig.h"
#import "ELPlayhead.h"
#import "ELStartTool.h"
#import "ELRicochetTool.h"

@implementation ELRotorTool

+ (ELRotorTool *)new {
  return [[ELRotorTool alloc] init];
}

- (id)init {
  if( ( self = [super initWithType:@"rotor"] ) ) {
    [self setClockwise:YES];
    [self setPreferredOrder:9];
  }
  
  return self;
}

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"clockwise",nil]];
  return keys;
}

// Properties

- (BOOL)clockwise {
  return [config booleanForKey:@"clockwise"];
}

- (void)setClockwise:(BOOL)_clockwise_ {
  [config setBoolean:_clockwise_ forKey:@"clockwise"];
}

// What happens when a playhead arrives

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    ELTool<DirectedTool> *tool;
    
    if( [[_playhead position] toolOfType:@"ricochet"] ) {
      tool = [[_playhead position] toolOfType:@"ricochet"];
    } else if( [[_playhead position] toolOfType:@"start"] ) {
      tool = [[_playhead position] toolOfType:@"start"];
    } else {
      tool = nil;
    }
    
    if( [self clockwise] ) {
      [tool setDirection:(([tool direction]+1) % 6)];
    } else {
      [tool setDirection:(([tool direction]-1) % 6)];
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

  [[_attributes_ objectForKey:ELToolColor] set];
  
  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  
  if( [self clockwise] ) {
    [symbolPath moveToPoint:NSMakePoint( centre.x - radius/3 - radius/10, centre.y - radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x - radius/3, centre.y + radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x - radius/3 + radius/10, centre.y - radius/8 )];
    
    [symbolPath moveToPoint:NSMakePoint( centre.x + radius/3 - radius/10, centre.y + radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y - radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3 + radius/10, centre.y + radius/8 )];
  } else {
    [symbolPath moveToPoint:NSMakePoint( centre.x - radius/3 - radius/10, centre.y + radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x - radius/3, centre.y - radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x - radius/3 + radius/10, centre.y + radius/8 )];
    
    [symbolPath moveToPoint:NSMakePoint( centre.x + radius/3 - radius/10, centre.y - radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y + radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3 + radius/10, centre.y - radius/8 )];
  }
  
  [symbolPath setLineWidth:2.0];
  [symbolPath stroke];
}

@end
