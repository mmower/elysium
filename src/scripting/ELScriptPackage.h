//
//  ELScriptPackage.h
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@interface ELScriptPackage : NSObject <ELXmlData> {
  BOOL  flag[8];
  
  float var[8];
  float varMin[8];
  float varMax[8];
}

@property BOOL f1;
@property BOOL f2;
@property BOOL f3;
@property BOOL f4;
@property BOOL f5;
@property BOOL f6;
@property BOOL f7;
@property BOOL f8;

@property float v1;
@property float v1min;
@property float v1max;

@property float v2;
@property float v2min;
@property float v2max;

@property float v3;
@property float v3min;
@property float v3max;

@property float v4;
@property float v4min;
@property float v4max;

@property float v5;
@property float v5min;
@property float v5max;

@property float v6;
@property float v6min;
@property float v6max;

@property float v7;
@property float v7min;
@property float v7max;

@property float v8;
@property float v8min;
@property float v8max;

@end
