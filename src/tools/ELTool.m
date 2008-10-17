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

#import "RubyBlock.h"

NSMutableDictionary *toolMapping = nil;

@implementation ELTool

+ (ELTool *)toolAlloc:(NSString *)_key_ {
  Class toolClass = NSClassFromString( [NSString stringWithFormat:@"EL%@Tool", [_key_ capitalizedString]] );
  ELTool *tool = [toolClass alloc];
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
@synthesize skip;
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
    [self performSelectorOnMainThread:@selector(runWillRunScript:) withObject:_playhead_ waitUntilDone:YES];
    if( !skip ) {
      [self runTool:_playhead_];
    }
    skip = NO;
    [self performSelectorOnMainThread:@selector(runDidRunScript:) withObject:_playhead_ waitUntilDone:YES];
  }
}

// Should be overridden by tool subclasses
- (void)runTool:(ELPlayhead *)_playhead_ {
  [self doesNotRecognizeSelector:_cmd];
}

// Scripting

- (void)runWillRunScript:(ELPlayhead *)_playhead_ {
  [[scripts objectForKey:@"willRun"] evalWithArg:self arg:_playhead_];
}

- (void)runDidRunScript:(ELPlayhead *)_playhead_ {
  [[scripts objectForKey:@"didRun"] evalWithArg:self arg:_playhead_];
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
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:([self enabled] ? @"YES" : @"NO") forKey:@"enabled"];
  [toolElement setAttributesAsDictionary:attributes];
  
  [toolElement addChild:[self controlsXmlRepresentation]];
  [toolElement addChild:[self scriptsXmlRepresentation]];
  return toolElement;
}

- (NSXMLElement *)controlsXmlRepresentation {
  return [NSXMLNode elementWithName:@"controls"];
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

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void)loadIsEnabled:(NSXMLElement *)_representation_ {
  [self setEnabled:([[[_representation_ attributeForName:@"enabled"] stringValue] boolValue])];
}

- (void)loadScripts:(NSXMLElement *)_representation_ {
  NSArray *nodes = [_representation_ nodesForXPath:@"scripts/script" error:nil];
  for( NSXMLNode *node in nodes ) {
    NSXMLElement *element = (NSXMLElement *)node;
    [scripts setObject:[[element stringValue] asRubyBlock]
                forKey:[[element attributeForName:@"name"] stringValue]];
  }
}

@end
