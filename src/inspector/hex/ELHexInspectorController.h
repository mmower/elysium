//
//  ELHexInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <StackedListView/PAStackedListView.h>
#import <StackedListView/PACollapsibleSectionBox.h>
#import <StackedListView/PASectionHeaderView.h>

@class ELHex;

@interface ELHexInspectorController : NSWindowController {
  IBOutlet  id  generateBox;
  IBOutlet  id  noteBox;
  IBOutlet  id  reboundBox;
  IBOutlet  id  absorbBox;
  IBOutlet  id  splitBox;
  IBOutlet  id  spinBox;
  ELHex         *hex;
}

@property ELHex *hex;

- (void)focus:(ELHex *)hex;
- (void)selectionChanged:(NSNotification*)notification;

@end
