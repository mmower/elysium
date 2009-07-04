//
//  ELLayerWindowController.m
//  Elysium
//
//  Created by Matt Mower on 05/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELLayerWindowController.h"

#import "ELLayer.h"
#import "ELCell.h"
#import "Elysium.h"

@implementation ELLayerWindowController

- (id)initWithLayer:(ELLayer *)layer {
  if( ( self = [self initWithWindowNibName:@"LayerWindow"] ) ) {
    [self setShouldCloseDocument:YES];
    [self setLayer:layer];
  }
  
  return self;
}

@synthesize layer = _layer;
@synthesize layerView = _layerView;

#pragma mark NSWindowController overrides

- (void)windowDidLoad {
  // This is required because the HoneycombView doesn't resize very nicely right now
  [[self window] setAspectRatio:NSMakeSize(1.12,1.0)];
  
  [[self layerView] setDelegate:self];
  [[self layerView] setDataSource:[self layer]];
  [[self layer] setDelegate:[self layerView]];
  [[self layer] addObserver:self forKeyPath:@"channelDial.value" options:0 context:nil];
  [[self layer] addObserver:self forKeyPath:@"layerId" options:0 context:nil];
}


- (void)windowDidBecomeMain:(NSNotification *)notification {
}


- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
  return [NSString stringWithFormat:@"%@ - %@ (Channel %d)", displayName, [[self layer] layerId], [[[self layer] channelDial] value]];
}

#pragma mark Move selection with arrow keys

-(void)selectCellAtColumn:(int)column row:(int)row
{
	ELCell * nextSelection = (ELCell*)[[[self layerView] dataSource] hexCellAtColumn:column row:row];
	[nextSelection makeCurrentSelection];
}

// Deliberately not using Direction and [cell neighbour]
- (void)moveRight:(id)sender
{
	ELCell *currentSelection = [[self layerView] selectedCell];
	
	if([currentSelection column] < HTABLE_MAX_COL ) {
		[self selectCellAtColumn:[currentSelection column] + 1
							 row:[currentSelection row]];
	} else if ([currentSelection row] > 0){
		[self selectCellAtColumn:0
							 row:[currentSelection row] -1];
	} else {
		[self selectCellAtColumn:0
							 row:HTABLE_MAX_ROW];
	}
}
- (void)moveLeft:(id)sender
{
	ELCell *currentSelection = [[self layerView] selectedCell];
	
	if([currentSelection column] > 0) {
		[self selectCellAtColumn:[currentSelection column] - 1
							 row:[currentSelection row]];
	} else if([currentSelection column] == 0
			  && [currentSelection row] == HTABLE_MAX_ROW) {
		[self selectCellAtColumn:HTABLE_MAX_COL
							 row:0];
	} else {
		[self selectCellAtColumn:HTABLE_MAX_COL
							 row:[currentSelection row]  + 1];
	}
}
- (void)moveUp:(id)sender
{
	ELCell *currentSelection = [[self layerView] selectedCell];
	
	if([currentSelection row] == HTABLE_MAX_ROW && [currentSelection column] == HTABLE_MAX_COL) {
		[self selectCellAtColumn:0 row:0];
	} else {
		//[[currentSelection neighbour:(Direction) N] makeCurrentSelection];
		// Adding 1 to row will let us continue on bottom of next column
		[self selectCellAtColumn:[currentSelection column]
							 row:[currentSelection row] + 1];
	}
}
- (void)moveDown:(id)sender
{
	ELCell *currentSelection = [[self layerView] selectedCell];
	
	if([currentSelection row] == 0 && [currentSelection column] == 0) {
		[self selectCellAtColumn:HTABLE_MAX_COL
							 row:HTABLE_MAX_ROW];
	} else {
		[self selectCellAtColumn:[currentSelection column]
							 row:[currentSelection row] - 1];
	}
}

#pragma mark NSKeyValueObserving protocol

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(id)context {
  if( object == [self layer] && ( [keyPath isEqualToString:@"channelDial.value"] || [keyPath isEqualToString:@"layerId"] ) ) {
    [self updateWindowTitle];
  }
}


#pragma mark Layer Window Control

- (void)updateWindowTitle {
  [[self window] setTitle:[self windowTitleForDocumentDisplayName:[[self document] displayName]]];
}


- (void)updateView {
  [[self layerView] setNeedsDisplay:YES];
}

@end
