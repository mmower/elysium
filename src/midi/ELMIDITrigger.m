//
//  ELMIDITrigger.m
//  Elysium
//
//  The ELMIDITrigger class is intended to handle MIDI CC control messages through the use of user-customizable
//  MacRuby script callbacks. Each trigger can accept one CC message (although on any number of channels) and
//  routes the value for the message to an appropriate Ruby callback. The callback can then take any action
//  required, e.g. starting/stopping layers or adjusting control knob values.
//
//  Created by Matt Mower on 30/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELMIDITrigger.h"

#import "ELMIDIControlMessage.h"

@implementation ELMIDITrigger


#pragma mark Object initialization

- (id)init {
  if( ( self = [super init] ) ) {
    [self setChannelMask:0x0F];
    [self setController:0x00];
    [self setCallback:[@"function(player,message) {\n\t// write your callback code here\n}\n" asJavascriptFunction]];
    [self setPlayer:nil];
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)player channelMask:(Byte)channelMask controller:(Byte)controller callback:(ELScript *)callback {
  if( ( self = [self init] ) ) {
    [self setPlayer:player];
    [self setChannelMask:channelMask];
    [self setController:controller];
    [self setCallback:callback];
  }
  
  return self;
}


#pragma mark Properties

@synthesize player = _player;
@synthesize channelMask = _channelMask;
@synthesize controller = _controller;
@synthesize callback = _callback;


#pragma mark Object behaviours

- (BOOL)handleMIDIControlMessage:(ELMIDIControlMessage *)controlMessage {
  NSLog( @"Trigger %@ checking CC message: %@", self, controlMessage );
  if( [controlMessage matchesChannelMask:[self channelMask] andController:[self controller]] ) {
    @try {
      NSLog( @"Invoke MIDI trigger callback" );
      [[self callback] evalWithArg:[self player] arg:controlMessage];
      return YES;
    }
    @catch( NSException *exception ) {
      NSLog( @"Exception executing MIDI trigger callback: %@", exception );
    }
  }
  
  return NO;
}


#pragma mark Implements ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *triggerElement = [NSXMLNode elementWithName:@"trigger"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[NSNumber numberWithUnsignedShort:[self channelMask]] forKey:@"channelMask"];
  [attributes setObject:[NSNumber numberWithUnsignedShort:[self controller]] forKey:@"controller"];
  [triggerElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *callbackElement = [NSXMLNode elementWithName:@"callback"];
  NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
  [cdataNode setStringValue:[[self callback] source]];
  [callbackElement addChild:cdataNode];
  [triggerElement addChild:callbackElement];
  
  return triggerElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [self init] ) ) {
    BOOL hasValue;
    
    [self setPlayer:player];
    
    int channelMask = [representation attributeAsInteger:@"channelMask" hasValue:&hasValue];
    if( !hasValue ) {
      NSLog( @"Trigger found without channelMask" );
      return nil;
    }
    
    int controller = [representation attributeAsInteger:@"controller" hasValue:&hasValue];
    if( !hasValue ) {
      NSLog( @"Trigger found without controller" );
      return nil;
    }
    
    NSString *callbackSource;
    NSArray *nodes = [representation nodesForXPath:@"callback" error:error];
    if( [nodes isEmpty] ) {
      NSLog( @"Trigger found without callback: %@", (error && *error) ? [*error description] : @"no further info" );
      return nil;
    } else {
      callbackSource = [[nodes firstXMLElement] stringValue];
    }
    
    [self setChannelMask:channelMask];
    [self setController:controller];
    [self setCallback:[callbackSource asJavascriptFunction]];
  }
  
  return self;
}

@end
