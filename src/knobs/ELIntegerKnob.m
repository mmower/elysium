//
//  ELIntegerKnob.m
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELIntegerKnob.h"

#import "ELOscillator.h"

@implementation ELIntegerKnob

- (id)initWithName:(NSString *)_name_
      integerValue:(int)_value_
           minimum:(float)_minimum_
           maximum:(float)_maximum_
          stepping:(float)_stepping_
        linkedKnob:(ELKnob *)_knob_
           enabled:(BOOL)_enabled_
        hasEnabled:(BOOL)_hasEnabled_
       linkEnabled:(BOOL)_linkEnabled_
          hasValue:(BOOL)_hasValue_
         linkValue:(BOOL)_linkValue_
            oscillator:(ELOscillator *)_oscillator_
        linkOscillator:(BOOL)_linkOscillator_
{
  if( ( self = [self initWithName:name
                          minimum:_minimum_
                          maximum:_maximum_
                         stepping:_stepping_
                       linkedKnob:_knob_
                          enabled:_enabled_
                       hasEnabled:_hasEnabled_
                      linkEnabled:_linkEnabled_
                         hasValue:_hasValue_
                        linkValue:_linkValue_
                           oscillator:_oscillator_
                       linkOscillator:_linkOscillator_] ) )
  {
    [self setValue:_value_];
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ integerValue:(int)_value_ minimum:(float)_minimum_ maximum:(float)_maximum_ stepping:(float)_stepping_ {
  if( ( self = [self initWithName:_name_ minimum:_minimum_ maximum:_maximum_ stepping:_stepping_] ) ) {
    [self setValue:_value_];
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ linkedToIntegerKnob:(ELIntegerKnob *)_knob_ {
  if( ( self = [self initWithName:_name_ minimum:[_knob_ minimum] maximum:[_knob_ maximum] stepping:[_knob_ stepping]] ) ) {
    [self setLinkedKnob:_knob_];
    [self setLinkValue:YES];
  }
  
  return self;
}

- (NSString *)xmlType {
  return @"integer";
}

- (BOOL)encodesType:(char *)_type_ {
  return strcmp( _type_, @encode(int)) == 0;
}

- (int)value {
  if( linkValue ) {
    return [(ELIntegerKnob *)linkedKnob value];
  } else if( hasValue ) {
    return value;
  } else {
    @throw [NSException exceptionWithName:@"KnobException" reason:@"Value called on ELIntegerKnob with no value or linkage." userInfo:[NSDictionary dictionaryWithObject:self forKey:@"knob"]];
  }
}

- (int)filteredValue {
  if( linkValue ) {
    return [(ELIntegerKnob *)linkedKnob filteredValue];
  } else if( hasValue ) {
    return [self filteredValue:value];
  } else {
    @throw [NSException exceptionWithName:@"KnobException" reason:@"Value called on ELIntegerKnob with no value or linkage." userInfo:[NSDictionary dictionaryWithObject:self forKey:@"knob"]];
  }
}

- (int)filteredValue:(int)_value_ {
  if( oscillator && [oscillator enabled] ) {
    return [oscillator generate];
  } else {
    return _value_;
  }
}

- (NSString *)stringValue {
  return [[NSNumber numberWithInt:[self value]] stringValue];
}

- (void)setValueWithString:(NSString *)_stringValue_ {
  [self setValue:[_stringValue_ intValue]];
}

- (void)setValue:(int)_value_ {
  hasValue = YES;
  value    = _value_;
}

// NSMutableCopying protocol

- (id)copyWithZone:(NSZone *)_zone_ {
  NSLog( @"in copyWithZone:%@", _zone_ );
  return [self mutableCopyWithZone:_zone_];
}

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithName:name
                                              integerValue:value
                                                   minimum:minimum
                                                   maximum:maximum
                                                  stepping:stepping
                                                linkedKnob:linkedKnob
                                                   enabled:enabled
                                                hasEnabled:hasEnabled
                                               linkEnabled:linkEnabled
                                                  hasValue:hasValue
                                                 linkValue:linkValue
                                                    oscillator:oscillator
                                                linkOscillator:linkOscillator];
}

@end
