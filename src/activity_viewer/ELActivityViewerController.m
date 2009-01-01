//
//  ELActivityViewerController.m
//  Elysium
//
//  Created by Matt Mower on 16/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELActivityViewerController.h"

#import "ElysiumController.h"

@implementation ELActivityViewerController

- (id)init {
  if( ( self = [self initWithWindowNibName:@"ActivityViewer"] ) ) {
    activities = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)recordActivity:(NSDictionary *)_activity_ {
  id proxy = [self mutableArrayValueForKey:@"activities"];
  if( [proxy count] > 32 ) {
    [proxy removeObjectAtIndex:0];
  }
  [proxy addObject:_activity_];
}

- (void)recordActivity:(NSString *)_type_ when:(NSString *)_when_ {
  [self recordActivity:[NSDictionary dictionaryWithObjectsAndKeys:_type_,@"activity",_when_,@"time",nil]];
}

- (IBAction)clearActivities:(id)_sender_ {
  [[self mutableArrayValueForKey:@"activities"] removeAllObjects];
}

@end
