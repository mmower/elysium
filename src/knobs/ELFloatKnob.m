//
//  ELFloatKnob.m
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELFloatKnob.h"

#import "ELOscillator.h"

@implementation ELFloatKnob

- (id)initWithName:(NSString *)_name_
        floatValue:(float)_value_
           minimum:(float)_minimum_
           maximum:(float)_maximum_
          stepping:(float)_stepping_
        linkedKnob:(ELKnob *)_knob_
           enabled:(BOOL)_enabled_
         linkValue:(BOOL)_linkValue_
        oscillator:(ELOscillator *)_oscillator_
{
  if( ( self = [self initWithName:_name_
                          minimum:_minimum_
                          maximum:_maximum_
                         stepping:_stepping_
                       linkedKnob:_knob_
                          enabled:_enabled_
                        linkValue:_linkValue_
                       oscillator:_oscillator_] ) )
  {
    [self setValue:_value_];
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ floatValue:(float)_value_ minimum:(float)_minimum_ maximum:(float)_maximum_ stepping:(float)_stepping_ {
  if( ( self = [self initWithName:_name_ minimum:_minimum_ maximum:_maximum_ stepping:_stepping_] ) ) {
    [self setValue:_value_];
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ linkedToFloatKnob:(ELFloatKnob *)_knob_ {
  if( ( self = [self initWithName:_name_ minimum:[_knob_ minimum] maximum:[_knob_ maximum] stepping:[_knob_ stepping]] ) ) {
    [self setLinkedKnob:_knob_];
    [self setLinkValue:YES];
  }
  
  return self;
}

- (NSString *)xmlType {
  return @"float";
}

- (BOOL)encodesType:(char *)_type_ {
  return strcmp( _type_, @encode(float)) == 0;
}

- (float)value {
  if( linkValue ) {
    return [(ELFloatKnob *)linkedKnob value];
  } else {
    return value;
  }
}

- (float)dynamicValue {
  if( linkValue ) {
    return [(ELFloatKnob *)linkedKnob dynamicValue];
  } else {
    return [self dynamicValue:value];
  }
}

- (float)dynamicValue:(float)_value_ {
  if( oscillator && [oscillator enabled] ) {
    return [oscillator generate];
  } else {
    return _value_;
  }
}

- (NSString *)stringValue {
  return [[NSNumber numberWithFloat:[self value]] stringValue];
}

- (void)setValueWithString:(NSString *)_stringValue_ {
  [self setValue:[_stringValue_ floatValue]];
}

- (void)setValue:(float)_value_ {
  value = _value_;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithName:name
                                                floatValue:value
                                                   minimum:minimum
                                                   maximum:maximum
                                                  stepping:stepping
                                                linkedKnob:linkedKnob
                                                   enabled:enabled
                                                 linkValue:linkValue
                                                oscillator:oscillator];
}

@end
