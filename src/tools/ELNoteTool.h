//
//  ELNoteTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELTool.h"

@interface ELNoteTool : ELTool {
  ELIntegerKnob *velocityKnob;
  ELIntegerKnob *emphasisKnob;
  ELIntegerKnob *durationKnob;
  ELIntegerKnob *triadKnob;
  ELIntegerKnob *ghostsKnob;
  
  ELBooleanKnob *overrideKnob;
  NSDictionary  *channelSends;
}

- (id)initWithVelocityKnob:(ELIntegerKnob *)velocityKnob
              emphasisKnob:(ELIntegerKnob *)emphasisKnob
              durationKnob:(ELIntegerKnob *)durationKnob
                 triadKnob:(ELIntegerKnob *)triadKnob
                ghostsKnob:(ELIntegerKnob *)ghostsKnob
              overrideKnob:(ELBooleanKnob *)overrideKnob
              channelSends:(NSDictionary *)channelSends;

@property ELIntegerKnob *velocityKnob;
@property ELIntegerKnob *emphasisKnob;
@property ELIntegerKnob *durationKnob;
@property ELIntegerKnob *triadKnob;
@property ELIntegerKnob *ghostsKnob;
@property ELBooleanKnob *overrideKnob;
@property (assign) NSDictionary *channelSends;

@end
