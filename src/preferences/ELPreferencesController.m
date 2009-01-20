//
//  ELPreferencesWindowController.m
//  Elysium
//
//  Created by Matt Mower on 20/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELPreferencesController.h"

NSString * const ELBehaviourAtOpenKey = @"BehaviourAtOpen";
NSString * const ELLastCompositionFileKey = @"LastCompositionFile";
NSString * const ELComposerNameKey = @"ComposerName";
NSString * const ELComposerEmailKey = @"ComposerEmail";

@implementation ELPreferencesController

- (id)init {
  if( ( self = [super initWithWindowNibName:@"PreferencesWindow"] ) ) {
  }
  
  return self;
}

@end
