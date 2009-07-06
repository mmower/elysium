//
//  ELPreferences.h
//  Elysium
//
//  Created by Matt Mower on 04/07/2008.
//  Copyright 2009 Matthew Mower.
//  See MIT-LICENSE for more information.
//

extern NSString * const ELBehaviourAtOpenKey;
extern NSString * const ELLayerThreadPriorityKey;
extern NSString * const ELMiddleCOctaveKey;
extern NSString * const ELComposerNameKey;
extern NSString * const ELComposerEmailKey;

extern NSString * const ELDefaultTempoKey;
extern NSString * const ELDefaultTTLKey;
extern NSString * const ELDefaultPulseCountKey;
extern NSString * const ELDefaultVelocityKey;
extern NSString * const ELDefaultEmphasisKey;
extern NSString * const ELDefaultDurationKey;

extern NSString * const ELHasMidiDeviceKey;
extern NSString * const ELUsedMidiDeviceKey;

extern NSString * const ELDefaultCellBackgroundColor;
extern NSString * const ELDefaultCellBorderColor;
extern NSString * const ELDefaultSelectedCellBackgroundColor;
extern NSString * const ELDefaultSelectedCellBorderColor;
extern NSString * const ELDefaultTokenColor;
extern NSString * const ELDisabledTokenColor;
extern NSString * const ELDefaultActivePlayheadColor;
extern NSString * const ELTonicNoteColor;
extern NSString * const ELScaleNoteColor;

extern NSString * const ELShowNotesPrefKey;
extern NSString * const ELShowOctavesPrefKey;
extern NSString * const ELShowKeyPrefKey;

typedef enum tagBehaviourAtOpen {
  EL_DO_NOT_OPEN = 0,
  EL_OPEN_EMPTY,
  EL_OPEN_LAST
} ELBehaviourAtOpen;

typedef enum tagMiddleCOctave {
    EL_C3 = 0,
    EL_C4 = 1
} ELMiddleCOctave;
