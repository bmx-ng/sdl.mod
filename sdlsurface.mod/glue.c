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
#include "SDL_surface.h"
#include "brl.mod/blitz.mod/blitz.h"

SDL_PixelFormat * bmx_sdl_surface_Format(SDL_Surface * surface) {
	return surface->format;
}

int bmx_sdl_surface_Width(SDL_Surface * surface) {
	return surface->w;
}

int bmx_sdl_surface_Height(SDL_Surface * surface) {
	return surface->h;
}

int bmx_sdl_surface_Pitch(SDL_Surface * surface) {
	return surface->pitch;
}

void * bmx_sdl_surface_Pixels(SDL_Surface * surface) {
	return surface->pixels;
}

void bmx_sdl_surface_GetClipRect(SDL_Surface * surface, int * x, int * y, int * w, int * h) {
	SDL_Rect r;
	SDL_GetClipRect(surface, &r);
	*x = r.x;
	*y = r.y;
	*w = r.w;
	*h = r.h;
}

void bmx_sdl_surface_SetClipRect(SDL_Surface * surface, int x, int y, int w, int h) {
	SDL_Rect r;
	r.x = x;
	r.y = y;
	r.w = w;
	r.h = h;
	SDL_SetClipRect(surface, &r);
}

int bmx_sdl_surface_MustLock(SDL_Surface * surface) {
	return SDL_MUSTLOCK(surface);
}

int bmx_sdl_surface_FillRect(SDL_Surface * surface, int x, int y, int w, int h, Uint32 color) {
	SDL_Rect r;
	r.x = x;
	r.y = y;
	r.w = w;
	r.h = h;
	return SDL_FillRect(surface, &r, color);
}

int bmx_sdl_surface_Blit(SDL_Surface * surface, int sx, int sy, int sw, int sh, SDL_Surface * dest, int dx, int dy) {
	SDL_Rect sr;
	sr.x = sx;
	sr.y = sy;
	sr.w = sw;
	sr.h = sh;
	
	SDL_Rect dr;
	dr.x = dx;
	dr.y = dy;
	
	return SDL_BlitSurface(surface, (sw==0 && sh==0 && sx==0 && sy==0) ? NULL : &sr, dest, &dr);
}

int bmx_sdl_surface_BlitScaled(SDL_Surface * surface, int sx, int sy, int sw, int sh, SDL_Surface * dest, int dx, int dy) {
	SDL_Rect sr;
	sr.x = sx;
	sr.y = sy;
	sr.w = sw;
	sr.h = sh;
	
	SDL_Rect dr;
	dr.x = dx;
	dr.y = dy;
	
	return SDL_BlitScaled(surface, (sw==0 && sh==0 && sx==0 && sy==0) ? NULL : &sr, dest, &dr);
}

SDL_Surface * bmx_sdl_LoadBMP(BBString * file) {
	char * f = bbStringToUTF8String(file);
	SDL_Surface * surface = SDL_LoadBMP(f);
	bbMemFree(f);
	return surface;
}



