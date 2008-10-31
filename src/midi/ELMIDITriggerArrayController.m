//
//  ELMIDITriggerArrayController.m
//  Elysium
//
//  Created by Matt Mower on 30/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELMIDITriggerArrayController.h"

#import "ELPlayer.h"
#import "ELMIDITrigger.h"

@implementation ELMIDITriggerArrayController

@synthesize player;

- (id)newObject {
  ELMIDITrigger *trigger = (ELMIDITrigger *)[super newObject];
  [trigger setPlayer:[self player]];
  NSLog( @"Made new %@ with player %@", [trigger className], [self player] );
  return trigger;
}

@end
