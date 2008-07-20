//
//  ELPlayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHarmonicTable;

@interface ELPlayer : NSObject {
  ELHarmonicTable   *harmonicTable;
  NSMutableArray    *layers;
}

- (ELHarmonicTable *)harmonicTable;

@end
