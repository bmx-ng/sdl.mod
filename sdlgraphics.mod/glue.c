/*
 Copyright (c) 2014-2022 Bruce A Henderson

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

#include "SDL_video.h"
#include "SDL_mouse.h"
#include "SDL_syswm.h"

#include <brl.mod/blitz.mod/blitz.h>


int bbSDLGraphicsGraphicsModes( int display, int *imodes,int maxcount ) {
	SDL_DisplayMode mode;
	int count,i;

	count = SDL_GetNumDisplayModes(display);
	if (count>maxcount) count=maxcount;
	for (i=0;i<count;i++) {
		SDL_GetDisplayMode(display, i, &mode);

		*imodes++=mode.w;
		*imodes++=mode.h;
		*imodes++=SDL_BITSPERPIXEL(mode.format);
		*imodes++=mode.refresh_rate;
	}
	return count;
}
