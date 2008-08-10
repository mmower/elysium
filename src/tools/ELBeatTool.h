//
//  ELBeatTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELTool.h"

@interface ELBeatTool : ELTool {

}

+ (id)new;

- (id)initWithVelocity:(int)velocity duration:(float)duration;

@property int velocity;
@property float duration;

@end
