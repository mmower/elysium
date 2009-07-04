//
//  ELInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 02/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELInspectorController.h"

#import "ELInspectorViewController.h"
#import "ELPlayerInspectorViewController.h"
#import "ELLayerInspectorViewController.h"
#import "ELGenerateInspectorViewController.h"
#import "ELNoteInspectorViewController.h"
#import "ELReboundInspectorViewController.h"
#import "ELAbsorbInspectorViewController.h"
#import "ELSplitInspectorViewController.h"
#import "ELSpinInspectorViewController.h"
#import "ELSkipInspectorViewController.h"

#import "ELDial.h"

#import "ELKey.h"
#import "ELCell.h"
#import "ELLayer.h"
#import "ELPlayer.h"

#import "ELInspectorOverlay.h"
#import "ELOscillatorDesignerController.h"

@interface ELInspectorController (PrivateMethods)

- (NSView *)wrapWithOverlayView:(NSView *)view target:(NSString *)target;

@end


@implementation ELInspectorController

- (id)init {
  if( ( self = [super initWithWindowNibName:@"ELInspector"] ) ) {
    playerViewController   = [[ELPlayerInspectorViewController alloc] initWithInspectorController:self];
    layerViewController    = [[ELLayerInspectorViewController alloc] initWithInspectorController:self];
    generateViewController = [[ELGenerateInspectorViewController alloc] initWithInspectorController:self];
    noteViewController     = [[ELNoteInspectorViewController alloc] initWithInspectorController:self];
    reboundViewController  = [[ELReboundInspectorViewController alloc] initWithInspectorController:self];
    absorbViewController   = [[ELAbsorbInspectorViewController alloc] initWithInspectorController:self];
    splitViewController    = [[ELSplitInspectorViewController alloc] initWithInspectorController:self];
    spinViewController     = [[ELSpinInspectorViewController alloc] initWithInspectorController:self];
    skipViewController     = [[ELSkipInspectorViewController alloc] initWithInspectorController:self];
    
    oscillatorEditors      = [NSMapTable mapTableWithStrongToStrongObjects];
  }
  
  return self;
}

@synthesize panel = _panel;
@synthesize modeView = _modeView;
@synthesize tabView = _tabView;

@synthesize player = _player;
@synthesize layer = _layer;
@synthesize cell = _cell;

@synthesize title;


#pragma mark NSNibAwakening protocol

- (void)awakeFromNib {
  //[self wrapWithOverlayView:[skipViewController view] target:@"cell.tokens.skip"]
  [[[self tabView] tabViewItemAtIndex:0] setView:[playerViewController view]];
  [[[self tabView] tabViewItemAtIndex:1] setView:[layerViewController view]];
  [[[self tabView] tabViewItemAtIndex:2] setView:[self wrapWithOverlayView:[generateViewController view] target:@"cell.tokens.generate"]];
  [[[self tabView] tabViewItemAtIndex:3] setView:[self wrapWithOverlayView:[noteViewController view] target:@"cell.tokens.note"]];
  [[[self tabView] tabViewItemAtIndex:4] setView:[self wrapWithOverlayView:[reboundViewController view] target:@"cell.tokens.rebound"]];
  [[[self tabView] tabViewItemAtIndex:5] setView:[self wrapWithOverlayView:[absorbViewController view] target:@"cell.tokens.absorb"]];
  [[[self tabView] tabViewItemAtIndex:6] setView:[self wrapWithOverlayView:[splitViewController view] target:@"cell.tokens.split"]];
  [[[self tabView] tabViewItemAtIndex:7] setView:[self wrapWithOverlayView:[spinViewController view] target:@"cell.tokens.spin"]];
  [[[self tabView] tabViewItemAtIndex:8] setView:[self wrapWithOverlayView:[skipViewController view] target:@"cell.tokens.skip"]];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(documentsClosed:)
                                              name:ELNotifyAllDocumentsClosed
                                            object:nil];
}


#pragma mark NSWindowController

- (void)windowDidLoad {
  [[self panel] setFloatingPanel:YES];
  [[self panel] setBecomesKeyOnlyIfNeeded:YES];
}


#pragma mark Inspector implementation


- (NSView *)wrapWithOverlayView:(NSView *)view target:(NSString *)target {
  NSView *parent = [[NSView alloc] initWithFrame:[[self tabView] contentRect]];
  ELInspectorOverlay *overlay = [[ELInspectorOverlay alloc] initWithFrame:[[self tabView] contentRect]];
  
  [parent addSubview:view];
  [parent addSubview:overlay positioned:NSWindowAbove relativeTo:view];
  
  [overlay bind:@"hidden"
       toObject:self
    withKeyPath:target
    options:[NSDictionary dictionaryWithObject:@"NSIsNotNil" forKey:NSValueTransformerNameBindingOption]];
  
  return parent;
}


