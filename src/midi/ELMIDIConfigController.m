//
//  ELMIDIConfigController.m
//  Elysium
//
//  Created by Matt Mower on 29/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import <PYMIDI/PYMIDI.h>

#import "ELMIDIConfigController.h"

#import "ELPlayer.h"
#import "ELMIDIController.h"

#import "RubyBlock.h"

@implementation ELMIDIConfigController

- (id)initWithPlayer:(ELPlayer *)_player_ {
  if( ( self = [super initWithWindowNibName:@"MIDIConfig"] ) ) {
    [self setPlayer:_player_];
    [self rescanMidiBus:nil];
  }
  
  return self;
}

@synthesize player;

- (void)awakeFromNib {
  [triggerArrayController setPlayer:[self player]];
}

@synthesize destinations;

- (IBAction)rescanMidiBus:(id)_sender_ {
  [self setDestinations:[[PYMIDIManager sharedInstance] realSources]];
}

- (IBAction)setMidiDestination:(id)_sender_ {
  int index = [destinationsTable selectedRow];
  if( index >= 0 ) {
    [[ELMIDIController sharedInstance] setInput:[destinations objectAtIndex:index]];
  }
}

- (IBAction)editTriggerCallback:(id)_sender_ {
  int index = [triggersTable selectedRow];
  if( index >= 0 ) {
    ELMIDITrigger *trigger = [[player triggers] objectAtIndex:index];
    [[trigger callback] inspect:self];
  }
}

@end
