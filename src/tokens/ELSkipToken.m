//
//  ELSkipToken.m
//  Elysium
//
//  Created by Matt Mower on 23/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELSkipToken.h"

#import "ELCell.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"

@implementation ELSkipToken

+ (NSString *)tokenType {
  return @"skip";
}


- (id)initWithSkipCountDial:(ELDial *)newSkipCountDial {
  if( ( self = [super init] ) ) {
    [self setSkipCountDial:newSkipCountDial];
  }
  
  return self;
}


- (id)init {
  return [self initWithSkipCountDial:[ELPlayer defaultSkipCountDial]];
}


@dynamic skipCountDial;

- (ELDial *)skipCountDial {
  return skipCountDial;
}


- (void)setSkipCountDial:(ELDial *)newSkipCountDial {
  skipCountDial = newSkipCountDial;
  [skipCountDial setDelegate:self];
}


#pragma mark ELTool implementation

- (void)drawWithAttributes:(NSDictionary *)drawingAttributes {
  [self setTokenDrawColor:drawingAttributes];
  
  NSPoint centre = [[self cell] centre];
  float radius = [[self cell] radius];
  
  NSBezierPath *hopPath = [NSBezierPath bezierPath];
  [hopPath moveToPoint:NSMakePoint( centre.x - radius / 1.8, centre.y - radius / 1.8 )];
  [hopPath lineToPoint:NSMakePoint( centre.x - radius / 2.8, centre.y - radius / 2.8 )];
  [hopPath lineToPoint:NSMakePoint( centre.x - radius / 2.8, centre.y + radius / 2.8 )];
  [hopPath lineToPoint:NSMakePoint( centre.x - radius / 1.8, centre.y + radius / 1.8 )];
  
  [hopPath moveToPoint:NSMakePoint( centre.x + radius / 1.8, centre.y - radius / 1.8 )];
  [hopPath lineToPoint:NSMakePoint( centre.x + radius / 2.8, centre.y - radius / 2.8 )];
  [hopPath lineToPoint:NSMakePoint( centre.x + radius / 2.8, centre.y + radius / 2.8 )];
  [hopPath lineToPoint:NSMakePoint( centre.x + radius / 1.8, centre.y + radius / 1.8 )];
  
  [hopPath setLineWidth:2.0];
  [hopPath stroke];
}


- (void)runToken:(ELPlayhead *)playhead {
  [playhead setSkipCount:[skipCountDial value]];
}


#pragma mark NSMutableCopying protocol implementation

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setSkipCountDial:[[self skipCountDial] mutableCopy]];
  return copy;
}


#pragma mark ELXmlData protocol implementation

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[skipCountDial xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    [self setSkipCountDial:[_representation_ loadDial:@"skip" parent:nil player:_player_ error:_error_]];
  }
  
  return self;
}


@end
