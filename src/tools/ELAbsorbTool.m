//
//  ELSinkTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELAbsorbTool.h"

#import "ELHex.h"
#import "ELPlayhead.h"

static NSString * const toolType = @"absorb";

@implementation ELAbsorbTool

- (NSString *)toolType {
  return toolType;
}

- (void)runTool:(ELPlayhead *)_playhead_ {
  if( ![_playhead_ isNew] ) {
    [_playhead_ kill];
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];
  
  NSBezierPath *symbolPath;
  [self setToolDrawColor:_attributes_];
  symbolPath = [NSBezierPath bezierPathWithRect:NSMakeRect( centre.x - radius/3, centre.y - radius/3, 2*radius/3, 2*radius/3 )];
  [symbolPath setLineWidth:2.0];
  [symbolPath stroke];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] init];
}

// Implement the ELXmlData protocol

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self init] ) ) {
    [self loadScripts:_representation_];
  }
  
  return self;
}

@end
