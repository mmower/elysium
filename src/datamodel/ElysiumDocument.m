//
//  ElysiumDocument.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright LucidMac Software 2008 . All rights reserved.
//

#import "Elysium.h"

#import <HoneycombView/LMHoneycombView.h>

#import "ElysiumDocument.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELHarmonicTable.h"
#import "ElysiumController.h"
#import "ELLayerWindowController.h"

#import "ELStartTool.h"
#import "ELBeatTool.h"

@implementation ElysiumDocument

- (id)init
{
    self = [super init];
    if (self) {
      player = [[ELPlayer alloc] initWithDocument:self midiController:[self midiController]];
    }
    return self;
}

@synthesize player;

- (void)makeWindowControllers {
  [self addWindowController:[[NSWindowController alloc] initWithWindowNibName:@"ElysiumDocument"]];
  [self addWindowController:[[ELLayerWindowController alloc] initWithLayer:[player layer:0]]];
  [[NSApp delegate] showPalette:self];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  NSLog( @"dataOfType:%@", typeName );
  
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];

  NSXMLElement *rootElement = [NSXMLNode elementWithName:@"elysium"];
  [attributes setObject:[NSNumber numberWithInt:1] forKey:@"version"];
  [rootElement setAttributesAsDictionary:attributes];

  NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement:rootElement];
  [document setVersion:@"1.0"];
  [document setCharacterEncoding:@"UTF-8"];
  
  [rootElement addChild:[player asXMLData]];
  
  NSData *xml = [document XMLDataWithOptions:NSXMLNodePrettyPrint|NSXMLNodeCompactEmptyElement];
  
  return xml;
  //     if ( outError != NULL ) {
  //  *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
  // }
  // return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  // Get a new, empty, player for this document
  player = [[ELPlayer alloc] initWithDocument:self midiController:[self midiController] createDefaultLayer:NO];
  
  NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:0 error:outError];
  if( document == nil ) {
    return NO;
  }
  
  NSXMLElement *rootElement = [document rootElement];
  if( ![[rootElement name] isEqualToString:@"elysium"] ) {
    NSLog( @"Invalid root element type!" );
    return NO;
  }
  if( ![[[rootElement attributeForName:@"version"] stringValue] isEqualToString:@"1"] ) {
    NSLog( @"Invalid document version!" );
    return NO;
  }
  
  if( [player fromXMLData:rootElement] ) {
    NSLog( @"Loaded XML document" );
    return YES;
  } else {
    NSLog( @"Problem loading document" );
    return NO;
  }
  
  //     if ( outError != NULL ) {
  //  *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
  // }
  //     return YES;
}

- (ElysiumController *)appController {
  return [[NSApplication sharedApplication] delegate];
}

- (ELMIDIController *)midiController {
  return [[self appController] midiController];
}

// Actions

- (IBAction)startStop:(id)_sender_ {
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

- (IBAction)runOnce:(id)_sender_ {
  [player runOnce];
}

- (IBAction)clearAll:(id)_sender_ {
  [player clearAll];
  [self updateView:self];
}

- (IBAction)newLayer:(id)_sender_ {
  ELLayer *layer = [[ELLayer alloc] initWithPlayer:player channel:([player layerCount]+1)];
  [player addLayer:layer];
  NSLog( @"Added new layer %@ on channel %d", layer, [layer channel] );
  ELLayerWindowController *windowController = [[ELLayerWindowController alloc] initWithLayer:layer];
  [self addWindowController:windowController];
  [windowController showWindow:self];
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
