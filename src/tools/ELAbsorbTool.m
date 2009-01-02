//
//  ELSinkTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
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

// Implement the ELXmlData protocol

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  return [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_];
}

@end
