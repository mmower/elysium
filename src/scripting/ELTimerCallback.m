//
//  ELTimerCallback.m
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELTimerCallback.h"

#import "ELPlayer.h"

@interface ELTimerCallback (PrivateMethods)

- (void)runCallback:(NSTimer *)timer;

@end


@implementation ELTimerCallback

- (id)initWithPlayer:(ELPlayer *)player {
  if( ( self = [super init] ) ) {
    _player = player;
    _active = NO;
    _interval = 30.0;
    _timer = nil;
    _callback = [@"function(player,timer) {\n\t// Write your callback here\n}\n" asJavascriptFunction:[player scriptEngine]];
    
    [self addObserver:self forKeyPath:@"active" options:0 context:nil];
  }
  
  return self;
}

@synthesize active = _active;
@synthesize interval = _interval;
@synthesize callback = _callback;
@synthesize player = _player;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if( [keyPath isEqualToString:@"active"] ) {
    if( [self active] ) {
      _timer = [NSTimer timerWithTimeInterval:[self interval] target:self selector:@selector(runCallback:) userInfo:nil repeats:YES];
      [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    } else {
      [_timer invalidate];
    }
  }
}

- (void)runCallback:(NSTimer *)timer {
  NSLog( @"Timer has fired." );
  [[self callback] evalWithArg:[self player] arg:self];
}

// ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [self initWithPlayer:player] ) ) {
    [self setInterval:[representation attributeAsDouble:@"interval" defaultValue:30.0]];
    NSXMLElement *scriptElement = (NSXMLElement *)[[representation nodesForXPath:@"script" error:error] objectAtIndex:0];
    [[self callback] setSource:[scriptElement stringValue]];
  }
  
  return self;
}

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *timerElement = [NSXMLNode elementWithName:@"timer"];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[NSNumber numberWithDouble:[self interval]] forKey:@"interval"];
  [timerElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];
  NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
  [cdataNode setStringValue:[[self callback] source]];
  [scriptElement addChild:cdataNode];
  [timerElement addChild:scriptElement];
  
  return timerElement;
}

@end
