//
//  ELGenerateTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

#import "ELTool.h"

@interface ELGenerateTool : ELTool <DirectedTool> {
  ELIntegerKnob *directionKnob;
  ELIntegerKnob *timeToLiveKnob;
  ELIntegerKnob *pulseCountKnob;
  ELIntegerKnob *offsetKnob;
}

@property ELIntegerKnob *directionKnob;
@property ELIntegerKnob *timeToLiveKnob;
@property ELIntegerKnob *pulseCountKnob;
@property ELIntegerKnob *offsetKnob;

- (BOOL)shouldPulseOnBeat:(int)beat;

@end
