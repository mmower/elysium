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


@interface ELNoteToken (PrivateMethods)

- (void)runWithOverrides:(ELPlayable *)playable velocity:(int)velocity offset:(int)offset;
- (void)runNormal:(ELPlayable *)playable velocity:(int)velocty offset:(int)offset;
- (void)playOnChannel:(ELPlayable *)playable channel:(int)channel velocity:(int)velocity offset:(int)offset;

@end


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
         chan1OverrideDial:(ELDial *)chan1OverrideDial
         chan2OverrideDial:(ELDial *)chan2OverrideDial
         chan3OverrideDial:(ELDial *)chan3OverrideDial
         chan4OverrideDial:(ELDial *)chan4OverrideDial
         chan5OverrideDial:(ELDial *)chan5OverrideDial
         chan6OverrideDial:(ELDial *)chan6OverrideDial
         chan7OverrideDial:(ELDial *)chan7OverrideDial
         chan8OverrideDial:(ELDial *)chan8OverrideDial
{
  if( ( self = [super init] ) ) {
    [self setVelocityDial:velocityDial];
    [self setEmphasisDial:emphasisDial];
    [self setTempoSyncDial:tempoSyncDial];
    [self setNoteLengthDial:noteLengthDial];
    [self setTriadDial:triadDial];
    [self setGhostsDial:ghostsDial];
    [self setOverrideDial:overrideDial];
    [self setChan1OverrideDial:chan1OverrideDial];
    [self setChan2OverrideDial:chan2OverrideDial];
    [self setChan3OverrideDial:chan3OverrideDial];
    [self setChan4OverrideDial:chan4OverrideDial];
    [self setChan5OverrideDial:chan5OverrideDial];
    [self setChan6OverrideDial:chan6OverrideDial];
    [self setChan7OverrideDial:chan7OverrideDial];
    [self setChan8OverrideDial:chan8OverrideDial];
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
                  chan1OverrideDial:[ELDialBank defaultChannelOverrideDial:1]
                  chan2OverrideDial:[ELDialBank defaultChannelOverrideDial:2]
                  chan3OverrideDial:[ELDialBank defaultChannelOverrideDial:3]
                  chan4OverrideDial:[ELDialBank defaultChannelOverrideDial:4]
                  chan5OverrideDial:[ELDialBank defaultChannelOverrideDial:5]
                  chan6OverrideDial:[ELDialBank defaultChannelOverrideDial:6]
                  chan7OverrideDial:[ELDialBank defaultChannelOverrideDial:7]
                  chan8OverrideDial:[ELDialBank defaultChannelOverrideDial:8]];
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


@synthesize chan1OverrideDial = _chan1OverrideDial;

- (void)setChan1OverrideDial:(ELDial *)chan1OverrideDial {
  _chan1OverrideDial = chan1OverrideDial;
  [_chan1OverrideDial setDelegate:self];
}


@synthesize chan2OverrideDial = _chan2OverrideDial;

- (void)setChan2OverrideDial:(ELDial *)chan2OverrideDial {
  _chan2OverrideDial = chan2OverrideDial;
  [_chan2OverrideDial setDelegate:self];
}


@synthesize chan3OverrideDial = _chan3OverrideDial;

- (void)setChan3OverrideDial:(ELDial *)chan3OverrideDial {
  _chan3OverrideDial = chan3OverrideDial;
  [_chan3OverrideDial setDelegate:self];
}


@synthesize chan4OverrideDial = _chan4OverrideDial;

- (void)setChan4OverrideDial:(ELDial *)chan4OverrideDial {
  _chan4OverrideDial = chan4OverrideDial;
  [_chan4OverrideDial setDelegate:self];
}


@synthesize chan5OverrideDial = _chan5OverrideDial;

- (void)setChan5OverrideDial:(ELDial *)chan5OverrideDial {
  _chan5OverrideDial = chan5OverrideDial;
  [_chan5OverrideDial setDelegate:self];
}


@synthesize chan6OverrideDial = _chan6OverrideDial;

- (void)setChan6OverrideDial:(ELDial *)chan6OverrideDial {
  _chan6OverrideDial = chan6OverrideDial;
  [_chan6OverrideDial setDelegate:self];
}


@synthesize chan7OverrideDial = _chan7OverrideDial;

- (void)setChan7OverrideDial:(ELDial *)chan7OverrideDial {
  _chan7OverrideDial = chan7OverrideDial;
  [_chan7OverrideDial setDelegate:self];
}


@synthesize chan8OverrideDial = _chan8OverrideDial;

- (void)setChan8OverrideDial:(ELDial *)chan8OverrideDial {
  _chan8OverrideDial = chan8OverrideDial;
  [_chan8OverrideDial setDelegate:self];
}


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
  
  [[self chan1OverrideDial] start];
  [[self chan2OverrideDial] start];
  [[self chan3OverrideDial] start];
  [[self chan4OverrideDial] start];
  [[self chan5OverrideDial] start];
  [[self chan6OverrideDial] start];
  [[self chan7OverrideDial] start];
  [[self chan8OverrideDial] start];
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
  
  [[self chan1OverrideDial] stop];
  [[self chan2OverrideDial] stop];
  [[self chan3OverrideDial] stop];
  [[self chan4OverrideDial] stop];
  [[self chan5OverrideDial] stop];
  [[self chan6OverrideDial] stop];
  [[self chan7OverrideDial] stop];
  [[self chan8OverrideDial] stop];
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
      [self runWithOverrides:playable velocity:velocity offset:offset];
    } else {
      [self runNormal:playable velocity:velocity offset:offset];
    }
    
    offset += [[[self cell] layer] timerResolution];
  }
}


