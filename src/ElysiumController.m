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

@implementation ElysiumController

- (id)init {
  if( self = [super init] ) {
    midiController = [[ELMIDIController alloc] init];
  }
  
  return self;
}

- (ELMIDIController *)midiController {
  return midiController;
}

- (void)awakeFromNib {
}

@end
