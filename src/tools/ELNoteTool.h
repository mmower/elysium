//
//  ELNoteTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELTool.h"

@interface ELNoteTool : ELTool <NSMutableCopying,ELXmlData> {
  ELIntegerKnob *velocityKnob;
  ELFloatKnob   *durationKnob;
  ELIntegerKnob *triadKnob;
}

- (id)initWithVelocityKnob:(ELIntegerKnob *)velocityKnob durationKnob:(ELFloatKnob *)durationKnob triadKnob:(ELIntegerKnob *)triadKnob;

@property (readonly) ELIntegerKnob *velocityKnob;
@property (readonly) ELFloatKnob *durationKnob;
@property (readonly) ELIntegerKnob *triadKnob;

@end
