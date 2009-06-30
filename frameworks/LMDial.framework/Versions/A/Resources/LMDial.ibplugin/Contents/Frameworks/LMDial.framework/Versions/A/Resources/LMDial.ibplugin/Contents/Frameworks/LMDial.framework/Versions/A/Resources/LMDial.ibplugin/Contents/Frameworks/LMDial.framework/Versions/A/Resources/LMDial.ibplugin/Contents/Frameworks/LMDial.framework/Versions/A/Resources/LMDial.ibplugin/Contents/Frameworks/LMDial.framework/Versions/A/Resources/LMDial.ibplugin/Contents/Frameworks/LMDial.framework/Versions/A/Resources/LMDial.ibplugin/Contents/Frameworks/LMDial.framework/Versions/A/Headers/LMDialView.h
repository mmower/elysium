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

@interface LMDialView : NSControl {
    BOOL              mEnabled;
    LMDialStyle       mStyle;
    int               mMinimum;
    int               mMaximum;
    int               mStepping;
    int               mValue;
    
    BOOL              mShowValue;

    NSColor           *mOnBorderColor;
    NSColor           *mLocalOnBorderColor;
    NSColor           *mOnFillColor;
    NSColor           *mLocalOnFillColor;
    NSColor           *mOffBorderColor;
    NSColor           *mLocalOffBorderColor;
    NSColor           *mOffFillColor;
    NSColor           *mLocalOffFillColor;
    NSColor           *mValueColor;
    
    int               mDivisor;
    NSString          *mFormatter;
    NSString          *mValueText;
    
    CGFloat           mFontSize;
    
    NSTextField       *mValueEditor;
    
    float             mAlpha;
}

@property (getter=enabled,setter=setEnabled:) BOOL mEnabled;
@property (getter=style,setter=setStyle:) LMDialStyle mStyle;
@property (getter=minimum,setter=setMinimum:) int mMinimum;
@property (getter=maximum,setter=setMaximum:) int mMaximum;
@property (getter=stepping,setter=setStepping:) int mStepping;
@property (getter=value,setter=setValue:) int mValue;
@property (getter=divisor,setter=setDivisor:) int mDivisor;
@property (getter=formatter,setter=setFormatter:,copy) NSString *mFormatter;

@property (getter=showValue,setter=setShowValue:) BOOL mShowValue;
@property (getter=fontSize,setter=setFontSize:) CGFloat mFontSize;

@property (getter=onBorderColor,setter=setOnBorderColor:,assign) NSColor *mOnBorderColor;
@property (getter=onFillColor,setter=setOnFillColor:,assign) NSColor *mOnFillColor;
@property (getter=offBorderColor,setter=setOffBorderColor:,assign) NSColor *mOffBorderColor;
@property (getter=offFillColor,setter=setOffFillColor:,assign) NSColor *mOffFillColor;
@property (getter=valueColor,setter=setValueColor:,assign) NSColor *mValueColor;

@end
