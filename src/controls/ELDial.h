//
//  ELDial.h
//  Elysium
//
//  Created by Matt Mower on 31/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELXmlData.h"

#import <Cocoa/Cocoa.h>

extern NSString *const dialModeValueTransformer;
extern NSString *const dialHasOscillatorValueTransformer;

typedef enum tagELDialMode {
    dialFree,
    dialDynamic,
    dialInherited
} ELDialMode;

@class ELPlayer;
@class ELOscillator;

@interface ELDial : NSObject <ELXmlData, NSMutableCopying> {
    id _delegate;
    
    ELDialMode _mode;
    
    NSString *_name;
    NSString *_toolTip;
    int _tag;
    
    ELPlayer *_player;
    ELDial *_parent;
    ELOscillator *_oscillator;
    
    int _assigned;
    int _last;
    int _value;
    
    // For range based controls
    int _min;
    int _max;
    int _step;
    
    BOOL _duplicate;
}


- (id)initWithMode:(ELDialMode)mode
              name:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
            player:(ELPlayer *)player
            parent:(ELDial *)parent
        oscillator:(ELOscillator *)oscillator
          assigned:(int)assigned
              last:(int)last
             value:(int)value;

- (id)initWithMode:(ELDialMode)mode
              name:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
            player:(ELPlayer *)player
            parent:(ELDial *)parent
        oscillator:(ELOscillator *)oscillator
          assigned:(int)assigned
              last:(int)last
             value:(int)value
               min:(int)min
               max:(int)max
              step:(int)step;

- (id)initWithName:(NSString *)aName
           toolTip:(NSString *)aToolTip
               tag:(int)aTag
            player:(ELPlayer *)player
          assigned:(int)aAssigned
               min:(int)aMin
               max:(int)aMax
              step:(int)aStep;

- (id)initWithName:(NSString *)aName
           toolTip:(NSString *)aToolTip
               tag:(int)tag
         boolValue:(BOOL)value;

- (id)initWithParent:(ELDial *)parent;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) ELDialMode mode;
@property (nonatomic, assign)   NSString *name;
@property (nonatomic, assign)   NSString *toolTip;
@property (nonatomic) int tag;
@property (nonatomic, strong) ELPlayer *player;
@property (nonatomic, strong) ELDial *parent;
@property (nonatomic, strong) ELOscillator *oscillator;
@property (nonatomic) int assigned;
@property (nonatomic) int last;
@property (nonatomic) int value;
@property (nonatomic) int min;
@property (nonatomic) int max;
@property (nonatomic) int step;
@property (nonatomic) BOOL duplicate;

- (BOOL)boolValue;
- (void)setBoolValue:(BOOL)boolValue;

// Fake properties to make it easier to work with bindings
- (BOOL)isInherited;
- (void)setIsInherited:(BOOL)shouldInherit;

- (void)start;
- (void)stop;

- (BOOL)pTest;

- (ELDial *)duplicateDial;

@end

@interface NSObject (ELDialDelegation)
- (void)dialDidChangeValue:(ELDial *)dial;
@end
