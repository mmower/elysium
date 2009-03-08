//
//  ELScriptPackageController.m
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELScriptPackageController.h"

#import "ELPlayer.h"
#import "ELLayer.h"
#import "ELCell.h"

@implementation ELScriptPackageController

- (id)init {
  if( ( self = [super initWithWindowNibName:@"ScriptPackageInspector"] ) ) {
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)_player_ {
  if( ( self = [self init] ) ) {
    [self setPlayer:_player_];
  }
  
  return self;
}

@synthesize player;

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
}

- (void)selectionChanged:(NSNotification*)notification
{
  if( [[notification object] isKindOfClass:[ELPlayer class]] ) {
    [self setPlayer:[notification object]];
  } else if( [[notification object] isKindOfClass:[ELLayer class]] ) {
    [self setPlayer:(ELPlayer *)[[notification object] player]];
  } else if( [[notification object] isKindOfClass:[ELCell class]] ) {
    [self setPlayer:(ELPlayer *)[[[notification object] layer] player]];
  }
}

@end
