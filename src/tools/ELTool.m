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

#import "ELBeatTool.h"
#import "ELStartTool.h"
#import "ELRicochetTool.h"
#import "ELSinkTool.h"
#import "ELSplitterTool.h"
#import "ELRotorTool.h"

NSMutableDictionary *toolMapping = nil;

@implementation ELTool

+ (void)initialize {
  static BOOL initialized = NO;
  
  if( !initialized ) {
    toolMapping = [NSMutableDictionary dictionary];
    initialized = YES;
  }
}

+ (void)addToolMapping:(Class)_class_ forKey:(NSString *)_key_ {
  [toolMapping setObject:_class_ forKey:_key_];
}

+ (NSDictionary *)toolMapping {
  return toolMapping;
}

// + (ELTool *)fromXMLData:(NSXMLElement *)_xml_ {
//   NSXMLNode *attribute = [_xml_ attributeForName:@"type"];
//   if( !attribute ) {
//     NSLog( @"Marker without type!" );
//     return nil;
//   }
//   
//   NSString *type = [attribute stringValue];
//   
//   ELTool *tool = [[[[ELTool toolMapping] objectForKey:type] alloc] init];
//   if( !tool ) {
//     NSLog( @"Unknown tool type:%@", type );
//   }
//   
//   if( ![tool loadToolConfig:_xml_] ) {
//     NSLog( @"Failed to load tool configuration!" );
//     return nil;
//   }
//   
//   return tool;
// }

- (id)initWithType:(NSString *)_type_ {
  if( ( self = [super init] ) ) {
    toolType       = _type_;
    enabled        = YES;
    preferredOrder = 5;
  }
  
  return self;
}

// Properties

@synthesize enabled;
@synthesize preferredOrder;
@synthesize toolType;
@synthesize layer;
@synthesize hex;

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

// Tool specific invocation goes here
- (BOOL)run:(ELPlayhead *)_playhead_ {
  return enabled;
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

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

@end
