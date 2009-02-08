//
//  ELNoteTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELTool.h"
#import "ELNoteTool.h"

#import "ELHex.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayable.h"
#import "ELNoteGroup.h"
#import "ELPlayhead.h"

NSDictionary *defaultChannelSends( void ) {
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

@implementation ELNoteTool

+ (NSString *)tokenType {
  return @"note";
}

- (id)initWithVelocityDial:(ELDial *)newVelocityDial
              emphasisDial:(ELDial *)newEmphasisDial
             tempoSyncDial:(ELDial *)newTempoSyncDial
            noteLengthDial:(ELDial *)newNoteLengthDial
                 triadDial:(ELDial *)newTriadDial
                ghostsDial:(ELDial *)newGhostsDial
              overrideDial:(ELDial *)newOverrideDial
              channelSends:(NSDictionary *)newChannelSends
{
  if( ( self = [super init] ) ) {
    [self setVelocityDial:newVelocityDial];
    [self setEmphasisDial:newEmphasisDial];
    [self setTempoSyncDial:newTempoSyncDial];
    [self setNoteLengthDial:newNoteLengthDial];
    [self setTriadDial:newTriadDial];
    [self setGhostsDial:newGhostsDial];
    [self setOverrideDial:newOverrideDial];
    [self setChannelSends:newChannelSends];
  }
  
  return self;
}

- (id)init {
  return [self initWithVelocityDial:[ELPlayer defaultVelocityDial]
                       emphasisDial:[ELPlayer defaultEmphasisDial]
                      tempoSyncDial:[ELPlayer defaultTempoSyncDial]
                     noteLengthDial:[ELPlayer defaultNoteLengthDial]
                          triadDial:[ELPlayer defaultTriadDial]
                         ghostsDial:[ELPlayer defaultGhostsDial]
                       overrideDial:[ELPlayer defaultOverrideDial]
                       channelSends:defaultChannelSends()];
}

#pragma mark Dials

@dynamic velocityDial;

- (ELDial *)velocityDial {
  return velocityDial;
}

- (void)setVelocityDial:(ELDial *)newVelocityDial {
  velocityDial = newVelocityDial;
  [velocityDial setDelegate:self];
}

@dynamic emphasisDial;

- (ELDial *)emphasisDial {
  return emphasisDial;
}

- (void)setEmphasisDial:(ELDial *)newEmphasisDial {
  emphasisDial = newEmphasisDial;
  [emphasisDial setDelegate:self];
}

@dynamic tempoSyncDial;

- (ELDial *)tempoSyncDial {
  return tempoSyncDial;
}

- (void)setTempoSyncDial:(ELDial *)newTempoSyncDial {
  tempoSyncDial = newTempoSyncDial;
  [tempoSyncDial setDelegate:self];
}

@dynamic noteLengthDial;

- (ELDial *)noteLengthDial {
  return noteLengthDial;
}

- (void)setNoteLengthDial:(ELDial *)newNoteLengthDial {
  noteLengthDial = newNoteLengthDial;
  [noteLengthDial setDelegate:self];
}

@dynamic triadDial;

- (ELDial *)triadDial {
  return triadDial;
}

- (void)setTriadDial:(ELDial *)newTriadDial {
  triadDial = newTriadDial;
  [triadDial setDelegate:self];
}

@dynamic ghostsDial;

- (ELDial *)ghostsDial {
  return ghostsDial;
}

- (void)setGhostsDial:(ELDial *)newGhostsDial {
  ghostsDial = newGhostsDial;
  [ghostsDial setDelegate:self];
}

@dynamic overrideDial;

- (ELDial *)overrideDial {
  return overrideDial;
}

- (void)setOverrideDial:(ELDial *)newOverrideDial {
  overrideDial = newOverrideDial;
  [overrideDial setDelegate:self];
}

@synthesize channelSends;

#pragma mark Layer support

- (void)addedToLayer:(ELLayer *)_layer_ atPosition:(ELHex *)_hex_ {
  [super addedToLayer:_layer_ atPosition:_hex_];
  
  if( !loaded ) {
    [velocityDial setParent:[_layer_ velocityDial]];
    [velocityDial setMode:dialInherited];
    
    [emphasisDial setParent:[_layer_ emphasisDial]];
    [emphasisDial setMode:dialInherited];
    
    [tempoSyncDial setParent:[_layer_ tempoSyncDial]];
    [tempoSyncDial setMode:dialInherited];
    [noteLengthDial setParent:[_layer_ noteLengthDial]];
    [noteLengthDial setMode:dialInherited];
  }
}

- (void)removedFromLayer:(ELLayer *)_layer_ {
  [super removedFromLayer:_layer_];
  
  [velocityDial setParent:nil];
  [emphasisDial setParent:nil];
  [tempoSyncDial setParent:nil];
  [noteLengthDial setParent:nil];
}

- (void)start {
  [super start];
  
  [velocityDial onStart];
  [emphasisDial onStart];
  [tempoSyncDial onStart];
  [noteLengthDial onStart];
  [triadDial onStart];
  [ghostsDial onStart];
  [overrideDial onStart];
}

// Tool runner

- (void)runTool:(ELPlayhead *)_playhead_ {
  int velocity;
  
  if( [layer firstBeatInBar] ) {
    velocity = [emphasisDial value];
  } else {
    velocity = [velocityDial value];
  }
  
  ELHex *position = [_playhead_ position];
  int triad = [triadDial value];
  ELPlayable *playable;
  
  if( triad == 0 ) {
    playable = [position note];
  } else {
    playable = [position triad:triad];
  }
  
  int beats = 1 + [ghostsDial value];
  int offset = 0;
  for( int b = 0; b < beats; b++ ) {
    if( [overrideDial value] ) {
      int channel;
      for( channel = 1; channel <= 16; channel++ ) {
        ELDial *send = [channelSends objectForKey:[[NSNumber numberWithInt:channel] stringValue]];
        if( [send boolValue] ) {
          [playable playOnChannel:[send tag] duration:[noteLengthDial value] velocity:velocity transpose:[[layer transposeDial] value] offset:offset];
        }
      }
    } else {
      [playable playOnChannel:[[layer channelDial] value] duration:[noteLengthDial value] velocity:velocity transpose:[[layer transposeDial] value] offset:offset];
    }
    
    offset += [[hex layer] timerResolution];
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];
  
  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  [symbolPath moveToPoint:NSMakePoint( centre.x - radius / 6, centre.y + radius / 5 )];
  [symbolPath lineToPoint:NSMakePoint( centre.x + radius / 4, centre.y )];
  [symbolPath lineToPoint:NSMakePoint( centre.x - radius / 6, centre.y - radius / 5 )];
  [symbolPath closePath];
  [symbolPath setLineWidth:2.0];
  
  [self setToolDrawColor:_attributes_];
  
  [symbolPath stroke];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setVelocityDial:[[self velocityDial] mutableCopy]];
  [copy setEmphasisDial:[[self emphasisDial] mutableCopy]];
  [copy setTempoSyncDial:[[self tempoSyncDial] mutableCopy]];
  [copy setNoteLengthDial:[[self noteLengthDial] mutableCopy]];
  [copy setTriadDial:[[self triadDial] mutableCopy]];
  [copy setGhostsDial:[[self ghostsDial] mutableCopy]];
  [copy setOverrideDial:[[self overrideDial] mutableCopy]];
  
  NSMutableDictionary *copySends = [NSMutableDictionary dictionary];
  for( NSString *key in [channelSends allKeys] ) {
    [copySends setObject:[[channelSends objectForKey:key] mutableCopy] forKey:key];
  }
  [copy setChannelSends:copySends];
  
  return copy;
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[velocityDial xmlRepresentation]];
  [controlsElement addChild:[emphasisDial xmlRepresentation]];
  [controlsElement addChild:[tempoSyncDial xmlRepresentation]];
  [controlsElement addChild:[noteLengthDial xmlRepresentation]];
  [controlsElement addChild:[triadDial xmlRepresentation]];
  [controlsElement addChild:[ghostsDial xmlRepresentation]];
  [controlsElement addChild:[overrideDial xmlRepresentation]];
  for( ELDial *dial in [channelSends allValues] ) {
    [controlsElement addChild:[dial xmlRepresentation]];
  }
  
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    NSArray *nodes;
    
    [self setVelocityDial:[_representation_ loadDial:@"velocity" parent:nil player:_player_ error:_error_]];
    [self setEmphasisDial:[_representation_ loadDial:@"emphasis" parent:nil player:_player_ error:_error_]];
    [self setTempoSyncDial:[_representation_ loadDial:@"tempoSync" parent:nil player:_player_ error:_error_]];
    [self setNoteLengthDial:[_representation_ loadDial:@"noteLength" parent:nil player:_player_ error:_error_]];
    [self setTriadDial:[_representation_ loadDial:@"triad" parent:nil player:_player_ error:_error_]];
    [self setGhostsDial:[_representation_ loadDial:@"ghosts" parent:nil player:_player_ error:_error_]];
    [self setOverrideDial:[_representation_ loadDial:@"override" parent:nil player:_player_ error:_error_]];
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[starts-with(@name,'send')]" error:_error_] ) ) {
      NSMutableDictionary *sends = [NSMutableDictionary dictionary];
      for( NSXMLNode *node in nodes ) {
        ELDial *dial = [[ELDial alloc] initWithXmlRepresentation:((NSXMLElement *)node) parent:nil player:_player_ error:_error_];
        [sends setObject:dial forKey:[[NSNumber numberWithInteger:[dial tag]] stringValue]];
      }
      channelSends = sends;
    } else {
      return nil;
    }
  }
  
  return self;
}

@end
