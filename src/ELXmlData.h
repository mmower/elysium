//
//  ELXmlData.h
//  Elysium
//
//  Created by Matt Mower on 15/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

@class ELPlayer;

@protocol ELXmlData

- (NSXMLElement *)xmlRepresentation;
- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error;

@end