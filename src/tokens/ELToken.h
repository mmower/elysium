//
//  ELToken.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@class ELCell;
@class ELLayer;
@class ELPlayhead;
@class ELMutexGroup;

@protocol DirectedToken
@property (nonatomic, strong) ELDial *directionDial;
@end

@interface ELToken : NSObject <ELXmlData, NSMutableCopying> {
    BOOL _loaded;
    ELLayer *_layer;
    ELCell *_cell;
    NSMutableDictionary *_scripts;
    BOOL _skip;
    BOOL _fired;
    int _gateCount;
    
    ELMutexGroup *_mutexGroup;
    
    ELDial *_enabledDial;
    ELDial *_pDial;
    ELDial *_gateDial;
}

- (id)initEnabledDial:(ELDial *)enabledDial pDial:(ELDial *)pDial gateDial:(ELDial *)gateDial scripts:(NSMutableDictionary *)scripts;

@property (nonatomic,readonly) BOOL loaded;
@property (nonatomic, strong) ELCell *cell;
@property (nonatomic, strong) ELLayer *layer;

@property  (nonatomic) BOOL skip;
@property  (nonatomic) BOOL fired;

@property (nonatomic, strong) ELDial *enabledDial;
@property (nonatomic, strong) ELDial *pDial;
@property (nonatomic, strong) ELDial *gateDial;

@property  (nonatomic,assign)  NSMutableDictionary *scripts;

+ (NSString *)tokenType;

+ (ELToken *)tokenAlloc:(NSString *)key;

- (NSString *)tokenType;

// - (NSArray *)observableValues;

- (void)addedToLayer:(ELLayer *)layer atPosition:(ELCell *)cell;
- (void)removedFromLayer:(ELLayer *)layer;

- (void)start;
- (void)stop;

- (void)run:(ELPlayhead *)playhead;
- (void)runToken:(ELPlayhead *)playhead;
- (void)afterRun;

- (void)drawWithAttributes:(NSDictionary *)attributes;
- (void)setTokenDrawColor:(NSDictionary *)attributes;

- (NSXMLElement *)controlsXmlRepresentation;
- (NSXMLElement *)scriptsXmlRepresentation;

- (void)runWillRunScript:(ELPlayhead *)playhead;
- (void)runDidRunScript:(ELPlayhead *)playhead;

- (ELScript *)callbackTemplate;

- (ELScript *)script:(NSString *)scriptName;
- (void)removeScript:(NSString *)scriptName;

@end
