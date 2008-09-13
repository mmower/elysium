# Controls

Implement a control scheme based on the concept of a "knob" (the word control is already too overloaded) which represents how a particular control is represented. In UI terms it might represent a number of controls that allow configuration of value, alpha, probability, attached oscillator, register number, & script.

# Tools

We need to allow the user some flexibility about managing & resetting the state of tools. For example there is the state prior to hitting start. Then changes that may be made during a performance. Do we want to reset those (as we do now) or offer some means to reset some (or all) controls back to their pre-performance state.

Sink tools should allow permeability in specific directions.

Splitter tools should have an option to bounce back (i.e. emit in all directions). Maybe we should also allow specifying exactly which directions to send playheads in. Splitter and ricochet begin to merge at this point.

Rotors have a fixed step size, maybe this should be variable (even random).

Beat tool should support 2-notes, (e.g. 1/2 + 1/2), and 3-notes (e.g. 1/3+1/3+1/3), and 4-notes (e.g. 1/4+1/4+1/4+1/4) all MIDI scheduled.

Beat tool should support playback of triads, chords, and linked notes.

# Surface

Allow the edge of the surface to wrap around.

Allow the edge of the surface to represent a "jump" to another hex or layer.

Allow easier sensing of notes and octaves (e.g. colour each octave in the map).

# Playheads

When a playhead is reaching it's TTL begin to fade it.

Active playheads: Playheads should know their owner generator and be scriptable. E.g. change velocity as the TTL diminishes.

# Scripting

Embed JavascriptCore.

Choose callback points.

Expose state of player, layers, and tools as registers to be manipulated by scripts and to hold state between callbacks.

Examples might be layerWillRun/layerDidRun, toolWillRun/toolDidRun. Since the player has no global sense it which it is run any more there is no callback except maybe playerWillStart/playerDidStart and playerWillStop/playerDidStop.

# Shape

Allow scripting and attachment of oscillators to control inputs.

# Performance

Allow configuration of a set of controls to form a playback "preset" that can be stored and called back.

Add a transposer bar for changing the octave of playback for the entire layer.

# Documents

Support close.

# MIDI and timing

At the moment the timing takes no account of the length of time layer processing requires. In particular the sleep time is fixed to the tempo, we might switch to something like:

- (void)run {
  ...
  start = AudioGetCurrentHostTime();
  
  ... current run ...
  
  usleep( timerResolution - ( AudioGetCurrentHostTime() - start ) );
  ...
  
}

CC messages?

