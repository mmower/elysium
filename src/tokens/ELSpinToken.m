//
//  ELSpinToken.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSpinToken.h"

#import "ELCell.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"
#import "ELGenerateToken.h"
#import "ELReboundToken.h"

#import "ELDialBank.h"

@implementation ELSpinToken

+ (NSString *)tokenType {
  return @"spin";
}


- (id)initWithClockwiseDial:(ELDial *)clockwiseDial steppingDial:(ELDial *)steppingDial {
  if( ( self = [super init] ) ) {
    [self setClockwiseDial:clockwiseDial];
    [self setSteppingDial:steppingDial];
  }
  
  return self;
}


- (id)init {
  return [self initWithClockwiseDial:[ELDialBank defaultClockWiseDial]
                        steppingDial:[ELDialBank defaultSteppingDial]];
}


#pragma mark Properties

@synthesize clockwiseDial = _clockwiseDial;

- (void)setClockwiseDial:(ELDial *)clockwiseDial {
  _clockwiseDial = clockwiseDial;
  [_clockwiseDial setDelegate:self];
}


@synthesize steppingDial = _steppingDial;

- (void)setSteppingDial:(ELDial *)steppingDial {
  _steppingDial = steppingDial;
  [_steppingDial setDelegate:self];
}


#pragma mark Token interactions

- (void)start {
  [super start];
  
  [[self clockwiseDial] start];
  [[self steppingDial] start];
}


- (void)stop {
  [super stop];
  
  [[self clockwiseDial] stop];
  [[self steppingDial] stop];
}


- (void)runToken:(ELPlayhead *)playhead {
  ELToken<DirectedToken> *token;
  
  if( [[playhead position] reboundToken] ) {
    token = [[playhead position] reboundToken];
  } else if( [[playhead position] generateToken] ) {
    token = [[playhead position] generateToken];
  } else {
    token = nil;
  }
  
  if( [[self clockwiseDial] value] ) {
    [[token directionDial] setValue:(([[token directionDial] value]+[[self steppingDial] value]) % 6)];
  } else {
    [[token directionDial] setValue:(([[token directionDial] value]-[[self steppingDial] value]) % 6)];
  }
}


#pragma mark Drawing

- (void)drawWithAttributes:(NSDictionary *)attributes {
  NSPoint centre = [[self cell] centre];
  float radius = [[self cell] radius];
  
  [self setTokenDrawColor:attributes];
  
  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  
  if( [[self clockwiseDial] value] ) {
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


#pragma mark Implements NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  id copy = [super mutableCopyWithZone:zone];
  [copy setClockwiseDial:[[self clockwiseDial] duplicateDial]];
  [copy setSteppingDial:[[self steppingDial] duplicateDial]];
  return copy;
}


#pragma mark Implements ELXmlData

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[[self clockwiseDial] xmlRepresentation]];
  [controlsElement addChild:[[self steppingDial] xmlRepresentation]];
  return controlsElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    [self setClockwiseDial:[representation loadDial:@"clockwise" parent:nil player:player error:error]];
    [self setSteppingDial:[representation loadDial:@"stepping" parent:nil player:player error:error]];
  }
  
  return self;
}

@end
