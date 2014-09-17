/*
 Copyright (c) 2014 Bruce A Henderson

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
#include "SDL_events.h"
#include "SDL_keyboard.h"

#include <brl.mod/blitz.mod/blitz.h>
#include <brl.mod/event.mod/event.h>	//event enums
#include <brl.mod/keycodes.mod/keycodes.h>	//keycode enums

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
	FLAGS_FULLSCREEN    = 0x80000000
};

typedef struct BBSDLContext BBSDLContext;

struct BBSDLContext{
	int mode,width,height,depth,hertz,flags,sync;
	SDL_Window * window;
	SDL_GLContext context;
};


int bbSDLGraphicsGraphicsModes( int display, int *imodes,int maxcount );
void bbSDLGraphicsFlip( int sync );
void bbSDLGraphicsSetGraphics( BBSDLContext *context );
void bbSDLGraphicsGetSettings( BBSDLContext *context, int * width,int * height,int * depth,int * hertz,int * flags);
void bbSDLGraphicsClose( BBSDLContext *context );
void bmx_SDL_Poll();
void bmx_SDL_WaitEvent();

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
		*imodes++=mode.format;
		*imodes++=mode.refresh_rate;
	}
	return count;
}

BBSDLContext *bbSDLGraphicsCreateGraphics( int width,int height,int depth,int hz,int flags ) {

	int mode;
	char * appTitle = bbStringToUTF8String( bbAppTitle );
	
	int windowFlags = SDL_WINDOW_OPENGL;
	
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

	if (flags & FLAGS_BACKBUFFER) SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
	if (flags & FLAGS_ALPHABUFFER) SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 1);
	if (flags & FLAGS_DEPTHBUFFER) SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
	if (flags & FLAGS_STENCILBUFFER) SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 1);
	
	SDL_Window *window = SDL_CreateWindow(appTitle, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
		width, height, windowFlags);

	SDL_GL_SetSwapInterval(-1);
	
	SDL_GLContext context = SDL_GL_CreateContext(window);

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



/* System stuff */

void brl_event_EmitEvent( BBObject *event );
BBObject *brl_event_CreateEvent( int id,BBObject *source,int data,int mods,int x,int y,BBObject *extra );

void bbSDLSystemEmitEvent( int id,BBObject *source,int data,int mods,int x,int y,BBObject *extra ){
	BBObject *event=brl_event_CreateEvent( id,source,data,mods,x,y,extra );
	brl_event_EmitEvent( event );
}
int mapkey(SDL_Scancode scancode);
int mapmods(int keymods);


int bmx_SDL_GetDisplayWidth(int display) {
	SDL_DisplayMode mode;
	SDL_GetCurrentDisplayMode(display, &mode);
	return mode.w;
}

int bmx_SDL_GetDisplayHeight(int display) {
	SDL_DisplayMode mode;
	SDL_GetCurrentDisplayMode(display, &mode);
	return mode.h;
}

int bmx_SDL_GetDisplayDepth(int display) {
	SDL_DisplayMode mode;
	SDL_GetCurrentDisplayMode(display, &mode);
	return mode.format; // TODO - make this a proper bit depth number
}

int bmx_SDL_GetDisplayhertz(int display) {
	SDL_DisplayMode mode;
	SDL_GetCurrentDisplayMode(display, &mode);
	return mode.refresh_rate;
}

void bmx_SDL_EmitSDLEvent( SDL_Event *event, BBObject *source ) {
	int data;
	int mods;
	switch (event->type) {
		case SDL_QUIT:
			bbSDLSystemEmitEvent(BBEVENT_APPTERMINATE, source, 0, 0, 0, 0, &bbNullObject);
			return;
		case SDL_KEYDOWN:
		case SDL_KEYUP:
			data = mapkey(event->key.keysym.scancode);
			mods = mapmods(event->key.keysym.mod);
			if (event->key.repeat) {
				bbSDLSystemEmitEvent( BBEVENT_KEYREPEAT,source,data,mods,0,0,&bbNullObject );
				return;
			}
			bbSDLSystemEmitEvent( (event->type == SDL_KEYDOWN) ? BBEVENT_KEYDOWN : BBEVENT_KEYUP,source,data,mods,0,0,&bbNullObject );
			return;
			break;
		case SDL_MOUSEMOTION:
			bbSDLSystemEmitEvent( BBEVENT_MOUSEMOVE,source,0,0,event->motion.x,event->motion.y,&bbNullObject );
			return;
		case SDL_MOUSEBUTTONDOWN:
		case SDL_MOUSEBUTTONUP:
			bbSDLSystemEmitEvent( (event->type == SDL_MOUSEBUTTONDOWN) ? BBEVENT_MOUSEDOWN : BBEVENT_MOUSEUP,source,event->button.button,0,event->button.x,event->button.y,&bbNullObject );
			return;
		case SDL_MOUSEWHEEL:
			bbSDLSystemEmitEvent( BBEVENT_MOUSEWHEEL,source,(event->wheel.y < 0) ? -1 : 1,0,0,0,&bbNullObject );
			return;
	}	
	
}

