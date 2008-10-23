//
//  ELNoteTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELTool.h"
#import "ELNoteTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayable.h"
#import "ELPlayhead.h"

static NSString * const toolType = @"note";

@implementation ELNoteTool

- (id)initWithVelocityKnob:(ELIntegerKnob *)_velocityKnob_ emphasisKnob:(ELIntegerKnob *)_emphasisKnob_ durationKnob:(ELFloatKnob *)_durationKnob_ triadKnob:(ELIntegerKnob *)_triadKnob_ {
  if( ( self = [super init] ) ) {
    velocityKnob = _velocityKnob_;
    emphasisKnob = _emphasisKnob_;
    durationKnob = _durationKnob_;
    triadKnob    = _triadKnob_;
  }
  
  return self;
}

- (id)init {
  return [self initWithVelocityKnob:[[ELIntegerKnob alloc] initWithName:@"velocity"]
                       emphasisKnob:[[ELIntegerKnob alloc] initWithName:@"emphasis"]
                       durationKnob:[[ELFloatKnob alloc] initWithName:@"duration"]
                          triadKnob:[[ELIntegerKnob alloc] initWithName:@"triad" integerValue:0 minimum:0 maximum:6 stepping:1]];
}

- (NSString *)toolType {
  return toolType;
}

@synthesize velocityKnob;
@synthesize emphasisKnob;
@synthesize durationKnob;
@synthesize triadKnob;

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
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"velocityKnob.value",@"emphasisKnob.value",@"durationKnob.value",@"triadKnob.value",nil]];
  return keys;
}

// Tool runner

- (void)runTool:(ELPlayhead *)_playhead_ {
  int velocity;
  
  if( [layer firstBeatInBar] ) {
    velocity = [emphasisKnob filteredValue];
  } else {
    velocity = [velocityKnob filteredValue];
  }
  
  int triad = [triadKnob value];
  if( triad == 0 ) {
    [[[_playhead_ position] note] playOnChannel:[[layer channelKnob] value] duration:[durationKnob filteredValue] velocity:velocity transpose:[[layer transposeKnob] value]];
  } else {
    [[[_playhead_ position] triad:triad] playOnChannel:[[layer channelKnob] value] duration:[durationKnob filteredValue] velocity:velocity transpose:[[layer transposeKnob] value]];
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
  return [[[self class] allocWithZone:_zone_] initWithVelocityKnob:[velocityKnob mutableCopy] emphasisKnob:[emphasisKnob mutableCopy] durationKnob:[durationKnob mutableCopy] triadKnob:[triadKnob mutableCopy]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[emphasisKnob xmlRepresentation]];
  [controlsElement addChild:[durationKnob xmlRepresentation]];
  [controlsElement addChild:[triadKnob xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self initWithVelocityKnob:nil emphasisKnob:nil durationKnob:nil triadKnob:nil] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    [self loadIsEnabled:_representation_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      velocityKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] velocityKnob] player:_player_];
    } else {
      velocityKnob = [[ELIntegerKnob alloc] initWithName:@"velocity"];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='emphasis']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      emphasisKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] velocityKnob] player:_player_];
    } else {
      emphasisKnob = [[ELIntegerKnob alloc] initWithName:@"emphasis"];
    }
    
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      durationKnob = [[ELFloatKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] durationKnob] player:_player_];
    } else {
      durationKnob = [[ELFloatKnob alloc] initWithName:@"duration"];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='triad']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      triadKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_];
    } else {
      triadKnob = [[ELIntegerKnob alloc] initWithName:@"triad" integerValue:0 minimum:0 maximum:6 stepping:1];
    }
    
    [self loadScripts:_representation_];
  }
  
  return self;
}

@end
