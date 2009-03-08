//
//  ELMIDIConfigController.m
//  Elysium
//
//  Created by Matt Mower on 29/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import <PYMIDI/PYMIDI.h>

#import "ELMIDIConfigController.h"

#import "ELCell.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELMIDIController.h"

@implementation ELMIDIConfigController

- (id)initWithPlayer:(ELPlayer *)_player_ {
  if( ( self = [super initWithWindowNibName:@"MIDIConfig"] ) ) {
    [self setPlayer:_player_];
    [self rescanMidiBus:nil];
  }
  
  return self;
}

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
  [triggerArrayController setPlayer:[self player]];
}

@synthesize player;
@synthesize destinations;

- (void)selectionChanged:(NSNotification*)notification
{
  if( [[notification object] isKindOfClass:[ELPlayer class]] ) {
    [self setPlayer:[notification object]];
  } else if( [[notification object] isKindOfClass:[ELLayer class]] ) {
    [self setPlayer:(ELPlayer *)[[notification object] player]];
  } else if( [[notification object] isKindOfClass:[ELCell class]] ) {
    [self setPlayer:(ELPlayer *)[[[notification object] layer] player]];
  }
  
  [triggerArrayController setPlayer:[self player]];
}

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
