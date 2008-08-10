//
//  ElysiumDocument.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright LucidMac Software 2008 . All rights reserved.
//

#import "Elysium.h"

#import "ElysiumDocument.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ElysiumController.h"

#import "ELStartTool.h"
#import "ELBeatTool.h"

@implementation ElysiumDocument

- (id)init
{
    self = [super init];
    if (self) {
      player   = [[ELPlayer alloc] init];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"ElysiumDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [player setMIDIController:[self midiController]];
    [player setDocument:self];
    
    ELLayer *layer = [player layerForChannel:1];
    [[layer hexAtColumn:5 row:5] addTool:[[ELStartTool alloc] initWithDirection:NE TTL:25]];
    [[layer hexAtColumn:6 row:5] addTool:[ELBeatTool new]];
    [[layer hexAtColumn:11 row:8] addTool:[ELBeatTool new]];
    
    [layerView setDelegate:self];
    [layerView setDataSource:layer];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

- (ElysiumController *)appController {
  return [[NSApplication sharedApplication] delegate];
}

- (ELMIDIController *)midiController {
  return [[self appController] midiController];
}

// Actions

- (IBAction)startStop:(id)sender {
  if( [player isRunning] ) {
    [controlButton setTitle:@"Start"];
    [player stop];
    [[self midiController] setDelegate:nil];
  } else {
    [controlButton setTitle:@"Stop"];
    [[self midiController] setDelegate:self];
    [player start];
  }
}

// Sent by background threads when the view needs to be updated
- (void)updateView:(id)sender {
  [layerView setNeedsDisplay:YES];
}


// MIDI Controller delegate methods

- (void)noteOn:(int)_note velocity:(int)_velocity channel:(int)_channel {
  NSLog( @"delegate received noteOn:%d:%d message", _channel, _note );
}

- (void)noteOff:(int)_note velocity:(int)_velocity channel:(int)_channel {
  NSLog( @"delegate received noteOff:%d:%d message", _channel, _note );
}

- (void)programChange:(int)_preset channel:(int)_channel {
  NSLog( @"delegate received programChange:%d on channel:%d", _preset, _channel );
}

@end
