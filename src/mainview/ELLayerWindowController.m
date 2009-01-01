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

- (id)initWithLayer:(ELLayer *)_layer_ {
  if( ( self = [self initWithWindowNibName:@"LayerWindow"] ) ) {
    layer = _layer_;
  }
  
  return self;
}

- (void)windowDidLoad {
  // This is required because the HoneycombView doesn't resize very nicely right now
  [[self window] setAspectRatio:NSMakeSize(1.12,1.0)];
  
  [layerView setDelegate:self];
  [layerView setDataSource:layer];
  [layer setDelegate:layerView];
  [layer addObserver:self forKeyPath:@"channelKnob.value" options:0 context:nil];
  [layer addObserver:self forKeyPath:@"layerId" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)_keyPath_ ofObject:(id)_object_ change:(NSDictionary *)_change_ context:(id)_context_ {
  if( _object_ == layer && ( [_keyPath_ isEqualToString:@"channelKnob.value"] || [_keyPath_ isEqualToString:@"layerId"] ) ) {
    [self updateWindowTitle];
  }
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)_displayName_ {
  return [NSString stringWithFormat:@"%@ - %@ (Channel %d)", _displayName_, [layer layerId], [[layer channelKnob] value]];
}

- (void)updateWindowTitle {
  [[self window] setTitle:[self windowTitleForDocumentDisplayName:[[self document] displayName]]];
}

- (void)updateView {
  [layerView setNeedsDisplay:YES];
}

@end
