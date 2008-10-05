//
//  ELTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayhead.h"

#import "ELNoteTool.h"
#import "ELGenerateTool.h"
#import "ELReboundTool.h"
#import "ELAbsorbTool.h"
#import "ELSplitTool.h"
#import "ELSpinTool.h"

NSMutableDictionary *toolMapping = nil;

@implementation ELTool

+ (ELTool *)toolAlloc:(NSString *)_key_ {
  Class toolClass = NSClassFromString( [NSString stringWithFormat:@"EL%@Tool", [_key_ capitalizedString]] );
  ELTool *tool = [toolClass alloc];
  NSLog( @"toolAlloc:%@ -> %@ -> %@", _key_, toolClass, tool );
  return tool;
}

- (id)init {
  if( ( self = [super init] ) ) {
    preferredOrder = 5;
    enabled        = YES;
    scripts        = [NSMutableDictionary dictionary];
  }
  
  return self;
}

// Properties

@synthesize enabled;
@synthesize preferredOrder;
@synthesize layer;
@synthesize hex;
@synthesize scripts;

- (NSString *)toolType {
  [self doesNotRecognizeSelector:_cmd];
  return @"unknown";
}

- (NSArray *)observableValues {
  return [NSArray arrayWithObject:@"enabled"];
}

- (void)addedToLayer:(ELLayer *)_layer_ atPosition:(ELHex *)_hex_ {
  layer = _layer_;
  hex   = _hex_;
}

- (void)removedFromLayer:(ELLayer *)_layer_ {
  layer = nil;
  hex = nil;
}

// Tool-run protocol. The layer will call run and, as long as the tool is enabled,
// the tool will invoke it's scripts and the subclass overriden runTool between them.
- (void)run:(ELPlayhead *)_playhead_ {
  if( enabled ) {
    [[scripts objectForKey:@"willRun"] value:self value:_playhead_];
    [self runTool:_playhead_];
    [[scripts objectForKey:@"didRun"] value:self value:_playhead_];
  }
}

// Should be overridden by tool subclasses
- (void)runTool:(ELPlayhead *)_playhead_ {
  [self doesNotRecognizeSelector:_cmd];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSLog( @"Drawing has not been defined for tool class %@", [self className] );
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

@end
