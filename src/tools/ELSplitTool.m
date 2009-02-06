//
//  ELSplitTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSplitTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"

@implementation ELSplitTool

+ (NSString *)tokenType {
  return @"split";
}

- (id)initWithBounceBackDial:(ELDial *)newBounceBackDial {
  if( ( self = [super init] ) ) {
    [self setBounceBackDial:newBounceBackDial];
  }
  
  return self;
}

- (id)init {
  return [self initWithBounceBackDial:[ELPlayer defaultBounceBackDial]];
}

@dynamic bounceBackDial;

- (ELDial *)bounceBackDial {
  return bounceBackDial;
}

- (void)setBounceBackDial:(ELDial *)newBounceBackDial {
  bounceBackDial = newBounceBackDial;
  [bounceBackDial setDelegate:self];
}

// - (NSArray *)observableValues {
//   NSMutableArray *keys = [[NSMutableArray alloc] init];
//   [keys addObjectsFromArray:[super observableValues]];
//   [keys addObjectsFromArray:[NSArray arrayWithObjects:@"bounceBackDial.value",nil]];
//   return keys;
// }

- (void)start {
  [super start];
  
  [bounceBackDial onStart];
}

- (void)runTool:(ELPlayhead *)_playhead_ {
  [_playhead_ setPosition:nil];
  
  BOOL bounceBack = ![bounceBackDial value];
  int bounceBackDirection = INVERSE_DIRECTION( [_playhead_ direction] );
  
  for( int direction = N; direction <= NW; direction++ ) {
    if( bounceBack && ( direction == bounceBackDirection ) ) {
      continue;
    }
    
    [layer queuePlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                    direction:direction
                                                          TTL:[_playhead_ TTL]]];
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
  
  [self setToolDrawColor:_attributes_];
  [symbolPath setLineWidth:2.0];
  [symbolPath stroke];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setBounceBackDial:[[self bounceBackDial] mutableCopy]];
  return copy;
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[bounceBackDial xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_player_ player:_player_ error:_error_] ) ) {
    [self setBounceBackDial:[_representation_ loadDial:@"bounceBack" parent:nil player:_player_ error:_error_]];
  }
  
  return self;
}

@end
