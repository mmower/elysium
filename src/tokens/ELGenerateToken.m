//
//  ELGenerateToken.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELGenerateToken.h"

#import "ELCell.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"

@implementation ELGenerateToken

+ (NSString *)tokenType {
  return @"generate";
}

- (id)initWithDirectionDial:(ELDial *)newDirectionDial
             timeToLiveDial:(ELDial *)newTimeToLiveDial
             pulseEveryDial:(ELDial *)newPulseEveryDial
                 offsetDial:(ELDial *)newOffsetDial
{
  if( ( self = [super init] ) ) {
    [self setDirectionDial:newDirectionDial];
    [self setTimeToLiveDial:newTimeToLiveDial];
    [self setPulseEveryDial:newPulseEveryDial];
    [self setOffsetDial:newOffsetDial];
  }
  
  return self;
}

- (id)init {
  return [self initWithDirectionDial:[ELPlayer defaultDirectionDial]
                      timeToLiveDial:[ELPlayer defaultTimeToLiveDial]
                      pulseEveryDial:[ELPlayer defaultPulseEveryDial]
                          offsetDial:[ELPlayer defaultOffsetDial]];
}

@dynamic directionDial;

- (ELDial *)directionDial {
  return directionDial;
}

- (void)setDirectionDial:(ELDial *)newDirectionDial {
  directionDial = newDirectionDial;
  [directionDial setDelegate:self];
}

@dynamic timeToLiveDial;

- (ELDial *)timeToLiveDial {
  return timeToLiveDial;
}

- (void)setTimeToLiveDial:(ELDial *)newTimeToLiveDial {
  timeToLiveDial = newTimeToLiveDial;
  [timeToLiveDial setDelegate:self];
}

@dynamic pulseEveryDial;

- (ELDial *)pulseEveryDial {
  return pulseEveryDial;
}

- (void)setPulseEveryDial:(ELDial *)newPulseEveryDial {
  pulseEveryDial = newPulseEveryDial;
  [pulseEveryDial setDelegate:self];
}

@dynamic offsetDial;

- (ELDial *)offsetDial {
  return offsetDial;
}

- (void)setOffsetDial:(ELDial *)newOffsetDial {
  offsetDial = newOffsetDial;
  [offsetDial setDelegate:self];
}

#pragma mark Layer support

- (void)addedToLayer:(ELLayer *)targetLayer atPosition:(ELCell *)targetCell {
  [super addedToLayer:targetLayer atPosition:targetCell];
  
  if( !loaded ) {
    [timeToLiveDial setParent:[targetLayer timeToLiveDial]];
    [timeToLiveDial setMode:dialInherited];
    
    [pulseEveryDial setParent:[targetLayer pulseEveryDial]];
    [pulseEveryDial setMode:dialInherited];
  }
  
  [targetLayer addGenerator:self];
}

- (void)removedFromLayer:(ELLayer *)targetLayer {
  [targetLayer removeGenerator:self];
  
  [timeToLiveDial setParent:nil];
  [pulseEveryDial setParent:nil];
  
  [super removedFromLayer:targetLayer];
}

// Token runner

- (BOOL)shouldPulseOnBeat:(int)_beat_ {
  if( [pulseEveryDial value] < 1 ) {
    return NO;
  } else {
    return ( ( _beat_ - [offsetDial value] ) % [pulseEveryDial value] ) == 0;
  }
}

- (void)start {
  [super start];
  
  [directionDial start];
  [timeToLiveDial start];
  [pulseEveryDial start];
  [offsetDial start];
}

- (void)stop {
  [super stop];
  
  [directionDial stop];
  [timeToLiveDial stop];
  [pulseEveryDial stop];
  [offsetDial stop];
}

- (void)runToken:(ELPlayhead *)_playhead_ {
    [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:cell
                                                  direction:[directionDial value]
                                                        TTL:[timeToLiveDial value]]];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self cell] centre];
  float radius = [[self cell] radius];
  
  NSBezierPath *symbolPath;
  symbolPath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect( centre.x - radius/3, centre.y - radius/3, 2*radius/3, 2*radius/3 )];
  [symbolPath setLineWidth:2.0];

  [self setTokenDrawColor:_attributes_];
  [symbolPath stroke];
  
  [[self cell] drawTriangleInDirection:[directionDial value] withAttributes:_attributes_];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[directionDial xmlRepresentation]];
  [controlsElement addChild:[timeToLiveDial xmlRepresentation]];
  [controlsElement addChild:[pulseEveryDial xmlRepresentation]];
  [controlsElement addChild:[offsetDial xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    [self setDirectionDial:[[ELDial alloc] initWithXmlRepresentation:[[_representation_ nodesForXPath:@"controls/dial[@name='direction']" error:_error_] firstXMLElement]
                                                              parent:nil
                                                              player:_player_
                                                               error:_error_]];
    [self setTimeToLiveDial:[[ELDial alloc] initWithXmlRepresentation:[[_representation_ nodesForXPath:@"controls/dial[@name='timeToLive']" error:_error_] firstXMLElement]
                                                               parent:nil
                                                               player:_player_
                                                                error:_error_]];
    [self setPulseEveryDial:[[ELDial alloc] initWithXmlRepresentation:[[_representation_ nodesForXPath:@"controls/dial[@name='pulseEvery']" error:_error_] firstXMLElement]
                                                               parent:nil
                                                               player:_player_
                                                                error:_error_]];
    [self setOffsetDial:[[ELDial alloc] initWithXmlRepresentation:[[_representation_ nodesForXPath:@"controls/dial[@name='offset']" error:_error_] firstXMLElement]
                                                           parent:nil
                                                           player:_player_
                                                            error:_error_]];
  }
  
  return self;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setDirectionDial:[[self directionDial] mutableCopy]];
  [copy setTimeToLiveDial:[[self timeToLiveDial] mutableCopy]];
  [copy setPulseEveryDial:[[self pulseEveryDial] mutableCopy]];
  [copy setOffsetDial:[[self offsetDial] mutableCopy]];
  return copy;
}

@end
