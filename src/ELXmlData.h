/*
 *  ELXmlData.h
 *  Elysium
 *
 *  Created by Matt Mower on 15/09/2008.
 *  Copyright 2008 LucidMac Software. All rights reserved.
 *
 */

@class ELPlayer;

@protocol ELXmlData

- (NSXMLElement *)xmlRepresentation;
- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player;

@end