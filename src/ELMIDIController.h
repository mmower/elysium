//
//  ELMIDIController.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <CoreMIDI/CoreMIDI.h>

@interface ELMIDIController : NSObject {
  CFStringRef     clientName;
  CFStringRef     portName;
  MIDIClientRef   midiClient;
  MIDIPortRef     outputPort;
  MIDIEndpointRef destination;
}

@end
