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
        hasEnabled:(BOOL)_hasEnabled_
       linkEnabled:(BOOL)_linkEnabled_
          hasValue:(BOOL)_hasValue_
         linkValue:(BOOL)_linkValue_
            oscillator:(ELOscillator *)_filter_
        linkOscillator:(BOOL)_linkFilter_
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
                           oscillator:_filter_
                       linkOscillator:_linkFilter_] ) )
  {
    [self setValue:_value_];
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ floatValue:(float)_value_ minimum:(float)_minimum_ maximum:(float)_maximum_ stepping:(float)_stepping_ {
  if( ( self = [self initWithName:_name_ minimum:_maximum_ maximum:_maximum_ stepping:_stepping_] ) ) {
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

@synthesize minimum;
@synthesize maximum;
@synthesize stepping;

- (NSString *)xmlType {
  return @"float";
}

- (BOOL)encodesType:(char *)_type_ {
  return strcmp( _type_, @encode(float)) == 0;
}

- (float)value {
  if( linkValue ) {
    return [(ELFloatKnob *)linkedKnob value];
  } else if( hasValue ) {
    return value;
  } else {
    @throw [NSException exceptionWithName:@"KnobException" reason:@"Value called on ELFloatKnob with no value or linkage." userInfo:[NSDictionary dictionaryWithObject:self forKey:@"knob"]];
  }
}

- (float)filteredValue {
  if( linkValue ) {
    return [(ELFloatKnob *)linkedKnob filteredValue];
  } else if( hasValue ) {
    return [self filteredValue:value];
  } else {
    @throw [NSException exceptionWithName:@"KnobException" reason:@"Value called on ELFloatKnob with no value or linkage." userInfo:[NSDictionary dictionaryWithObject:self forKey:@"knob"]];
  }
}

- (float)filteredValue:(float)_value_ {
  if( filter && [filter enabled] ) {
    return [filter generate];
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
  hasValue = YES;
  value    = _value_;
}

- (void)clearValue {
  hasValue = NO;
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
                                                hasEnabled:hasEnabled
                                               linkEnabled:linkEnabled
                                                  hasValue:hasValue
                                                 linkValue:linkValue
                                                    oscillator:filter
                                                linkOscillator:linkFilter];
}

@end
