/*
 * Scratchr2 Wav Player
 * Ian Reynolds (idr@mit.edu), July 2014
 *
 * Copyright (C) 2014 Massachusetts Institute of Technology
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */


package {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.external.ExternalInterface;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import scratch.ScratchSound;

import sound.ScratchSoundPlayer;

[SWF(width='100',height='100',backgroundColor='#ffffff',frameRate='25')]
public class WavPlayer extends Sprite {
	public var sound:ScratchSoundPlayer;
	private var loader:URLLoader;

	public function WavPlayer() {
		if(ExternalInterface.available) {
			ExternalInterface.addCallback('AS_loadSound', loadSound);
			ExternalInterface.addCallback('AS_playSound', playSound);
			ExternalInterface.addCallback('AS_stopSound', stopSound);
		}
	}

	public function loadSound(url:String):void {
		loader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, onLoadComplete);
		loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
		loader.load(new URLRequest(url));
	}

	private function onLoadProgress(e:ProgressEvent):void {
		ExternalInterface.call('SoundPlayer.onLoadProgress',e.bytesLoaded,e.bytesTotal);
	}

	private function onLoadComplete(e:Event):void {
		sound = new ScratchSound('sound',loader.data as ByteArray).sndplayer();
		ExternalInterface.call('SoundPlayer.onLoadComplete');
	}

	private function playSound():void {
		if(!sound) return;
		(sound as ScratchSoundPlayer).startPlaying(soundDone);
	}

	private function stopSound():void {
		if(!sound) return;
		(sound as ScratchSoundPlayer).stopPlaying();
	}

	private function soundDone():void {
		ExternalInterface.call('SoundPlayer.onPlayComplete');
	}
}
}
