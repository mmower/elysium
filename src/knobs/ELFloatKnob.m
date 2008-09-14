//
//  ELFloatKnob.m
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELFloatKnob.h"

@implementation ELFloatKnob

- (id)initWithName:(NSString *)_name_ value:(float)_value_ {
  if( ( self = [self initWithName:_name_] ) ) {
    [self setValue:_value_];
  }
  
  return self;
}

- (float)value {
  NSAssert( hasValue || linkValue, @"ELFloatKnob must have or be linked to a value" );
  
  if( hasValue ) {
    return value;
  } else if( linkValue ) {
    return [(ELFloatKnob *)linkedKnob value];
  } else {
    NSLog( @"value called on ELFloatKnob with no value or linkage." );
    abort();
  }
}

- (void)setValue:(float)_value_ {
  hasValue = YES;
  value    = _value_;
}

- (void)clearValue {
  hasValue = NO;
}

@end
