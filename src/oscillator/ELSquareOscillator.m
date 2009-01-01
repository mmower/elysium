//
//  ELSquareOscillator.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSquareOscillator.h"

#import "ELOscillator.h"

@implementation ELSquareOscillator

- (id)initEnabled:(BOOL)_enabled_ minimum:(float)_minimum_ maximum:(float)_maximum_ rest:(int)_rest_ sustain:(int)_sustain_ {
  if( ( self = [super initEnabled:_enabled_ minimum:_minimum_ maximum:_maximum_] ) ) {
    [self setRest:_rest_];
    [self setSustain:_sustain_];
  }
  
  return self;
}

- (NSString *)type {
  return @"Square";
}

@dynamic rest;

- (int)rest {
  return rest;
}

- (void)setRest:(int)_rest_ {
  rest = _rest_;
  [self updatePeriod];
}

@dynamic sustain;

- (int)sustain {
  return sustain;
}

- (void)setSustain:(int)_sustain_ {
  sustain = _sustain_;
  [self updatePeriod];
}

- (void)updatePeriod {
  period = rest + sustain;
}

- (float)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() - [self timeBase] ) / 1000000;
    int t = time % period;
    return [self generateWithT:t];
}

- (float)generateWithT:(int)_t_ {
  if( _t_ < sustain ) {
    return minimum;
  } else {
    return maximum;
  }
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"rest"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'rest' attribute node for oscillator!" );
      return nil;
    } else {
      [self setRest:[[attributeNode stringValue] floatValue]];
    }
    
    attributeNode = [_representation_ attributeForName:@"sustain"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'sustain' attribute node for oscillator" );
      return nil;
    } else {
      [self setSustain:[[attributeNode stringValue] floatValue]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
  
  [_attributes_ setObject:[NSNumber numberWithFloat:[self rest]] forKey:@"rest"];
  [_attributes_ setObject:[NSNumber numberWithFloat:[self sustain]] forKey:@"sustain"];
}

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initEnabled:[self enabled]
                                                  minimum:[self minimum]
                                                  maximum:[self maximum]
                                                     rest:[self rest]
                                                  sustain:[self sustain]];
}

@end
