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
#import "ELPlayable.h"
#import "ELNoteGroup.h"
#import "ELPlayhead.h"

static NSString * const toolType = @"note";

@implementation ELNoteTool

NSDictionary *defaultChannelSends( void ) {
  NSMutableDictionary *sends = [NSMutableDictionary dictionary];
  for( int i = 1; i <= 16; i++ ) {
    ELBooleanKnob *knob = [[ELBooleanKnob alloc] initWithName:[NSString stringWithFormat:@"send%d",i] booleanValue:NO];
    [knob setTag:i];
    [sends setObject:knob forKey:[[NSNumber numberWithInteger:[knob tag]] stringValue]];
  }
  return sends;
}

- (id)initWithVelocityKnob:(ELIntegerKnob *)_velocityKnob_
              emphasisKnob:(ELIntegerKnob *)_emphasisKnob_
              durationKnob:(ELFloatKnob *)_durationKnob_
                 triadKnob:(ELIntegerKnob *)_triadKnob_
                ghostsKnob:(ELIntegerKnob *)_ghostsKnob_
              overrideKnob:(ELBooleanKnob *)_overrideKnob_
              channelSends:(NSDictionary *)_channelSends_ {
  if( ( self = [super init] ) ) {
    velocityKnob = _velocityKnob_;
    emphasisKnob = _emphasisKnob_;
    durationKnob = _durationKnob_;
    triadKnob    = _triadKnob_;
    ghostsKnob   = _ghostsKnob_;
    overrideKnob = _overrideKnob_;
    channelSends = _channelSends_;
  }
  
  return self;
}

- (id)init {
  return [self initWithVelocityKnob:[[ELIntegerKnob alloc] initWithName:@"velocity"]
                       emphasisKnob:[[ELIntegerKnob alloc] initWithName:@"emphasis"]
                       durationKnob:[[ELFloatKnob alloc] initWithName:@"duration"]
                          triadKnob:[[ELIntegerKnob alloc] initWithName:@"triad" integerValue:0 minimum:0 maximum:6 stepping:1]
                         ghostsKnob:[[ELIntegerKnob alloc] initWithName:@"ghosts" integerValue:0 minimum:0 maximum:16 stepping:1]
                       overrideKnob:[[ELBooleanKnob alloc] initWithName:@"override" booleanValue:NO]
                       channelSends:defaultChannelSends()];
}

- (NSString *)toolType {
  return toolType;
}

@synthesize velocityKnob;
@synthesize emphasisKnob;
@synthesize durationKnob;
@synthesize triadKnob;
@synthesize ghostsKnob;
@synthesize overrideKnob;
@synthesize channelSends;

- (void)addedToLayer:(ELLayer *)_layer_ atPosition:(ELHex *)_hex_ {
  [super addedToLayer:_layer_ atPosition:_hex_];
  
  [velocityKnob setValue:[[_layer_ velocityKnob] value]];
  [velocityKnob setLinkedKnob:[_layer_ velocityKnob]];
  [velocityKnob setLinkValue:YES];
  
  [emphasisKnob setValue:[[_layer_ emphasisKnob] value]];
  [emphasisKnob setLinkedKnob:[_layer_ emphasisKnob]];
  [emphasisKnob setLinkValue:YES];
  
  [durationKnob setValue:[[_layer_ durationKnob] value]];
  [durationKnob setLinkedKnob:[_layer_ durationKnob]];
  [durationKnob setLinkValue:YES];
}

- (void)removedFromLayer:(ELLayer *)_layer_ {
  [super removedFromLayer:_layer_];
  
  [velocityKnob setLinkedKnob:nil];
  [emphasisKnob setLinkedKnob:nil];
  [durationKnob setLinkedKnob:nil];
}

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"velocityKnob.value",@"emphasisKnob.value",@"durationKnob.value",@"triadKnob.value",@"ghostsKnob.value",nil]];
  return keys;
}

- (void)start {
  [super start];
  
  [velocityKnob start];
  [emphasisKnob start];
  [durationKnob start];
  [triadKnob start];
  [ghostsKnob start];
  [overrideKnob start];
}

// Tool runner

