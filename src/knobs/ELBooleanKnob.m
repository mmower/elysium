//
//  ELBooleanKnob.m
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELBooleanKnob.h"

@implementation ELBooleanKnob

- (id)initWithName:(NSString *)_name_
      booleanValue:(BOOL)_value_
        linkedKnob:(ELKnob *)_knob_
           enabled:(BOOL)_enabled_
         linkValue:(BOOL)_linkValue_
                 p:(float)_p_
        oscillator:(ELOscillator *)_oscillator_
{
  if( ( self = [self initWithName:_name_
                       linkedKnob:_knob_
                          enabled:_enabled_
                        linkValue:_linkValue_
                                p:_p_
                       oscillator:_oscillator_] ) )
  {
    value = _value_;
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ booleanValue:(BOOL)_value_ {
  if( ( self = [self initWithName:_name_] ) ) {
    [self setValue:_value_];
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ linkedToBooleanKnob:(ELBooleanKnob *)_knob_ {
  if( ( self = [self initWithName:_name_] ) ) {
    [self setLinkedKnob:_knob_];
    [self setLinkValue:YES];
  }
  
  return self;
}

- (NSString *)xmlType {
  return @"boolean";
}

- (BOOL)encodesType:(char *)_type_ {
  return strcmp( _type_, @encode(BOOL)) == 0;
}

- (BOOL)value {
  if( linkValue ) {
    return [(ELBooleanKnob *)linkedKnob value];
  } else {
    return value;
  }
}

- (NSString *)stringValue {
  return [self value] ? @"YES" : @"NO";
}

- (void)setValueWithString:(NSString *)_stringValue_ {
  [self setValue:[_stringValue_ boolValue]];
}

- (void)setValue:(BOOL)_value_ {
  value = _value_;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithName:name
                                              booleanValue:value
                                                linkedKnob:linkedKnob
                                                   enabled:enabled
                                                 linkValue:linkValue
                                                         p:p
                                                oscillator:oscillator];
}

@end
