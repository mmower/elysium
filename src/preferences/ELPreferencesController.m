//
//  ELPreferencesWindowController.m
//  Elysium
//
//  Created by Matt Mower on 20/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELPreferencesController.h"

NSString * const ELBehaviourAtOpenKey = @"BehaviourAtOpen";
NSString * const ELLayerThreadPriorityKey = @"LayerThreadPriority";
NSString * const ELMiddleCOctaveKey = @"MiddleCOctave";

NSString * const ELComposerNameKey = @"ComposerName";
NSString * const ELComposerEmailKey = @"ComposerEmail";

NSString * const ELDefaultTempoKey = @"DefaultTempo";
NSString * const ELDefaultTTLKey = @"DefaultTTL";
NSString * const ELDefaultPulseCountKey = @"DefaultPulseCount";
NSString * const ELDefaultVelocityKey = @"DefaultVelocity";
NSString * const ELDefaultEmphasisKey = @"DefaultEmphasis";
NSString * const ELDefaultDurationKey = @"DefaultDuration";

@implementation ELPreferencesController

- (id)init {
  if( ( self = [super initWithWindowNibName:@"PreferencesWindow"] ) ) {
  }
  
  return self;
}

@end
