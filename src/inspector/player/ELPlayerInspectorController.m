//
//  ELPlayerInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELPlayerInspectorController.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"

#import "ELOscillator.h"
#import "ELOscillatorDesignerController.h"

@implementation ELPlayerInspectorController

@synthesize player;

- (id)init {
  if( ( self = [super initWithWindowNibName:@"PlayerInspector"] ) ) {
    oscillatorDesigners = [NSMutableDictionary dictionary];
  }
  
  return self;
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

- (IBAction)editOscillator:(id)_sender_ {
  ELOscillatorDesignerController *controller;
  
  // if( !( controller = [_sender_ oscillatorController] ) ) {
    // controller = [[ELOscillatorDesignerController alloc] initWithDial:_sender_];
    // [_sender_ setOscillatorController:controller];
  // }
  
  [controller edit];
}

- (IBAction)editScript:(id)_sender_ {
  ELScript *block;
  NSString *callback = @"unknown";
  
  switch( [_sender_ tag] ) {
    case 0:
      callback = @"willStart";
      break;
    case 1:
      callback = @"didStart";
      break;
    case 2:
      callback = @"willStop";
      break;
    case 3:
      callback = @"didStop";
      break;
  }
  
  if( !( block = [[player scripts] objectForKey:callback] ) ) {
    block = [@"function(player) {\n\t// write your callback code here\n}\n" asJavascriptFunction];
    [[player scripts] setObject:block forKey:callback];
  }
  
  [block inspect:self];
}

- (IBAction)removeScript:(id)_sender_ {
  NSString *callback = @"unknown";
  
  switch( [_sender_ tag] ) {
    case 0:
      callback = @"willStart";
      break;
    case 1:
      callback = @"didStart";
      break;
    case 2:
      callback = @"willStop";
      break;
    case 3:
      callback = @"didStop";
      break;
  }
  
  [[player scripts] removeObjectForKey:callback];
}

@end
