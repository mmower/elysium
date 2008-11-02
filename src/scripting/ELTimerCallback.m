//
//  ELTimerCallback.m
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELTimerCallback.h"

#import "ELPlayer.h"

#import "RubyBlock.h"

@implementation ELTimerCallback

- (id)initWithPlayer:(ELPlayer *)_player_ {
  if( ( self = [super init] ) ) {
    player = _player_;
    active = NO;
    interval = 30.0;
    timer = nil;
    callback = [[RubyBlock alloc] initWithSource:@"do |player,timer|\n\t#Write your callback here\nend\n"];
    
    [self addObserver:self forKeyPath:@"active" options:0 context:nil];
  }
  
  return self;
}

@synthesize active;
@synthesize interval;
@synthesize callback;
@synthesize player;

- (void)observeValueForKeyPath:(NSString *)_keyPath_ ofObject:(id)_object_ change:(NSDictionary *)_change_ context:(id)_context_ {
  if( [_keyPath_ isEqualToString:@"active"] ) {
    timer = [NSTimer timerWithTimeInterval:[self interval] target:self selector:@selector(run) userInfo:nil repeats:YES];
  } else {
    [timer invalidate];
  }
}

- (void)run {
  [callback evalWithArg:[self player] arg:self];
}

// ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self initWithPlayer:_player_] ) ) {
    
    [self setInterval:[[[_representation_ attributeForName:@"interval"] stringValue] doubleValue]];
    
    NSXMLElement *scriptElement = (NSXMLElement *)[[_representation_ nodesForXPath:@"script" error:nil] objectAtIndex:0];
    [[self callback] setSource:[scriptElement stringValue]];
  }
  
  return self;
}

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *timerElement = [NSXMLNode elementWithName:@"timer"];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[NSNumber numberWithDouble:interval] forKey:@"interval"];
  [timerElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];
  NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
  [cdataNode setStringValue:[callback source]];
  [scriptElement addChild:cdataNode];
  [timerElement addChild:scriptElement];
  
  return timerElement;
}

@end
