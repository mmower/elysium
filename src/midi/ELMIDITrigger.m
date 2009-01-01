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

#import "RubyBlock.h"

@implementation ELMIDITrigger

- (id)init {
  if( ( self = [super init] ) ) {
    [self setChannelMask:0x0F];
    [self setController:0x00];
    [self setCallback:[@"do |player,message|\n\t# write your callback code here\nend\n" asRubyBlock]];
    [self setPlayer:nil];
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)_player_ channelMask:(Byte)_channelMask_ controller:(Byte)_controller_ callback:(RubyBlock *)_callback_ {
  if( ( self = [self init] ) ) {
    [self setPlayer:_player_];
    [self setChannelMask:_channelMask_];
    [self setController:_controller_];
    [self setCallback:_callback_];
  }
  
  return self;
}

@synthesize player;
@synthesize channelMask;
@synthesize controller;
@synthesize callback;

- (BOOL)handleMIDIControlMessage:(ELMIDIControlMessage *)_controlMessage_ {
  NSLog( @"Trigger %@ checking CC message: %@", self, _controlMessage_ );
  if( [_controlMessage_ matchesChannelMask:[self channelMask] andController:[self controller]] ) {
    @try {
      NSLog( @"Invoke Ruby callback" );
      [[self callback] evalWithArg:[self player] arg:_controlMessage_];
      return YES;
    }
    @catch( NSException *exception ) {
      NSLog( @"We got an exception trying to go Ruby: %@", exception );
    }
  }
  
  return NO;
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

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [self init] ) ) {
    NSXMLNode *attributeNode;
    
    [self setPlayer:_player_];
    
    if( ( attributeNode = [_representation_ attributeForName:@"channelMask"] ) ) {
      [self setChannelMask:[[attributeNode stringValue] intValue]];
    } else {
      NSLog( @"Trigger found without channelMask" );
      return nil;
    }
    
    if( ( attributeNode = [_representation_ attributeForName:@"controller"] ) ) {
      [self setController:[[attributeNode stringValue] intValue]];
    } else {
      NSLog( @"Trigger found without controller" );
      return nil;
    }

    NSArray *nodes = [_representation_ nodesForXPath:@"callback" error:nil];
    if( [nodes count] > 0 ) {
      NSXMLElement *element = (NSXMLElement *)[nodes objectAtIndex:0];
      [self setCallback:[[element stringValue] asRubyBlock]];
    } else {
      NSLog( @"Trigger found without callback" );
      return nil;
    }
  }
  
  return self;
}

@end