- (void)runWithOverrides:(ELPlayable *)playable velocity:(int)velocity offset:(int)offset {
  if( [[self chan1OverrideDial] pTest] ) {
    [self playOnChannel:playable channel:1 velocity:velocity offset:offset];
  }
  if( [[self chan2OverrideDial] pTest] ) {
    [self playOnChannel:playable channel:2 velocity:velocity offset:offset];
  }
  if( [[self chan3OverrideDial] pTest] ) {
    [self playOnChannel:playable channel:3 velocity:velocity offset:offset];
  }
  if( [[self chan4OverrideDial] pTest] ) {
    [self playOnChannel:playable channel:4 velocity:velocity offset:offset];
  }
  if( [[self chan5OverrideDial] pTest] ) {
    [self playOnChannel:playable channel:5 velocity:velocity offset:offset];
  }
  if( [[self chan6OverrideDial] pTest] ) {
    [self playOnChannel:playable channel:6 velocity:velocity offset:offset];
  }
  if( [[self chan7OverrideDial] pTest] ) {
    [self playOnChannel:playable channel:7 velocity:velocity offset:offset];
  }
  if( [[self chan8OverrideDial] pTest] ) {
    [self playOnChannel:playable channel:8 velocity:velocity offset:offset];
  }
}


- (void)runNormal:(ELPlayable *)playable velocity:(int)velocity offset:(int)offset {
  [self playOnChannel:playable channel:[[[self layer] channelDial] value] velocity:velocity offset:offset];
}


- (void)playOnChannel:(ELPlayable *)playable channel:(int)channel velocity:(int)velocity offset:(int)offset {
  [playable playOnChannel:channel duration:[[self noteLengthDial] value] velocity:velocity transpose:[[[self layer] transposeDial] value] offset:offset];
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
  [copy setChan1OverrideDial:[[self chan1OverrideDial] duplicateDial]];
  [copy setChan2OverrideDial:[[self chan2OverrideDial] duplicateDial]];
  [copy setChan3OverrideDial:[[self chan3OverrideDial] duplicateDial]];
  [copy setChan4OverrideDial:[[self chan4OverrideDial] duplicateDial]];
  [copy setChan5OverrideDial:[[self chan5OverrideDial] duplicateDial]];
  [copy setChan6OverrideDial:[[self chan6OverrideDial] duplicateDial]];
  [copy setChan7OverrideDial:[[self chan7OverrideDial] duplicateDial]];
  [copy setChan8OverrideDial:[[self chan8OverrideDial] duplicateDial]];
  
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
  [controlsElement addChild:[[self chan1OverrideDial] xmlRepresentation]];
  [controlsElement addChild:[[self chan2OverrideDial] xmlRepresentation]];
  [controlsElement addChild:[[self chan3OverrideDial] xmlRepresentation]];
  [controlsElement addChild:[[self chan4OverrideDial] xmlRepresentation]];
  [controlsElement addChild:[[self chan5OverrideDial] xmlRepresentation]];
  [controlsElement addChild:[[self chan6OverrideDial] xmlRepresentation]];
  [controlsElement addChild:[[self chan7OverrideDial] xmlRepresentation]];
  [controlsElement addChild:[[self chan8OverrideDial] xmlRepresentation]];
  
  return controlsElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    [self setVelocityDial:[representation loadDial:@"velocity" parent:nil player:player error:error]];
    [self setEmphasisDial:[representation loadDial:@"emphasis" parent:nil player:player error:error]];
    [self setTempoSyncDial:[representation loadDial:@"tempoSync" parent:nil player:player error:error]];
    [self setNoteLengthDial:[representation loadDial:@"noteLength" parent:nil player:player error:error]];
    [self setTriadDial:[representation loadDial:@"triad" parent:nil player:player error:error]];
    [self setGhostsDial:[representation loadDial:@"ghosts" parent:nil player:player error:error]];
    [self setOverrideDial:[representation loadDial:@"override" parent:nil player:player error:error]];
    
    [self setChan1OverrideDial:[representation loadDial:@"chan1Override" parent:nil player:player error:error]];
    [self setChan2OverrideDial:[representation loadDial:@"chan2Override" parent:nil player:player error:error]];
    [self setChan3OverrideDial:[representation loadDial:@"chan3Override" parent:nil player:player error:error]];
    [self setChan4OverrideDial:[representation loadDial:@"chan4Override" parent:nil player:player error:error]];
    [self setChan5OverrideDial:[representation loadDial:@"chan5Override" parent:nil player:player error:error]];
    [self setChan6OverrideDial:[representation loadDial:@"chan6Override" parent:nil player:player error:error]];
    [self setChan7OverrideDial:[representation loadDial:@"chan7Override" parent:nil player:player error:error]];
    [self setChan8OverrideDial:[representation loadDial:@"chan8Override" parent:nil player:player error:error]];
  }
  
  return self;
}


@end
