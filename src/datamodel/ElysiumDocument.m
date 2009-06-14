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

- (id)init {
  if( ( self = [super init] ) ) {
    _player = [[ELPlayer alloc] initWithDocument:self createDefaultLayer:YES];
    [self setComposerName:[[NSUserDefaults standardUserDefaults] stringForKey:ELComposerNameKey]];
    [self setComposerEmail:[[NSUserDefaults standardUserDefaults] stringForKey:ELComposerEmailKey]];
  }
  
  return self;
}

#pragma mark Properties

@synthesize player = _player;
@synthesize composerName = _composerName;
@synthesize composerEmail = _composerEmail;
@synthesize title = _title;
@synthesize notes = _notes;


#pragma mark Implements NSDocument

- (void)makeWindowControllers {
  for( ELLayer *layer in [[self player] layers] ) {
    [self addWindowController:[[ELLayerWindowController alloc] initWithLayer:layer]];
  }
  
  // Show the inspectors by default, and ensure something is selected from the right player/layer
  [[NSApp delegate] showLayerManager:self];
  [[NSApp delegate] showInspectorPanel:self];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
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
  
  NSXMLElement *playerElement = [[self player] xmlRepresentation];
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


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
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
    _player = [[ELPlayer alloc] initWithXmlRepresentation:surfaceElement parent:self player:nil error:outError];
  }
  
  if( !surfaceElement || !_player ) {
    *outError = [[NSError alloc] initWithDomain:ELErrorDomain
                                           code:EL_ERR_DOCUMENT_LOAD_FAILURE
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Cannot load document, reason unknown.", NSLocalizedDescriptionKey, nil]];
    return NO;
  }
  
  [_player setDocument:self];
  
  return YES;
}


#pragma mark Object behaviour

- (ElysiumController *)appController {
  return [[NSApplication sharedApplication] delegate];
}


#pragma mark UI Actions

- (BOOL)validateMenuItem:(NSMenuItem *)item {
  SEL action = [item action];
  
  if( action == @selector(toggleKeyDisplay:) ) {
    if( [[self player] showKey] ) {
      [item setTitle:@"Hide Key"];
      [item setState:NSOnState];
    } else {
      [item setTitle:@"Show Key"];
      [item setState:NSOffState];
    }
  } else if( action == @selector(toggleOctavesDisplay:) ) {
    if( [[self player] showOctaves] ) {
      [item setTitle:@"Hide Octaves"];
      [item setState:NSOnState];
    } else {
      [item setTitle:@"Show Octaves"];
      [item setState:NSOffState];
    }
  } else if( action == @selector(toggleNoteDisplay:) ) {
    if( [[self player] showNotes] ) {
      [item setTitle:@"Hide Notes"];
      [item setState:NSOnState];
    } else {
      [item setTitle:@"Show Notes"];
      [item setState:NSOffState];
    }
  } else if( action == @selector(startStop:) ) {
    if( [[self player] running] ) {
      [item setTitle:@"Stop Playing"];
      [item setState:NSOnState];
    } else {
      [item setTitle:@"Start Playing"];
      [item setState:NSOffState];
    }
  }
  
  return YES;
}

- (IBAction)startStop:(id)sender {
  if( [[self player] running] ) {
    [[self player] stop:self];
  } else {
    [[self player] start:self];
  }
}

- (IBAction)toggleNoteDisplay:(id)sender {
  [[self player] toggleNoteDisplay];
  [self updateView:self];
}

- (IBAction)toggleKeyDisplay:(id)sender {
  BOOL showKey = ![[self player] showKey];
  [[self player] setShowKey:showKey];
  if( showKey ) {
    [[self player] setShowOctaves:NO];
  }
  [self updateView:self];
}

- (IBAction)toggleOctavesDisplay:(id)sender {
  BOOL showOctave = ![[self player] showOctaves];
  [[self player] setShowOctaves:showOctave];
  if( showOctave ) {
    [[self player] setShowKey:NO];
  }
  [self updateView:self];
}

- (IBAction)clearAll:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSWarningAlertStyle];
  [alert addButtonWithTitle:@"Clear All"];
  [alert addButtonWithTitle:@"Do Not Clear"];
  [alert setInformativeText:@"Pressing 'Clear All' will clear all cells on all layers."];
  if( [alert runModal] == NSAlertFirstButtonReturn ) {
    [[self player] clearAll];
    [self updateView:self];
  }
}

- (IBAction)clearSelectedLayer:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSWarningAlertStyle];
  [alert addButtonWithTitle:@"Clear Layer"];
  [alert addButtonWithTitle:@"Do Not Clear"];
  [alert setInformativeText:@"Pressing 'Clear Layer' will clear all cells on the selected layer."];
  if( [alert runModal] == NSAlertFirstButtonReturn ) {
    [[[self player] selectedLayer] clear];
    [self updateView:self];
  }
}

- (IBAction)newLayer:(id)sender {
  ELLayerWindowController *windowController = [[ELLayerWindowController alloc] initWithLayer:[[self player] createLayer]];
  [self addWindowController:windowController];
  [windowController showWindow:self];
}

- (IBAction)toggleGeneratorToken:(id)sender {
  [[[[self player] selectedLayer] selectedCell] toggleGenerateToken:sender];
}

- (IBAction)toggleNoteToken:(id)sender {
  [[[[self player] selectedLayer] selectedCell] toggleNoteToken:sender];
}

- (IBAction)toggleReboundToken:(id)sender {
  [[[[self player] selectedLayer] selectedCell] toggleReboundToken:sender];
}

- (IBAction)toggleAbsorbToken:(id)sender {
  [[[[self player] selectedLayer] selectedCell] toggleAbsorbToken:sender];
}

- (IBAction)toggleSplitToken:(id)sender {
  [[[[self player] selectedLayer] selectedCell] toggleSplitToken:sender];
}

- (IBAction)toggleSpinToken:(id)sender {
  [[[[self player] selectedLayer] selectedCell] toggleSpinToken:sender];
}

- (IBAction)toggleSkipToken:(id)sender {
  [[[[self player] selectedLayer] selectedCell] toggleSkipToken:sender];
}

- (IBAction)clearCell:(id)sender {
  [[[[self player] selectedLayer] selectedCell] clearTokens:sender];
}

- (IBAction)showOscillatorDesigner:(id)sender {
  if( !_oscillatorDesignerController ) {
    _oscillatorDesignerController = [[ELOscillatorDesignerController alloc] initWithPlayer:[self player]];
  }
  
  [_oscillatorDesignerController showWindow:sender];
}


#pragma mark NSDocument implementation

- (void)document:(NSDocument *)document shouldClose:(BOOL)shouldClose contextInfo:(void*)contextInfo {
  if( shouldClose ) {
    [self close];
  }
}

- (IBAction)closeDocument:(id)sender {
  [self canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(document:shouldClose:contextInfo:) contextInfo:nil];
}


#pragma mark Background thread support

- (void)updateView:(id)sender {
  [[self player] needsDisplay];
}


#pragma mark MIDI Controller delegate methods

- (void)noteOn:(int)note velocity:(int)velocity channel:(int)channel {
  NSLog( @"delegate received noteOn:%d:%d message", channel, note );
}


- (void)noteOff:(int)note velocity:(int)velocity channel:(int)channel {
  NSLog( @"delegate received noteOff:%d:%d message", channel, note );
}


- (void)programChange:(int)preset channel:(int)channel {
  NSLog( @"delegate received programChange:%d on channel:%d", preset, channel );
}


@end
