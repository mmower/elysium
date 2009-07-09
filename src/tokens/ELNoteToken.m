//
//  ELNoteToken.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELToken.h"
#import "ELNoteToken.h"

#import "ELNote.h"
#import "ELCell.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayable.h"
#import "ELNoteGroup.h"
#import "ELPlayhead.h"

#import "ELDialBank.h"

NSDictionary *defaultChannelSends() {
  NSMutableDictionary *sends = [NSMutableDictionary dictionary];
  for( int i = 1; i <= 16; i++ ) {
    ELDial *dial = [[ELDial alloc] initWithName:[NSString stringWithFormat:@"send%d",i]
                                        toolTip:[NSString stringWithFormat:@"Controls whether MIDI is always sent on channel %d for this note.",i]
                                            tag:i
                                      boolValue:NO];
    [sends setObject:dial forKey:[[NSNumber numberWithInteger:[dial tag]] stringValue]];
  }
  return sends;
}


@implementation ELNoteToken

#pragma mark Class behaviour

+ (NSString *)tokenType {
  return @"note";
}


#pragma mark Object initialization

- (id)initWithVelocityDial:(ELDial *)velocityDial
              emphasisDial:(ELDial *)emphasisDial
             tempoSyncDial:(ELDial *)tempoSyncDial
            noteLengthDial:(ELDial *)noteLengthDial
                 triadDial:(ELDial *)triadDial
                ghostsDial:(ELDial *)ghostsDial
              overrideDial:(ELDial *)overrideDial
              channelSends:(NSDictionary *)channelSends
{
  if( ( self = [super init] ) ) {
    [self setVelocityDial:velocityDial];
    [self setEmphasisDial:emphasisDial];
    [self setTempoSyncDial:tempoSyncDial];
    [self setNoteLengthDial:noteLengthDial];
    [self setTriadDial:triadDial];
    [self setGhostsDial:ghostsDial];
    [self setOverrideDial:overrideDial];
    [self setChannelSends:channelSends];
  }
  
  return self;
}


- (id)init {
  return [self initWithVelocityDial:[ELDialBank defaultVelocityDial]
                       emphasisDial:[ELDialBank defaultEmphasisDial]
                      tempoSyncDial:[ELDialBank defaultTempoSyncDial]
                     noteLengthDial:[ELDialBank defaultNoteLengthDial]
                          triadDial:[ELDialBank defaultTriadDial]
                         ghostsDial:[ELDialBank defaultGhostsDial]
                       overrideDial:[ELDialBank defaultOverrideDial]
                       channelSends:defaultChannelSends()];
}


#pragma mark Properties

@synthesize velocityDial = _velocityDial;

- (void)setVelocityDial:(ELDial *)velocityDial {
  _velocityDial = velocityDial;
  [_velocityDial setDelegate:self];
}


@synthesize emphasisDial = _emphasisDial;

- (void)setEmphasisDial:(ELDial *)emphasisDial {
  _emphasisDial = emphasisDial;
  [_emphasisDial setDelegate:self];
}


@synthesize tempoSyncDial = _tempoSyncDial;

- (void)setTempoSyncDial:(ELDial *)tempoSyncDial {
  _tempoSyncDial = tempoSyncDial;
  [_tempoSyncDial setDelegate:self];
}


@synthesize noteLengthDial = _noteLengthDial;

- (void)setNoteLengthDial:(ELDial *)noteLengthDial {
  _noteLengthDial = noteLengthDial;
  [_noteLengthDial setDelegate:self];
}


@synthesize triadDial = _triadDial;

- (void)setTriadDial:(ELDial *)triadDial {
  _triadDial = triadDial;
  [_triadDial setDelegate:self];
}


@synthesize ghostsDial = _ghostsDial;

- (void)setGhostsDial:(ELDial *)ghostsDial {
  _ghostsDial = ghostsDial;
  [_ghostsDial setDelegate:self];
}


@synthesize overrideDial = _overrideDial;

- (void)setOverrideDial:(ELDial *)overrideDial {
  _overrideDial = overrideDial;
  [_overrideDial setDelegate:self];
}


@synthesize channelSends = _channelSends;


#pragma mark Layer support

- (void)addedToLayer:(ELLayer *)targetLayer atPosition:(ELCell *)targetCell {
  [super addedToLayer:targetLayer atPosition:targetCell];
  
  if( ![self loaded] ) {
    [[self velocityDial] setParent:[targetLayer velocityDial]];
    if( ![[self velocityDial] duplicate] ) {
      [[self velocityDial] setMode:dialInherited];
    }
    
    [[self emphasisDial] setParent:[targetLayer emphasisDial]];
    if( ![[self emphasisDial] duplicate] ) {
      [[self emphasisDial] setMode:dialInherited];
    }
    
    [[self tempoSyncDial] setParent:[targetLayer tempoSyncDial]];
    if( ![[self tempoSyncDial] duplicate] ) {
      [[self tempoSyncDial] setMode:dialInherited];
    }
    
    [[self noteLengthDial] setParent:[targetLayer noteLengthDial]];
    if( ![[self noteLengthDial] duplicate] ) {
      [[self noteLengthDial] setMode:dialInherited];
    }
  }
}


- (void)removedFromLayer:(ELLayer *)targetLayer {
  [super removedFromLayer:targetLayer];
  
  [[self velocityDial] setParent:nil];
  [[self emphasisDial] setParent:nil];
  [[self tempoSyncDial] setParent:nil];
  [[self noteLengthDial] setParent:nil];
}