- (void)inspect:(NSString *)identifier {
  int index = [[self tabView] indexOfTabViewItemWithIdentifier:identifier];
  if( index != NSNotFound ) {
    [[self tabView] selectTabViewItemAtIndex:index];
    [[self modeView] setSelectedSegment:index];
  }
}


- (void)documentsClosed:(NSNotification *)notification {
  [[self window] orderOut:self];
}


- (void)selectionChanged:(NSNotification *)notification {
  if( [[notification object] isKindOfClass:[ELPlayer class]] ) {
    [self playerSelected:[notification object]];
  } else if( [[notification object] isKindOfClass:[ELLayer class]] ) {
    [self layerSelected:[notification object]];
  } else if( [[notification object] isKindOfClass:[ELCell class]] ) {
    [self cellSelected:[notification object]];
  }
  
  [self tabView:[self tabView] willSelectTabViewItem:[[self tabView] tabViewItemAtIndex:0]];
}


- (void)playerSelected:(ELPlayer *)player {
  [self setPlayer:player];
  [self setLayer:nil];
  [self setCell:nil];
  
  [[self modeView] setSelectedSegment:0];
  [[self tabView] selectTabViewItemAtIndex:0];
}


- (void)layerSelected:(ELLayer *)layer {
  [self setPlayer:[layer player]];
  [self setLayer:layer];
  [self setCell:nil];
  
  [[self modeView] setSelectedSegment:1];
  [[self tabView] selectTabViewItemAtIndex:1];
}


- (void)cellSelected:(ELCell *)cell {
  [self setPlayer:[[cell layer] player]];
  [self setLayer:[cell layer]];
  [self setCell:cell];
}


- (IBAction)selectTab:(id)sender {
  int tab = [sender selectedSegment];
  // 
  // [self setTitle:[[tabView tabViewItemAtIndex:tab] label]];
  [[self tabView] selectTabViewItemAtIndex:tab];
}


- (NSArray *)keySignatures {
  return [ELKey allKeys];
}


- (IBAction)editOscillator:(ELDial *)dial {
  ELOscillatorDesignerController *controller;
  
  controller = [oscillatorEditors objectForKey:dial];
  if( controller == nil ) {
    controller = [[ELOscillatorDesignerController alloc] initWithDial:dial controller:self];
    [oscillatorEditors setObject:controller forKey:dial];
  }
  
  [controller edit];
}


- (void)finishedEditingOscillatorForDial:(ELDial *)dial {
  [oscillatorEditors removeObjectForKey:dial];
}


// Script editing options

- (void)editCallback:(id)scriptable tag:(NSNumber *)tag {
  NSString *callbackName;
  
  switch( [tag intValue] ) {
    case 0:
      callbackName = @"willStart";
      break;
    case 1:
      callbackName = @"didStart";
      break;
    case 2:
      callbackName = @"willStop";
      break;
    case 3:
      callbackName = @"didStop";
      break;
    case 4:
      callbackName = @"willRun";
      break;
    case 5:
      callbackName = @"didRun";
      break;
    default:
      NSLog( @"Unknown callback tag: %d for scriptable: %@", [tag intValue], scriptable );
      return;
  }
  
  ELScript *callback;
  
  if( !( callback = [[scriptable scripts] objectForKey:callbackName] ) ) {
    callback = [scriptable callbackTemplate];
    [[scriptable scripts] setObject:callback forKey:callbackName];
  }
  
  [callback inspect:self];
}


- (void)removeCallback:(id)scriptable tag:(NSNumber *)tag {
  NSString *callbackName;
  
  switch( [tag intValue] ) {
    case 0:
      callbackName = @"willStart";
      break;
    case 1:
      callbackName = @"didStart";
      break;
    case 2:
      callbackName = @"willStop";
      break;
    case 3:
      callbackName = @"didStop";
      break;
    case 4:
      callbackName = @"willRun";
      break;
    case 5:
      callbackName = @"didRun";
      break;
    default:
      NSLog( @"Unknown callback tag: %d for scriptable: %@", [tag intValue], scriptable );
      return;
  }
  
  [[scriptable scripts] removeObjectForKey:callbackName];
}


#pragma mark NSTabView delegate implementation

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem {
  NSDocument *document = [[[NSApp mainWindow] windowController] document];
  NSString *target = [tabViewItem label];
  
  if( document ) {
    [self setTitle:[NSString stringWithFormat:@"%@ - Inspect %@", [document displayName], target]];
  } else {
    [self setTitle:[NSString stringWithFormat:@"Inspect %@", target]];
  }
}


@end
