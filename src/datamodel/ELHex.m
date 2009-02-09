//
//  ELHex.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import <HoneycombView/LMHoneycombView.h>

#import "ELHex.h"
#import "ELKey.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELTool.h"
#import "ELPlayhead.h"
#import "ELNoteGroup.h"
#import "ELHarmonicTable.h"
#import "ELSurfaceView.h"
#import "ELToolView.h"

#import "ELGenerateTool.h"
#import "ELNoteTool.h"
#import "ELReboundTool.h"
#import "ELAbsorbTool.h"
#import "ELSplitTool.h"
#import "ELSpinTool.h"

@implementation ELHex

- (id)initWithLayer:(ELLayer *)_layer_ note:(ELNote *)_note_ column:(int)_col_ row:(int)_row_ {
  if( ( self = [super initWithColumn:_col_ row:_row_] ) ) {
    layer        = _layer_;
    note         = _note_;
    tokens       = [[NSMutableDictionary alloc] init];
    playheads    = [[NSMutableArray alloc] init];
    scriptingTag = [NSString stringWithFormat:@"cell%d:%d",_col_,_row_];
    
    [self connectNeighbour:nil direction:N];
    [self connectNeighbour:nil direction:NE];
    [self connectNeighbour:nil direction:SE];
    [self connectNeighbour:nil direction:S];
    [self connectNeighbour:nil direction:SW];
    [self connectNeighbour:nil direction:NW];
  }
  
  return self;
}

// Properties

@synthesize layer;
@synthesize note;
@synthesize scriptingTag;

@synthesize tokens;

@dynamic generateTool;

- (ELGenerateTool *)generateTool {
  return generateTool;
}

- (void)setGenerateTool:(ELGenerateTool *)_generateTool_ {
  [self removeTool:generateTool];
  generateTool = _generateTool_;
  [self addTool:generateTool];
}

@dynamic noteTool;

- (ELNoteTool *)noteTool {
  return noteTool;
}

- (void)setNoteTool:(ELNoteTool *)_noteTool_ {
  [self removeTool:noteTool];
  noteTool = _noteTool_;
  [self addTool:noteTool];
}

@dynamic reboundTool;

- (ELReboundTool *)reboundTool {
  return reboundTool;
}

- (void)setReboundTool:(ELReboundTool *)_reboundTool_ {
  [self removeTool:reboundTool];
  reboundTool = _reboundTool_;
  [self addTool:reboundTool];
}

@dynamic absorbTool;

- (ELAbsorbTool *)absorbTool {
  return absorbTool;
}

- (void)setAbsorbTool:(ELAbsorbTool *)_absorbTool_ {
  [self removeTool:absorbTool];
  absorbTool = _absorbTool_;
  [self addTool:absorbTool];
}

@dynamic splitTool;

- (ELSplitTool *)splitTool {
  return splitTool;
}

- (void)setSplitTool:(ELSplitTool *)_splitTool_ {
  [self removeTool:splitTool];
  splitTool = _splitTool_;
  [self addTool:splitTool];
}

@dynamic spinTool;

- (ELSpinTool *)spinTool {
  return spinTool;
}

- (void)setSpinTool:(ELSpinTool *)_spinTool_ {
  [self removeTool:spinTool];
  spinTool = _spinTool_;
  [self addTool:spinTool];
}

// Hexes form a grid

- (void)connectToHex:(ELHex *)_hex direction:(Direction)_direction {
  neighbours[_direction] = _hex;
}

- (void)connectNeighbour:(ELHex *)_hex direction:(Direction)_direction {
  [self connectToHex:_hex direction:_direction];
  // [_hex connectToHex:self direction:INVERSE_DIRECTION(_direction)];
}

