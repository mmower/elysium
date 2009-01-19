//
//  LMDialView.h
//  LMDial
//
//  Created by Matt Mower on 13/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum tagLMDialStyle {
  abletonLive,
  logicPro
} LMDialStyle;

@interface LMDialView : NSView {
    BOOL        enabled;
    LMDialStyle style;
    int         minimum;
    int         maximum;
    int         stepping;
    int         value;
    
    BOOL        showValue;

    NSColor     *onBorderColor;
    NSColor     *onFillColor;
    NSColor     *offBorderColor;
    NSColor     *offFillColor;
    NSColor     *valueColor;
    
    CGFloat     fontSize;
}

@property BOOL enabled;
@property LMDialStyle style;
@property int minimum;
@property int maximum;
@property int stepping;
@property int value;

@property BOOL showValue;
@property CGFloat fontSize;

@property (assign) NSColor *onBorderColor;
@property (assign) NSColor *onFillColor;
@property (assign) NSColor *offBorderColor;
@property (assign) NSColor *offFillColor;
@property (assign) NSColor *valueColor;

- (void)drawAbletonLiveStyleDial:(NSRect)bounds;
- (void)drawLogicProStyleDial:(NSRect)bounds;
- (void)drawValue:(NSRect)bounds;
- (void)drawText:(NSString *)text boundedBy:(NSRect)bounds;

- (void)updateBoundValue;

@end
