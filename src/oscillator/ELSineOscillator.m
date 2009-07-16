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

#pragma mark Object initialization

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum hardMinimum:(int)hardMinimum maximum:(int)maximum hardMaximum:(int)hardMaximum period:(int)period {
  if( ( self = [super initEnabled:enabled minimum:minimum hardMinimum:hardMinimum maximum:maximum hardMaximum:hardMaximum] ) ) {
    [self setPeriod:period];
  }
  
  return self;
}


- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum period:(int)period {
  return [self initEnabled:enabled minimum:minimum hardMinimum:minimum maximum:maximum hardMaximum:maximum period:period];
}


- (NSString *)type {
  return @"Sine";
}


- (NSString *)description {
  return [NSString stringWithFormat:@"<ELSineOscillator: %p> min:%d hard_min:%d max:%d hard_max:%d period:%d", self, [self minimum], [self hardMinimum], [self maximum], [self hardMaximum], [self period]];
}

@synthesize period = _period;

- (int)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() - [self timeBase] ) / 1000000;
    int t = time % [self period];
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
                                            hardMinimum:[self hardMinimum]
                                                maximum:[self maximum]
                                            hardMaximum:[self hardMaximum]
                                                 period:[self period]];
}


@end
