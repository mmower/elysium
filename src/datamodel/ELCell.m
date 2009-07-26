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
- (void)setReboundTokenWithUndo:(ELReboundToken *)reboundToken;
- (void)setAbsorbTokenWithUndo:(ELAbsorbToken *)absorbToken;
- (void)setSplitTokenWithUndo:(ELSplitToken *)splitToken;
- (void)setSpinTokenWithUndo:(ELSpinToken *)spinToken;
- (void)setSkipTokenWithUndo:(ELSkipToken *)skipToken;

- (void)addToken:(ELToken *)token;
- (void)removeToken:(ELToken *)token;

@end

@implementation ELCell

- (id)initWithLayer:(ELLayer *)layer note:(ELNote *)note column:(int)col row:(int)row {
  if( ( self = [super initWithColumn:col row:row] ) ) {
    _layer        = layer;
    _note         = note;
    _tokens       = [[NSMutableDictionary alloc] init];
    _playheads    = [[NSMutableArray alloc] init];
    _scriptingTag = [NSString stringWithFormat:@"cell%d:%d",[self col],[self row]];
    _dirty        = NO;
    
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

@synthesize layer = _layer;
@synthesize note = _note;
@synthesize playheads = _playheads;
@synthesize scriptingTag = _scriptingTag;
@synthesize tokens = _tokens;

@synthesize dirty = _dirty;

- (void)setDirty:(BOOL)dirty {
  _dirty = dirty;
  if( _dirty ) {
    [[self layer] setDirty:YES];
  }
}


@synthesize generateToken = _generateToken;

- (void)setGenerateToken:(ELGenerateToken *)generateToken {
  [self removeToken:_generateToken];
  _generateToken = generateToken;
  [self addToken:_generateToken];
  [self makeCurrentSelection];
}


- (void)setGenerateTokenWithUndo:(ELGenerateToken *)generateToken {
  NSUndoManager *undoManager = [[[self layer] player] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setGenerateTokenWithUndo:_generateToken];
  if( ![undoManager isUndoing] ) {
    if( generateToken ) {
      [undoManager setActionName:@"add generate"];
    } else {
      [undoManager setActionName:@"remove generate"];
    }
  }
  [self setGenerateToken:generateToken];
}


@synthesize noteToken = _noteToken;

- (void)setNoteToken:(ELNoteToken *)noteToken {
  [self removeToken:_noteToken];
  _noteToken = noteToken;
  [self addToken:_noteToken];
  [self makeCurrentSelection];
}


- (void)setNoteTokenWithUndo:(ELNoteToken *)noteToken {
  NSUndoManager *undoManager = [[[self layer] player] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setNoteTokenWithUndo:_noteToken];
  if( ![undoManager isUndoing] ) {
    if( noteToken ) {
      [undoManager setActionName:@"add note"];
    } else {
      [undoManager setActionName:@"remove note"];
    }
  }
  [self setNoteToken:noteToken];
}


@synthesize reboundToken = _reboundToken;

- (void)setReboundToken:(ELReboundToken *)reboundToken {
  [self removeToken:_reboundToken];
  _reboundToken = reboundToken;
  [self addToken:_reboundToken];
  [self makeCurrentSelection];
}


- (void)setReboundTokenWithUndo:(ELReboundToken *)reboundToken {
  NSUndoManager *undoManager = [[[self layer] player] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setReboundTokenWithUndo:_reboundToken];
  if( ![undoManager isUndoing] ) {
    if( reboundToken ) {
      [undoManager setActionName:@"add rebound"];
    } else {
      [undoManager setActionName:@"remove rebound"];
    }
  }
  [self setReboundToken:reboundToken];
}


@synthesize absorbToken = _absorbToken;

- (void)setAbsorbToken:(ELAbsorbToken *)absorbToken {
  [self removeToken:_absorbToken];
  _absorbToken = absorbToken;
  [self addToken:_absorbToken];
  [self makeCurrentSelection];
}


- (void)setAbsorbTokenWithUndo:(ELAbsorbToken *)absorbToken {
  NSUndoManager *undoManager = [[[self layer] player] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setAbsorbTokenWithUndo:_absorbToken];
  if( ![undoManager isUndoing] ) {
    if( absorbToken ) {
      [undoManager setActionName:@"add absorb"];
    } else {
      [undoManager setActionName:@"remove absorb"];
    }
  }
  [self setAbsorbToken:absorbToken];
}


@synthesize splitToken = _splitToken;

- (void)setSplitToken:(ELSplitToken *)splitToken {
  [self removeToken:_splitToken];
  _splitToken = splitToken;
  [self addToken:_splitToken];
  [self makeCurrentSelection];
}


- (void)setSplitTokenWithUndo:(ELSplitToken *)splitToken {
  NSUndoManager *undoManager = [[[self layer] player] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setSplitTokenWithUndo:_splitToken];
  if( ![undoManager isUndoing] ) {
    if( splitToken ) {
      [undoManager setActionName:@"add split"];
    } else {
      [undoManager setActionName:@"remove split"];
    }
  }
  [self setSplitToken:splitToken];
}


@synthesize spinToken = _spinToken;

- (void)setSpinToken:(ELSpinToken *)spinToken {
  [self removeToken:_spinToken];
  _spinToken = spinToken;
  [self addToken:_spinToken];
  [self makeCurrentSelection];
}


- (void)setSpinTokenWithUndo:(ELSpinToken *)spinToken {
  NSUndoManager *undoManager = [[[self layer] player] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setSpinTokenWithUndo:_spinToken];
  if( ![undoManager isUndoing] ) {
    if( spinToken ) {
      [undoManager setActionName:@"add spin"];
    } else {
      [undoManager setActionName:@"remove spin"];
    }
  }
  [self setSpinToken:spinToken];
}


@synthesize skipToken = _skipToken;

- (void)setSkipToken:(ELSkipToken *)skipToken {
  [self removeToken:_skipToken];
  _skipToken = skipToken;
  [self addToken:_skipToken];
  [self makeCurrentSelection];
}


- (void)setSkipTokenWithUndo:(ELSkipToken *)skipToken {
  NSUndoManager *undoManager = [[[self layer] player] undoManager];
  [[undoManager prepareWithInvocationTarget:self] setSkipTokenWithUndo:_skipToken];
  if( ![undoManager isUndoing] ) {
    if( skipToken ) {
      [undoManager setActionName:@"add skip"];
    } else {
      [undoManager setActionName:@"remove skip"];
    }
  }
  [self setSkipToken:skipToken];
}


@synthesize playheadEntered = _playheadEntered;


#pragma mark Lattice management

- (void)connectToCell:(ELCell *)cell direction:(Direction)direction {
  _neighbours[direction] = cell;
}

- (void)connectNeighbour:(ELCell *)cell direction:(Direction)direction {
  [self connectToCell:cell direction:direction];
}

- (ELCell *)neighbour:(Direction)direction {
  ASSERT_VALID_DIRECTION( direction );
  return _neighbours[direction];
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


#pragma mark Token support

- (void)needsDisplay {
  [[self layer] needsDisplay];
}


- (BOOL)shouldBeSaved {
  return [[self tokens] count] > 0;
}


- (void)start {
  [[[self tokens] allValues] makeObjectsPerformSelector:@selector(start)];
}


- (void)stop {
  [[[self tokens] allValues] makeObjectsPerformSelector:@selector(stop)];
}


- (void)run:(ELPlayhead *)playhead {
  [[self noteToken] run:playhead];
  [[self splitToken] run:playhead];
  [[self reboundToken] run:playhead];
  [[self absorbToken] run:playhead];
  [[self spinToken] run:playhead];
  [[self skipToken] run:playhead];
}


- (BOOL)hasTokenWithIdentifier:(NSString *)identifier {
  return [[self tokens] objectForKey:identifier] != nil;
}


- (void)addToken:(ELToken *)token {
  if( token ) {
    [[self tokens] setObject:token forKey:[token tokenType]];
    [token addedToLayer:[self layer] atPosition:self];
  }
}


- (void)removeToken:(ELToken *)token {
  if( token ) {
    [token removedFromLayer:[self layer]];
    [[self tokens] removeObjectForKey:[token tokenType]];
  }
}


- (void)removeAllTokensWithUndo {
  NSUndoManager *undoManager = [[[self layer] player] undoManager];
  
  [undoManager beginUndoGrouping];
  [self setGenerateTokenWithUndo:nil];
  [self setNoteTokenWithUndo:nil];
  [self setReboundTokenWithUndo:nil];
  [self setAbsorbTokenWithUndo:nil];
  [self setSplitTokenWithUndo:nil];
  [self setSpinTokenWithUndo:nil];
  [self setSkipTokenWithUndo:nil];
  [undoManager setActionName:@"clear"];
  [undoManager endUndoGrouping];
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
  [self setGenerateTokenWithUndo:[[cell generateToken] mutableCopy]];
  [self setNoteTokenWithUndo:[[cell noteToken] mutableCopy]];
  [self setReboundTokenWithUndo:[[cell reboundToken] mutableCopy]];
  [self setAbsorbTokenWithUndo:[[cell absorbToken] mutableCopy]];
  [self setSplitTokenWithUndo:[[cell splitToken] mutableCopy]];
  [self setSpinTokenWithUndo:[[cell spinToken] mutableCopy]];
  [self setSkipTokenWithUndo:[[cell skipToken] mutableCopy]];
}


- (NSString *)description {
  return [NSString stringWithFormat:@"Cell %d,%d - %@", [self col], [self row], [self note]];
}


#pragma mark Playhead support

- (void)playheadEntering:(ELPlayhead *)playhead {
  [[self playheads] addObject:playhead];
  
  [self setPlayheadEntered:YES];
}

- (void)playheadLeaving:(ELPlayhead *)playhead {
  [[self playheads] removeObject:playhead];
}


#pragma mark Menu support

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
  
  item = [[NSMenuItem alloc] initWithTitle:@"Clear" action:@selector(clearTokens:) keyEquivalent:@""];
  [item setTarget:self];
  [menu addItem:item];
  
  return menu;
}


- (NSMenuItem *)tokenMenuItem:(NSString *)name present:(BOOL)present selector:(SEL)selector {
  NSMenuItem *item;
  
  if( present ) {
    item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Remove %@",name] action:selector keyEquivalent:@""];
  } else {
    item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Add %@",name] action:selector keyEquivalent:@""];
  }
  [item setTarget:self];
  
  return item;
}


#pragma mark UI Actions

- (IBAction)clearTokens:(id)sender {
  [self removeAllTokensWithUndo];
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

- (void)drawText:(NSString *)text withAttributes:(NSMutableDictionary *)attributes {
  NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
  [textAttributes setObject:[NSFont fontWithName:@"Helvetica" size:9]
                 forKey:NSFontAttributeName];
  [textAttributes setObject:[attributes objectForKey:ELDefaultTokenColor]
                 forKey:NSForegroundColorAttributeName];
  
  NSSize strSize = [text sizeWithAttributes:textAttributes];
  
  NSPoint strOrigin;
  strOrigin.x = [[self path] bounds].origin.x + ( [[self path] bounds].size.width - strSize.width ) / 2;
  strOrigin.y = [[self path] bounds].origin.y + ( [[self path] bounds].size.height - strSize.height ) / 2;
  
  [text drawAtPoint:strOrigin withAttributes:textAttributes];
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
- (void)drawTriangleInDirection:(Direction)direction withAttributes:(NSDictionary *)attributes {
  NSPoint base1 = NSMakePoint( [self centre].x - [self radius] / 4, [self centre].y + [self radius] / 2 );
  NSPoint base2 = NSMakePoint( [self centre].x + [self radius] / 4, [self centre].y + [self radius] / 2 );
  NSPoint apex = NSMakePoint( [self centre].x, [self centre].y + 3 * [self radius] / 4 );
  
  NSBezierPath *trianglePath = [NSBezierPath bezierPath];
  [trianglePath moveToPoint:base1];
  [trianglePath lineToPoint:apex];
  [trianglePath lineToPoint:base2];
  [trianglePath lineToPoint:base1];
  [trianglePath closePath];
  
  if( direction != 0 ) {
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:[self centre].x yBy:[self centre].y];
    [transform rotateByDegrees:(360.0 - ( direction * 60 ))];
    [transform translateXBy:-[self centre].x yBy:-[self centre].y];
    [trianglePath transformUsingAffineTransform:transform];
  }
  
  [trianglePath setLineWidth:2.0];
  [trianglePath stroke];
}


- (void)drawOnHoneycombView:(LMHoneycombView *)view withAttributes:(NSMutableDictionary *)attributes {
  if( [[self playheads] count] > 0 ) {
    int minTTL = 5;
    for( ELPlayhead *playhead in [self playheads] ) {
      if( [playhead TTL] < minTTL ) {
        minTTL = [playhead TTL];
      }
    }
    CGFloat fader = 0.5 + ( 0.5 * ((float)minTTL/5) );
    
    if( [self selected] ) {
      [attributes setObject:[[attributes objectForKey:ELDefaultActivePlayheadColor] colorWithAlphaComponent:fader] forKey:LMHoneycombViewSelectedColor];
    } else {
      [attributes setObject:[[attributes objectForKey:ELDefaultActivePlayheadColor] colorWithAlphaComponent:fader] forKey:LMHoneycombViewDefaultColor];
    }
    
    
  } else {
    if( [[NSApp delegate] showKey] ) {
      BOOL isTonic;
      if( [[[self layer] key] containsNote:[self note] isTonic:&isTonic] ) {
        if( isTonic ) {
          [attributes setObject:[attributes objectForKey:ELTonicNoteColor] forKey:LMHoneycombViewDefaultColor];
        } else {
          [attributes setObject:[attributes objectForKey:ELScaleNoteColor] forKey:LMHoneycombViewDefaultColor];
        }
      }
    } else if( [[NSApp delegate] showOctaves] ) {
      [attributes setObject:[(ELSurfaceView *)view octaveColor:[[self note] octave]] forKey:LMHoneycombViewDefaultColor];
    }
  }
  
  [super drawOnHoneycombView:view withAttributes:attributes];
  
  if( [[NSApp delegate] showNotes] ) {
    if( [[[self layer] key] flat] ) {
      [self drawText:[[self note] flattenedName] withAttributes:attributes];
    } else {
      [self drawText:[[self note] name] withAttributes:attributes];
    }
    
  }
  
  [[[self tokens] allValues] makeObjectsPerformSelector:@selector(drawWithAttributes:) withObject:attributes];
}


#pragma mark Implements the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *cellElement = [NSXMLNode elementWithName:@"cell"];
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:[NSNumber numberWithInt:[self col]] forKey:@"col"];
  [attributes setObject:[NSNumber numberWithInt:[self row]] forKey:@"row"];
  [cellElement setAttributesAsDictionary:attributes];
  
  for( ELToken *token in [[self tokens] allValues] ) {
    [cellElement addChild:[token xmlRepresentation]];
  }
  
  return cellElement;
}


// This method is slightly different in that we know the object already
// exists within the layer, we're sort of over-initing it
- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  NSXMLElement *element;
  
  element = [[representation nodesForXPath:@"generate" error:error] firstXMLElement];
  if( element ) {
    [self setGenerateToken:[[ELGenerateToken alloc] initWithXmlRepresentation:element parent:parent player:player error:error]];
  }
  
  element = [[representation nodesForXPath:@"note" error:error] firstXMLElement];
  if( element ) {
    [self setNoteToken:[[ELNoteToken alloc] initWithXmlRepresentation:element parent:parent player:player error:error]];
  }
  
  element = [[representation nodesForXPath:@"rebound" error:error] firstXMLElement];
  if( element ) {
    [self setReboundToken:[[ELReboundToken alloc] initWithXmlRepresentation:element parent:parent player:player error:error]];
  }
  
  element = [[representation nodesForXPath:@"absorb" error:error] firstXMLElement];
  if( element ) {
    [self setAbsorbToken:[[ELAbsorbToken alloc] initWithXmlRepresentation:element parent:parent player:player error:error]];
  }
  
  element = [[representation nodesForXPath:@"split" error:error] firstXMLElement];
  if( element ) {
    [self setSplitToken:[[ELSplitToken alloc] initWithXmlRepresentation:element parent:parent player:player error:error]];
  }
  
  element = [[representation nodesForXPath:@"spin" error:error] firstXMLElement];
  if( element ) {
    [self setSpinToken:[[ELSpinToken alloc] initWithXmlRepresentation:element parent:parent player:player error:error]];
  }
  
  element = [[representation nodesForXPath:@"skip" error:error] firstXMLElement];
  if( element ) {
    [self setSkipToken:[[ELSkipToken alloc] initWithXmlRepresentation:element parent:parent player:player error:error]];
  }
  
  return self;
}

@end