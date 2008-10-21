//
//  ELFilterDesignerController.h
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELKnob;
@class ELSquareFilter;
@class ELSawFilter;
@class ELSineFilter;
@class ELListFilter;
@class ELRandomFilter;

@interface ELFilterDesignerController : NSWindowController {
  ELKnob          *knob;
  
  ELSquareFilter  *squareFilter;
  ELSawFilter     *sawFilter;
  ELSineFilter    *sineFilter;
  ELListFilter    *listFilter;
  ELRandomFilter  *randomFilter;
}

- (id)initWithKnob:(ELKnob *)knob;

@property (readonly) ELKnob *knob;

@end
