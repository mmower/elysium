//
//  ELSegmentedControl.m
//  Elysium
//
//  Created by Matt Mower on 10/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELSegmentedControl.h"

@implementation ELSegmentedControl

+ (void)initialize {
  [self exposeBinding:@"segment1enabled"];
}

@dynamic segment1enabled;

- (BOOL)segment1enabled {
  return segment1enabled;
}

- (void)setSegment1enabled:(BOOL)enabled {
  segment1enabled = enabled;
  [self setEnabled:segment1enabled forSegment:1];
}

@end
