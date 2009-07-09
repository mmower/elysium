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

#import "ELDialBank.h"

@implementation ELSkipToken

+ (NSString *)tokenType {
  return @"skip";
}


- (id)initWithSkipCountDial:(ELDial *)skipCountDial {
  if( ( self = [super init] ) ) {
    [self setSkipCountDial:skipCountDial];
  }
  
  return self;
}


- (id)init {
  return [self initWithSkipCountDial:[ELDialBank defaultSkipCountDial]];
}


@synthesize skipCountDial = _skipCountDial;

- (void)setSkipCountDial:(ELDial *)skipCountDial {
  _skipCountDial = skipCountDial;
  [_skipCountDial setDelegate:self];
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
  [playhead setSkipCount:[[self skipCountDial] value]];
}


#pragma mark NSMutableCopying protocol implementation

- (id)mutableCopyWithZone:(NSZone *)zone {
  id copy = [super mutableCopyWithZone:zone];
  [copy setSkipCountDial:[[self skipCountDial] duplicateDial]];
  return copy;
}


#pragma mark ELXmlData protocol implementation

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[[self skipCountDial] xmlRepresentation]];
  return controlsElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    [self setSkipCountDial:[representation loadDial:@"skip" parent:nil player:player error:error]];
  }
  
  return self;
}


@end
