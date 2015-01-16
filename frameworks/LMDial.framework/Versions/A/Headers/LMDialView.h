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

@interface LMDialView : NSView <NSTextFieldDelegate> {
    BOOL _enabled;
    LMDialStyle _style;
    int _minimum;
    int _maximum;
    int _stepping;
    int _value;
    
    BOOL _showValue;
    
    NSColor *_onBorderColor;
    NSColor *_localOnBorderColor;
    NSColor *_onFillColor;
    NSColor *_localOnFillColor;
    NSColor *_offBorderColor;
    NSColor *_localOffBorderColor;
    NSColor *_offFillColor;
    NSColor *_localOffFillColor;
    NSColor *_valueColor;
    
    int _divisor;
    NSString *_formatter;
    NSString *_valueText;
    
    CGFloat _fontSize;
    
    NSTextField *_valueEditor;
    
    float _alpha;
}

@property (nonatomic) BOOL enabled;
@property (nonatomic)  LMDialStyle style;
@property (nonatomic) int minimum;
@property (nonatomic) int maximum;
@property (nonatomic)  int stepping;
@property (nonatomic) int value;
@property (nonatomic) int divisor;
@property (nonatomic, copy) NSString *formatter;

@property (nonatomic) BOOL showValue;
@property (nonatomic) CGFloat fontSize;

@property (assign, nonatomic) NSColor *onBorderColor;
@property (assign, nonatomic) NSColor *onFillColor;
@property (assign, nonatomic) NSColor *offBorderColor;
@property (assign, nonatomic) NSColor *offFillColor;
@property (assign, nonatomic) NSColor *valueColor;

@end
