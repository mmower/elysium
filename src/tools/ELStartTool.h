//
//  ELStartTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

#import "ELTool.h"

@interface ELStartTool : ELTool <NSMutableCopying,ELXmlData> {
  ELIntegerKnob *directionKnob;
  ELIntegerKnob *timeToLiveKnob;
  ELIntegerKnob *pulseCountKnob;
}

@property (readonly) ELIntegerKnob *directionKnob;
@property (readonly) ELIntegerKnob *timeToLiveKnob;
@property (readonly) ELIntegerKnob *pulseCountKnob;

- (BOOL)shouldPulseOnBeat:(int)beat;

@end
