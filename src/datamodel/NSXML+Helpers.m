//
//  NSXML+Helpers.m
//  Elysium
//
//  Created by Matt Mower on 04/11/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "NSXML+Helpers.h"

@implementation NSArray (NSXML_Helpers)

- (NSXMLElement *)firstXMLElement {
  if( [self count] < 1 ) {
    return nil;
  }
  
  return (NSXMLElement *)[self objectAtIndex:0];
}

@end
