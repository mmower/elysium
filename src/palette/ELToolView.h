//
//  ELToolView.h
//  Elysium
//
//  Created by Matt Mower on 29/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *ToolPBoardType;

#define EL_TOOL_GENERATOR   0x00
#define EL_TOOL_BEAT        0x01
#define EL_TOOL_RICOCHET    0x02
#define EL_TOOL_SINK        0x03
#define EL_TOOL_SPLITTER    0x04
#define EL_TOOL_ROTOR       0x05

#define EL_TOOL_CLEAR       0x0B

@interface ELToolView : NSImageView {
  NSEvent *savedEvent;
}

@end
