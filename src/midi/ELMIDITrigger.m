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
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELMIDITrigger.h"

#import "ELMIDIControlMessage.h"

#import "RubyBlock.h"

@implementation ELMIDITrigger

- (id)initWithChannelMask:(Byte)_channelMask_ controller:(Byte)_controller_ callback:(RubyBlock *)_callback_ {
  if( ( self = [super init] ) ) {
    [self setChannelMask:_channelMask_];
    [self setController:_controller_];
    [self setCallback:_callback_];
  }
  
  return self;
}

@synthesize channelMask;
@synthesize controller;
@synthesize callback;

- (BOOL)handleControlMessage:(ELMIDIControlMessage *)controlMessage {
  if( [controlMessage matchesChannelMask:[self channelMask] andController:[self controller]] ) {
    [[self callback] evalWithArg:[NSNumber numberWithInteger:[controlMessage value]]];
    return YES;
  } else {
    return NO;
  }
}

// ELXmlData protocol conformance

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *triggerElement = [NSXMLNode elementWithName:@"trigger"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[NSNumber numberWithUnsignedShort:channelMask] forKey:@"channelMask"];
  [attributes setObject:[NSNumber numberWithUnsignedShort:controller] forKey:@"controller"];
  [triggerElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *callbackElement = [NSXMLNode elementWithName:@"callback"];
  NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
  [cdataNode setStringValue:[callback source]];
  [callbackElement addChild:cdataNode];
  [triggerElement addChild:callbackElement];
  
  return triggerElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  NSXMLNode *attributeNode;
  
  Byte newChannelMask;
  Byte newController;
  RubyBlock *newCallback;
  
  if( ( attributeNode = [_representation_ attributeForName:@"channelMask"] ) ) {
    newChannelMask = [[attributeNode stringValue] intValue];
  } else {
    NSLog( @"Trigger found without channelMask" );
    return nil;
  }
  
  if( ( attributeNode = [_representation_ attributeForName:@"controller"] ) ) {
    newController = [[attributeNode stringValue] intValue];
  } else {
    NSLog( @"Trigger found without controller" );
    return nil;
  }
  
  NSArray *nodes = [_representation_ nodesForXPath:@"callback" error:nil];
  if( [nodes count] > 0 ) {
    NSXMLElement *element = (NSXMLElement *)[nodes objectAtIndex:0];
    newCallback = [[element stringValue] asRubyBlock];
  } else {
    NSLog( @"Trigger found without callback" );
    return nil;
  }
  
  return [self initWithChannelMask:newChannelMask controller:newController callback:newCallback];
}

@end
