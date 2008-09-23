//
//  ELPlayerInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELPlayerInspectorController.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"

@implementation ELPlayerInspectorController

@synthesize player;

- (id)init {
  return [super initWithWindowNibName:@"PlayerInspector"];
}

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
}

- (void)focus:(ELPlayer *)_player_ {
  [self setPlayer:_player_];
}

- (void)selectionChanged:(NSNotification*)_notification_
{
  if( [[_notification_ object] isKindOfClass:[ELPlayer class]] ) {
    [self focus:[_notification_ object]];
  } else if( [[_notification_ object] isKindOfClass:[ELLayer class]] ) {
    [self focus:(ELPlayer *)[[_notification_ object] player]];
  } else if( [[_notification_ object] isKindOfClass:[ELHex class]] ) {
    [self focus:(ELPlayer *)[[[_notification_ object] layer] player]];
  }
}


@end