- (void)runTool:(ELPlayhead *)_playhead_ {
  int velocity;
  
  if( [layer firstBeatInBar] ) {
    velocity = [emphasisKnob dynamicValue];
  } else {
    velocity = [velocityKnob dynamicValue];
  }
  
  ELHex *position = [_playhead_ position];
  int triad = [triadKnob value];
  ELPlayable *playable;
  
  if( triad == 0 ) {
    playable = [position note];
  } else {
    playable = [position triad:triad];
  }
  
  int beats = 1 + [ghostsKnob dynamicValue];
  int offset = 0;
  for( int b = 0; b < beats; b++ ) {
    if( [overrideKnob value] ) {
      int channel;
      for( channel = 1; channel <= 16; channel++ ) {
        ELBooleanKnob *send = [channelSends objectForKey:[[NSNumber numberWithInt:channel] stringValue]];
        if( [send value] ) {
          [playable playOnChannel:[send tag] duration:[durationKnob dynamicValue] velocity:velocity transpose:[[layer transposeKnob] dynamicValue] offset:offset];
        }
      }
    } else {
      [playable playOnChannel:[[layer channelKnob] value] duration:[durationKnob dynamicValue] velocity:velocity transpose:[[layer transposeKnob] dynamicValue] offset:offset];
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
  [copy setVelocityKnob:[[self velocityKnob] mutableCopy]];
  [copy setEmphasisKnob:[[self emphasisKnob] mutableCopy]];
  [copy setDurationKnob:[[self durationKnob] mutableCopy]];
  [copy setTriadKnob:[[self triadKnob] mutableCopy]];
  [copy setGhostsKnob:[[self ghostsKnob] mutableCopy]];
  [copy setOverrideKnob:[[self overrideKnob] mutableCopy]];
  
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
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[emphasisKnob xmlRepresentation]];
  [controlsElement addChild:[durationKnob xmlRepresentation]];
  [controlsElement addChild:[triadKnob xmlRepresentation]];
  [controlsElement addChild:[ghostsKnob xmlRepresentation]];
  [controlsElement addChild:[overrideKnob xmlRepresentation]];
  for( ELBooleanKnob *knob in [channelSends allValues] ) {
    [controlsElement addChild:[knob xmlRepresentation]];
  }
  
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        velocityKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] velocityKnob] player:_player_ error:_error_];
      } else {
        velocityKnob = [[ELIntegerKnob alloc] initWithName:@"velocity"];
      }
      
      if( velocityKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='emphasis']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        emphasisKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] velocityKnob] player:_player_ error:_error_];
      } else {
        emphasisKnob = [[ELIntegerKnob alloc] initWithName:@"emphasis"];
      }
      
      if( emphasisKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        durationKnob = [[ELFloatKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] durationKnob] player:_player_ error:_error_];
      } else {
        durationKnob = [[ELFloatKnob alloc] initWithName:@"duration"];
      }
      
      if( durationKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='triad']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        triadKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        triadKnob = [[ELIntegerKnob alloc] initWithName:@"triad" integerValue:0 minimum:0 maximum:6 stepping:1];
      }
      
      if( triadKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='ghosts']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        ghostsKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        ghostsKnob = [[ELIntegerKnob alloc] initWithName:@"ghost" integerValue:0 minimum:0 maximum:16 stepping:1];
      }
      
      if( ghostsKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='override']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        overrideKnob = [[ELBooleanKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        overrideKnob = [[ELBooleanKnob alloc] initWithName:@"override" booleanValue:NO];
      }
      
      if( overrideKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[starts-with(@name,'send')]" error:_error_] ) ) {
      NSMutableDictionary *sends = [NSMutableDictionary dictionary];
      for( NSXMLNode *node in nodes ) {
        ELBooleanKnob *knob = [[ELBooleanKnob alloc] initWithXmlRepresentation:((NSXMLElement *)node) parent:nil player:_player_ error:_error_];
        [sends setObject:knob forKey:[[NSNumber numberWithInteger:[knob tag]] stringValue]];
      }
      channelSends = sends;
    } else {
      return nil;
    }
  }
  
  return self;
}

@end
