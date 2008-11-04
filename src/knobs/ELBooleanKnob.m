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
        hasEnabled:(BOOL)_hasEnabled_
       linkEnabled:(BOOL)_linkEnabled_
          hasValue:(BOOL)_hasValue_
         linkValue:(BOOL)_linkValue_
        oscillator:(ELOscillator *)_oscillator_
{
  if( ( self = [self initWithName:_name_
                       linkedKnob:_knob_
                          enabled:_enabled_
                       hasEnabled:_hasEnabled_
                      linkEnabled:_linkEnabled_
                         hasValue:_hasValue_
                        linkValue:_linkValue_
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
  NSAssert( hasValue || linkValue, @"Value must be either defined or linked!" );
  
  if( linkValue ) {
    return [(ELBooleanKnob *)linkedKnob value];
  } else if( hasValue ) {
    return value;
  } else {
    NSLog( @"value called on ELBooleanKnob with no value or linkage." );
    abort();
  }
}

- (NSString *)stringValue {
  return [self value] ? @"YES" : @"NO";
}

- (void)setValueWithString:(NSString *)_stringValue_ {
  [self setValue:[_stringValue_ boolValue]];
}

- (void)setValue:(BOOL)_value_ {
  hasValue = YES;
  value    = _value_;
}

- (void)clearValue {
  hasValue = NO;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithName:name
                                              booleanValue:value
                                                linkedKnob:linkedKnob
                                                   enabled:enabled
                                                hasEnabled:hasEnabled
                                               linkEnabled:linkEnabled
                                                  hasValue:hasValue
                                                 linkValue:linkValue
                                                oscillator:oscillator];
}

@end
