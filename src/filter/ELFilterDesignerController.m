//
//  ELFilterDesignerController.m
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELFilterDesignerController.h"

#import "ELPlayer.h"

@implementation ELFilterDesignerController

- (id)initWithPlayer:(ELPlayer *)_player_ {
  if( ( self = [self initWithWindowNibName:@"FilterDesigner"] ) ) {
    player = _player_;
  }
  
  return self;
}

@synthesize player;

@end
