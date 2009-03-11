//
//  ELLayerWindowController.m
//  Elysium
//
//  Created by Matt Mower on 05/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELLayerWindowController.h"

#import "ELLayer.h"

@implementation ELLayerWindowController

- (id)initWithLayer:(ELLayer *)layer {
  if( ( self = [self initWithWindowNibName:@"LayerWindow"] ) ) {
    [self setShouldCloseDocument:YES];
    [self setLayer:layer];
  }
  
  return self;
}

@synthesize mLayer;


#pragma mark NSWindowController overrides

- (void)windowDidLoad {
  // This is required because the HoneycombView doesn't resize very nicely right now
  [[self window] setAspectRatio:NSMakeSize(1.12,1.0)];
  
  [layerView setDelegate:self];
  [layerView setDataSource:[self layer]];
  [[self layer] setDelegate:layerView];
  [[self layer] addObserver:self forKeyPath:@"channelDial.value" options:0 context:nil];
  [[self layer] addObserver:self forKeyPath:@"layerId" options:0 context:nil];
}


// When a layer window becomes main, show it's gadgets and hide the
// gadgets of all non-main windows
- (void)windowDidBecomeMain:(NSNotification *)notification {
  
}


- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
  return [NSString stringWithFormat:@"%@ - %@ (Channel %d)", displayName, [[self layer] layerId], [[[self layer] channelDial] value]];
}


#pragma mark NSKeyValueObserving protocol

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(id)context {
  if( object == [self layer] && ( [keyPath isEqualToString:@"channelDial.value"] || [keyPath isEqualToString:@"layerId"] ) ) {
    [self updateWindowTitle];
  }
}


#pragma mark Layer Window Control

- (void)updateWindowTitle {
  [[self window] setTitle:[self windowTitleForDocumentDisplayName:[[self document] displayName]]];
}


- (void)updateView {
  [layerView setNeedsDisplay:YES];
}

@end
