//
//  ELSineOscillator.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSineOscillator.h"

@implementation ELSineOscillator

- (id)initEnabled:(BOOL)_enabled_ minimum:(float)_minimum_ maximum:(float)_maximum_ period:(int)_period_ {
  if( ( self = [super initEnabled:_enabled_ minimum:_minimum_ maximum:_maximum_] ) ) {
    period = _period_;
  }
  
  return self;
}

- (NSString *)type {
  return @"Sine";
}

@synthesize period;

- (float)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) / 1000000;
    int t = time % period;
    
    NSLog( @"time = %llu, period = %d, t = %d", time, period, t );
    
    return [self generateWithT:t];
}

- (float)generateWithT:(int)_t_ {
  // Convert to angular form and use as a proportion of the range
  float angle = ((float)_t_ / period) * M_PI;
  return minimum + ( range * sin( angle ) );
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"period"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'period' attribute node for oscillator!" );
      return nil;
    } else {
      [self setPeriod:[[attributeNode stringValue] floatValue]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
  
  [_attributes_ setObject:[NSNumber numberWithFloat:[self period]] forKey:@"period"];
}

@end