- (ELHex *)neighbour:(Direction)_direction_ {
  ASSERT_VALID_DIRECTION( _direction_ );
  return neighbours[_direction_];
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

// Tool support

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

- (void)run:(ELPlayhead *)_playhead_ {
  [noteTool run:_playhead_];
  [splitTool run:_playhead_];
  [reboundTool run:_playhead_];
  [absorbTool run:_playhead_];
  [spinTool run:_playhead_];
}

- (void)addTool:(ELTool *)newToken {
  if( newToken ) {
    [tokens setObject:newToken forKey:[newToken tokenType]];
    [newToken addedToLayer:layer atPosition:self];
  }
}

- (void)removeTool:(ELTool *)token {
  if( token ) {
    [token removedFromLayer:layer];
    [tokens removeObjectForKey:[token tokenType]];
  }
}

- (void)removeAllTools {
  [self setGenerateTool:nil];
  [self setNoteTool:nil];
  [self setReboundTool:nil];
  [self setAbsorbTool:nil];
  [self setSplitTool:nil];
  [self setSpinTool:nil];
}

- (void)copyToolsFrom:(ELHex *)_hex_ {
  [self setGenerateTool:[[_hex_ generateTool] mutableCopy]];
  [self setNoteTool:[[_hex_ noteTool] mutableCopy]];
  [self setReboundTool:[[_hex_ reboundTool] mutableCopy]];
  [self setAbsorbTool:[[_hex_ absorbTool] mutableCopy]];
  [self setSplitTool:[[_hex_ splitTool] mutableCopy]];
  [self setSpinTool:[[_hex_ spinTool] mutableCopy]];
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

// Context menu

- (NSMenu *)contextMenu {
  NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Context Menu"];
  
  // Add a dummy separator as item-0 which the pull-down will use to store the title. Lord knows why...
  [menu addItem:[NSMenuItem separatorItem]];
  
  NSMenuItem *item;
  
  [menu addItem:[self toolMenuItem:@"Generate"
                           present:([self generateTool] != nil)
                          selector:@selector(toggleGenerateToken:)]];
  
  [menu addItem:[self toolMenuItem:@"Note"
                           present:([self noteTool] != nil)
                          selector:@selector(toggleNoteToken:)]];
  
  [menu addItem:[self toolMenuItem:@"Rebound"
                           present:([self reboundTool] != nil)
                          selector:@selector(toggleReboundToken:)]];
  
  [menu addItem:[self toolMenuItem:@"Absorb"
                           present:([self absorbTool] != nil)
                          selector:@selector(toggleAbsorbToken:)]];
  
  [menu addItem:[self toolMenuItem:@"Split"
                           present:([self splitTool] != nil)
                          selector:@selector(toggleSplitToken:)]];
  
  [menu addItem:[self toolMenuItem:@"Spin"
                           present:([self spinTool] != nil)
                          selector:@selector(toggleSpinToken:)]];
  
  [menu addItem:[NSMenuItem separatorItem]];
  
  item = [[NSMenuItem alloc] initWithTitle:@"Clear" action:@selector(clearTools) keyEquivalent:@""];
  [item setTarget:self];
  [menu addItem:item];
  
  return menu;
}

- (NSMenuItem *)toolMenuItem:(NSString *)_name_ present:(BOOL)_present_ selector:(SEL)_selector_ {
  NSMenuItem *item;
  
  if( _present_ ) {
    item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Remove %@",_name_] action:_selector_ keyEquivalent:@""];
  } else {
    item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Add %@",_name_] action:_selector_ keyEquivalent:@""];
  }
  [item setTarget:self];
  
  return item;
}

// Tool support

// - (void)addToolWithTag:(int)_toolTag_ {
//   switch( _toolTag_ ) {
//     case EL_TOOL_GENERATE:
//       [self setGenerateTool:[[ELGenerateTool alloc] init]];
//       break;
//       
//     case EL_TOOL_NOTE:
//       [self setNoteTool:[[ELNoteTool alloc] init]];
//       break;
//       
//     case EL_TOOL_REBOUND:
//       [self setReboundTool:[[ELReboundTool alloc] init]];
//       break;
//       
//     case EL_TOOL_ABSORB:
//       [self setAbsorbTool:[[ELAbsorbTool alloc] init]];
//       break;
//       
//     case EL_TOOL_SPLIT:
//       [self setSplitTool:[[ELSplitTool alloc] init]];
//       break;
//       
//     case EL_TOOL_SPIN:
//       [self setSpinTool:[[ELSpinTool alloc] init]];
//       break;
//       
//     case EL_TOOL_CLEAR:
//       [self removeAllTools];
//       break;
//       
//     default:
//       NSAssert1( NO, @"Unknown tool tag %d experienced!", _toolTag_ );
//   }
// }

- (IBAction)clearTools:(id)_sender_ {
  [self removeAllTools];
  [self makeCurrentSelection];
}

- (IBAction)toggleGenerateToken:(id)_sender_ {
  if( [self generateTool] ) {
    [self setGenerateTool:nil];
    // [self makeCurrentSelection];
  } else {
    [self setGenerateTool:[[ELGenerateTool alloc] init]];
    [self makeCurrentSelection];
  }
}

// - (IBAction)addGenerateTool:(id)_sender_ {
//   [self setGenerateTool:[[ELGenerateTool alloc] init]];
//   [self makeCurrentSelection];
// }

// - (IBAction)removeGenerateTool:(id)_sender_ {
//   [self setGenerateTool:nil];
//   [self makeCurrentSelection];
// }

- (IBAction)toggleNoteToken:(id)_sender_ {
  if( [self noteTool] ) {
    [self setNoteTool:nil];
  } else {
    [self setNoteTool:[[ELNoteTool alloc] init]];
    [self makeCurrentSelection];
  }
}

// - (IBAction)addNoteTool:(id)_sender_ {
//   [self setNoteTool:[[ELNoteTool alloc] init]];
//   [self makeCurrentSelection];
// }
// 
// - (IBAction)removeNoteTool:(id)_sender_ {
//   [self setNoteTool:nil];
//   [self makeCurrentSelection];
// }

- (IBAction)toggleReboundToken:(id)_sender_ {
  if( [self reboundTool] ) {
    [self setReboundTool:nil];
  } else {
    [self setReboundTool:[[ELReboundTool alloc] init]];
    [self makeCurrentSelection];
  }
}

// - (IBAction)addReboundTool:(id)_sender_ {
//   [self setReboundTool:[[ELReboundTool alloc] init]];
//   [self makeCurrentSelection];
// }
// 
// - (IBAction)removeReboundTool:(id)_sender_ {
//   [self setReboundTool:nil];
//   [self makeCurrentSelection];
// }

- (IBAction)toggleAbsorbToken:(id)_sender_ {
  if( [self absorbTool] ) {
    [self setAbsorbTool:nil];
  } else {
    [self setAbsorbTool:[[ELAbsorbTool alloc] init]];
    [self makeCurrentSelection];
  }
}

// - (IBAction)addAbsorbTool:(id)_sender_ {
//   [self setAbsorbTool:[[ELAbsorbTool alloc] init]];
//   [self makeCurrentSelection];
// }
// 
// - (IBAction)removeAbsorbTool:(id)_sender_ {
//   [self setAbsorbTool:nil];
//   [self makeCurrentSelection];
// }

- (IBAction)toggleSplitToken:(id)_sender_ {
  if( [self splitTool] ) {
    [self setSplitTool:nil];
  } else {
    [self setSplitTool:[[ELSplitTool alloc] init]];
    [self makeCurrentSelection];
  }
}

// - (IBAction)addSplitTool:(id)_sender_ {
//   [self setSplitTool:[[ELSplitTool alloc] init]];
//   [self makeCurrentSelection];
// }
// 
// - (IBAction)removeSplitTool:(id)_sender_ {
//   [self setSplitTool:nil];
//   [self makeCurrentSelection];
// }

- (IBAction)toggleSpinToken:(id)_sender_ {
  if( [self spinTool] ) {
    [self setSpinTool:nil];
  } else {
    [self setSpinTool:[[ELSpinTool alloc] init]];
    [self makeCurrentSelection];
  }
}

// - (IBAction)addSpinTool:(id)_sender_ {
//   [self setSpinTool:[[ELSpinTool alloc] init]];
//   [self makeCurrentSelection];
// }
// 
// - (IBAction)removeSpinTool:(id)_sender_ {
//   [self setSpinTool:nil];
//   [self makeCurrentSelection];
// }

- (void)makeCurrentSelection {
  [(LMHoneycombView *)[[self layer] delegate] setSelected:self];
}

// Drawing

- (void)drawText:(NSString *)_text_ withAttributes:(NSMutableDictionary *)_attributes_ {
  NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
  [textAttributes setObject:[NSFont fontWithName:@"Helvetica" size:9]
                 forKey:NSFontAttributeName];
  [textAttributes setObject:[_attributes_ objectForKey:ELDefaultToolColor]
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

// Draw a triangle to represent the direction a playhead might leave a hex
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
  
  for( ELTool *tool in [[self tokens] allValues] ) {
    [cellElement addChild:[tool xmlRepresentation]];
  }
  
  return cellElement;
}

// This method is slightly different in that we know the object already
// exists within the layer, we're sort of over-initing it
- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  NSXMLElement *element;
  
  element = [[_representation_ nodesForXPath:@"generate" error:_error_] firstXMLElement];
  if( element ) {
    [self setGenerateTool:[[ELTool toolAlloc:@"generate"] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"note" error:_error_] firstXMLElement];
  if( element ) {
    [self setNoteTool:[[ELTool toolAlloc:@"note"] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"rebound" error:_error_] firstXMLElement];
  if( element ) {
    [self setReboundTool:[[ELTool toolAlloc:@"rebound"] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"absorb" error:_error_] firstXMLElement];
  if( element ) {
    [self setAbsorbTool:[[ELTool toolAlloc:@"absorb"] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"split" error:_error_] firstXMLElement];
  if( element ) {
    [self setSplitTool:[[ELTool toolAlloc:@"split"] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  element = [[_representation_ nodesForXPath:@"spin" error:_error_] firstXMLElement];
  if( element ) {
    [self setSpinTool:[[ELTool toolAlloc:@"spin"] initWithXmlRepresentation:element parent:self player:_player_ error:_error_]];
  }
  
  return self;
}

@end