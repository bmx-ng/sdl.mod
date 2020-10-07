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

#include "SDL_video.h"
#include "SDL_mouse.h"
#include "SDL_syswm.h"

#include <brl.mod/blitz.mod/blitz.h>

enum{
	MODE_SHARED=0,
	MODE_WIDGET=1,
	MODE_WINDOW=2,
	MODE_DISPLAY=3
};

enum{
	FLAGS_BACKBUFFER    = 0x02,
	FLAGS_ALPHABUFFER   = 0x04,
	FLAGS_DEPTHBUFFER   = 0x08,
	FLAGS_STENCILBUFFER = 0x10,
	FLAGS_ACCUMBUFFER   = 0x20,
	FLAGS_BORDERLESS    = 0x40,
	FLAGS_RPI_TV_FULLSCREEN = 0x1000,
	FLAGS_DX            = 0x1000000,
	FLAGS_FULLSCREEN    = 0x80000000
};

typedef struct BBSDLContext BBSDLContext;

struct BBSDLContext{
	int mode,width,height,depth,hertz,flags,sync;
	SDL_Window * window;
	SDL_GLContext context;
	SDL_SysWMinfo info;
};


int bbSDLGraphicsGraphicsModes( int display, int *imodes,int maxcount );
void bbSDLGraphicsFlip( int sync );
void bbSDLGraphicsSetGraphics( BBSDLContext *context );
void bbSDLGraphicsGetSettings( BBSDLContext *context, int * width,int * height,int * depth,int * hertz,int * flags);
void bbSDLGraphicsClose( BBSDLContext *context );
void bmx_SDL_Poll();
void bmx_SDL_WaitEvent();
void * bbSDLGraphicsGetHandle(BBSDLContext *context);

static BBSDLContext *_currentContext;

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

BBSDLContext *bbSDLGraphicsCreateGraphics( int width,int height,int depth,int hz,int flags ) {

	int mode;
	char * appTitle = bbStringToUTF8String( bbAppTitle );
	
	int windowFlags = 0;

	if ((flags & FLAGS_DX) == 0) {
		windowFlags = SDL_WINDOW_OPENGL;
	}
	
	if (flags & FLAGS_BORDERLESS) windowFlags |= SDL_WINDOW_BORDERLESS;
	
	if( depth ){
		windowFlags |= SDL_WINDOW_FULLSCREEN;
		mode=MODE_DISPLAY;
	} else {
		if (flags & FLAGS_FULLSCREEN) {
			windowFlags |= SDL_WINDOW_FULLSCREEN_DESKTOP;
		}
		mode=MODE_WINDOW;
	}

	if ((flags & FLAGS_DX) == 0) {
		if (flags & FLAGS_BACKBUFFER) SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
		if (flags & FLAGS_ALPHABUFFER) SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 1);
		if (flags & FLAGS_DEPTHBUFFER) SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
		if (flags & FLAGS_STENCILBUFFER) SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 1);
	}
#ifdef __ANDROID__
	SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 5);
	SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 6);
	SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 5);
#endif

	SDL_Window *window = SDL_CreateWindow(appTitle, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
		width, height, windowFlags);
		
	if (window == NULL) {
		printf("error... %s\n", SDL_GetError());fflush(stdout);
		return NULL;
	}

	SDL_GLContext context = 0;
	
	if ((flags & FLAGS_DX) == 0) {
		SDL_GL_SetSwapInterval(-1);
	
		context = SDL_GL_CreateContext(window);
	}

	BBSDLContext *bbcontext=(BBSDLContext*)malloc( sizeof(BBSDLContext) );
	memset( bbcontext,0,sizeof(BBSDLContext) );
	bbcontext->mode=mode;	
	bbcontext->width=width;	
	bbcontext->height=height;
	bbcontext->depth=24;	
	bbcontext->hertz=hz;
	bbcontext->flags=flags;
	bbcontext->sync=-1;	
	bbcontext->window=window;
	bbcontext->context=context;
	SDL_GetWindowWMInfo(window, &bbcontext->info);

	return bbcontext;

}

void bbSDLGraphicsFlip( int sync ) {
	if( !_currentContext ) return;
	
	sync=sync ? 1 : 0;
	
	static int _sync=-1;
	
	if( sync!=_currentContext->sync ){
		_currentContext->sync=sync;
		SDL_GL_SetSwapInterval(sync);
	}
	
	SDL_GL_SwapWindow(_currentContext->window);
	bmx_SDL_Poll();
}

void bbSDLGraphicsClose( BBSDLContext *context ){
	if (context){
		if (_currentContext==context) _currentContext=0;
		if (context->context) 
		{
			SDL_GL_DeleteContext(context->context);	
		}
		if (context->window && context->mode!=MODE_WIDGET){
			SDL_DestroyWindow(context->window);
		}
		free( context );
	}
}

void bbSDLGraphicsSetGraphics( BBSDLContext *context ) {
	if( context ){
		SDL_GL_MakeCurrent(context->window, context->context);
	}
	_currentContext=context;
}

void bmx_SDL_WarpMouseInWindow(int x, int y) {
	if( _currentContext ){
		SDL_WarpMouseInWindow(_currentContext->window, x, y);
	} else {
		SDL_WarpMouseInWindow(SDL_GL_GetCurrentWindow(), x, y);
	}
}

void bbSDLGraphicsGetSettings( BBSDLContext *context, int * width,int * height,int * depth,int * hertz,int * flags) {
	if( context ){
		SDL_GL_GetDrawableSize(context->window, &context->width, &context->height);
		*width=context->width;
		*height=context->height;
		*depth=context->depth;
		*hertz=context->hertz;
		*flags=context->flags;
	}
}

void bbSDLExit(){
	bbSDLGraphicsClose( _currentContext );
	_currentContext=0;
}

void * bbSDLGraphicsGetHandle(BBSDLContext *context) {
#ifdef _WIN32
	return context->info.info.win.window;
#endif
	return 0;
}
