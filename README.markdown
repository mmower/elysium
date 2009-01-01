# Elysium
### Version 0.9.0 - 15.Dec.2008
### by Matt Mower <matt@lucidmac.com>
### [http://lucidmac.com/products/elysium](http://lucidmac.com/products/elysium)

Elysium is a generative music application for MacOSX written in Objective-C and using the Cocoa application framework. It is released as free software under the MIT license. See the included LICENSE file for more information.

## Background

The inspiration for Elysium came from watching a 5 minute long [video of the Reactogon](http://www.youtube.com/watch?v=AklKy2NDpqs) a "chain reactive performance arpeggiator". The Reactogon is a custom built MIDI instrument based upon the harmonic table. I decided it would be a fun project to get back into Cocoa programming to build a software application to play with, and build upon, the same concepts and was greatly encouraged by Giles Bowketts, Ruby self-generating pattern sequencer, [Archaeopteryx](http://gilesbowkett.blogspot.com/2008/02/archaeopteryx-ruby-midi-generator.html).

## Introduction

Elysium is a generative MIDI sequencer. Okay so what does that mean?

Let's take that in reverse:

1. Elysium is a sequencer, that means it's designed to produce sequences of notes that can be layered to form music.

2. Elysium uses MIDI which means that it doesn't make sounds itself but can drive MIDI based synthesizers, samplers, and other instruments. It also means that Elysium's output can be recorded, and manipulated, in a DAW such as Logic or Ableton Live.

3. Elysium is generative which relates to the way the music is created by building up a "system" composed of layers, cells, tokens, and playheads that combined, when "played", to produce a sequence of notes.

Still not with me? That's okay. Once you've played with it a bit it will all become clear.

The basic upshot is that you're going to need something to make the actual sounds. If you have a DAW like Logic or Ableton Live you're probably already equipped to do that. If not, here are a couple of free alternatives you could try:

* [SimpleSynth](http://notahat.com/simplesynth) by Pete Yandell. Free and a great way to check things are working. It uses the general midi library so you'll want something else when you want to sound insanely great.
* [Kore Player](http://www.native-instruments.com/index.php?id=koreplayer) from Native Instruments. Free and sounds absolutely great with a 300mb sound library. I've had occasional crashes under MacOSX 10.5.4 so it might not be suitable for live performances.

## Getting Started

I use a combintion of Xcode/Interface Builder and TextMate for working on Elysium. All editing is done in TextMate but builds are done with Xcode.

The included Xcode project may not, however, build for you. I use a few frameworks and wasn't too careful how I set the project up... their may be local dependencies you won't have or will not have setup right.

Please let me know as I would like to get the project to the point where building Elysium is as simple as checking out and clicking build.

## License

Elysium is released under the MIT License. Please see the MIT-LICENSE file that comes with the distribution. It is unmodified save for the copyright notice.

## Acknowledgements

* Mark Burtons reacTogon
* Giles Bowkett's Archaeopteryx
* Pete Yandell for SimpleSynth, MIDIPatchBay and PYMIDI and for useful advice when I was struggling to get CoreMIDI to work.
* Laurent Sansonetti for MacRuby
* Tomas Fransen for his PAStackableListView
* Andy Matschuchak for Sparkle (again)
