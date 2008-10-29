//
//  ELMIDIConfigController.m
//  Elysium
//
//  Created by Matt Mower on 29/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <PYMIDI/PYMIDI.h>

#import "ELMIDIConfigController.h"

#import "ELMIDIController.h"

@implementation ELMIDIConfigController

- (id)init {
  if( ( self = [super initWithWindowNibName:@"MIDIConfig"] ) ) {
    [self rescanMidiBus:nil];
  }
  
  return self;
}

@synthesize destinations;

- (IBAction)rescanMidiBus:(id)_sender_ {
  [self setDestinations:[[PYMIDIManager sharedInstance] realSources]];
}

- (IBAction)setMidiDestination:(id)_sender_ {
  
  int index = [destinationsTable selectedRow];
  NSLog( @"selected index = %d", index );
  
  PYMIDIRealDestination *destination = [destinations objectAtIndex:index];
  NSLog( @"Destination = %@", destination );
  
  [[ELMIDIController sharedInstance] setInput:destination];
}

@end
