//
//  ELMIDIConfigController.h
//  Elysium
//
//  Created by Matt Mower on 29/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELMIDIConfigController : NSWindowController {
  IBOutlet NSTableView        *destinationsTable;
  NSArray                     *destinations;
}

@property (assign) NSArray *destinations;

- (IBAction)rescanMidiBus:(id)sender;
- (IBAction)setMidiDestination:(id)sender;

@end
