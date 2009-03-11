//
//  ElysiumDocument.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#define CURRENT_DOCUMENT_VERSION 7

#import <HoneycombView/LMHoneycombView.h>

#import "ElysiumDocument.h"

#import "ELCell.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELHarmonicTable.h"
#import "ElysiumController.h"

#import "ELLayerWindowController.h"
#import "ELLayerManagerWindowController.h"
#import "ELOscillatorDesignerController.h"


@implementation ElysiumDocument

@synthesize player;
@synthesize composerName;
@synthesize composerEmail;
@synthesize title;
@synthesize notes;

- (id)init {
  if( ( self = [super init] ) ) {
    player = [[ELPlayer alloc] initWithDocument:self createDefaultLayer:YES];
    [self setComposerName:[[NSUserDefaults standardUserDefaults] stringForKey:ELComposerNameKey]];
    [self setComposerEmail:[[NSUserDefaults standardUserDefaults] stringForKey:ELComposerEmailKey]];
  }
  
  return self;
}

- (void)makeWindowControllers {
  // [self addWindowController:[[NSWindowController alloc] initWithWindowNibName:@"ElysiumDocument" owner:self]];
  
  for( ELLayer *layer in [player layers] ) {
    [self addWindowController:[[ELLayerWindowController alloc] initWithLayer:layer]];
  }
  
  // Show the inspectors by default, and ensure something is selected from the right player/layer
  [[NSApp delegate] showLayerManager:self];
  [[NSApp delegate] showInspectorPanel:self];
  
  // Select a cell, any cell
  // [[player layer:0] hexCellSelected:[[player layer:0] cellAtColumn:8 row:6]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  
  NSXMLElement *rootElement = [NSXMLNode elementWithName:@"elysium"];
  [attributes setObject:[NSNumber numberWithInt:CURRENT_DOCUMENT_VERSION] forKey:@"version"];
  [rootElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *infoElement = [NSXMLNode elementWithName:@"info"];
  
  NSXMLElement *composerElement = [NSXMLNode elementWithName:@"composer"];
  [attributes removeAllObjects];
  [attributes setObject:[self composerName] forKey:@"name"];
  [attributes setObject:[self composerEmail] forKey:@"email"];
  [composerElement setAttributesAsDictionary:attributes];
  [infoElement addChild:composerElement];
  
  NSXMLElement *titleElement = [NSXMLNode elementWithName:@"title"];
  [titleElement setStringValue:[self title]];
  [infoElement addChild:titleElement];
  
  NSXMLElement *notesElement = [NSXMLNode elementWithName:@"notes"];
  [notesElement setStringValue:[self notes]];
  [infoElement addChild:notesElement];
  
  [rootElement addChild:infoElement];
  
  NSXMLElement *playerElement = [player xmlRepresentation];
  if( !playerElement ) {
    *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    return nil;
  }
  [rootElement addChild:playerElement];
  
  NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement:rootElement];
  [document setVersion:@"1.0"];
  [document setCharacterEncoding:@"UTF-8"];
  return [document XMLDataWithOptions:NSXMLNodePrettyPrint|NSXMLNodeCompactEmptyElement];
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)typeName {
  NSError *error = nil;
  BOOL result = [self readFromData:data ofType:typeName error:&error];
  
  if( error != nil ) {
    NSLog( @"Error loading last document: %@", [error localizedDescription] );
  }
  
  return result;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  assert( outError != nil );
  
  NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:0 error:outError];
  if( document == nil ) {
    return NO;
  }
  
  NSXMLElement *rootElement = [document rootElement];
  if( ![[rootElement name] isEqualToString:@"elysium"] ) {
    *outError = [[NSError alloc] initWithDomain:ELErrorDomain
                                           code:EL_ERR_DOCUMENT_INVALID_ROOT
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Document root element must be 'elysium'", NSLocalizedDescriptionKey, nil]];
    return NO;
  }
  
  int docVersion = [rootElement attributeAsInteger:@"version" defaultValue:-1];
  if( docVersion < CURRENT_DOCUMENT_VERSION ) {
    NSLog( @"Wrong document version." );
    *outError = [[NSError alloc] initWithDomain:ELErrorDomain
                                           code:EL_ERR_DOCUMENT_INVALID_VERSION
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Document version %d is not supported",docVersion], NSLocalizedDescriptionKey, nil]];
    return NO;
  }
  
  NSXMLElement *titleElement = [[rootElement nodesForXPath:@"info/title" error:outError] firstXMLElement];
  if( titleElement ) {
    [self setTitle:[titleElement stringValue]];
  }
  
  NSXMLElement *notesElement = [[rootElement nodesForXPath:@"info/notes" error:outError] firstXMLElement];
  if( notesElement ) {
    [self setNotes:[notesElement stringValue]];
  }
  
  NSXMLElement *composerElement = [[rootElement nodesForXPath:@"info/composer" error:outError] firstXMLElement];
  if( composerElement ) {
    [self setComposerName:[composerElement attributeAsString:@"name"]];
    [self setComposerEmail:[composerElement attributeAsString:@"email"]];
  }
  
  NSXMLElement *surfaceElement = [[rootElement nodesForXPath:@"surface" error:nil] firstXMLElement];
  if( surfaceElement ) {
    player = [[ELPlayer alloc] initWithXmlRepresentation:surfaceElement parent:self player:nil error:outError];
  }
  
  if( !surfaceElement || !player ) {
    *outError = [[NSError alloc] initWithDomain:ELErrorDomain
                                           code:EL_ERR_DOCUMENT_LOAD_FAILURE
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Cannot load document, reason unknown.", NSLocalizedDescriptionKey, nil]];
    return NO;
  }
  
  [player setDocument:self];
  
  return YES;
}

- (ElysiumController *)appController {
  return [[NSApplication sharedApplication] delegate];
}

// Actions

- (BOOL)validateMenuItem:(NSMenuItem *)_item_ {
  SEL action = [_item_ action];
  
  if( action == @selector(toggleKeyDisplay:) ) {
    if( [player showKey] ) {
      [_item_ setTitle:@"Hide Key"];
      [_item_ setState:NSOnState];
    } else {
      [_item_ setTitle:@"Show Key"];
      [_item_ setState:NSOffState];
    }
  } else if( action == @selector(toggleOctavesDisplay:) ) {
    if( [player showOctaves] ) {
      [_item_ setTitle:@"Hide Octaves"];
      [_item_ setState:NSOnState];
    } else {
      [_item_ setTitle:@"Show Octaves"];
      [_item_ setState:NSOffState];
    }
  } else if( action == @selector(toggleNoteDisplay:) ) {
    if( [player showNotes] ) {
      [_item_ setTitle:@"Hide Notes"];
      [_item_ setState:NSOnState];
    } else {
      [_item_ setTitle:@"Show Notes"];
      [_item_ setState:NSOffState];
    }
  } else if( action == @selector(startStop:) ) {
    if( [player running] ) {
      [_item_ setTitle:@"Stop Playing"];
      [_item_ setState:NSOnState];
    } else {
      [_item_ setTitle:@"Start Playing"];
      [_item_ setState:NSOffState];
    }
  }
  
  return YES;
}

- (IBAction)startStop:(id)_sender_ {
  if( [player running] ) {
    [player stop:self];
  } else {
    [player start:self];
  }
}

- (IBAction)toggleNoteDisplay:(id)_sender_ {
  [player toggleNoteDisplay];
  [self updateView:self];
}

- (IBAction)toggleKeyDisplay:(id)_sender_ {
  BOOL showKey = ![player showKey];
  [player setShowKey:showKey];
  if( showKey ) {
    [player setShowOctaves:NO];
  }
  [self updateView:self];
}

- (IBAction)toggleOctavesDisplay:(id)_sender_ {
  BOOL showOctave = ![player showOctaves];
  [player setShowOctaves:showOctave];
  if( showOctave ) {
    [player setShowKey:NO];
  }
  [self updateView:self];
}

- (IBAction)clearAll:(id)_sender_ {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSWarningAlertStyle];
  [alert addButtonWithTitle:@"Clear All"];
  [alert addButtonWithTitle:@"Do Not Clear"];
  [alert setInformativeText:@"Pressing 'Clear All' will clear all cells on all layers."];
  if( [alert runModal] == NSAlertFirstButtonReturn ) {
    [player clearAll];
    [self updateView:self];
  }
}

- (IBAction)clearSelectedLayer:(id)_sender_ {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSWarningAlertStyle];
  [alert addButtonWithTitle:@"Clear Layer"];
  [alert addButtonWithTitle:@"Do Not Clear"];
  [alert setInformativeText:@"Pressing 'Clear Layer' will clear all cells on the selected layer."];
  if( [alert runModal] == NSAlertFirstButtonReturn ) {
    [[player selectedLayer] clear];
    [self updateView:self];
  }
}

