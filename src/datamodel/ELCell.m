//
//  ELCell.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import <HoneycombView/LMHoneycombView.h>

#import "ELCell.h"

#import "ELKey.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"
#import "ELNoteGroup.h"
#import "ELHarmonicTable.h"
#import "ELSurfaceView.h"
#import "ElysiumController.h"

#import "ELToken.h"
#import "ELGenerateToken.h"
#import "ELNoteToken.h"
#import "ELReboundToken.h"
#import "ELAbsorbToken.h"
#import "ELSplitToken.h"
#import "ELSpinToken.h"
#import "ELSkipToken.h"

@interface ELCell (PrivateMethods)

- (void)setGenerateTokenWithUndo:(ELGenerateToken *)generateToken;
- (void)setNoteTokenWithUndo:(ELNoteToken *)noteToken;

@end

@implementation ELCell

- (id)initWithLayer:(ELLayer *)_layer_ note:(ELNote *)_note_ column:(int)_col_ row:(int)_row_ {
  if( ( self = [super initWithColumn:_col_ row:_row_] ) ) {
    layer        = _layer_;
    note         = _note_;
    tokens       = [[NSMutableDictionary alloc] init];
    playheads    = [[NSMutableArray alloc] init];
    scriptingTag = [NSString stringWithFormat:@"cell%d:%d",_col_,_row_];
    mDirty       = NO;
    
    [self connectNeighbour:nil direction:N];
    [self connectNeighbour:nil direction:NE];
    [self connectNeighbour:nil direction:SE];
    [self connectNeighbour:nil direction:S];
    [self connectNeighbour:nil direction:SW];
    [self connectNeighbour:nil direction:NW];
  }
  
  return self;
}


#pragma mark Properties

@synthesize layer;
@synthesize note;
@synthesize scriptingTag;
@synthesize tokens;

@synthesize mDirty;

- (void)setDirty:(BOOL)dirty {
  mDirty = dirty;
  if( mDirty ) {
    [layer setDirty:YES];
  }
}


@synthesize generateToken;

- (void)setGenerateToken:(ELGenerateToken *)_generateToken_ {
  [self removeToken:generateToken];
  generateToken = _generateToken_;
  [self addToken:generateToken];
  [self makeCurrentSelection];
}


- (void)setGenerateTokenWithUndo:(ELGenerateToken *)_generateToken_ {
  NSUndoManager *undoManager = [[[[NSApp mainWindow] windowController] document] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setGenerateTokenWithUndo:generateToken];
  if( ![undoManager isUndoing] ) {
    if( _generateToken_ ) {
      [undoManager setActionName:@"add generate"];
    } else {
      [undoManager setActionName:@"remove generate"];
    }
  }
  [self setGenerateToken:_generateToken_];
}


@synthesize noteToken;

- (void)setNoteToken:(ELNoteToken *)_noteToken_ {
  [self removeToken:noteToken];
  noteToken = _noteToken_;
  [self addToken:noteToken];
  [self makeCurrentSelection];
}


- (void)setNoteTokenWithUndo:(ELNoteToken *)_noteToken_ {
  NSUndoManager *undoManager = [[[[NSApp mainWindow] windowController] document] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setNoteTokenWithUndo:noteToken];
  if( ![undoManager isUndoing] ) {
    if( _noteToken_ ) {
      [undoManager setActionName:@"add note"];
    } else {
      [undoManager setActionName:@"remove note"];
    }
  }
  [self setNoteToken:_noteToken_];
}


@synthesize reboundToken;

- (void)setReboundToken:(ELReboundToken *)_reboundToken_ {
  [self removeToken:reboundToken];
  reboundToken = _reboundToken_;
  [self addToken:reboundToken];
  [self makeCurrentSelection];
}


- (void)setReboundTokenWithUndo:(ELReboundToken *)_reboundToken_ {
  NSUndoManager *undoManager = [[[[NSApp mainWindow] windowController] document] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setReboundTokenWithUndo:reboundToken];
  if( ![undoManager isUndoing] ) {
    if( _reboundToken_ ) {
      [undoManager setActionName:@"add rebound"];
    } else {
      [undoManager setActionName:@"remove rebound"];
    }
  }
  [self setReboundToken:_reboundToken_];
}


@synthesize absorbToken;

- (void)setAbsorbToken:(ELAbsorbToken *)_absorbToken_ {
  [self removeToken:absorbToken];
  absorbToken = _absorbToken_;
  [self addToken:absorbToken];
  [self makeCurrentSelection];
}


