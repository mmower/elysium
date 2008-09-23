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

- (id)initWithVelocityKnob:(ELIntegerKnob *)_velocityKnob_ durationKnob:(ELFloatKnob *)_durationKnob_ {
  if( ( self = [super init] ) ) {
    velocityKnob = _velocityKnob_;
    durationKnob = _durationKnob_;
  }
  
  return self;
}

- (id)init {
  return [self initWithVelocityKnob:[[ELIntegerKnob alloc] initWithName:@"velocity"]
                       durationKnob:[[ELFloatKnob alloc] initWithName:@"duration"]];
}

- (NSString *)toolType {
  return toolType;
}

@synthesize velocityKnob;
@synthesize durationKnob;

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
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"velocityKnob.value",@"durationKnob.value",nil]];
  return keys;
}

// Tool runner

- (BOOL)run:(ELPlayhead *)_playhead_ {
  if( [super run:_playhead_] ) {
    [layer playNote:[[_playhead_ position] note]
           velocity:[velocityKnob filteredValue]
           duration:[durationKnob filteredValue]];
    return YES;
  } else {
    return NO;
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
  
  [[_attributes_ objectForKey:ELDefaultToolColor] set];
  
  [symbolPath stroke];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithVelocityKnob:[velocityKnob mutableCopy] durationKnob:[durationKnob mutableCopy]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *noteElement = [NSXMLNode elementWithName:toolType];
  
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[durationKnob xmlRepresentation]];
  [noteElement addChild:controlsElement];
  
  return noteElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ {
  if( ( self = [self initWithVelocityKnob:nil durationKnob:nil] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    velocityKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] velocityKnob]];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    durationKnob = [[ELFloatKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] durationKnob]];
  }
  
  return self;
}

// // Save/Load support
// 
// - (void)saveToolConfig:(NSMutableDictionary *)_attributes_ {
//   // if( [config definesValueForKey:@"velocity"] ) {
//   //   [_attributes_ setObject:[config stringForKey:@"velocity"] forKey:@"velocity"];
//   // }
//   // if( [config definesValueForKey:@"duration"] ) {
//   //   [_attributes_ setObject:[config stringForKey:@"duration"] forKey:@"duration"];
//   // }
// }
// 
// - (BOOL)loadToolConfig:(NSXMLElement *)_xml_ {
//   // NSXMLNode *node;
//   // 
//   // node = [_xml_ attributeForName:@"velocity"];
//   // if( node ) {
//   //   [self setVelocity:[[node stringValue] intValue]];
//   // }
//   // 
//   // node = [_xml_ attributeForName:@"duration"];
//   // if( node ) {
//   //   [self setDuration:[[node stringValue] floatValue]];
//   // }
//   // 
//   return YES;
// }

@end
