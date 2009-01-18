//
//  PASectionHeaderView.h
//  StackedListView
//
//  Created by Tomas Franzén on 2008-07-17.
//  Copyright 2008 Lighthead Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PACollapsibleSectionBox.h"


@interface PASectionHeaderView : NSButton {
	IBOutlet PACollapsibleSectionBox *box;
}

@end