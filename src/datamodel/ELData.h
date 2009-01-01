//
//  ELData.h
//  Elysium
//
//  Created by Matt Mower on 25/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

@protocol ELData

- (NSXMLElement *)asXMLData;
- (BOOL)fromXMLData:(NSXMLElement *)data;

@end