//
//  PAStackedListView.h
//  StackedListView
//
//  Created by Tomas Franzén on 2008-07-16.
//  Copyright 2008 Lighthead Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PAStackedListView : NSView {
  BOOL  isArranging;
}

- (void)rearrangeSubviews;

@end
