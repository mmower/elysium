//
//  Block+NAryGuardedValue.h
//  Elysium
//
//  Created by Matt Mower on 05/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <FScript/FScript.h>

@interface Block (Block_NAryGuardedValue)

- (id)guardedValue:(id)arg1 value:(id)arg2;

@end
