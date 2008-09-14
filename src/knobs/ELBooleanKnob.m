//
//  ELBooleanKnob.m
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELBooleanKnob.h"

@implementation ELBooleanKnob

- (id)initWithName:(NSString *)_name_ value:(BOOL)_value_ {
  if( ( self = [self initWithName:_name_] ) ) {
    [self setValue:_value_];
  }
  
  return self;
}

- (BOOL)value {
  NSAssert( hasValue || linkValue, @"Value must be either defined or linked!" );
  
  if( hasValue ) {
    return value;
  } else if( linkValue ) {
    return [(ELBooleanKnob *)linkedKnob value];
  } else {
    NSLog( @"value called on ELBooleanKnob with no value or linkage." );
    abort();
  }
}

- (void)setValue:(BOOL)_value_ {
  hasValue = YES;
  value    = _value_;
}

- (void)clearValue {
  hasValue = NO;
}

@end
