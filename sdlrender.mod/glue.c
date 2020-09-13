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
#include "SDL_render.h"


int bmx_SDL_RenderCopy(SDL_Renderer * renderer, SDL_Texture * texture, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh) {
	if (sx < 0 || sy < 0 || sw < 0 || sh < 0) {
		if (dx < 0 || dy < 0 || dw < 0 || dh < 0) {
			return SDL_RenderCopy(renderer, texture, 0, 0);
		} else {
			SDL_Rect dr = { dx, dy, dw, dh };
			return SDL_RenderCopy(renderer, texture, 0, &dr);
		}
	} else {
		SDL_Rect sr = { sx, sy, sw, sh };
		if (dx < 0 || dy < 0 || dw < 0 || dh < 0) {
			return SDL_RenderCopy(renderer, texture, &sr, 0);
		} else {
			SDL_Rect dr = { dx, dy, dw, dh };
			return SDL_RenderCopy(renderer, texture, &sr, &dr);
		}
	}
}

int bmx_SDL_RenderDrawRect(SDL_Renderer * renderer, int x, int y, int w, int h) {
	if (x < 0 || y < 0 || w < 0 || h < 0) {
		return SDL_RenderDrawRect(renderer, 0);
	} else {
		SDL_Rect r = { x, y, w, h };
		return SDL_RenderDrawRect(renderer, &r);
	}
}

int bmx_SDL_RenderFillRect(SDL_Renderer * renderer, int x, int y, int w, int h) {
	if (x < 0 || y < 0 || w < 0 || h < 0) {
		return SDL_RenderFillRect(renderer, 0);
	} else {
		SDL_Rect r = { x, y, w, h };
		return SDL_RenderFillRect(renderer, &r);
	}
}

void bmx_SDL_RenderGetClipRect(SDL_Renderer * renderer, int * x, int * y, int * w, int * h) {
	SDL_Rect r;
	SDL_RenderGetClipRect(renderer, &r);
	*x = r.x;
	*y = r.y;
	*w = r.w;
	*h = r.h;
}

void bmx_SDL_RenderGetViewport(SDL_Renderer * renderer, int * x, int * y, int * w, int * h) {
	SDL_Rect r;
	SDL_RenderGetViewport(renderer, &r);
	*x = r.x;
	*y = r.y;
	*w = r.w;
	*h = r.h;
}

int bmx_SDL_RenderReadPixels(SDL_Renderer * renderer, Uint32 format, void * pixels, int pitch, int x, int y, int w, int h) {
	if (x < 0 || y < 0 || w < 0 || h < 0) {
		return SDL_RenderReadPixels(renderer, 0, format, pixels, pitch);
	} else {
		SDL_Rect r = { x, y, w, h };
		return SDL_RenderReadPixels(renderer, &r, format, pixels, pitch);
	}	
}

int bmx_SDL_RenderSetClipRect(SDL_Renderer * renderer, int x, int y, int w, int h) {
	if (x < 0 || y < 0 || w < 0 || h < 0) {
		return SDL_RenderSetClipRect(renderer, 0);
	} else {
		SDL_Rect r = { x, y, w, h };
		return SDL_RenderSetClipRect(renderer, &r);
	}
}

int bmx_SDL_RenderSetViewport(SDL_Renderer * renderer, int x, int y, int w, int h) {
	if (x < 0 || y < 0 || w < 0 || h < 0) {
		return SDL_RenderSetViewport(renderer, 0);
	} else {
		SDL_Rect r = { x, y, w, h };
		return SDL_RenderSetViewport(renderer, &r);
	}
}

int bmx_SDL_RenderCopyEx(SDL_Renderer * renderer, SDL_Texture * texture, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh, double angle, int cx, int cy, int flipMode) {
	if (sx < 0 || sy < 0 || sw < 0 || sh < 0) {
		if (dx < 0 || dy < 0 || dw < 0 || dh < 0) {
			if (cx < 0 || cy < 0) {
				return SDL_RenderCopyEx(renderer, texture, 0, 0, angle, 0, flipMode);
			} else {
				SDL_Point p = { cx, cy };
				return SDL_RenderCopyEx(renderer, texture, 0, 0, angle, &p, flipMode);
			}
		} else {
			SDL_Rect dr = { dx, dy, dw, dh };
			if (cx < 0 || cy < 0) {
				return SDL_RenderCopyEx(renderer, texture, 0, &dr, angle, 0, flipMode);
			} else {
				SDL_Point p = { cx, cy };
				return SDL_RenderCopyEx(renderer, texture, 0, &dr, angle, &p, flipMode);
			}
		}
	} else {
		SDL_Rect sr = { sx, sy, sw, sh };
		if (dx < 0 || dy < 0 || dw < 0 || dh < 0) {
			if (cx < 0 || cy < 0) {
				return SDL_RenderCopyEx(renderer, texture, &sr, 0, angle, 0, flipMode);
			} else {
				SDL_Point p = { cx, cy };
				return SDL_RenderCopyEx(renderer, texture, &sr, 0, angle, &p, flipMode);
			}
		} else {
			SDL_Rect dr = { dx, dy, dw, dh };
			if (cx < 0 || cy < 0) {
				return SDL_RenderCopyEx(renderer, texture, &sr, &dr, angle, 0, flipMode);
			} else {
				SDL_Point p = { cx, cy };
				return SDL_RenderCopyEx(renderer, texture, &sr, &dr, angle, &p, flipMode);
			}
		}
	}
}

// --------------------------------------------------------

int bmx_SDL_LockTexture(SDL_Texture * texture, void ** pixels, int * pitch, int x, int y, int w, int h) {
	if (x < 0 || y < 0 || w < 0 || h < 0) {
		return SDL_LockTexture(texture, 0, pixels, pitch);
	} else {
		SDL_Rect r = { x, y, w, h };
		return SDL_LockTexture(texture, &r, pixels, pitch);
	}
}

int bmx_SDL_UpdateTexture(SDL_Texture * texture, void * pixels, int pitch, int x, int y, int w, int h) {
	if (x < 0 || y < 0 || w < 0 || h < 0) {
		return SDL_UpdateTexture(texture, 0, pixels, pitch);
	} else {
		SDL_Rect r = { x, y, w, h };
		return SDL_UpdateTexture(texture, &r, pixels, pitch);
	}
}

int bmx_SDL_UpdateYUVTexture(SDL_Texture * texture, Uint8 * yPlane, int yPitch, Uint8 * uPlane, int uPitch, Uint8 * vPlane, int vPitch, int x, int y, int w, int h) {
	if (x < 0 || y < 0 || w < 0 || h < 0) {
		return SDL_UpdateYUVTexture(texture, 0, yPlane, yPitch, uPlane, uPitch, vPlane, vPitch);
	} else {
		SDL_Rect r = { x, y, w, h };
		return SDL_UpdateYUVTexture(texture, &r, yPlane, yPitch, uPlane, uPitch, vPlane, vPitch);
	}
}

