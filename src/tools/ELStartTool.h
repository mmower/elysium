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

@interface ELStartTool : ELTool {
}

- (id)initWithDirection:(Direction)direction TTL:(int)ttl;

@property Direction direction;
@property int TTL;

@end
