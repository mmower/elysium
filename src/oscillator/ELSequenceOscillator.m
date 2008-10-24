//
//  ELSequencescillator.m
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSequenceOscillator.h"

@implementation ELSequenceOscillator

- (id)initEnabled:(BOOL)_enabled_ values:(NSArray *)_values_ {
  if( ( self = [super initEnabled:_enabled_] ) ) {
    values = [_values_ mutableCopy];
    index  = 0;
  }
  
  return self;
}

@synthesize values;

- (float)generate {
  if( [values count] < 1 ) {
    @throw [NSException exceptionWithName:@"OscillatorException" reason:@"SequenceOscillator has no values" userInfo:[NSDictionary dictionaryWithObject:self forKey:@"oscillator"]];
  }
  
  float value = [[values objectAtIndex:index] floatValue];
  index += 1;
  if( index == [values count] ) {
    index = 0;
  }
  return value;
}

@end
