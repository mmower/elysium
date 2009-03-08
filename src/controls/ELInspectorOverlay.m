//
//  ELInspectorOverlay.m
//  Elysium
//
//  Created by Matt Mower on 08/03/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELInspectorOverlay.h"

@implementation ELInspectorOverlay

- (BOOL)isOpaque {
  return NO;
}


- (void)drawRect:(NSRect)bounds {
  [[[NSColor orangeColor] colorWithAlphaComponent:0.60] set];
  NSBezierPath *path = [NSBezierPath bezierPathWithRect:bounds];
  [path fill];
}


- (void)mouseDown:(NSEvent *)event {
  
}

- (void)rightMouseDown:(NSEvent *)event {
  
}


@end
