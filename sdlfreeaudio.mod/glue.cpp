/*
 Copyright (c) 2014-2020 Bruce A Henderson

 This software is provided 'as-is', without any express or implied
 warranty. In no event will the authors be held liable for any damages
 arising from the use of this software.

 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
*/

#include "pub.mod/freeaudio.mod/freeaudio.h"

#include "SDL.h"
#include "SDL_audio.h"

extern "C" {
	audiodevice *OpenSDLAudioDevice();
	void read_callback(void*  userdata, Uint8* stream, int len);
}


struct sdlaudio : audiodevice {
	SDL_AudioDeviceID device;
	SDL_AudioSpec have;

	int reset() {

		if (!SDL_WasInit(SDL_INIT_AUDIO)) {
			SDL_InitSubSystem(SDL_INIT_AUDIO);
		}
		
		SDL_AudioSpec want;
		
		mix=new mixer(8192);
		mix->freq=22050;
		mix->channels=2;
		
		SDL_zero(want);
		want.freq = 44100;
		want.format = AUDIO_S16LSB;
		want.channels = 2;
		want.samples = 4096;
		want.callback = read_callback;
		want.userdata = this;
		
		device = SDL_OpenAudioDevice(NULL, 0, &want, &have, SDL_AUDIO_ALLOW_FORMAT_CHANGE);
		if (device == 0) {
			return 1;
		}
		
		SDL_PauseAudioDevice(device, 0);
		
		return 0;
	}
	
	
	int close(){
		int	res;

		if (device > 0){
			SDL_CloseAudioDevice(device);
			device = 0;
		}
		return 0;
	}

	void read(Uint8* stream, int len){
		mix->mix16((short*)stream,len/2);
	}

};


void read_callback(void*  userdata, Uint8* stream, int len) {
	sdlaudio	*audio;
	audio=(sdlaudio*)userdata;
	audio->read(stream, len);
}

audiodevice * OpenSDLAudioDevice() {
	return new sdlaudio();
}
