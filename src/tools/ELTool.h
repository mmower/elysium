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
@property (readonly) ELIntegerKnob *directionKnob;
@end

@interface ELTool : NSObject <ELXmlData> {
  BOOL                enabled;
  ELLayer             *layer;
  ELHex               *hex;
  NSMutableDictionary *scripts;
  BOOL                skip;
  BOOL                fired;
  int                 gateCount;
  
  ELIntegerKnob       *pKnob;
  ELIntegerKnob       *gateKnob;
}

@property BOOL enabled;
@property (readonly) ELIntegerKnob *pKnob;
@property (readonly) ELIntegerKnob *gateKnob;
@property BOOL skip;
@property BOOL fired;
@property (readonly) ELLayer *layer;
@property (readonly) ELHex *hex;
@property (readonly) NSMutableDictionary *scripts;

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

- (RubyBlock *)script:(NSString *)scriptName;
- (void)removeScript:(NSString *)scriptName;

@end
