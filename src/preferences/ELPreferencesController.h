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
extern NSString * const ELLayerThreadPriorityKey;

extern NSString * const ELComposerNameKey;
extern NSString * const ELComposerEmailKey;

extern NSString * const ELDefaultTempoKey;
extern NSString * const ELDefaultTTLKey;
extern NSString * const ELDefaultPulseCountKey;
extern NSString * const ELDefaultVelocityKey;
extern NSString * const ELDefaultEmphasisKey;
extern NSString * const ELDefaultDurationKey;

@interface ELPreferencesController : NSWindowController {
}

@end
