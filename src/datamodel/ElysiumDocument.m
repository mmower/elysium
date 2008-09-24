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
#import "ELLayerManagerWindowController.h"

#import "ELGenerateTool.h"
#import "ELNoteTool.h"

@implementation ElysiumDocument

@synthesize player;

- (void)makeWindowControllers {
  if( !player ) {
    player = [[ELPlayer alloc] initWithDocument:self midiController:[self midiController] createDefaultLayer:YES];
  }
  
  [self addWindowController:[[NSWindowController alloc] initWithWindowNibName:@"ElysiumDocument" owner:self]];
  
  for( ELLayer *layer in [player layers] ) {
    [self addWindowController:[[ELLayerWindowController alloc] initWithLayer:layer]];
  }
  
  [self addWindowController:[[ELLayerManagerWindowController alloc] init]];
  [[NSApp delegate] showPalette:self];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  NSLog( @"dataOfType:%@", typeName );
  
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];

  NSXMLElement *rootElement = [NSXMLNode elementWithName:@"elysium"];
  [attributes setObject:[NSNumber numberWithInt:2] forKey:@"version"];
  [rootElement setAttributesAsDictionary:attributes];

  NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement:rootElement];
  [document setVersion:@"1.0"];
  [document setCharacterEncoding:@"UTF-8"];
  
  [rootElement addChild:[player xmlRepresentation]];
  
  NSData *xml = [document XMLDataWithOptions:NSXMLNodePrettyPrint|NSXMLNodeCompactEmptyElement];
  
  return xml;
  //     if ( outError != NULL ) {
  //  *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
  // }
  // return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:0 error:outError];
  if( document == nil ) {
    return NO;
  }
  
  NSXMLElement *rootElement = [document rootElement];
  if( ![[rootElement name] isEqualToString:@"elysium"] ) {
    NSLog( @"Invalid root element type!" );
    return NO;
  }
  if( ![[[rootElement attributeForName:@"version"] stringValue] isEqualToString:@"2"] ) {
    NSLog( @"Invalid document version!" );
    return NO;
  }
  
  NSArray *nodes = [rootElement nodesForXPath:@"surface" error:nil];
  NSXMLElement *surfaceElement = (NSXMLElement *)[nodes objectAtIndex:0];
  if( ( player = [[ELPlayer alloc] initWithXmlRepresentation:surfaceElement parent:self player:nil] ) ) {
    [player setMIDIController:[self midiController]];
    [player setDocument:self];
    NSLog( @"Loaded XML document" );
    return YES;
  } else {
    NSLog( @"Problem loading document" );
    return NO;
  }
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
    [player stop];
  } else {
    [player start];
  }
}

- (IBAction)notesOnOff:(id)_sender_ {
  [player toggleNoteDisplay];
}

- (IBAction)clearAll:(id)_sender_ {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSWarningAlertStyle];
  [alert addButtonWithTitle:@"Clear All"];
  [alert addButtonWithTitle:@"Do Not Clear"];
  [alert setInformativeText:@"Pressing 'Clear All' will clear all hexes on all layers."];
  if( [alert runModal] == NSAlertFirstButtonReturn ) {
    [player clearAll];
    [self updateView:self];
  }
}

- (IBAction)newLayer:(id)_sender_ {
  ELLayerWindowController *windowController = [[ELLayerWindowController alloc] initWithLayer:[player createLayer]];
  [self addWindowController:windowController];
  [windowController showWindow:self];
}

- (void)document:(NSDocument *)_document_ shouldClose:(BOOL)_shouldClose_ contextInfo:(void*)_contextInfo_ {
  if( _shouldClose_ ) {
    [self close];
  }
}

- (IBAction)closeDocument:(id)_sender_ {
  [self canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(document:shouldClose:contextInfo:) contextInfo:nil];
}

// Sent by background threads when the view needs to be updated
- (void)updateView:(id)_sender_ {
  NSLog( @"document#needsDisplay" );
  [player needsDisplay];
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
