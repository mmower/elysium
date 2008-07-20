//
//  ELMIDIController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELMIDIController.h"

@implementation ELMIDIController

- (id)init {
  if( self = [super init] ) {
    clientName = CFStringCreateWithCString( NULL, "Elysium", 0 );
    if( clientName == NULL ) {
      NSLog( @"Cannot create client name" );
      return nil;
    }
    
    MIDIClientCreate( clientName, NULL, NULL, &midiClient );
    
    portName = CFStringCreateWithCString( NULL, "Output", 0 );
    if( portName == NULL ) {
      NSLog( @"Cannot create port name" );
      return nil;
    }
    
    MIDIOutputPortCreate( midiClient, portName, &outputPort );
    
    if( MIDIGetNumberOfDestinations() < 1 ) {
      NSLog( @"No MIDI destinations area available" );
      return nil;
    }
    
    destination = MIDIGetDestination( 0 );
    if( destination == NULL ) {
      NSLog( @"Failed to obtain MIDI output" );
      return nil;
    }
  }
  
  return self;
}



@end
