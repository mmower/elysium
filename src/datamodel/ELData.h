/*
 *  ELData.h
 *  Elysium
 *
 *  Created by Matt Mower on 25/08/2008.
 *  Copyright 2008 LucidMac Software. All rights reserved.
 *
 */

@protocol ELData

- (NSXMLElement *)asXMLData;
- (BOOL)fromXMLData:(NSXMLElement *)data;

@end