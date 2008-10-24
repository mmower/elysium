//
//  ELSequenceOscillator.h
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELOscillator.h"

@interface ELSequenceOscillator : ELOscillator {
  NSMutableArray  *values;
  int             index;
}

- (id)initEnabled:(BOOL)enabled values:(NSArray *)values;

@property (readonly) NSMutableArray *values;

@end
