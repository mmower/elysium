//
//  ELDialModeValueTransformer.m
//  Elysium
//
//  Created by Matt Mower on 06/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELDialModeValueTransformer.h"

#import "ELDial.h"

@implementation ELDialModeValueTransformer

+ (Class)transformedValueClass {
  return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation {
  return NO;
}

- (id)transformedValue:(id)value {
  if( dialFree == [value intValue] ) {
    return [NSNumber numberWithBool:YES];
  } else {
    return [NSNumber numberWithBool:NO];
  }
}

@end
