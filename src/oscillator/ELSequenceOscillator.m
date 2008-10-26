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

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"values"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'values' attribute node for oscillator!" );
      return nil;
    } else {
      [self setValues:[[[attributeNode stringValue] componentsSeparatedByString:@","] mutableCopy]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
  
  [_attributes_ setObject:[values componentsJoinedByString:@","] forKey:@"values"];
}

@end
