//
//  ELRangedOscillator.m
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRangedOscillator.h"

@implementation ELRangedOscillator

- (id)initEnabled:(BOOL)_enabled_ minimum:(float)_minimum_ maximum:(float)_maximum_ {
  if( ( self = [super initEnabled:_enabled_] ) ) {
    [self setMinimum:_minimum_];
    [self setMaximum:_maximum_];
  }
  
  return self;
}

@dynamic minimum;

- (float)minimum {
  return minimum;
}

- (void)setMinimum:(float)_minimum_ {
  minimum = _minimum_;
  range = maximum - minimum;
}

@dynamic maximum;

- (float)maximum {
  return maximum;
}

- (void)setMaximum:(float)_maximum_ {
  maximum = _maximum_;
  range = maximum - minimum;
}

@synthesize range;

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"minimum"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'minimum' attribute node for oscillator!" );
      return nil;
    } else {
      [self setMinimum:[[attributeNode stringValue] floatValue]];
    }

    attributeNode = [_representation_ attributeForName:@"maximum"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'maximum' attribute node for oscillator" );
      return nil;
    } else {
      [self setMaximum:[[attributeNode stringValue] floatValue]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
  
  [_attributes_ setObject:[NSNumber numberWithFloat:[self minimum]] forKey:@"minimum"];
  [_attributes_ setObject:[NSNumber numberWithFloat:[self maximum]] forKey:@"maximum"];
}

@end
