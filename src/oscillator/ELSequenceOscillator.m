//
//  ELSequencescillator.m
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSequenceOscillator.h"

@implementation ELSequenceValue

- (id)initWithStringValue:(NSString *)_stringValue_ {
  if( ( self = [super init] ) ) {
    [self setStringValue:_stringValue_];
  }
  
  return self;
}

@dynamic floatValue;

- (float)floatValue {
  return floatValue;
}

- (void)setFloatValue:(float)_floatValue_ {
  floatValue = _floatValue_;
  stringValue = [[NSNumber numberWithFloat:floatValue] stringValue];
}

@dynamic stringValue;

- (NSString *)stringValue {
  return stringValue;
}

- (void)setStringValue:(NSString *)_stringValue_ {
  stringValue = _stringValue_;
  floatValue = [stringValue floatValue];
}

@end

@implementation ELSequenceOscillator

- (id)initEnabled:(BOOL)_enabled_ values:(NSArray *)_values_ {
  if( ( self = [super initEnabled:_enabled_] ) ) {
    [self setValues:[_values_ mutableCopy]];
    index  = 0;
  }
  
  return self;
}

@synthesize values;

- (NSString *)type {
  return @"Sequence";
}

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

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"values"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'values' attribute node for oscillator!" );
      return nil;
    } else {
      NSArray *terms = [[attributeNode stringValue] componentsSeparatedByString:@","];
      NSMutableArray *sequenceValues = [[NSMutableArray alloc] init];
      
      for( NSString *term in terms ) {
        [sequenceValues addObject:[[ELSequenceValue alloc] initWithStringValue:term]];
      }
      
      [self setValues:sequenceValues];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
  
  [_attributes_ setObject:[values componentsJoinedByString:@","] forKey:@"values"];
}

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initEnabled:[self enabled]
                                                   values:[self values]];
}

@end
