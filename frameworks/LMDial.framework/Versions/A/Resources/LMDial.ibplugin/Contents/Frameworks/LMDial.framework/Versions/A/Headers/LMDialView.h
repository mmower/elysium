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

@class LMDialMap;

@interface LMDialView : NSView {
    BOOL              _enabled;
    LMDialStyle       _style;
    int               _minimum;
    int               _maximum;
    int               _stepping;
    int               _value;
    
    BOOL              _showValue;

    NSColor           *_onBorderColor;
    NSColor           *_localOnBorderColor;
    NSColor           *_onFillColor;
    NSColor           *_localOnFillColor;
    NSColor           *_offBorderColor;
    NSColor           *_localOffBorderColor;
    NSColor           *_offFillColor;
    NSColor           *_localOffFillColor;
    NSColor           *_valueColor;
    
    int               _divisor;
    NSString          *_formatter;
    NSString          *_valueText;
    
    CGFloat           _fontSize;
    
    NSTextField       *_valueEditor;
    
    float             _alpha;
    
    LMDialMap         *_dialMap;
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

@property (assign) LMDialMap *dialMap;

@end
