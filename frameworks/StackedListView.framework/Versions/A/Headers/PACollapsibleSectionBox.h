//
//  PACollapsibleSectionBox.h
//  StackedListView
//
//  Created by Tomas Franzén on 2008-07-17.
//  Copyright 2008 Lighthead Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PACollapsibleSectionBox : NSView {
	IBOutlet NSView *sectionHeaderView;
	IBOutlet NSButton *disclosureTriangle;
	
	NSAnimation *animation;
}

- (void)animationDidEnd:(NSAnimation *)a;
- (BOOL)isCollapsed;
- (void)prepareForDisplay;
- (void)expandWithAnimation:(BOOL)animate;
- (void)collapseWithAnimation:(BOOL)animate;
- (void)toggleWithAnimation:(BOOL)animate;
- (IBAction)toggleState:(id)sender;

@end