//
//  ELOscillatorController.h
//  Elysium
//
//  Created by Matt Mower on 07/07/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// @class ELDial;
@class ELOscillator;

@interface ELOscillatorController : NSObject {
  NSThread            *_oscillatorThread;
  NSMutableArray      *_activeOscillators;
}

- (void)addOscillator:(ELOscillator *)oscillator;
- (void)removeOscillator:(ELOscillator *)oscillator;

- (void)startOscillators;
- (void)stopOscillators;

@end
