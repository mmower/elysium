//
//  ELLayerWindowController.h
//  Elysium
//
//  Created by Matt Mower on 05/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELLayer;
@class ELSurfaceView;

@interface ELLayerWindowController : NSWindowController {
  IBOutlet  ELSurfaceView     *layerView;
  IBOutlet  NSSlider          *transposeSlider;
  
  ELLayer                     *layer;
}

- (id)initWithLayer:(ELLayer *)layer;

- (void)updateWindowTitle;
- (void)updateView;

@end
