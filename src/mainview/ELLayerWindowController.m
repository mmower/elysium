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
  if( self = [self initWithWindowNibName:@"LayerWindow"] ) {
    layer = _layer_;
  }
  
  NSLog( @"Controller#initWithLayer:%@", layer );
  
  return self;
}

- (void)windowDidLoad {
  NSLog( @"Controller %@#windowDidLoad", self );
  [layerView setDelegate:self];
  [layerView setDataSource:layer];
  [self titleWindow];
  [layer addObserver:self forKeyPath:@"channel" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)_keyPath_ ofObject:(id)_object_ change:(NSDictionary *)_change_ context:(id)_context_ {
  if( _object_ == layer && [_keyPath_ isEqualToString:@"channel"] ) {
    [self titleWindow];
  }
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)_displayName_ {
  return [NSString stringWithFormat:@"%@ - Channel:%d", _displayName_, [layer channel]];
}

- (void)titleWindow {
  NSLog( @"title window %@ as %@", [self window], [NSString stringWithFormat:@"Channel %d",[layer channel]] );
  [[self window] setTitle:[NSString stringWithFormat:@"%@ - Channel:%d",[[self document] displayName],[layer channel]]];
}

@end
