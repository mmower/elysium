//
//  ELKnobView.h
//  Elysium
//
//  Created by Matt Mower on 22/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELKnobView : NSView {
  BOOL              supportsInheritance;
  
  NSViewController  *subviewController;
}

@property BOOL supportsInheritance;

@end
