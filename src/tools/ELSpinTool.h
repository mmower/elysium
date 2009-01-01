//
//  ELSpinTool.h
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

#import "ELTool.h"

@interface ELSpinTool : ELTool <NSMutableCopying> {
  ELBooleanKnob *clockwiseKnob;
  ELIntegerKnob *steppingKnob;
}

- (id)initWithClockwiseKnob:(ELBooleanKnob *)clockwiseKnob steppingKnob:(ELIntegerKnob *)steppingKnob;

@property (readonly) ELBooleanKnob *clockwiseKnob;
@property (readonly) ELIntegerKnob *steppingKnob;

@end
