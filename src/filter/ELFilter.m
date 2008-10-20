//
//  ELFilter.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <CoreAudio/CoreAudio.h>

#import "ELFilter.h"
#import "ELSquareFilter.h"
#import "ELSawFilter.h"
#import "ELSineFilter.h"

UInt64 currentTimeInMillis( void ) {
  return AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) / 100000;
}

@implementation ELFilter

- (id)initWithMinimum:(float)_minimum_ maximum:(float)_maximum_ {
  if( ( self = [super init] ) ) {
    [self setMinimum:_minimum_];
    [self setMinimum:_maximum_];
  }
  
  return self;
}

- (NSString *)type {
  return @"filter";
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

- (int)periodInMillis {
  [self doesNotRecognizeSelector:_cmd];
  return 0.0; // Should never get here
}

- (float)generate {
  return [self generateWithT:( currentTimeInMillis() % [self periodInMillis] )];
}

- (float)generateWithT:(int)_t_ {
  [self doesNotRecognizeSelector:_cmd];
  return 0.0; // Should never happen
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *filterElement = [NSXMLNode elementWithName:@"filter"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [filterElement setAttributesAsDictionary:attributes];
  
  return filterElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  NSXMLNode *attributeNode;
  attributeNode = [_representation_ attributeForName:@"type"];
  NSString *type = [attributeNode stringValue];

  if( [type isEqualToString:@"square"] ) {
    return [[ELSquareFilter alloc] initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_];
  } else if( [type isEqualToString:@"saw"] ) {
    return [[ELSawFilter alloc] initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_];
  } else if( [type isEqualToString:@"sine"] ) {
    return [[ELSineFilter alloc] initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_];
  } else {
    NSLog( @"Unknown filter type '%@' detected.", type );
    return nil;
  }
}

@end
