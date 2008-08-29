//
//  ELSurfaceView.h
//  Elysium
//
//  Created by Matt Mower on 29/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <HoneycombView/LMHoneycombView.h>

@class ELHexCell;

@interface ELSurfaceView : LMHoneycombView {

}

- (ELHexCell *)cellUnderMouseLocation:(NSPoint)point;

- (void)addTool:(int)toolTag toCell:(ELHexCell *)cell;
- (void)addStartToolToCell:(ELHexCell *)cell;
- (void)addBeatToolToCell:(ELHexCell *)cell;
    
@end
