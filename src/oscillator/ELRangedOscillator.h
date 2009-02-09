//
//  ELRangedOscillator.h
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELOscillator.h"

@interface ELRangedOscillator : ELOscillator {
  int minimum;
  int maximum;
  
  int range;
}

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum;

@property int minimum;
@property int maximum;
@property (readonly) int range;

@end
