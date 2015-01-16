//
//  ELMIDIConfigController.h
//  Elysium
//
//  Created by Matt Mower on 29/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
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

@property  (nonatomic,assign)  NSArray *destinations;
@property  (nonatomic,assign)  ELPlayer *player;

- (void)selectionChanged:(NSNotification*)notification;
- (IBAction)rescanMidiBus:(id)sender;
- (IBAction)setMidiDestination:(id)sender;
- (IBAction)editTriggerCallback:(id)sender;

@end