void bmx_SDL_Poll() {
	SDL_Event event;
	while (SDL_PollEvent(&event)) {
		bmx_SDL_EmitSDLEvent(&event, &bbNullObject);
	}
}

void bmx_SDL_WaitEvent() {
	SDL_Event event;
	if (SDL_WaitEvent(&event)) {
		bmx_SDL_EmitSDLEvent(&event, &bbNullObject);
	}
}


int mapkey(SDL_Scancode scancode) {
	switch(scancode) {
		case SDL_SCANCODE_BACKSPACE:
			return KEY_BACKSPACE;
		case SDL_SCANCODE_TAB:
			return KEY_TAB;
		case SDL_SCANCODE_RETURN:
			return KEY_ENTER;
		case SDL_SCANCODE_ESCAPE:
			return KEY_ESC;
		case SDL_SCANCODE_SPACE:
			return KEY_SPACE;
		case SDL_SCANCODE_PAGEUP:
			return KEY_PAGEUP;
		case SDL_SCANCODE_PAGEDOWN:
			return KEY_PAGEDOWN;
		case SDL_SCANCODE_END:
			return KEY_END;
		case SDL_SCANCODE_HOME:
			return KEY_HOME;
		case SDL_SCANCODE_LEFT:
			return KEY_LEFT;
		case SDL_SCANCODE_UP:
			return KEY_UP;
		case SDL_SCANCODE_RIGHT:
			return KEY_RIGHT;
		case SDL_SCANCODE_DOWN:
			return KEY_DOWN;
		case SDL_SCANCODE_INSERT:
			return KEY_INSERT;
		case SDL_SCANCODE_DELETE:
			return KEY_DELETE;
		case SDL_SCANCODE_0:
			return KEY_0;
		case SDL_SCANCODE_1:
			return KEY_1;
		case SDL_SCANCODE_2:
			return KEY_2;
		case SDL_SCANCODE_3:
			return KEY_3;
		case SDL_SCANCODE_4:
			return KEY_4;
		case SDL_SCANCODE_5:
			return KEY_5;
		case SDL_SCANCODE_6:
			return KEY_6;
		case SDL_SCANCODE_7:
			return KEY_7;
		case SDL_SCANCODE_8:
			return KEY_8;
		case SDL_SCANCODE_9:
			return KEY_9;
		case SDL_SCANCODE_A:
			return KEY_A;
		case SDL_SCANCODE_B:
			return KEY_B;
		case SDL_SCANCODE_C:
			return KEY_C;
		case SDL_SCANCODE_D:
			return KEY_D;
		case SDL_SCANCODE_E:
			return KEY_E;
		case SDL_SCANCODE_F:
			return KEY_F;
		case SDL_SCANCODE_G:
			return KEY_G;
		case SDL_SCANCODE_H:
			return KEY_H;
		case SDL_SCANCODE_I:
			return KEY_I;
		case SDL_SCANCODE_J:
			return KEY_J;
		case SDL_SCANCODE_K:
			return KEY_K;
		case SDL_SCANCODE_L:
			return KEY_L;
		case SDL_SCANCODE_M:
			return KEY_M;
		case SDL_SCANCODE_N:
			return KEY_N;
		case SDL_SCANCODE_O:
			return KEY_O;
		case SDL_SCANCODE_P:
			return KEY_P;
		case SDL_SCANCODE_Q:
			return KEY_Q;
		case SDL_SCANCODE_R:
			return KEY_R;
		case SDL_SCANCODE_S:
			return KEY_S;
		case SDL_SCANCODE_T:
			return KEY_T;
		case SDL_SCANCODE_U:
			return KEY_U;
		case SDL_SCANCODE_V:
			return KEY_V;
		case SDL_SCANCODE_W:
			return KEY_W;
		case SDL_SCANCODE_X:
			return KEY_X;
		case SDL_SCANCODE_Y:
			return KEY_Y;
		case SDL_SCANCODE_Z:
			return KEY_Z;
		case SDL_SCANCODE_LGUI:
			return KEY_LSYS;
		case SDL_SCANCODE_RGUI:
			return KEY_RSYS;
		case SDL_SCANCODE_KP_0:
			return KEY_NUM0;
		case SDL_SCANCODE_KP_1:
			return KEY_NUM1;
		case SDL_SCANCODE_KP_2:
			return KEY_NUM2;
		case SDL_SCANCODE_KP_3:
			return KEY_NUM3;
		case SDL_SCANCODE_KP_4:
			return KEY_NUM4;
		case SDL_SCANCODE_KP_5:
			return KEY_NUM5;
		case SDL_SCANCODE_KP_6:
			return KEY_NUM6;
		case SDL_SCANCODE_KP_7:
			return KEY_NUM7;
		case SDL_SCANCODE_KP_8:
			return KEY_NUM8;
		case SDL_SCANCODE_KP_9:
			return KEY_NUM9;
		case SDL_SCANCODE_KP_MULTIPLY:
			return KEY_NUMMULTIPLY;
		case SDL_SCANCODE_KP_PLUS:
			return KEY_NUMADD;
		case SDL_SCANCODE_KP_EQUALS:
			return KEY_NUMSLASH;
		case SDL_SCANCODE_KP_MINUS:
			return KEY_NUMSUBTRACT;
		case SDL_SCANCODE_KP_PERIOD:
			return KEY_NUMDECIMAL;
		case SDL_SCANCODE_KP_DIVIDE:
			return KEY_NUMDIVIDE;
		case SDL_SCANCODE_F1:
			return KEY_F1;
		case SDL_SCANCODE_F2:
			return KEY_F2;
		case SDL_SCANCODE_F3:
			return KEY_F3;
		case SDL_SCANCODE_F4:
			return KEY_F4;
		case SDL_SCANCODE_F5:
			return KEY_F5;
		case SDL_SCANCODE_F6:
			return KEY_F6;
		case SDL_SCANCODE_F7:
			return KEY_F7;
		case SDL_SCANCODE_F8:
			return KEY_F8;
		case SDL_SCANCODE_F9:
			return KEY_F9;
		case SDL_SCANCODE_F10:
			return KEY_F10;
		case SDL_SCANCODE_F11:
			return KEY_F11;
		case SDL_SCANCODE_F12:
			return KEY_F12;
		case SDL_SCANCODE_LSHIFT:
			return KEY_LSHIFT;
		case SDL_SCANCODE_RSHIFT:
			return KEY_RSHIFT;
		case SDL_SCANCODE_LCTRL:
			return KEY_LCONTROL;
		case SDL_SCANCODE_RCTRL:
			return KEY_RCONTROL;
		case SDL_SCANCODE_LALT:
			return KEY_LALT;
		case SDL_SCANCODE_RALT:
			return KEY_RALT;
		case SDL_SCANCODE_GRAVE:
			return KEY_TILDE;
		case SDL_SCANCODE_MINUS:
			return KEY_MINUS;
		case SDL_SCANCODE_EQUALS:
			return KEY_EQUALS;
		case SDL_SCANCODE_LEFTBRACKET:
			return KEY_OPENBRACKET;
		case SDL_SCANCODE_RIGHTBRACKET:
			return KEY_CLOSEBRACKET;
		case SDL_SCANCODE_BACKSLASH:
			return KEY_BACKSLASH;
		case SDL_SCANCODE_SEMICOLON:
			return KEY_SEMICOLON;
		case SDL_SCANCODE_APOSTROPHE:
			return KEY_QUOTES;
		case SDL_SCANCODE_COMMA:
			return KEY_COMMA;
		case SDL_SCANCODE_PERIOD:
			return KEY_PERIOD;
		case SDL_SCANCODE_SLASH:
			return KEY_SLASH;
	}
	
	return scancode;
}

int mapmods(int keymods) {
	int mod = 0;
	
	if (keymods & KMOD_SHIFT) {
		mod |= MODIFIER_SHIFT;
	}
	
	if (keymods & KMOD_CTRL) {
		mod |= MODIFIER_CONTROL;
	}
	
	if (keymods & KMOD_ALT) {
		mod |= MODIFIER_OPTION;
	}
	
	if (keymods & KMOD_GUI) {
		mod |= MODIFIER_SYSTEM;
	}

	return mod;
}
