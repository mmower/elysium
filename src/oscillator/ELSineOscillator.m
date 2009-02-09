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

- (id)initEnabled:(BOOL)aEnabled minimum:(int)aMin maximum:(int)aMax period:(int)aPeriod {
  if( ( self = [super initEnabled:aEnabled minimum:aMin maximum:aMax] ) ) {
    [self setPeriod:aPeriod];
  }
  
  return self;
}

- (NSString *)type {
  return @"Sine";
}

@synthesize period;

- (int)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() - [self timeBase] ) / 1000000;
    int t = time % period;
    
    // NSLog( @"time = %llu, period = %d, t = %d", time, period, t );
    
    return [self generateWithT:t];
}

- (int)generateWithT:(int)_t_ {
  // Convert to angular form and use as a proportion of the range
  float angle = ((float)_t_ / period) * M_PI;
  return minimum + ( range * sin( angle ) );
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"period"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'period' attribute node for oscillator!" );
      return nil;
    } else {
      [self setPeriod:[[attributeNode stringValue] intValue]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
  
  [_attributes_ setObject:[NSNumber numberWithInteger:[self period]] forKey:@"period"];
}

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initEnabled:[self enabled]
                                                  minimum:[self minimum]
                                                  maximum:[self maximum]
                                                   period:[self period]];
}


@end
