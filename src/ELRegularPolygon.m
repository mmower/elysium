//
//  ELRegularPolygon.m
//  Elysium
//
//  Created by Matt Mower on 23/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRegularPolygon.h"

// Conversion functions from:
// http://blog.digitalagua.com/2008/06/30/how-to-convert-degrees-to-radians-radians-to-degrees-in-objective-c

CGFloat degreesToRadians( CGFloat degrees ) {
  return degrees * M_PI / 180;
}

CGFloat radiansToDegrees( CGFloat radians ) {
  return radians * 180 / M_PI;
}

// Algorithm for polygons based on
// http://livingcode.blogspot.com/2005/01/extending-nsbezierpath.html

NSPoint polyPoint( NSPoint centre, CGFloat radius, CGFloat degrees ) {
  return NSMakePoint(
    radius * cos( degrees ) + centre.x,
    radius * sin( degrees ) + centre.y
    );
}

NSPointArray polyPoints( NSPoint centre, CGFloat radius, int numPoints, CGFloat degrees ) {
  CGFloat rotation = degreesToRadians( degrees );
  CGFloat theta = ( M_PI * 2 ) / numPoints;
  
  __strong NSPointArray points = NSAllocateCollectable( numPoints * sizeof( NSPoint ), 0 );
  
  for( int i = 0; i < numPoints; i++ ) {
    points[i] = polyPoint( centre, radius, i * theta + rotation );
  }
  
  return points;
}

@implementation NSBezierPath (RegularPolygon)

  - (void)appendRegularPolygonWithCentre:(NSPoint)_centre radius:(CGFloat)_radius numPoints:(int)_numPoints {
    __strong NSPointArray points = polyPoints( _centre, _radius, _numPoints, 0.0 );
    
    [self moveToPoint:points[0]];
    for( int i = 1; i < _numPoints; i++ ) {
      [self lineToPoint:points[i]];
    }
    
    [self closePath];
  }
  
  - (void)appendHexagonWithCentre:(NSPoint)_centre radius:(CGFloat)_radius {
    [self appendRegularPolygonWithCentre:_centre radius:_radius numPoints:6];
  }

@end

