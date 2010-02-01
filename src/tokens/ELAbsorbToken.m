//
//  ELSinkToken.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELAbsorbToken.h"

#import "ELCell.h"
#import "ELPlayhead.h"

@implementation ELAbsorbToken

+ (NSString *)tokenType {
  return @"absorb";
}


- (void)runToken:(ELPlayhead *)playhead {
  if( ![playhead isNew] ) {
    [playhead kill];
  }
}


#pragma mark Drawing

- (void)drawWithAttributes:(NSDictionary *)attributes {
  NSPoint centre = [[self cell] centre];
  float radius = [[self cell] radius];
  
  NSBezierPath *symbolPath;
  [self setTokenDrawColor:attributes];
  symbolPath = [NSBezierPath bezierPathWithRect:NSMakeRect( centre.x - radius/3, centre.y - radius/3, 2*radius/3, 2*radius/3 )];
  [symbolPath setLineWidth:2.0];
  [symbolPath stroke];
}


#pragma mark Implements ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  return [super initWithXmlRepresentation:representation parent:parent player:player error:error];
}


@end
