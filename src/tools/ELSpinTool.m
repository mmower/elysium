//
//  ELSpinTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSpinTool.h"

#import "ELHex.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"
#import "ELGenerateTool.h"
#import "ELReboundTool.h"

@implementation ELSpinTool

+ (NSString *)tokenType {
  return @"spin";
}

- (id)initWithClockwiseDial:(ELDial *)newClockwiseDial steppingDial:(ELDial *)newSteppingDial {
  if( ( self = [super init] ) ) {
    [self setClockwiseDial:newClockwiseDial];
    [self setSteppingDial:newSteppingDial];
  }
  
  return self;
}

- (id)init {
  return [self initWithClockwiseDial:[ELPlayer defaultClockWiseDial]
                        steppingDial:[ELPlayer defaultSteppingDial]];
}

@dynamic clockwiseDial;

- (ELDial *)clockwiseDial {
  return clockwiseDial;
}

- (void)setClockwiseDial:(ELDial *)newClockwiseDial {
  clockwiseDial = newClockwiseDial;
  [clockwiseDial setDelegate:self];
}

@dynamic steppingDial;

- (ELDial *)steppingDial {
  return steppingDial;
}

- (void)setSteppingDial:(ELDial *)newSteppingDial {
  steppingDial = newSteppingDial;
  [steppingDial setDelegate:self];
}

// - (NSArray *)observableValues {
//   NSMutableArray *keys = [[NSMutableArray alloc] init];
//   [keys addObjectsFromArray:[super observableValues]];
//   [keys addObjectsFromArray:[NSArray arrayWithObjects:@"clockwiseDial.value",@"steppingDial.value",nil]];
//   return keys;
// }

- (void)start {
  [super start];
  
  [clockwiseDial onStart];
  [steppingDial onStart];
}

// What happens when a playhead arrives

- (void)runTool:(ELPlayhead *)_playhead_ {
  ELTool<DirectedTool> *tool;
  
  if( [[_playhead_ position] reboundTool] ) {
    tool = [[_playhead_ position] reboundTool];
  } else if( [[_playhead_ position] generateTool] ) {
    tool = [[_playhead_ position] generateTool];
  } else {
    tool = nil;
  }
  
  if( [clockwiseDial value] ) {
    [[tool directionDial] setValue:(([[tool directionDial] value]+[steppingDial value]) % 6)];
  } else {
    [[tool directionDial] setValue:(([[tool directionDial] value]-[steppingDial value]) % 6)];
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];
  
  [self setToolDrawColor:_attributes_];
  
  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  
  if( [clockwiseDial value] ) {
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

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setClockwiseDial:[[self clockwiseDial] mutableCopy]];
  [copy setSteppingDial:[[self steppingDial] mutableCopy]];
  return copy;
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[clockwiseDial xmlRepresentation]];
  [controlsElement addChild:[steppingDial xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    [self setClockwiseDial:[_representation_ loadDial:@"clockwise" parent:nil player:_player_ error:_error_]];
    [self setSteppingDial:[_representation_ loadDial:@"stepping" parent:nil player:_player_ error:_error_]];
  }
  
  return self;
}

@end
