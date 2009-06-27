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


+ (ELToken *)tokenAlloc:(NSString *)key {
  Class tokenClass = NSClassFromString( [NSString stringWithFormat:@"EL%@Token", [key capitalizedString]] );
  ELToken *token = [tokenClass alloc];
  return token;
}


- (id)init {
  return [self initEnabledDial:[ELPlayer defaultEnabledDial]
                         pDial:[ELPlayer defaultPDial]
                      gateDial:[ELPlayer defaultGateDial]
                       scripts:[NSMutableDictionary dictionary]];
}


- (id)initEnabledDial:(ELDial *)enabledDial pDial:(ELDial *)pDial gateDial:(ELDial *)gateDial scripts:(NSMutableDictionary *)scripts {
  if( ( self = [super init] ) ) {
    _loaded = NO;
    [self setEnabledDial:enabledDial];
    [self setPDial:pDial];
    [self setGateDial:gateDial];
    [self setScripts:scripts];
  }
  
  return self;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initEnabledDial:[[self enabledDial] mutableCopy]
                                                      pDial:[[self pDial] mutableCopy]
                                                   gateDial:[[self gateDial] mutableCopy]
                                                    scripts:[[self scripts] mutableCopy]];
}

// Properties

@synthesize loaded = _loaded;
@synthesize cell = _cell;
@synthesize layer = _layer;

@synthesize skip = _skip;
@synthesize fired = _fired;

@synthesize enabledDial = _enabledDial;

- (void)setEnabledDial:(ELDial *)enabledDial {
  _enabledDial = enabledDial;
  [_enabledDial setDelegate:self];
}

@synthesize pDial = _pDial;

- (void)setPDial:(ELDial *)pDial {
  _pDial = pDial;
  [_pDial setDelegate:self];
}


@synthesize gateDial = _gateDial;

- (void)setGateDial:(ELDial *)gateDial {
  _gateDial = gateDial;
  [_gateDial setDelegate:self];
}

- (void)dialDidChangeValue:(ELDial *)dial {
  [[self cell] needsDisplay];
}

- (void)dialDidUnsetOscillator:(ELDial *)dial {
  [[[[self cell] layer] player] dialDidUnsetOscillator:dial];
}

- (void)dialDidSetOscillator:(ELDial *)dial {
  [[[[self cell] layer] player] dialDidSetOscillator:dial];
}

@synthesize scripts = _scripts;

- (NSString *)tokenType {
  return [[self class] tokenType];
}

- (void)addedToLayer:(ELLayer *)layer atPosition:(ELCell *)cell {
  [self setLayer:layer];
  [self setCell:cell];
}

- (void)removedFromLayer:(ELLayer *)layer {
  [self setLayer:nil];
  [self setCell:nil];
}

- (void)start {
  [[self pDial] start];
  [[self gateDial] start];
  _gateCount = [[self gateDial] value];
}

- (void)stop {
  [[self gateDial] stop];
  [[self pDial] stop];
}

// Token-run protocol. The layer will call run and, as long as the Token is enabled,
// the Token will invoke it's scripts and the subclass overriden runToken between them.
- (void)run:(ELPlayhead *)playhead {
  if( [[self enabledDial] value] ) {
    [self performSelectorOnMainThread:@selector(runWillRunScript:) withObject:playhead waitUntilDone:YES];
    if( _gateCount > 0 ) {
      _gateCount--;
    } else {
      [self setFired:NO];
      if( ![self skip] ) {
        if( randval() <= [[self pDial] value] ) {
          [self runToken:playhead];
          [self setFired:YES];
        }
      }
      [self setSkip:NO];
      
      _gateCount = [[self gateDial] value];
    }
    
    [self performSelectorOnMainThread:@selector(runDidRunScript:) withObject:playhead waitUntilDone:YES];
  }
}

// Should be overridden by Token subclasses
- (void)runToken:(ELPlayhead *)playhead {
  [self doesNotRecognizeSelector:_cmd];
}

// Scripting

- (void)runWillRunScript:(ELPlayhead *)playhead {
  [[[self scripts] objectForKey:@"willRun"] evalWithArg:[[self layer] player] arg:self arg:playhead];
}

- (void)runDidRunScript:(ELPlayhead *)playhead {
  [[[self scripts] objectForKey:@"didRun"] evalWithArg:[[self layer] player] arg:self arg:playhead];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)attributes {
  NSLog( @"Drawing has not been defined for Token class %@", [self className] );
}

- (void)setTokenDrawColor:(NSDictionary *)attributes {
  if( [[self enabledDial] boolValue] ) {
    [[attributes objectForKey:ELDefaultTokenColor] set];
  } else {
    [[attributes objectForKey:ELDisabledTokenColor] set];
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
  [controlsElement addChild:[[self enabledDial] xmlRepresentation]];
  [controlsElement addChild:[[self pDial] xmlRepresentation]];
  [controlsElement addChild:[[self gateDial] xmlRepresentation]];
  return controlsElement;
}

- (NSXMLElement *)scriptsXmlRepresentation {
  NSXMLElement *scriptsElement = [NSXMLNode elementWithName:@"scripts"];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  
  for( NSString *name in [[self scripts] allKeys] ) {
    NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];

    [attributes removeAllObjects];
    [attributes setObject:name forKey:@"name"];
    [scriptElement setAttributesAsDictionary:attributes];
    
    NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
    [cdataNode setStringValue:[[self scripts] objectForKey:name]];
    [scriptElement addChild:cdataNode];
    
    [scriptsElement addChild:scriptElement];
  }
  
  return scriptsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [self init] ) ) {
    _loaded = YES;
    
    [self setEnabledDial:[representation loadDial:@"enabled" parent:nil player:player error:error]];
    [self setPDial:[representation loadDial:@"p" parent:nil player:player error:error]];
    [self setGateDial:[representation loadDial:@"gate" parent:nil player:player error:error]];
    
    for( NSXMLNode *node in [representation nodesForXPath:@"scripts/script" error:nil] ) {
      NSXMLElement *element = (NSXMLElement *)node;
      [[self scripts] setObject:[[element stringValue] asJavascriptFunction]
                  forKey:[[element attributeForName:@"name"] stringValue]];
    }
    
  }
  
  return self;
}

- (ELScript *)callbackTemplate {
  return [@"function(player,token,playhead) {\n\t// write your callback code here\n}\n" asJavascriptFunction];
}

- (ELScript *)script:(NSString *)scriptName {
  ELScript *script = [[self scripts] objectForKey:scriptName];
  if( script == nil ) {
    script = [[NSString stringWithFormat:@"function(player,token,playhead) {\n\t// write your callback code here\n}\n"] asJavascriptFunction];
    [[self scripts] setObject:script forKey:scriptName];
  }
  return script;
}

- (void)removeScript:(NSString *)scriptName {
  [[self scripts] removeObjectForKey:scriptName];
}

@end