- (void)setAbsorbTokenWithUndo:(ELAbsorbToken *)_absorbToken_ {
  NSUndoManager *undoManager = [[[[NSApp mainWindow] windowController] document] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setAbsorbTokenWithUndo:absorbToken];
  if( ![undoManager isUndoing] ) {
    if( _absorbToken_ ) {
      [undoManager setActionName:@"add absorb"];
    } else {
      [undoManager setActionName:@"remove absorb"];
    }
  }
  [self setAbsorbToken:_absorbToken_];
}


@synthesize splitToken;

- (void)setSplitToken:(ELSplitToken *)_splitToken_ {
  [self removeToken:splitToken];
  splitToken = _splitToken_;
  [self addToken:splitToken];
  [self makeCurrentSelection];
}


- (void)setSplitTokenWithUndo:(ELSplitToken *)_splitToken_ {
  NSUndoManager *undoManager = [[[[NSApp mainWindow] windowController] document] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setSplitTokenWithUndo:splitToken];
  if( ![undoManager isUndoing] ) {
    if( _splitToken_ ) {
      [undoManager setActionName:@"add split"];
    } else {
      [undoManager setActionName:@"remove split"];
    }
  }
  [self setSplitToken:_splitToken_];
}


@synthesize spinToken;

- (void)setSpinToken:(ELSpinToken *)_spinToken_ {
  [self removeToken:spinToken];
  spinToken = _spinToken_;
  [self addToken:spinToken];
  [self makeCurrentSelection];
}


- (void)setSpinTokenWithUndo:(ELSpinToken *)_spinToken_ {
  NSUndoManager *undoManager = [[[[NSApp mainWindow] windowController] document] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setSpinTokenWithUndo:spinToken];
  if( ![undoManager isUndoing] ) {
    if( _spinToken_ ) {
      [undoManager setActionName:@"add spin"];
    } else {
      [undoManager setActionName:@"remove spin"];
    }
  }
  [self setSpinToken:_spinToken_];
}


@synthesize skipToken;

- (void)setSkipToken:(ELSkipToken *)newSkipToken {
  [self removeToken:skipToken];
  skipToken = newSkipToken;
  [self addToken:skipToken];
  [self makeCurrentSelection];
}


- (void)setSkipTokenWithUndo:(ELSkipToken *)newSkipToken {
  NSUndoManager *undoManager = [[[[NSApp mainWindow] windowController] document] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setSkipTokenWithUndo:skipToken];
  if( ![undoManager isUndoing] ) {
    if( newSkipToken ) {
      [undoManager setActionName:@"add skip"];
    } else {
      [undoManager setActionName:@"remove skip"];
    }
  }
  [self setSkipToken:newSkipToken];
}


#pragma mark Lattice management

- (void)connectToCell:(ELCell *)cell direction:(Direction)direction {
  neighbours[direction] = cell;
}

- (void)connectNeighbour:(ELCell *)cell direction:(Direction)direction {
  [self connectToCell:cell direction:direction];
}

- (ELCell *)neighbour:(Direction)direction {
  ASSERT_VALID_DIRECTION( direction );
  return neighbours[direction];
}

- (ELNoteGroup *)triad:(int)_triad_ {
  ELNoteGroup *triad = [[ELNoteGroup alloc] initWithNote:[self note]];
  switch( _triad_) {
    case 1:
      if( [self neighbour:N] ) {
        [triad addNote:[[self neighbour:N] note]];
      }
      if( [self neighbour:NE] ) {
        [triad addNote:[[self neighbour:NE] note]];
      }
      break;
    
    case 2:
      if( [self neighbour:NE] ) {
        [triad addNote:[[self neighbour:NE] note]];
      }
      if( [self neighbour:SE] ) {
        [triad addNote:[[self neighbour:SE] note]];
      }
      break;
    
    case 3:
      if( [self neighbour:SE] ) {
        [triad addNote:[[self neighbour:SE] note]];
      }
      if( [self neighbour:S] ) {
        [triad addNote:[[self neighbour:S] note]];
      }
      break;
    
    case 4:
      if( [self neighbour:S] ) {
        [triad addNote:[[self neighbour:S] note]];
      }
      if( [self neighbour:SW] ) {
        [triad addNote:[[self neighbour:SW] note]];
      }
      break;
    
    case 5:
      if( [self neighbour:SW] ) {
        [triad addNote:[[self neighbour:SW] note]];
      }
      if( [self neighbour:NW] ) {
        [triad addNote:[[self neighbour:NW] note]];
      }
      break;
    
    case 6:
      if( [self neighbour:NW] ) {
        [triad addNote:[[self neighbour:NW] note]];
      }
      if( [self neighbour:N] ) {
        [triad addNote:[[self neighbour:N] note]];
      }
      break;
  }
  
  return triad;
}

