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
  logicPro,
  logicPan
} LMDialStyle;

@class LMDialEditWindow;

@interface LMDialView : NSView {
    BOOL              enabled;
    LMDialStyle       style;
    int               minimum;
    int               maximum;
    int               stepping;
    int               value;
    
    BOOL              showValue;

    NSColor           *onBorderColor;
    NSColor           *localOnBorderColor;
    NSColor           *onFillColor;
    NSColor           *localOnFillColor;
    NSColor           *offBorderColor;
    NSColor           *localOffBorderColor;
    NSColor           *offFillColor;
    NSColor           *localOffFillColor;
    NSColor           *valueColor;
    
    int               divisor;
    NSString          *formatter;
    NSString          *valueText;
    
    CGFloat           fontSize;
    
    NSTextField       *valueEditor;
    
    float             alpha;
}

@property BOOL enabled;
@property LMDialStyle style;
@property int minimum;
@property int maximum;
@property int stepping;
@property int value;
@property int divisor;
@property (copy) NSString *formatter;

@property BOOL showValue;
@property CGFloat fontSize;

@property (assign) NSColor *onBorderColor;
@property (assign) NSColor *onFillColor;
@property (assign) NSColor *offBorderColor;
@property (assign) NSColor *offFillColor;
@property (assign) NSColor *valueColor;


@end
