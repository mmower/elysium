//
//  ELSkipToken.m
//  Elysium
//
//  Created by Matt Mower on 23/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELSkipToken.h"

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


- (void)runToken:(ELPlayhead *)playhead {
  [playhead setSkipCount:[skipCountDial value]];
}

#pragma mark NSMutableCopying protocol implementation

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setSkipCountDial:[[self skipCountDial] mutableCopy]];
  return copy;
}

// Implement the ELXmlData protocol

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
