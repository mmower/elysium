//
//  ELActivityViewerController.h
//  Elysium
//
//  Created by Matt Mower on 16/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ElysiumController;

@interface ELActivityViewerController : NSWindowController {
  NSMutableArray *activities;
}

- (void)recordActivity:(NSDictionary *)activity;
- (void)recordActivity:(NSString *)type when:(NSString *)when;
- (IBAction)clearActivities:(id)sender;

@end
