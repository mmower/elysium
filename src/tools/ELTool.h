//
//  ELTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@class ELHex;
@class ELLayer;
@class ELPlayhead;

@protocol DirectedTool
@property (readonly) ELIntegerKnob *directionKnob;
@end

@interface ELTool : NSObject <ELXmlData> {
  BOOL                enabled;
  ELLayer             *layer;
  ELHex               *hex;
  int                 preferredOrder;
  NSMutableDictionary *scripts;
  BOOL                skip;
}

@property BOOL enabled;
@property BOOL skip;
@property int preferredOrder;
@property (readonly) ELLayer *layer;
@property (readonly) ELHex *hex;
@property (readonly) NSMutableDictionary *scripts;

+ (ELTool *)toolAlloc:(NSString *)key;

- (NSString *)toolType;

- (NSArray *)observableValues;

- (void)addedToLayer:(ELLayer *)layer atPosition:(ELHex *)hex;
- (void)removedFromLayer:(ELLayer *)layer;

- (void)run:(ELPlayhead *)playhead;
- (void)runTool:(ELPlayhead *)playhead;

- (void)drawWithAttributes:(NSDictionary *)attributes;
- (void)setToolDrawColor:(NSDictionary *)attributes;

- (NSXMLElement *)controlsXmlRepresentation;
- (NSXMLElement *)scriptsXmlRepresentation;
- (void)loadScripts:(NSXMLElement *)representation;

- (void)runWillRunScript:(ELPlayhead *)playhead;
- (void)runDidRunScript:(ELPlayhead *)playhead;

@end