// Token support

- (void)needsDisplay {
  [layer needsDisplay];
}

- (BOOL)shouldBeSaved {
  return [tokens count] > 0;
}

- (void)start {
  [[tokens allValues] makeObjectsPerformSelector:@selector(start)];
}

- (void)stop {
  [[tokens allValues] makeObjectsPerformSelector:@selector(stop)];
}

- (void)run:(ELPlayhead *)playhead {
  [noteToken run:playhead];
  [splitToken run:playhead];
  [reboundToken run:playhead];
  [absorbToken run:playhead];
  [spinToken run:playhead];
  [skipToken run:playhead];
}

- (void)addToken:(ELToken *)newToken {
  if( newToken ) {
    [tokens setObject:newToken forKey:[newToken tokenType]];
    [newToken addedToLayer:layer atPosition:self];
  }
}

- (void)removeToken:(ELToken *)token {
  if( token ) {
    [token removedFromLayer:layer];
    [tokens removeObjectForKey:[token tokenType]];
  }
}

- (void)removeAllTokens {
  [self setGenerateToken:nil];
  [self setNoteToken:nil];
  [self setReboundToken:nil];
  [self setAbsorbToken:nil];
  [self setSplitToken:nil];
  [self setSpinToken:nil];
  [self setSkipToken:nil];
}

- (void)copyTokensFrom:(ELCell *)cell {
  [self setGenerateToken:[[cell generateToken] mutableCopy]];
  [self setNoteToken:[[cell noteToken] mutableCopy]];
  [self setReboundToken:[[cell reboundToken] mutableCopy]];
  [self setAbsorbToken:[[cell absorbToken] mutableCopy]];
  [self setSplitToken:[[cell splitToken] mutableCopy]];
  [self setSpinToken:[[cell spinToken] mutableCopy]];
  [self setSkipToken:[[cell skipToken] mutableCopy]];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Cell %d,%d - %@", col, row, note];
}

// Playheads

- (void)playheadEntering:(ELPlayhead *)_playhead {
  [playheads addObject:_playhead];
}

- (void)playheadLeaving:(ELPlayhead *)_playhead {
  [playheads removeObject:_playhead];
}

// Token support

- (NSMenu *)contextMenu {
  NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Context Menu"];
  
  // Add a dummy separator as item-0 which the pull-down will use to store the title. Lord knows why...
  [menu addItem:[NSMenuItem separatorItem]];
  
  NSMenuItem *item;
  
  [menu addItem:[self tokenMenuItem:@"Generate"
                           present:([self generateToken] != nil)
                          selector:@selector(toggleGenerateToken:)]];
  
  [menu addItem:[self tokenMenuItem:@"Note"
                           present:([self noteToken] != nil)
                          selector:@selector(toggleNoteToken:)]];
  
  [menu addItem:[self tokenMenuItem:@"Rebound"
                           present:([self reboundToken] != nil)
                          selector:@selector(toggleReboundToken:)]];
  
  [menu addItem:[self tokenMenuItem:@"Absorb"
                           present:([self absorbToken] != nil)
                          selector:@selector(toggleAbsorbToken:)]];
  
  [menu addItem:[self tokenMenuItem:@"Split"
                           present:([self splitToken] != nil)
                          selector:@selector(toggleSplitToken:)]];
  
  [menu addItem:[self tokenMenuItem:@"Spin"
                           present:([self spinToken] != nil)
                          selector:@selector(toggleSpinToken:)]];
  
  [menu addItem:[self tokenMenuItem:@"Skip"
                           present:([self skipToken] != nil)
                          selector:@selector(toggleSkipToken:)]];
  
  [menu addItem:[NSMenuItem separatorItem]];
  
  item = [[NSMenuItem alloc] initWithTitle:@"Clear" action:@selector(clearCell:) keyEquivalent:@""];
  [item setTarget:self];
  [menu addItem:item];
  
  return menu;
}

- (NSMenuItem *)tokenMenuItem:(NSString *)_name_ present:(BOOL)_present_ selector:(SEL)_selector_ {
  NSMenuItem *item;
  
  if( _present_ ) {
    item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Remove %@",_name_] action:_selector_ keyEquivalent:@""];
  } else {
    item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Add %@",_name_] action:_selector_ keyEquivalent:@""];
  }
  [item setTarget:self];
  
  return item;
}

- (IBAction)clearTokens:(id)sender {
  [self removeAllTokens];
  [self makeCurrentSelection];
}


