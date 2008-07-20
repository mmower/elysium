//
//  ELPlayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELPlayer.h"

#import "ELLayer.h"
#import "ELConfig.h"
#import "ELHarmonicTable.h"

@implementation ELPlayer

- (id)init {
  if( self = [super init] ) {
    harmonicTable = [[ELHarmonicTable alloc] init];
    layers        = [[NSMutableArray alloc] init];
    config        = [[ELConfig alloc] init];
    
    // Setup some default values
    [config setInteger:1 forKey:@"instrument"];
    [config setInteger:300 forKey:@"bpm"];
    [config setInteger:16 forKey:@"ttl"];
    [config setInteger:16 forKey:@"pulseCount"];
    [config setInteger:100 forKey:@"velocity"];
    [config setFloat:1.0 forKey:@"duration"];
  }
  
  return self;
}

- (ELHarmonicTable *)harmonicTable
{
  return harmonicTable;
}

- (ELLayer *)createLayer {
  ELConfig *layerConfig = [[ELConfig alloc] initWithParent:config
                                                      data:[[NSMutableDictionary alloc] init]];
  
  return [[ELLayer alloc] initWithPlayer:self config:layerConfig];
}

@end
