//
//  ELMIDIConfigController.h
//  Elysium
//
//  Created by Matt Mower on 29/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELPlayer;
@class ELMIDITriggerArrayController;

@interface ELMIDIConfigController : NSWindowController {
  IBOutlet NSTableView                  *destinationsTable;
  IBOutlet NSTableView                  *triggersTable;
  IBOutlet ELMIDITriggerArrayController *triggerArrayController;
  NSArray                               *destinations;
  ELPlayer                              *player;
}

- (id)initWithPlayer:(ELPlayer *)player;

@property (assign) NSArray *destinations;
@property (assign) ELPlayer *player;

- (void)selectionChanged:(NSNotification*)notification;
- (IBAction)rescanMidiBus:(id)sender;
- (IBAction)setMidiDestination:(id)sender;
- (IBAction)editTriggerCallback:(id)sender;

@end
