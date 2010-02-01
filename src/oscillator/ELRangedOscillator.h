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
  int _minimum;
  int _hardMinimum;
  int _maximum;
  int _hardMaximum;
  
  int _range;
}

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum hardMinimum:(int)hardMinimum maximum:(int)maximum hardMaximum:(int)hardMaximum;
- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum;

@property int minimum;
@property int hardMinimum;
@property int maximum;
@property int hardMaximum;
@property (readonly) int range;

@end