- (IBAction)toggleGenerateToken:(id)sender {
  if( [self generateToken] ) {
    [self setGenerateTokenWithUndo:nil];
  } else {
    [self setGenerateTokenWithUndo:[[ELGenerateToken alloc] init]];
    
    [[[NSApp delegate] inspectorController] inspect:@"generate"];
  }
}


- (IBAction)toggleNoteToken:(id)sender {
  if( [self noteToken] ) {
    [self setNoteTokenWithUndo:nil];
  } else {
    [self setNoteTokenWithUndo:[[ELNoteToken alloc] init]];
    [[[NSApp delegate] inspectorController] inspect:@"note"];
  }
}


- (IBAction)toggleReboundToken:(id)sender {
  if( [self reboundToken] ) {
    [self setReboundTokenWithUndo:nil];
  } else {
    [self setReboundTokenWithUndo:[[ELReboundToken alloc] init]];
    [[[NSApp delegate] inspectorController] inspect:@"rebound"];
  }
}


- (IBAction)toggleAbsorbToken:(id)sender {
  if( [self absorbToken] ) {
    [self setAbsorbTokenWithUndo:nil];
  } else {
    [self setAbsorbTokenWithUndo:[[ELAbsorbToken alloc] init]];
    [[[NSApp delegate] inspectorController] inspect:@"absorb"];
  }
}


- (IBAction)toggleSplitToken:(id)sender {
  if( [self splitToken] ) {
    [self setSplitTokenWithUndo:nil];
  } else {
    [self setSplitTokenWithUndo:[[ELSplitToken alloc] init]];
    [[[NSApp delegate] inspectorController] inspect:@"split"];
  }
}


- (IBAction)toggleSpinToken:(id)sender {
  if( [self spinToken] ) {
    [self setSpinTokenWithUndo:nil];
  } else {
    [self setSpinTokenWithUndo:[[ELSpinToken alloc] init]];
    [[[NSApp delegate] inspectorController] inspect:@"spin"];
  }
}


- (IBAction)toggleSkipToken:(id)sender {
  if( [self skipToken] ) {
    [self setSkipTokenWithUndo:nil];
  } else {
    [self setSkipTokenWithUndo:[[ELSkipToken alloc] init]];
    [[[NSApp delegate] inspectorController] inspect:@"skip"];
  }
}


- (void)makeCurrentSelection {
  [(LMHoneycombView *)[[self layer] delegate] setSelected:self];
}


#pragma mark Drawing code

- (void)drawText:(NSString *)_text_ withAttributes:(NSMutableDictionary *)_attributes_ {
  NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
  [textAttributes setObject:[NSFont fontWithName:@"Helvetica" size:9]
                 forKey:NSFontAttributeName];
  [textAttributes setObject:[_attributes_ objectForKey:ELDefaultTokenColor]
                 forKey:NSForegroundColorAttributeName];
  
  NSSize strSize = [_text_ sizeWithAttributes:textAttributes];
  
  NSPoint strOrigin;
  strOrigin.x = [path bounds].origin.x + ( [path bounds].size.width - strSize.width ) / 2;
  strOrigin.y = [path bounds].origin.y + ( [path bounds].size.height - strSize.height ) / 2;
  
  [_text_ drawAtPoint:strOrigin withAttributes:textAttributes];
}

int mapPathSection( Direction d ) {
  switch( d % 6 ) {
    case N:
    return 2;
    case NE:
    return 1;
    case SE:
    return 0;
    case S:
    return 5;
    case SW:
    return 4;
    case NW:
    return 3;
    default:
    NSLog( @"Well this shouldn't happen! (Direction = %d)", d );
    assert( NO );
  }
}

NSString* elementDescription( NSBezierPathElement elt ) {
  switch( elt ) {
    case NSMoveToBezierPathElement:
      return @"MOVE";
    case NSLineToBezierPathElement:
      return @"LINE";
    case NSCurveToBezierPathElement:
      return @"CURVE";
    case NSClosePathBezierPathElement:
      return @"CLOSE";
    default:
    NSLog( @"Well this shouldn't happen either" );
    assert( NO );
  }
}

