//
//  ELNoteTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELTool.h"

@interface ELNoteTool : ELTool <NSMutableCopying> {
  ELIntegerKnob *velocityKnob;
  ELIntegerKnob *emphasisKnob;
  ELFloatKnob   *durationKnob;
  ELIntegerKnob *triadKnob;
  
  ELBooleanKnob *overrideKnob;
  NSDictionary  *channelSends;
}

- (id)initWithVelocityKnob:(ELIntegerKnob *)velocityKnob
              emphasisKnob:(ELIntegerKnob *)emphasisKnob
              durationKnob:(ELFloatKnob *)durationKnob
                 triadKnob:(ELIntegerKnob *)triadKnob
              overrideKnob:(ELBooleanKnob *)overrideKnob
              channelSends:(NSDictionary *)channelSends;

@property (readonly) ELIntegerKnob *velocityKnob;
@property (readonly) ELIntegerKnob *emphasisKnob;
@property (readonly) ELFloatKnob *durationKnob;
@property (readonly) ELIntegerKnob *triadKnob;
@property (readonly) ELBooleanKnob *overrideKnob;
@property (readonly) NSDictionary *channelSends;

@end
