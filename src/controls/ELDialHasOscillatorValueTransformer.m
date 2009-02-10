//
//  ELDialHasOscillatorValueTransformer.m
//  Elysium
//
//  Created by Matt Mower on 10/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELDialHasOscillatorValueTransformer.h"

NSString * const dialHasOscillatorValueTransformer = @"ELDialHasOscillatorValueTransformer";

static NSImage *onImage;

@implementation ELDialHasOscillatorValueTransformer

+ (void)initialize {
  if( !onImage ) {
    onImage = [NSImage imageNamed:@"red_dot.tif"];
  }
}

+ (Class)transformedValueClass {
  return [NSImage class];
}

+ (BOOL)allowsReverseTransformation {
  return NO;
}

- (id)transformedValue:(id)value {
  NSLog( @"transform: %@", value );
  if( value ) {
    return onImage;
  } else {
    return nil;
  }
}

@end
