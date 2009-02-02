//
//  ELTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
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

int randval() {
  return ( random() % 100 ) + 1;
}

// double randval() {
//   return ((double)random()) / RAND_MAX;
// }

@implementation ELTool

+ (ELTool *)toolAlloc:(NSString *)_key_ {
  Class toolClass = NSClassFromString( [NSString stringWithFormat:@"EL%@Tool", [_key_ capitalizedString]] );
  ELTool *tool = [toolClass alloc];
  return tool;
}

- (id)init {
  return [self initEnabledDial:[[ELDial alloc] initWithName:@"enabled" tag:0 boolValue:YES]
                         pDial:[[ELDial alloc] initWithName:@"p" tag:0 assigned:100 min:0 max:100 step:1]
                      gateDial:[[ELDial alloc] initWithName:@"gate" tag:0 assigned:0 min:0 max:32 step:1]
                       scripts:[NSMutableDictionary dictionary]];
}

- (id)initEnabledDial:(ELDial *)newEnabledDial pDial:(ELDial *)newPDial gateDial:(ELDial *)newGateDial scripts:(NSMutableDictionary *)newScripts {
  if( ( self = [super init] ) ) {
    [self setEnabledDial:newEnabledDial];
    [self setPDial:newPDial];
    [self setGateDial:newGateDial];
    [self setScripts:newScripts];
  }
  
  return self;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initEnabledDial:[[self enabledDial] mutableCopy]
                                                        pDial:[[self pDial] mutableCopy]
                                                     gateDial:[[self gateDial] mutableCopy]
                                                      scripts:[[self scripts] mutableCopy]];
}

// Properties

@synthesize hex;
@synthesize layer;

@synthesize skip;
@synthesize fired;

@synthesize enabledDial;
@synthesize pDial;
@synthesize gateDial;

@synthesize scripts;

- (NSString *)toolType {
  [self doesNotRecognizeSelector:_cmd];
  return @"unknown";
}

- (NSArray *)observableValues {
  return [NSArray arrayWithObjects:@"enabledDial.value",@"pDial.value",@"gateDial.value",nil];
}

- (void)addedToLayer:(ELLayer *)newLayer atPosition:(ELHex *)newCell {
  layer = newLayer;
  hex   = newCell;
}

- (void)removedFromLayer:(ELLayer *)aLayer {
  layer = nil;
  hex = nil;
}

- (void)start {
  [gateDial onStart];
  gateCount = [gateDial value];
}

// Tool-run protocol. The layer will call run and, as long as the tool is enabled,
// the tool will invoke it's scripts and the subclass overriden runTool between them.
- (void)run:(ELPlayhead *)_playhead_ {
  if( [[self enabledDial] value] ) {
    [self performSelectorOnMainThread:@selector(runWillRunScript:) withObject:_playhead_ waitUntilDone:YES];
    if( gateCount > 0 ) {
      gateCount--;
    } else {
      fired = NO;
      if( !skip ) {
        if( randval() <= [pDial value] ) {
          [self runTool:_playhead_];
          fired = YES;
        }
      }
      skip = NO;
      
      gateCount = [gateDial value];
    }
    
    [self performSelectorOnMainThread:@selector(runDidRunScript:) withObject:_playhead_ waitUntilDone:YES];
  }
}

// Should be overridden by tool subclasses
- (void)runTool:(ELPlayhead *)_playhead_ {
  [self doesNotRecognizeSelector:_cmd];
}

// Scripting

- (void)runWillRunScript:(ELPlayhead *)_playhead_ {
  [[scripts objectForKey:@"willRun"] evalWithArg:[layer player] arg:self arg:_playhead_];
}

- (void)runDidRunScript:(ELPlayhead *)_playhead_ {
  [[scripts objectForKey:@"didRun"] evalWithArg:[layer player] arg:self arg:_playhead_];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSLog( @"Drawing has not been defined for tool class %@", [self className] );
}

- (void)setToolDrawColor:(NSDictionary *)_attributes_ {
  if( enabled ) {
    [[_attributes_ objectForKey:ELDefaultToolColor] set];
  } else {
    [[_attributes_ objectForKey:ELDisabledToolColor] set];
  }
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *toolElement = [NSXMLNode elementWithName:[self toolType]];
  [toolElement addChild:[self controlsXmlRepresentation]];
  [toolElement addChild:[self scriptsXmlRepresentation]];
  return toolElement;
}

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[enabledDial xmlRepresentation]];
  [controlsElement addChild:[pDial xmlRepresentation]];
  [controlsElement addChild:[gateDial xmlRepresentation]];
  return controlsElement;
}

- (NSXMLElement *)scriptsXmlRepresentation {
  NSXMLElement *scriptsElement = [NSXMLNode elementWithName:@"scripts"];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  
  for( NSString *name in [scripts allKeys] ) {
    NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];

    [attributes removeAllObjects];
    [attributes setObject:name forKey:@"name"];
    [scriptElement setAttributesAsDictionary:attributes];
    
    NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
    [cdataNode setStringValue:[scripts objectForKey:name]];
    [scriptElement addChild:cdataNode];
    
    [scriptsElement addChild:scriptElement];
  }
  
  return scriptsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [self init] ) ) {
    loaded = YES;
    
    [self setEnabledDial:[_representation_ loadDial:@"enabled" parent:nil player:_player_ error:_error_]];
    [self setPDial:[_representation_ loadDial:@"p" parent:nil player:_player_ error:_error_]];
    [self setGateDial:[_representation_ loadDial:@"gate" parent:nil player:_player_ error:_error_]];
    
    for( NSXMLNode *node in [_representation_ nodesForXPath:@"scripts/script" error:nil] ) {
      NSXMLElement *element = (NSXMLElement *)node;
      [scripts setObject:[[element stringValue] asJavascriptFunction]
                  forKey:[[element attributeForName:@"name"] stringValue]];
    }
    
  }
  
  return self;
}

- (ELScript *)script:(NSString *)_scriptName_ {
  ELScript *script = [scripts objectForKey:_scriptName_];
  if( script == nil ) {
    script = [[NSString stringWithFormat:@"function(player,token,playhead) {\n\t// write your callback code here\n}\n"] asJavascriptFunction];
    [scripts setObject:script forKey:_scriptName_];
  }
  return script;
}

- (void)removeScript:(NSString *)_scriptName_ {
  [scripts removeObjectForKey:_scriptName_];
}

@end
