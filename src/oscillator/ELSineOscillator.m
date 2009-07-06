//
//  ELSineOscillator.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSineOscillator.h"

@implementation ELSineOscillator

- (id)initEnabled:(BOOL)enabled minimum:(int)min maximum:(int)max period:(int)period {
  if( ( self = [super initEnabled:enabled minimum:min maximum:max] ) ) {
    [self setPeriod:period];
  }
  
  return self;
}

- (NSString *)type {
  return @"Sine";
}

@synthesize period = _period;

- (int)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() - [self timeBase] ) / 1000000;
    int t = time % [self period];
    
    // NSLog( @"time = %llu, period = %d, t = %d", time, period, t );
    
    return [self generateWithT:t];
}

- (int)generateWithT:(int)_t_ {
  // Convert to angular form and use as a proportion of the range
  float angle = ((float)_t_ / [self period]) * M_PI;
  return [self minimum] + ( [self range] * sin( angle ) );
}

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [representation attributeForName:@"period"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'period' attribute node for oscillator!" );
      return nil;
    } else {
      [self setPeriod:[[attributeNode stringValue] intValue]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)attributes {
  [super storeAttributes:attributes];
  
  [attributes setObject:[NSNumber numberWithInteger:[self period]] forKey:@"period"];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initEnabled:[self enabled]
                                                minimum:[self minimum]
                                                maximum:[self maximum]
                                                 period:[self period]];
}


@end
