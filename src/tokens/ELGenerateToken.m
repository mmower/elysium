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

#import "ELDialBank.h"

#define EL_BEAT_TRIGGER_MODE    0
#define EL_IMPACT_TRIGGER_MODE  1
#define EL_MIDI_TRIGGER_MODE    2

@implementation ELGenerateToken

+ (NSString *)tokenType {
  return @"generate";
}


#pragma mark Object initialization

- (id)initWithTriggerModeDial:(ELDial *)triggerModeDial
                directionDial:(ELDial *)directionDial
               timeToLiveDial:(ELDial *)timeToLiveDial
               pulseEveryDial:(ELDial *)pulseEveryDial
                   offsetDial:(ELDial *)offsetDial
{
  if( ( self = [super init] ) ) {
    [self setTriggerModeDial:triggerModeDial];
    [self setDirectionDial:directionDial];
    [self setTimeToLiveDial:timeToLiveDial];
    [self setPulseEveryDial:pulseEveryDial];
    [self setOffsetDial:offsetDial];
  }
  
  return self;
}

- (id)init {
  return [self initWithTriggerModeDial:[ELDialBank defaultTriggerModeDial]
                         directionDial:[ELDialBank defaultDirectionDial]
                        timeToLiveDial:[ELDialBank defaultTimeToLiveDial]
                        pulseEveryDial:[ELDialBank defaultPulseEveryDial]
                            offsetDial:[ELDialBank defaultOffsetDial]];
}


#pragma mark Properties

@synthesize triggerModeDial = _triggerModeDial;

- (void)setTriggerModeDial:(ELDial *)triggerModeDial {
  _triggerModeDial = triggerModeDial;
  [_triggerModeDial setDelegate:self];
}


@synthesize directionDial = _directionDial;

- (void)setDirectionDial:(ELDial *)directionDial {
  _directionDial = directionDial;
  [_directionDial setDelegate:self];
}


@synthesize timeToLiveDial = _timeToLiveDial;

- (void)setTimeToLiveDial:(ELDial *)timeToLiveDial {
  _timeToLiveDial = timeToLiveDial;
  [_timeToLiveDial setDelegate:self];
}


@synthesize pulseEveryDial = _pulseEveryDial;

- (void)setPulseEveryDial:(ELDial *)pulseEveryDial {
  _pulseEveryDial = pulseEveryDial;
  [_pulseEveryDial setDelegate:self];
}


@synthesize offsetDial = _offsetDial;

- (void)setOffsetDial:(ELDial *)offsetDial {
  _offsetDial = offsetDial;
  [_offsetDial setDelegate:self];
}


#pragma mark Layer support

- (void)addedToLayer:(ELLayer *)targetLayer atPosition:(ELCell *)targetCell {
  [super addedToLayer:targetLayer atPosition:targetCell];
  
  if( ![self loaded] ) {
    [[self timeToLiveDial] setParent:[targetLayer timeToLiveDial]];
    if( ![[self timeToLiveDial] duplicate] ) {
      [[self timeToLiveDial] setMode:dialInherited];
    }
    
    [[self pulseEveryDial] setParent:[targetLayer pulseEveryDial]];
    if( ![[self pulseEveryDial] duplicate] ) {
      [[self pulseEveryDial] setMode:dialInherited];
    }
  }
  
  if( [targetLayer isRunning] ) {
    _nextTriggerBeat = [targetLayer beatCount] + ([[self pulseEveryDial] value] - ([targetLayer beatCount] % [[self pulseEveryDial] value]));
  }
  
  [targetLayer addGenerator:self];
}


- (void)removedFromLayer:(ELLayer *)targetLayer {
  [targetLayer removeGenerator:self];
  
  [[self timeToLiveDial] setParent:nil];
  [[self timeToLiveDial] setPlayer:nil];
  [[self pulseEveryDial] setParent:nil];
  [[self pulseEveryDial] setPlayer:nil];
  
  [super removedFromLayer:targetLayer];
}


- (BOOL)shouldPulseOnBeat:(int)beat {
  BOOL pulse = NO;
  
  switch( [[self triggerModeDial] value] ) {
    case EL_BEAT_TRIGGER_MODE:
      pulse = ( beat - [[self offsetDial] value] ) == _nextTriggerBeat;
      break;
    
    case EL_IMPACT_TRIGGER_MODE:
      pulse = [[self cell] playheadEntered];
      break;
    
    case EL_MIDI_TRIGGER_MODE:
      pulse = [[self layer] receivedMIDINote:[[self cell] note]];
      break;
  }
  
  return pulse;
}


- (void)start {
  [super start];
  
  [[self directionDial] start];
  [[self timeToLiveDial] start];
  [[self pulseEveryDial] start];
  [[self offsetDial] start];
  
  _nextTriggerBeat = 0;
}


- (void)stop {
  [super stop];
  
  [[self directionDial] stop];
  [[self timeToLiveDial] stop];
  [[self pulseEveryDial] stop];
  [[self offsetDial] stop];
}


- (void)runToken:(ELPlayhead *)playhead {
  [[self layer] addPlayhead:[[ELPlayhead alloc] initWithPosition:[self cell]
                                                       direction:[[self directionDial] value]
                                                             TTL:[[self timeToLiveDial] value]]];
   _nextTriggerBeat += [[self pulseEveryDial] value];
}


#pragma mark Drawing

- (void)drawWithAttributes:(NSDictionary *)attributes {
  NSPoint centre = [[self cell] centre];
  float radius = [[self cell] radius];
  
  NSBezierPath *symbolPath;
  symbolPath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect( centre.x - radius/3, centre.y - radius/3, 2*radius/3, 2*radius/3 )];
  [symbolPath setLineWidth:2.0];

  [self setTokenDrawColor:attributes];
  [symbolPath stroke];
  
  [[self cell] drawTriangleInDirection:[[self directionDial] value] withAttributes:attributes];
}


#pragma mark Implements ELXmlData

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[[self triggerModeDial] xmlRepresentation]];
  [controlsElement addChild:[[self directionDial] xmlRepresentation]];
  [controlsElement addChild:[[self timeToLiveDial] xmlRepresentation]];
  [controlsElement addChild:[[self pulseEveryDial] xmlRepresentation]];
  [controlsElement addChild:[[self offsetDial] xmlRepresentation]];
  return controlsElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    [self setTriggerModeDial:[representation loadDial:@"triggerMode" parent:nil player:player error:error]];
    [self setDirectionDial:[representation loadDial:@"direction" parent:nil player:player error:error]];
    [self setTimeToLiveDial:[representation loadDial:@"timeToLive" parent:[parent timeToLiveDial] player:player error:error]];
    [self setPulseEveryDial:[representation loadDial:@"pulseEvery" parent:[parent pulseEveryDial] player:player error:error]];
    [self setOffsetDial:[representation loadDial:@"offset" parent:nil player:player error:error]];
  }
  
  return self;
}


#pragma mark Implements NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  id copy = [super mutableCopyWithZone:zone];
  
  [copy setTriggerModeDial:[[self triggerModeDial] duplicateDial]];
  [copy setDirectionDial:[[self directionDial] duplicateDial]];
  [copy setTimeToLiveDial:[[self timeToLiveDial] duplicateDial]];
  [copy setPulseEveryDial:[[self pulseEveryDial] duplicateDial]];
  [copy setOffsetDial:[[self offsetDial] duplicateDial]];
  
  return copy;
}


@end
