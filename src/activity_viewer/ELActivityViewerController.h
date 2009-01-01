//
//  ELActivityViewerController.h
//  Elysium
//
//  Created by Matt Mower on 16/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
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
