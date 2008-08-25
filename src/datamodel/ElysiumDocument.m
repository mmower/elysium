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
#import "ELHarmonicTable.h"
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
    
    NSLog( @"windowControllerDidLoadNib" );
    
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
