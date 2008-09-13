//
//  ELIntegerKnob.m
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELIntegerKnob.h"

@implementation ELIntegerKnob

- (id)initWithName:(NSString *)_name_ value:(int)_value_ {
  if( ( self = [self initWithName:_name_] ) ) {
    [self setValue:_value_];
  }
  
  return self;
}

- (int)value {
  NSAssert( hasValue || linkValue, @"ELFloatKnob must have or be linked to a value" );
  
  if( hasValue ) {
    return value;
  } else if( linkValue ) {
    return [(ELIntegerKnob *)linkedKnob value];
  } else {
    NSLog( @"value called on ELIntegerKnob with no value or linkage." );
    abort();
  }
}

- (void)setValue:(int)_value_ {
  hasValue = YES;
  value    = _value_;
}

@end
