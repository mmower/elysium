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
#import "ELHex.h"

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

- (void)selectionChanged:(NSNotification*)_notification_
{
  if( [[_notification_ object] isKindOfClass:[ELPlayer class]] ) {
    [self setPlayer:[_notification_ object]];
  } else if( [[_notification_ object] isKindOfClass:[ELLayer class]] ) {
    [self setPlayer:(ELPlayer *)[[_notification_ object] player]];
  } else if( [[_notification_ object] isKindOfClass:[ELHex class]] ) {
    [self setPlayer:(ELPlayer *)[[[_notification_ object] layer] player]];
  }
}

@end
