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

@protocol DirectedToken
@property ELDial *directionDial;
@end

@interface ELToken : NSObject <ELXmlData,NSMutableCopying> {
  BOOL                loaded;
  ELLayer             *layer;
  ELCell              *cell;
  NSMutableDictionary *scripts;
  BOOL                skip;
  BOOL                fired;
  int                 gateCount;
  
  ELDial              *enabledDial;
  ELDial              *pDial;
  ELDial              *gateDial;
}

- (id)initEnabledDial:(ELDial *)enabledDial pDial:(ELDial *)pDial gateDial:(ELDial *)gateDial scripts:(NSMutableDictionary *)scripts;

@property ELCell *cell;
@property ELLayer *layer;

@property BOOL skip;
@property BOOL fired;

@property ELDial *enabledDial;
@property ELDial *pDial;
@property ELDial *gateDial;

@property (assign) NSMutableDictionary *scripts;

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
