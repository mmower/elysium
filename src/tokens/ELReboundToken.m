//
//  ELReboundToken.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELReboundToken.h"

#import "ELCell.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"

#import "ELDialBank.h"

@implementation ELReboundToken

+ (NSString *)tokenType {
  return @"rebound";
}


#pragma mark Object initialization

- (id)initWithDirectionDial:(ELDial *)directionDial {
  if( ( self = [super init] ) ) {
    [self setDirectionDial:directionDial];
  }
  
  return self;
}

- (id)init {
  return [self initWithDirectionDial:[ELDialBank defaultDirectionDial]];
}


#pragma mark Properties

@synthesize directionDial = _directionDial;

- (void)setDirectionDial:(ELDial *)directionDial {
  _directionDial = directionDial;
  [_directionDial setDelegate:self];
}


#pragma mark Object behaviour

- (void)start {
  [super start];
  
  [[self directionDial] start];
}


- (void)stop {
  [super stop];
  
  [[self directionDial] stop];
}


- (void)runToken:(ELPlayhead *)playhead {
  [playhead setDirection:[[self directionDial] value]];
}


#pragma mark Drawing

- (void)drawWithAttributes:(NSDictionary *)attributes {
  [self setTokenDrawColor:attributes];
  [[self cell] drawTriangleInDirection:[[self directionDial] value] withAttributes:attributes];
}


#pragma mark Implements NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  id copy = [super mutableCopyWithZone:zone];
  [copy setDirectionDial:[[self directionDial] duplicateDial]];
  return copy;
}


#pragma mark Implements ELXmlData

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[[self directionDial] xmlRepresentation]];
  return controlsElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    [self setDirectionDial:[representation loadDial:@"direction" parent:nil player:player error:error]];
  }
  
  return self;
}


@end
