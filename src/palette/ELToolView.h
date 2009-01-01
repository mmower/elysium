//
//  ELToolView.h
//  Elysium
//
//  Created by Matt Mower on 29/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

extern NSString *ToolPBoardType;

#define EL_TOOL_GENERATE  0x00
#define EL_TOOL_NOTE      0x01
#define EL_TOOL_REBOUND   0x02
#define EL_TOOL_ABSORB    0x03
#define EL_TOOL_SPLIT     0x04
#define EL_TOOL_SPIN      0x05

#define EL_TOOL_CLEAR     0x0B

@interface ELToolView : NSImageView {
  NSEvent *savedEvent;
}

@end
