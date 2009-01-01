//
//  ELReboundTool.h
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

#import "ELTool.h"

@interface ELReboundTool : ELTool <NSMutableCopying,DirectedTool> {
  ELIntegerKnob *directionKnob;
}

@property (readonly) ELIntegerKnob *directionKnob;

@end
