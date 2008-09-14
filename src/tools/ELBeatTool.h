//
//  ELBeatTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELTool.h"

@interface ELBeatTool : ELTool <NSMutableCopying> {
  ELIntegerKnob *velocityKnob;
  ELFloatKnob   *durationKnob;
}

- (id)initWithVelocityKnob:(ELIntegerKnob *)velocityKnob durationKnob:(ELFloatKnob *)durationKnob;

@property (readonly) ELIntegerKnob *velocityKnob;
@property (readonly) ELFloatKnob *durationKnob;

@end
