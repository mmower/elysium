//
//  ELKnob.m
//  Elysium
//
//  Created by Matt Mower on 10/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELKnob.h"

//
// An ELKnob instance represents something controllable in the
// interface although it is not, in itself, a UI control. For
// example the velocity value for a note tool is represented
// by a knob with a type, value, a linked knob (that it might
// inherit from), filters, predicates, and so on.
//

@implementation ELKnob

- (id)initWithType:(KnobType)_type_ name:(NSString *)_name_ {
  if( ( self = [self init] ) ) {
    type = _type_;
    name = _name_;
  }
  
  return self;
}

- (NSString *)name {
  return name;
}

- (KnobType)type {
  return type;
}

- (BOOL)enabled {
  if( enabled ) {
    return [enabled boolValue];
  } else if( linkEnabled ) {
    return [linkedKnob enabled];
  } else {
    return NO;
  }
}

- (void)setEnabled:(BOOL)_enabled_ {
  enabled = [NSNumber numberWithBool:_enabled_];
}

- (BOOL)linkEnabled {
  return linkEnabled;
}

- (void)setLinkEnabled:(BOOL)_linkEnabled_ {
  linkEnabled = _linkEnabled_;
}

- (ELKnob *)linkedKnob {
  return linkedKnob;
}

- (void)setLinkedKnob:(ELKnob *)_linkedKnob_ {
  linkedKnob = _linkedKnob_;
}

- (int)intValue {
  NSAssert( type == INTEGER_KNOB, @"This knob does not hold INTEGER values!" );
  NSAssert( hasValue || linkValue, @"This knob does not refer to a value!" );
  
  if( hasValue ) {
    return intValue * [self alpha];
  } else if( linkValue ) {
    return [linkedKnob intValue];
  } else {
    NSLog( @"Error: no value stored or linked for knob: %@(%d)", name, type );
    return -1;
  }
}

- (void)setIntValue:(int)_value_ {
  NSAssert( type == INTEGER_KNOB, @"This knob does not hold INTEGER values!" );
  intValue = _value_;
  hasValue = true;
}

- (float)floatValue {
  NSAssert( type == FLOAT_KNOB, @"This knob does not hold FLOAT values!" );
  NSAssert( hasValue || linkValue, @"This knob does not refer to a value!" );
  
  if( hasValue ) {
    return floatValue * [self alpha];
  } else if( linkValue ) {
    return [linkedKnob floatValue];
  } else {
    NSLog( @"Error: no value stored or linked for knob: %@(%d)", name, type );
    return -1.0;
  }  
}

- (void)setFloatValue:(float)_value_ {
  NSAssert( type == FLOAT_KNOB, @"This knob does not hold FLOAT values!" );
  floatValue = _value_;
  hasValue = true;
}

- (BOOL)boolValue {
  NSAssert( type == BOOLEAN_KNOB, @"This knob does not hold BOOL values!" );
  NSAssert( hasValue || linkValue, @"This knob does not refer to a value!" );
  
  if( hasValue ) {
    return boolValue;
  } else if( linkValue ) {
    return [linkedKnob boolValue];
  } else {
    NSLog( @"Error: no value stored or linked for knob: %@(%d)", name, type );
    return NO;
  }
}

- (void)setBoolValue:(BOOL)_value_ {
  NSAssert( type == BOOLEAN_KNOB, @"This knob does not hold BOOL values!" );
  boolValue = _value_;
  hasValue = true;
}

- (BOOL)linkValue {
  return linkValue;
}

- (void)setLinkValue:(BOOL)_linkValue_ {
  linkValue = _linkValue_;
}

- (float)alpha {
  if( alpha ) {
    return [alpha floatValue];
  } else if( linkAlpha ) {
    return [linkedKnob alpha];
  } else {
    return 1.0;
  }
}

- (void)setAlpha:(float)_alpha_ {
  alpha = [NSNumber numberWithFloat:_alpha_];
}

- (BOOL)linkAlpha {
  return linkAlpha;
}

- (void)setLinkAlpha:(BOOL)_linkAlpha_ {
  linkAlpha = _linkAlpha_;
}

- (float)p {
  if( p ) {
    return [p floatValue];
  } else if( linkP ) {
    return [linkedKnob p];
  } else {
    return 1.0;
  }
}

- (void)setP:(float)_p_ {
  p = [NSNumber numberWithFloat:_p_];
}

- (BOOL)linkP {
  return linkP;
}

- (void)setLinkP:(BOOL)_linkP_ {
  linkP = _linkP_;
}

- (ELOscillator *)filter {
  if( filter ) {
    return filter;
  } else if( linkFilter ) {
    return [linkedKnob filter];
  } else {
    return nil;
  }
}

- (void)setFilter:(ELOscillator *)_filter_ {
  filter = _filter_;
}

- (BOOL)linkFilter {
  return linkFilter;
}

- (void)setLinkFilter:(BOOL)_linkFilter_ {
  linkFilter = _linkFilter_;
}

- (NSPredicate *)predicate {
  if( predicate ) {
    return predicate;
  } else if( linkPredicate ) {
    return [linkedKnob predicate];
  } else {
    return nil;
  }
}

- (void)setPredicate:(NSPredicate *)_predicate_ {
  predicate = _predicate_;
}

- (BOOL)linkPredicate {
  return linkPredicate;
}

- (void)setLinkPredicate:(BOOL)_linkPredicate_ {
  linkPredicate = _linkPredicate_;
}

@end
