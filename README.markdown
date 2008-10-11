# Elysium
### Version 0.7.1 - 11.Oct.2008
### by Matt Mower <matt@lucidmac.com>
### [http://lucidmac.com/products/elysium](http://lucidmac.com/products/elysium)

Elysium is a generative music application for MacOSX written in Objective-C and using the Cocoa application framework. It is released as free software under the MIT license. See the included LICENSE file for more information.

## Background

The inspiration for Elysium came from watching a 5 minute long [video of the Reactogon](http://www.youtube.com/watch?v=AklKy2NDpqs) a "chain reactive performance arpeggiator". The Reactogon is a custom built MIDI instrument based upon the harmonic table. I decided it would be a fun project to get back into Cocoa programming to build a software application to play with, and build upon, the same concepts.

Not having written any Cocoa code for over 12 months and never having attempted anything so ambitious in terms of custom drawing, UI, MIDI, et al. there are going to be a lot of rough edges to smooth out. Nevertheless I am happy to have a working prototype.

The aim of Elysium is to transcend an instrument that can be "wired up" and played by including the ability to script the instrument. I had in mind something along the lines of [Conways Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life) for music. As a practical step towards this type of goal, and taking inspiration from Giles Bowketts, Ruby self-generating pattern sequencer, [Archaeopteryx](http://gilesbowkett.blogspot.com/2008/02/archaeopteryx-ruby-midi-generator.html), I think it could be interesting to introduce probability distributions into how Elysium generates music.

But much of this is in the future. What is possible today...

## Introduction

Elysium is a software based MIDI controller. It makes no sound itself but depends upon its output being used to drive a MIDI instrument whether it is
another program, e.g. a software synthesizer:

* [SimpleSynth](http://notahat.com/simplesynth) by Pete Yandell. Free and a great way to check things are working. It uses the general midi library so you'll want something else when you want to sound insanely great.
* [Kore Player](http://www.native-instruments.com/index.php?id=koreplayer) from Native Instruments. Free and sounds absolutely great with a 300mb sound library. I've had occasional crashes under MacOSX 10.5.4 so it might not be suitable for live performances.

Alternatively a hardware MIDI instrument should be playable although I have no experience of that.

Elysium is a CoreMIDI compatible application and should be available as a MIDI source. If not please use Pete Yandell's excellent MIDIPatchBay application. Incidentally Elysium uses Pete's PYMIDI library.

With your instrument ready open Elysium and create a new surface. The surface is the main environment in Elysium and comprises 204 regular hexagons in 17
columns of 12 rows each. Each cell in this honeycomb represents a musical note.

The same note may appear in more than one location in the honeycomb. Notes
are grouped according to the harmonic table. See:

  http://www.c-thru-music.com/cgi/?page=layout_notemap
  
At this point you should be able to click any hex and hear it's accompanying note play in your MIDI instrument. Once you have that working you're ready to move on.

## Wired for sound

Elysium is a generative music application works by playing MIDI instruments. It does not generate music itself so much as it is an environment where you build  "patterns" of objects that will, in turn, create music for you.

A pattern is composed of one or more layers of hexes that represent a harmonic table. Hence each hex corresponds to a note and neighbouring hexes are related to notes that are close together. Each layer represents the same notes and spans several octaves with pitch increasing from the bottom to the top of a layer. By placing different kinds of tokens onto the hexes you build up a structure that plays notes when the composition is run.

A note gets played when a "playhead" token hits a "note" token, playing the note corresponding to the hex the note token is on. Playheads appear, at intervals, on "generator" tokens and are given a direction to travel in. At the beginning of each "beat" all existing playheads will move in their current direction. Playheads keep moving until they hit an "absorb" token, the edge of their layer, or they die of old age.

Every time a playhead passes over a note token the corresponding note for that hex is played. When a playhead passes over a hex without a note token no note is played. 

You can change the direction of a playhead using a rebound token placed on a hex or stop it altogether with an absorb token. When a playhead passes over a hex with a split token the playhead is copied and each copy moves off in a different direction from the point of impact. A spin object modifies the direction in which generator and rebound hexes operate.

Each layer is associated with a MIDI channel so each layer can play a different instrument.

## Things to hack on

### UI

* Do we still need the palette now that we have a context menu?
** Palette controls don't look right
** Palette controls new need icons
* Tools need better symbols in the main view

## Acknowledgements

* Pete Yandell for SimpleSynth, MIDIPatchBay and PYMIDI and for useful advice when I was struggling to get CoreMIDI to work.
* Tomas Fransen for his PAStackableListView
* Andy Matschuchak for Sparkle (again)
* #macdev for advice in solving problems