// Draw a triangle to represent the direction a playhead might leave a cell
//
// The strategy is to draw a triangle heading north, then rotate it
// appropriately.
//
- (void)drawTriangleInDirection:(Direction)_direction_ withAttributes:(NSDictionary *)_attributes_ {
  NSPoint base1 = NSMakePoint( [self centre].x - [self radius] / 4, [self centre].y + [self radius] / 2 );
  NSPoint base2 = NSMakePoint( [self centre].x + [self radius] / 4, [self centre].y + [self radius] / 2 );
  NSPoint apex = NSMakePoint( [self centre].x, [self centre].y + 3 * [self radius] / 4 );
  
  NSBezierPath *trianglePath = [NSBezierPath bezierPath];
  [trianglePath moveToPoint:base1];
  [trianglePath lineToPoint:apex];
  [trianglePath lineToPoint:base2];
  [trianglePath lineToPoint:base1];
  [trianglePath closePath];
  
  if( _direction_ != 0 ) {
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:centre.x yBy:centre.y];
    [transform rotateByDegrees:(360.0 - ( _direction_ * 60 ))];
    [transform translateXBy:-centre.x yBy:-centre.y];
    [trianglePath transformUsingAffineTransform:transform];
  }
  
  [trianglePath setLineWidth:2.0];
  [trianglePath stroke];
}

- (void)drawOnHoneycombView:(LMHoneycombView *)_view_ withAttributes:(NSMutableDictionary *)_attributes_ {
  if( [playheads count] > 0 ) {
    int minTTL = 5;
    for( ELPlayhead *playhead in playheads ) {
      if( [playhead TTL] < minTTL ) {
        minTTL = [playhead TTL];
      }
    }
    CGFloat fader = 0.5 + ( 0.5 * ((float)minTTL/5) );
    
    if( selected ) {
      [_attributes_ setObject:[[_attributes_ objectForKey:ELDefaultActivePlayheadColor] colorWithAlphaComponent:fader] forKey:LMHoneycombViewSelectedColor];
    } else {
      [_attributes_ setObject:[[_attributes_ objectForKey:ELDefaultActivePlayheadColor] colorWithAlphaComponent:fader] forKey:LMHoneycombViewDefaultColor];
    }
    
    
  } else {
    if( [[layer player] showKey] ) {
      BOOL isTonic;
      if( [[layer key] containsNote:note isTonic:&isTonic] ) {
        if( isTonic ) {
          [_attributes_ setObject:[_attributes_ objectForKey:ELTonicNoteColor] forKey:LMHoneycombViewDefaultColor];
        } else {
          [_attributes_ setObject:[_attributes_ objectForKey:ELScaleNoteColor] forKey:LMHoneycombViewDefaultColor];
        }
      }
    } else if( [[layer player] showOctaves] ) {
      [_attributes_ setObject:[(ELSurfaceView *)_view_ octaveColor:[note octave]] forKey:LMHoneycombViewDefaultColor];
    }
  }
  
  [super drawOnHoneycombView:_view_ withAttributes:_attributes_];
  
  if( [[layer player] showNotes] ) {
    if( [[layer key] flat] ) {
      [self drawText:[note flattenedName] withAttributes:_attributes_];
    } else {
      [self drawText:[note name] withAttributes:_attributes_];
    }
    
  }
  
  [[[self tokens] allValues] makeObjectsPerformSelector:@selector(drawWithAttributes:) withObject:_attributes_];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *cellElement = [NSXMLNode elementWithName:@"cell"];
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:[NSNumber numberWithInt:col] forKey:@"col"];
  [attributes setObject:[NSNumber numberWithInt:row] forKey:@"row"];
  [cellElement setAttributesAsDictionary:attributes];
  
  for( ELToken *token in [[self tokens] allValues] ) {
    [cellElement addChild:[token xmlRepresentation]];
  }
  
  return cellElement;
}

// This method is slightly different in that we know the object already
// exists within the layer, we're sort of over-initing it
- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  NSXMLElement *element;
  
  element = [[_representation_ nodesForXPath:@"generate" error:_error_] firstXMLElement];
  if( element ) {
    [self setGenerateToken:[[ELGenerateToken alloc] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"note" error:_error_] firstXMLElement];
  if( element ) {
    [self setNoteToken:[[ELNoteToken alloc] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"rebound" error:_error_] firstXMLElement];
  if( element ) {
    [self setReboundToken:[[ELReboundToken alloc] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"absorb" error:_error_] firstXMLElement];
  if( element ) {
    [self setAbsorbToken:[[ELAbsorbToken alloc] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"split" error:_error_] firstXMLElement];
  if( element ) {
    [self setSplitToken:[[ELSplitToken alloc] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"spin" error:_error_] firstXMLElement];
  if( element ) {
    [self setSpinToken:[[ELSpinToken alloc] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"skip" error:_error_] firstXMLElement];
  if( element ) {
    [self setSkipToken:[[ELSkipToken alloc] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  return self;
}

@end