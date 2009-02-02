//
//  ELTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@class ELHex;
@class ELLayer;
@class ELPlayhead;

@protocol DirectedTool
@property ELDial *directionDial;
@end

@interface ELTool : NSObject <ELXmlData,NSMutableCopying> {
  BOOL                loaded;
  BOOL                enabled;
  ELLayer             *layer;
  ELHex               *hex;
  NSMutableDictionary *scripts;
  BOOL                skip;
  BOOL                fired;
  int                 gateCount;
  
  ELDial              *enabledDial;
  ELDial              *pDial;
  ELDial              *gateDial;
}

- (id)initEnabledDial:(ELDial *)enabledDial pDial:(ELDial *)pDial gateDial:(ELDial *)gateDial scripts:(NSMutableDictionary *)scripts;

@property ELHex *hex;
@property ELLayer *layer;

@property BOOL skip;
@property BOOL fired;

@property ELDial *enabledDial;
@property ELDial *pDial;
@property ELDial *gateDial;

@property (assign) NSMutableDictionary *scripts;

+ (ELTool *)toolAlloc:(NSString *)key;

- (NSString *)toolType;

- (NSArray *)observableValues;

- (void)addedToLayer:(ELLayer *)layer atPosition:(ELHex *)hex;
- (void)removedFromLayer:(ELLayer *)layer;

- (void)start;

- (void)run:(ELPlayhead *)playhead;
- (void)runTool:(ELPlayhead *)playhead;

- (void)drawWithAttributes:(NSDictionary *)attributes;
- (void)setToolDrawColor:(NSDictionary *)attributes;

- (NSXMLElement *)controlsXmlRepresentation;
- (NSXMLElement *)scriptsXmlRepresentation;

- (void)runWillRunScript:(ELPlayhead *)playhead;
- (void)runDidRunScript:(ELPlayhead *)playhead;

- (ELScript *)script:(NSString *)scriptName;
- (void)removeScript:(NSString *)scriptName;

@end
