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
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.external.ExternalInterface;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.Security;
import flash.utils.ByteArray;

import scratch.ScratchSound;

[SWF(width='100',height='100',backgroundColor='#ffffff',frameRate='24')]
public class WavPlayer extends Sprite {
	private var loader:URLLoader;
	private var sound:Object;
	public function WavPlayer() {
		try {
			Security.allowDomain('localhost');
			Security.allowDomain('scratch.mit.edu');
			Security.allowDomain('beta.scratch.mit.edu');
			Security.allowDomain('jiggler.media.mit.edu');
			ExternalInterface.addCallback('ASloadSound', loadSound);
			ExternalInterface.addCallback('ASplaySound', playSound);
			ExternalInterface.addCallback('ASstopSound', stopSound);
		} catch(e:Error) {

		}
	}

	public function loadSound(url:String):void {
		loader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, onLoadComplete);
		loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
		loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		loader.load(new URLRequest(url));
	}

	private function onLoadProgress(e:ProgressEvent):void {
		externalInterfaceCall('SoundPlayer.onLoadProgress',e.bytesLoaded,e.bytesTotal);
	}

	private function onIOError(e:IOErrorEvent):void {
		externalInterfaceCall('SoundPlayer.onIOError',e.text);
	}

	private function onLoadComplete(e:Event):void {
		externalInterfaceCall('SoundPlayer.onLoadComplete');
	}

	private function playSound():void {
		if(sound) {
			(sound as ScratchSoundPlayerStandalone).stopPlaying();
		}
		sound = new ScratchSoundPlayerStandalone(loader.data as ByteArray);
		(sound as ScratchSoundPlayerStandalone).stopPlaying();
		(sound as ScratchSoundPlayerStandalone).startPlaying(soundDone);
	}

	private function stopSound():void {
		if(sound) {
			(sound as ScratchSoundPlayerStandalone).stopPlaying();
		}
	}

	private function soundDone(e:Event):void {
		externalInterfaceCall('SoundPlayer.onPlayComplete');
	}

	private function externalInterfaceCall(...args):void {
		if(ExternalInterface.available) {
			ExternalInterface.call.apply(this,args);
		}
	}
}
}
