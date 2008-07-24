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

- (IBAction)showInspectorPanel:(id)_sender {
  if( !inspectorController ) {
    inspectorController = [[ELInspectorController alloc] init];
  }
  
  NSLog( @"Showing %@", inspectorController );
  [inspectorController showWindow:self];
}

@end
