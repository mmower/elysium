//
//  ELRampOscillator.m
//  Elysium
//
//  Created by Matt Mower on 07/03/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELRampOscillator.h"

@interface ELRampOscillator (PrivateMethods)

- (int)generateRampedWithT:(int)time;
- (int)stableValue;

@end

@implementation ELRampOscillator

#pragma mark Object initialization

- (id)initEnabled:(BOOL)enabled minimum:(int)min maximum:(int)max period:(int)period rising:(BOOL)rising {
  if( ( self = [super initEnabled:enabled minimum:min maximum:max] ) ) {
    [self setPeriod:period];
    [self setRising:rising];
  }
  
  return self;
}


#pragma mark Properties

@synthesize period = _period;
@synthesize rising = _rising;


#pragma mark Object behaviours

- (NSString *)type {
  return @"Ramp";
}


- (int)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() - [self timeBase] ) / 1000000;
    return [self generateWithT:time];
}


- (int)generateWithT:(int)time {
  if( time < [self period] ) {
    return [self generateRampedWithT:time];
  } else {
    return [self stableValue];
  }
}


- (int)generateRampedWithT:(int)time {
  int delta = [self range] * ( (float)time / [self period] );
  
  if( [self rising] ) {
    return [self minimum] + delta;
  } else {
    return [self maximum] - delta;
  }
}


- (int)stableValue {
  if( [self rising] ) {
    return [self maximum];
  } else {
    return [self minimum];
  }
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:representation parent:_parent_ player:_player_ error:_error_] ) ) {
    
    [self setPeriod:[representation attributeAsInteger:@"period" defaultValue:30000]];
    
    BOOL isRising = [[NSNumber numberWithInteger:[representation attributeAsInteger:@"rising"
                                                                       defaultValue:[[NSNumber numberWithBool:YES] intValue]]] boolValue];
    [self setRising:isRising];
  }
  
  return self;
}


- (void)storeAttributes:(NSMutableDictionary *)serializedAttributes {
  [super storeAttributes:serializedAttributes];
  
  [serializedAttributes setObject:[NSNumber numberWithInteger:[self period]] forKey:@"period"];
  [serializedAttributes setObject:[NSNumber numberWithBool:[self rising]] forKey:@"rising"];
}


- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initEnabled:[self enabled]
                                                  minimum:[self minimum]
                                                  maximum:[self maximum]
                                                   period:[self period]
                                                   rising:[self rising]];
}


@end