- (IBAction)newLayer:(id)_sender_ {
  ELLayerWindowController *windowController = [[ELLayerWindowController alloc] initWithLayer:[player createLayer]];
  [self addWindowController:windowController];
  [windowController showWindow:self];
}

- (IBAction)toggleGeneratorToken:(id)_sender_ {
  [[[player selectedLayer] selectedCell] toggleGenerateToken:_sender_];
}

- (IBAction)toggleNoteToken:(id)_sender_ {
  [[[player selectedLayer] selectedCell] toggleNoteToken:_sender_];
}

- (IBAction)toggleReboundToken:(id)_sender_ {
  [[[player selectedLayer] selectedCell] toggleReboundToken:_sender_];
}

- (IBAction)toggleAbsorbToken:(id)_sender_ {
  [[[player selectedLayer] selectedCell] toggleAbsorbToken:_sender_];
}

- (IBAction)toggleSplitToken:(id)_sender_ {
  [[[player selectedLayer] selectedCell] toggleSplitToken:_sender_];
}

- (IBAction)toggleSpinToken:(id)_sender_ {
  [[[player selectedLayer] selectedCell] toggleSpinToken:_sender_];
}

- (IBAction)toggleSkipToken:(id)sender {
  [[[player selectedLayer] selectedCell] toggleSkipToken:sender];
}

- (IBAction)clearCell:(id)_sender_ {
  [[[player selectedLayer] selectedCell] clearTokens:_sender_];
}

- (IBAction)showOscillatorDesigner:(id)sender {
  if( !oscillatorDesignerController ) {
    oscillatorDesignerController = [[ELOscillatorDesignerController alloc] initWithPlayer:[self player]];
  }
  
  [oscillatorDesignerController showWindow:sender];
}


#pragma mark NSDocument implementation

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
