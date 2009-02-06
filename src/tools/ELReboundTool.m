//
//  ELReboundTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELReboundTool.h"

#import "ELHex.h"
#import "ELPlayhead.h"

@implementation ELReboundTool

+ (NSString *)tokenType {
  return @"rebound";
}

- (id)initWithDirectionDial:(ELDial *)newDirectionDial {
  if( ( self = [super init] ) ) {
    [self setDirectionDial:newDirectionDial];
  }
  
  return self;
}

- (id)init {
  return [self initWithDirectionDial:[[ELDial alloc] initWithName:@"direction"
                                                              tag:0
                                                         assigned:N
                                                              min:0
                                                              max:5
                                                             step:1]];
}

@dynamic directionDial;

- (ELDial *)directionDial {
  return directionDial;
}

- (void)setDirectionDial:(ELDial *)newDirectionDial {
  directionDial = newDirectionDial;
  [directionDial setDelegate:self];
}

// - (NSArray *)observableValues {
//   NSMutableArray *keys = [[NSMutableArray alloc] init];
//   [keys addObjectsFromArray:[super observableValues]];
//   [keys addObjectsFromArray:[NSArray arrayWithObjects:@"directionDial.value",nil]];
//   return keys;
// }

- (void)start {
  [super start];
  
  [directionDial onStart];
}

// Tool runner

- (void)runTool:(ELPlayhead *)_playhead_ {
  [_playhead_ setDirection:[directionDial value]];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  [self setToolDrawColor:_attributes_];
  [[self hex] drawTriangleInDirection:[directionDial value] withAttributes:_attributes_];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setDirectionDial:[[self directionDial] mutableCopy]];
  return copy;
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[directionDial xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    [self setDirectionDial:[_representation_ loadDial:@"direction" parent:nil player:_player_ error:_error_]];
  }
  
  return self;
}

@end
