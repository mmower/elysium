//
//  ELToken.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELToken.h"

#import "ELCell.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"

#import "ELNoteToken.h"
#import "ELGenerateToken.h"
#import "ELReboundToken.h"
#import "ELAbsorbToken.h"
#import "ELSplitToken.h"
#import "ELSpinToken.h"

NSMutableDictionary *tokenMapping = nil;

int randval() {
  return ( random() % 100 ) + 1;
}

@implementation ELToken

+ (NSString *)tokenType {
  @throw @"Token subtype has not defined tokenType!";
}

+ (ELToken *)tokenAlloc:(NSString *)_key_ {
  Class tokenClass = NSClassFromString( [NSString stringWithFormat:@"EL%@Token", [_key_ capitalizedString]] );
  ELToken *token = [tokenClass alloc];
  return token;
}

- (id)init {
  return [self initEnabledDial:[ELPlayer defaultEnabledDial]
                         pDial:[ELPlayer defaultPDial]
                      gateDial:[ELPlayer defaultGateDial]
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

@synthesize cell;
@synthesize layer;

@synthesize skip;
@synthesize fired;

@dynamic enabledDial;

- (ELDial *)enabledDial {
  return enabledDial;
}

- (void)setEnabledDial:(ELDial *)newEnabledDial {
  enabledDial = newEnabledDial;
  [enabledDial setDelegate:self];
}

@dynamic pDial;

- (ELDial *)pDial {
  return pDial;
}

- (void)setPDial:(ELDial *)newPDial {
  pDial = newPDial;
  [pDial setDelegate:self];
}


@dynamic gateDial;

- (ELDial *)gateDial {
  return gateDial;
}

- (void)setGateDial:(ELDial *)newGateDial {
  gateDial = newGateDial;
  [gateDial setDelegate:self];
}

- (void)dialDidChangeValue:(ELDial *)dial {
  [cell needsDisplay];
}

- (void)dialDidUnsetOscillator:(ELDial *)dial {
  [[[cell layer] player] dialDidUnsetOscillator:dial];
}

- (void)dialDidSetOscillator:(ELDial *)dial {
  [[[cell layer] player] dialDidSetOscillator:dial];
}

@synthesize scripts;

- (NSString *)tokenType {
  return [[self class] tokenType];
}

- (void)addedToLayer:(ELLayer *)newLayer atPosition:(ELCell *)newCell {
  [self setLayer:newLayer];
  [self setCell:newCell];
}

- (void)removedFromLayer:(ELLayer *)aLayer {
  [self setLayer:nil];
  [self setCell:nil];
}

- (void)start {
  [pDial start];
  [gateDial start];
  gateCount = [gateDial value];
}

- (void)stop {
  [gateDial stop];
  [pDial stop];
}

// Token-run protocol. The layer will call run and, as long as the Token is enabled,
// the Token will invoke it's scripts and the subclass overriden runToken between them.
- (void)run:(ELPlayhead *)_playhead_ {
  if( [[self enabledDial] value] ) {
    [self performSelectorOnMainThread:@selector(runWillRunScript:) withObject:_playhead_ waitUntilDone:YES];
    if( gateCount > 0 ) {
      gateCount--;
    } else {
      fired = NO;
      if( !skip ) {
        if( randval() <= [pDial value] ) {
          [self runToken:_playhead_];
          fired = YES;
        }
      }
      skip = NO;
      
      gateCount = [gateDial value];
    }
    
    [self performSelectorOnMainThread:@selector(runDidRunScript:) withObject:_playhead_ waitUntilDone:YES];
  }
}

// Should be overridden by Token subclasses
- (void)runToken:(ELPlayhead *)_playhead_ {
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
  NSLog( @"Drawing has not been defined for Token class %@", [self className] );
}

- (void)setTokenDrawColor:(NSDictionary *)_attributes_ {
  if( [enabledDial boolValue] ) {
    [[_attributes_ objectForKey:ELDefaultTokenColor] set];
  } else {
    [[_attributes_ objectForKey:ELDisabledTokenColor] set];
  }
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *tokenElement = [NSXMLNode elementWithName:[self tokenType]];
  [tokenElement addChild:[self controlsXmlRepresentation]];
  [tokenElement addChild:[self scriptsXmlRepresentation]];
  return tokenElement;
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

- (ELScript *)callbackTemplate {
  return [@"function(player,token,playhead) {\n\t// write your callback code here\n}\n" asJavascriptFunction];
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
