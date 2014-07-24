## scratchr2-wavplayer

This is a tiny sound player for the scratchr2 platform. It plays the ADPCM-encoded .wav files exported by the Scratch
editor, because browsers don't handle them very well. The Scratch editor source (`scratch-flash`) is included as a 
submodule. You'll have to run its ant buildfile before you'll be able to compile this player; see [the project's
readme](https://github.com/llk/scratch-flash) for more information.