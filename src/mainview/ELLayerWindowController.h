//
//  ELLayerWindowController.h
//  Elysium
//
//  Created by Matt Mower on 05/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELLayer;
@class ELSurfaceView;

@interface ELLayerWindowController : NSWindowController {
  IBOutlet  ELSurfaceView     *layerView;
  
  ELLayer                     *layer;
}

- (id)initWithLayer:(ELLayer *)layer;

- (void)titleWindow;

@end