- (void)start {
  [super start];
  
  [[self velocityDial] start];
  [[self emphasisDial] start];
  [[self tempoSyncDial] start];
  [[self noteLengthDial] start];
  [[self triadDial] start];
  [[self ghostsDial] start];
  [[self overrideDial] start];
}


- (void)stop {
  [super stop];
  
  [[self velocityDial] stop];
  [[self emphasisDial] stop];
  [[self tempoSyncDial] stop];
  [[self noteLengthDial] stop];
  [[self triadDial] stop];
  [[self ghostsDial] stop];
  [[self overrideDial] stop];
}


- (void)runToken:(ELPlayhead *)playhead {
  int velocity;
  
  if( [[self layer] firstBeatInBar] ) {
    velocity = [[self emphasisDial] value];
  } else {
    velocity = [[self velocityDial] value];
  }
  
  ELCell *position = [playhead position];
  int triad = [[self triadDial] value];
  ELPlayable *playable;
  
  if( triad == 0 ) {
    playable = [position note];
  } else {
    playable = [position triad:triad];
  }
  
  int beats = 1 + [[self ghostsDial] value];
  int offset = 0;
  for( int b = 0; b < beats; b++ ) {
    if( [[self overrideDial] value] ) {
      int channel;
      for( channel = 1; channel <= 16; channel++ ) {
        ELDial *send = [[self channelSends] objectForKey:[[NSNumber numberWithInt:channel] stringValue]];
        if( [send boolValue] ) {
          [playable playOnChannel:[send tag] duration:[[self noteLengthDial] value] velocity:velocity transpose:[[[self layer] transposeDial] value] offset:offset];
        }
      }
    } else {
      [playable playOnChannel:[[[self layer] channelDial] value] duration:[[self noteLengthDial] value] velocity:velocity transpose:[[[self layer] transposeDial] value] offset:offset];
    }
    
    offset += [[[self cell] layer] timerResolution];
  }
}


#pragma mark Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self cell] centre];
  float radius = [[self cell] radius];
  
  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  [symbolPath moveToPoint:NSMakePoint( centre.x - radius / 6, centre.y + radius / 5 )];
  [symbolPath lineToPoint:NSMakePoint( centre.x + radius / 4, centre.y )];
  [symbolPath lineToPoint:NSMakePoint( centre.x - radius / 6, centre.y - radius / 5 )];
  [symbolPath closePath];
  [symbolPath setLineWidth:2.0];
  
  [self setTokenDrawColor:_attributes_];
  
  [symbolPath stroke];
}


#pragma mark Implements NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  id copy = [super mutableCopyWithZone:zone];
  [copy setVelocityDial:[[self velocityDial] duplicateDial]];
  [copy setEmphasisDial:[[self emphasisDial] duplicateDial]];
  [copy setTempoSyncDial:[[self tempoSyncDial] duplicateDial]];
  [copy setNoteLengthDial:[[self noteLengthDial] duplicateDial]];
  [copy setTriadDial:[[self triadDial] duplicateDial]];
  [copy setGhostsDial:[[self ghostsDial] duplicateDial]];
  [copy setOverrideDial:[[self overrideDial] duplicateDial]];
  
  NSMutableDictionary *copySends = [NSMutableDictionary dictionary];
  for( NSString *key in [[self channelSends] allKeys] ) {
    [copySends setObject:[[[self channelSends] objectForKey:key] duplicateDial] forKey:key];
  }
  [copy setChannelSends:copySends];
  
  return copy;
}

#pragma mark Implements ELXmlData

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[[self velocityDial] xmlRepresentation]];
  [controlsElement addChild:[[self emphasisDial] xmlRepresentation]];
  [controlsElement addChild:[[self tempoSyncDial] xmlRepresentation]];
  [controlsElement addChild:[[self noteLengthDial] xmlRepresentation]];
  [controlsElement addChild:[[self triadDial] xmlRepresentation]];
  [controlsElement addChild:[[self ghostsDial] xmlRepresentation]];
  [controlsElement addChild:[[self overrideDial] xmlRepresentation]];
  for( ELDial *dial in [[self channelSends] allValues] ) {
    [controlsElement addChild:[dial xmlRepresentation]];
  }
  
  return controlsElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    NSArray *nodes;
    
    [self setVelocityDial:[representation loadDial:@"velocity" parent:nil player:player error:error]];
    [self setEmphasisDial:[representation loadDial:@"emphasis" parent:nil player:player error:error]];
    [self setTempoSyncDial:[representation loadDial:@"tempoSync" parent:nil player:player error:error]];
    [self setNoteLengthDial:[representation loadDial:@"noteLength" parent:nil player:player error:error]];
    [self setTriadDial:[representation loadDial:@"triad" parent:nil player:player error:error]];
    [self setGhostsDial:[representation loadDial:@"ghosts" parent:nil player:player error:error]];
    [self setOverrideDial:[representation loadDial:@"override" parent:nil player:player error:error]];
    
    if( ( nodes = [representation nodesForXPath:@"controls/dial[starts-with(@name,'send')]" error:error] ) ) {
      NSMutableDictionary *sends = [NSMutableDictionary dictionary];
      for( NSXMLNode *node in nodes ) {
        ELDial *dial = [[ELDial alloc] initWithXmlRepresentation:((NSXMLElement *)node) parent:nil player:player error:error];
        [sends setObject:dial forKey:[[NSNumber numberWithInteger:[dial tag]] stringValue]];
      }
      [self setChannelSends:sends];
    } else {
      return nil;
    }
  }
  
  return self;
}


@end
