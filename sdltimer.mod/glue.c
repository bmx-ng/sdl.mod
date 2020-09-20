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

#include "SDL_events.h"
#include "SDL_timer.h"
#include <brl.mod/blitz.mod/blitz.h>


void sdl_sdltimer__TimerFired( BBObject * data );
SDL_TimerID bmx_sdl_timer_start( float hertz, BBObject * timer );
void bmx_sdl_timer_stop( SDL_TimerID handle, BBObject * timer );
void bmx_sdl_timer_fire( int id, BBObject * obj, int ticks);

Uint32 bmx_sdl_timer_ontick(Uint32 interval, void *param) {
	sdl_sdltimer__TimerFired((BBObject*)param);
	return interval;
}

void bmx_sdl_timer_fire( int id, BBObject * obj, int ticks ) {
    SDL_Event event;
    SDL_UserEvent userevent;

	SDL_zero(event);
    userevent.type = SDL_USEREVENT;
    userevent.code = id,
    userevent.data1 = obj;
	userevent.data2 = malloc(sizeof(int));
	((int*)userevent.data2)[0] = ticks;

    event.type = SDL_USEREVENT;
    event.user = userevent;

    SDL_PushEvent(&event);
}

SDL_TimerID bmx_sdl_timer_start( float hertz, BBObject * timer ) {
	SDL_TimerID t = SDL_AddTimer(1000/((hertz != 0)?hertz:1), bmx_sdl_timer_ontick, timer);
	
	if (!t) {
		return 0;
	}

	BBRETAIN(timer);
	
	return t;
}

void bmx_sdl_timer_stop( SDL_TimerID handle, BBObject * timer ) {
	SDL_RemoveTimer(handle);
	BBRELEASE(timer);
}

