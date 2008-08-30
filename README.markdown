# Elysium
### Version 0.01 - 30.Aug.2008
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

The basic idea in Elysium is to drop tools from the palette onto hexes and set it playing.

## Things to hack on

### UI

* Focus issues for the inspector, palette, and main window.
* Palette controls don't look right
* Palette controls new need icons
* Tools need better symbols in the main view
* Need inspectors for
** Splitter
** Rotor
** Sink
** Ricochet

## Acknowledgements

* Pete Yandell for SimpleSynth, MIDIPatchBay and PYMIDI and for useful advice when I was struggling to get CoreMIDI to work.
* Tomas Fransen for his PAStackableListView
* Andy Matschuchak for Sparkle (again)
* #macdev for advice in solving problems
