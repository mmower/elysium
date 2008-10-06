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
#import "ELPlayhead.h"

static NSString * const toolType = @"note";

@implementation ELNoteTool

- (id)initWithVelocityKnob:(ELIntegerKnob *)_velocityKnob_ durationKnob:(ELFloatKnob *)_durationKnob_ triadKnob:(ELIntegerKnob *)_triadKnob_ {
  if( ( self = [super init] ) ) {
    velocityKnob = _velocityKnob_;
    durationKnob = _durationKnob_;
    triadKnob    = _triadKnob_;
  }
  
  return self;
}

- (id)init {
  return [self initWithVelocityKnob:[[ELIntegerKnob alloc] initWithName:@"velocity"]
                       durationKnob:[[ELFloatKnob alloc] initWithName:@"duration"]
                          triadKnob:[[ELIntegerKnob alloc] initWithName:@"triad" integerValue:0]];
}

- (NSString *)toolType {
  return toolType;
}

@synthesize velocityKnob;
@synthesize durationKnob;
@synthesize triadKnob;

- (void)addedToLayer:(ELLayer *)_layer_ atPosition:(ELHex *)_hex_ {
  [super addedToLayer:_layer_ atPosition:_hex_];
  
  [velocityKnob setValue:[[_layer_ velocityKnob] value]];
  [velocityKnob setLinkedKnob:[_layer_ velocityKnob]];
  [velocityKnob setLinkValue:YES];
  
  [durationKnob setValue:[[_layer_ durationKnob] value]];
  [durationKnob setLinkedKnob:[_layer_ durationKnob]];
  [durationKnob setLinkValue:YES];
}

- (void)removedFromLayer:(ELLayer *)_layer_ {
  [super removedFromLayer:_layer_];
  
  [velocityKnob setLinkedKnob:nil];
  [durationKnob setLinkedKnob:nil];
}

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"velocityKnob.value",@"durationKnob.value",@"triadKnob.value",nil]];
  return keys;
}

// Tool runner

- (void)runTool:(ELPlayhead *)_playhead_ {
  [layer playNotes:[[_playhead_ position] triad:[triadKnob value]]
          velocity:[velocityKnob filteredValue]
          duration:[durationKnob filteredValue]];
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
  
  [[_attributes_ objectForKey:ELDefaultToolColor] set];
  
  [symbolPath stroke];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithVelocityKnob:[velocityKnob mutableCopy] durationKnob:[durationKnob mutableCopy] triadKnob:[triadKnob mutableCopy]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[durationKnob xmlRepresentation]];
  [controlsElement addChild:[triadKnob xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self initWithVelocityKnob:nil durationKnob:nil triadKnob:nil] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      velocityKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] velocityKnob] player:_player_];
    } else {
      velocityKnob = [[ELIntegerKnob alloc] initWithName:@"velocity" integerValue:100];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      durationKnob = [[ELFloatKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] durationKnob] player:_player_];
    } else {
      durationKnob = [[ELFloatKnob alloc] initWithName:@"duration" floatValue:0.5];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='triad']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      triadKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_];
    } else {
      triadKnob = [[ELIntegerKnob alloc] initWithName:@"triad" integerValue:0];
    }
    
    [self loadScripts:_representation_];
  }
  
  return self;
}

@end
