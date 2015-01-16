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
    int               _modMinimum;
    int               _maximum;
    int               _modMaximum;
    int               _stepping;
    
    int               _lowerValueBound;
    int               _value;
    int               _upperValueBound;
    
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
    
    BOOL              _debug;
    BOOL              _boundsChecking;
}

@property BOOL enabled;
@property BOOL debug;
@property BOOL boundsChecking;

@property LMDialStyle style;
@property int minimum;
// @property int modMinimum;
@property int maximum;
// @property int modMaximum;
@property int stepping;
@property int value;
@property int divisor;
@property (copy) NSString *formatter;

@property (readonly) int lowerValueBound;
@property (readonly) int upperValueBound;

@property BOOL showValue;
@property CGFloat fontSize;

@property (assign) NSColor *onBorderColor;
@property (assign) NSColor *onFillColor;
@property (assign) NSColor *offBorderColor;
@property (assign) NSColor *offFillColor;
@property (assign) NSColor *valueColor;

@property (assign) LMDialMap *dialMap;

@end
