//
//  ELLayerWindowController.m
//  Elysium
//
//  Created by Matt Mower on 05/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELLayerWindowController.h"

#import "ELLayer.h"

@implementation ELLayerWindowController

- (id)initWithLayer:(ELLayer *)_layer_ {
  if( ( self = [self initWithWindowNibName:@"LayerWindow"] ) ) {
    layer = _layer_;
  }
  
  // NSLog( @"Controller#initWithLayer:%@", layer );
  
  return self;
}

- (void)windowDidLoad {
  // NSLog( @"Controller %@#windowDidLoad", self );
  [layerView setDelegate:self];
  [layerView setDataSource:layer];
  [layer setDelegate:layerView];
  [layer addObserver:self forKeyPath:@"channel" options:0 context:nil];
  [layer addObserver:self forKeyPath:@"layerId" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)_keyPath_ ofObject:(id)_object_ change:(NSDictionary *)_change_ context:(id)_context_ {
  if( _object_ == layer && ( [_keyPath_ isEqualToString:@"channel"] || [_keyPath_ isEqualToString:@"layerId"] ) ) {
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
