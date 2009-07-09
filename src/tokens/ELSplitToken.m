//
//  ELSplitToken.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSplitToken.h"

#import "ELCell.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"

#import "ELDialBank.h"

@implementation ELSplitToken

+ (NSString *)tokenType {
  return @"split";
}


#pragma mark Object initialization

- (id)initWithBounceBackDial:(ELDial *)bounceBackDial {
  if( ( self = [super init] ) ) {
    [self setBounceBackDial:bounceBackDial];
  }
  
  return self;
}


- (id)init {
  return [self initWithBounceBackDial:[ELDialBank defaultBounceBackDial]];
}


#pragma mark Properties

@synthesize bounceBackDial = _bounceBackDial;

- (void)setBounceBackDial:(ELDial *)bounceBackDial {
  _bounceBackDial = bounceBackDial;
  [_bounceBackDial setDelegate:self];
}


#pragma mark Object behaviours

- (void)start {
  [super start];
  
  [[self bounceBackDial] start];
}


- (void)stop {
  [super stop];
  
  [[self bounceBackDial] stop];
}


- (void)runToken:(ELPlayhead *)playhead {
  [playhead setPosition:nil];
  
  BOOL bounceBack = ![[self bounceBackDial] value];
  int bounceBackDirection = INVERSE_DIRECTION( [playhead direction] );
  
  for( int direction = N; direction <= NW; direction++ ) {
    if( bounceBack && ( direction == bounceBackDirection ) ) {
      continue;
    }
    
    [[self layer] queuePlayhead:[[ELPlayhead alloc] initWithPosition:[self cell]
                                                           direction:direction
                                                                 TTL:[playhead TTL]]];
  }
}


#pragma mark Drawing

- (void)drawWithAttributes:(NSDictionary *)attributes {
  NSPoint centre = [[self cell] centre];
  float radius = [[self cell] radius];

  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  
  [symbolPath moveToPoint:NSMakePoint( centre.x - radius/3, centre.y )];
  [symbolPath lineToPoint:centre];
  [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y + radius/4 )];
  [symbolPath moveToPoint:centre];
  [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y - radius/4 )];
  
  [self setTokenDrawColor:attributes];
  [symbolPath setLineWidth:2.0];
  [symbolPath stroke];
}


#pragma mark Implements NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  id copy = [super mutableCopyWithZone:zone];
  [copy setBounceBackDial:[[self bounceBackDial] duplicateDial]];
  return copy;
}


#pragma mark Implements ELXmlData

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[[self bounceBackDial] xmlRepresentation]];
  return controlsElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:player player:player error:error] ) ) {
    [self setBounceBackDial:[representation loadDial:@"bounceBack" parent:nil player:player error:error]];
  }
  
  return self;
}


@end
