//
//  ELSawFilter.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELFilter.h"

@interface ELSawFilter : ELFilter {
  float rest;
  float attack;
  float sustain;
  float decay;
  
  float attackBase;
  float attackDelta;
  
  float decayBase;
  float decayDelta;
}

@property float rest;
@property float attack;
@property float sustain;
@property float decay;

@end
