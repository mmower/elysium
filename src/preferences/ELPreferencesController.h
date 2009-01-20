//
//  ELPreferencesWindowController.h
//  Elysium
//
//  Created by Matt Mower on 20/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum tagBehaviourAtOpen {
  EL_DO_NOT_OPEN = 0,
  EL_OPEN_EMPTY,
  EL_OPEN_LAST
} ELBehaviourAtOpen;

extern NSString * const ELBehaviourAtOpenKey;
extern NSString * const ELLastCompositionFileKey;
extern NSString * const ELComposerNameKey;
extern NSString * const ELComposerEmailKey;

@interface ELPreferencesController : NSWindowController {
}

@end
