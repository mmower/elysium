//
//  ElysiumController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ElysiumController.h"

#import "ELMIDIController.h"
#import "ELPaletteController.h"
#import "ELInspectorController.h"

@implementation ElysiumController

- (id)init {
  if( self = [super init] ) {
    midiController = [[ELMIDIController alloc] init];
  }
  
  return self;
}

- (void)awakeFromNib {
}

- (ELMIDIController *)midiController {
  return midiController;
}

// Actions

- (IBAction)showInspectorPanel:(id)_sender_ {
  if( !inspectorController ) {
    inspectorController = [[ELInspectorController alloc] init];
  }
  
  [inspectorController showWindow:self];
  [inspectorController inspectPlayer];
}

- (IBAction)showPalette:(id)_sender_ {
  if( !paletteController ) {
    paletteController = [[ELPaletteController alloc] init];
  }
  
  // Asking inspector to show itself
  [paletteController showWindow:self];
}

@end
