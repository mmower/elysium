//
//  ELRegularPolygon.h
//  Elysium
//
//  Created by Matt Mower on 23/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (RegularPolygon)

- (void)appendRegularPolygonWithCentre:(NSPoint)centre radius:(CGFloat)radius numPoints:(int)numPoints;

- (void)appendHexagonWithCentre:(NSPoint)centre radius:(CGFloat)radius;

@end

