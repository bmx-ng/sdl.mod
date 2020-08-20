/*
 Copyright (c) 2014-2019 Bruce A Henderson

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
#include "SDL.h"
#include "SDL_events.h"
#include "SDL_keyboard.h"

#include <brl.mod/blitz.mod/blitz.h>
#include <brl.mod/event.mod/event.h>	//event enums
#include <brl.mod/keycodes.mod/keycodes.h>	//keycode enums

/* System stuff */

static int mouse_button_map[] = {0, 1, 3, 2, 4, 5};

int brl_event_EmitEvent( BBObject *event );
BBObject *brl_event_CreateEvent( int id,BBObject *source,int data,int mods,int x,int y,BBObject *extra );
int sdl_sdlsystem_TSDLSystemDriver__eventFilter(BBObject * userdata, int eventType);
BBObject * sdl_sdlsystem_TSDLMultiGesture__getGesture(BBLONG touchId, int x, int y, float dTheta, float dDist, int numFingers);
void sdl_sdlsystem_TSDLMultiGesture__freeGesture(BBObject * gesture);

void bbSDLSystemEmitEvent( int id,BBObject *source,int data,int mods,int x,int y,BBObject *extra ){
	BBObject *event=brl_event_CreateEvent( id,source,data,mods,x,y,extra );
	brl_event_EmitEvent( event );
}
int mapkey(SDL_Keycode keycode);
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
	int data = 0;
	int mods = 0;
	int i = 0;
	switch (event->type) {
		case SDL_QUIT:
			bbSDLSystemEmitEvent(BBEVENT_APPTERMINATE, source, 0, 0, 0, 0, &bbNullObject);
			return;
		case SDL_KEYDOWN:
			i = 0;
			// some keys are not raised as text input events..
			// so we will push them ourselves.
			switch (event->key.keysym.sym) {
				case SDLK_BACKSPACE:
					i = 0x08;
					break;
				case SDLK_DELETE:
					i = 0x7f;
					break;
				case SDLK_RETURN:
				case SDLK_RETURN2:
				case SDLK_KP_ENTER:
					i = 0x0d;
					break;
				case SDLK_ESCAPE:
					i = 0x1b;
					break;
			}
			// intentional fall-through...
		case SDL_KEYUP:
			data = mapkey(event->key.keysym.sym);
			mods = mapmods(event->key.keysym.mod);

			// only generate for keys we support
			if (data || i) {
				if (event->key.repeat) {
					bbSDLSystemEmitEvent( BBEVENT_KEYREPEAT,source,data,mods,0,0,&bbNullObject );
					if (i) {
						bbSDLSystemEmitEvent( BBEVENT_KEYCHAR,source,i,0,0,0,&bbNullObject );
					}
					return;
				}
				bbSDLSystemEmitEvent( (event->type == SDL_KEYDOWN) ? BBEVENT_KEYDOWN : BBEVENT_KEYUP,source,data,mods,0,0,&bbNullObject );
				if (i) {
					bbSDLSystemEmitEvent( BBEVENT_KEYCHAR,source,i,0,0,0,&bbNullObject );
				}
			}
			return;
			break;
		case SDL_TEXTINPUT:
			{
				BBString * s = bbStringFromUTF8String(event->text.text);
				while (i < s->length) {
					bbSDLSystemEmitEvent( BBEVENT_KEYCHAR,source,s->buf[i],0,0,0,&bbNullObject );
					i++;
				}
				return;
			}
		case SDL_MOUSEMOTION:
			bbSDLSystemEmitEvent( BBEVENT_MOUSEMOVE,source,0,0,event->motion.x,event->motion.y,&bbNullObject );
			return;
		case SDL_MOUSEBUTTONDOWN:
		case SDL_MOUSEBUTTONUP:
			bbSDLSystemEmitEvent( (event->type == SDL_MOUSEBUTTONDOWN) ? BBEVENT_MOUSEDOWN : BBEVENT_MOUSEUP,source,mouse_button_map[event->button.button],0,event->button.x,event->button.y,&bbNullObject );
			return;
		case SDL_MOUSEWHEEL:
			bbSDLSystemEmitEvent( BBEVENT_MOUSEWHEEL,source,(event->wheel.y < 0) ? -1 : 1,0,0,0,&bbNullObject );
			return;
		case SDL_USEREVENT:
			switch (event->user.code) {
				case BBEVENT_TIMERTICK:
					bbSDLSystemEmitEvent( BBEVENT_TIMERTICK,event->user.data1,((int*)event->user.data2)[0],0,0,0,&bbNullObject );
					return;
				case 0x802:
					brl_event_EmitEvent( event->user.data1 );
					return;
			}
		case SDL_FINGERMOTION:
			{
				SDL_DisplayMode mode;
				SDL_GetWindowDisplayMode(SDL_GL_GetCurrentWindow(), &mode);
				bbSDLSystemEmitEvent( BBEVENT_TOUCHMOVE, source, event->tfinger.fingerId, 0, event->tfinger.x * mode.w, event->tfinger.y * mode.h, &bbNullObject);
				return;
			}
		case SDL_FINGERDOWN:
		case SDL_FINGERUP:
			{
				SDL_DisplayMode mode;
				SDL_GetWindowDisplayMode(SDL_GL_GetCurrentWindow(), &mode);
				bbSDLSystemEmitEvent( (event->type == SDL_FINGERDOWN) ? BBEVENT_TOUCHDOWN : BBEVENT_TOUCHUP, source, event->tfinger.fingerId, 0, event->tfinger.x * mode.w, event->tfinger.y * mode.h, &bbNullObject );
				return;
			}
		case SDL_MULTIGESTURE:
			{
				SDL_DisplayMode mode;
				SDL_GetWindowDisplayMode(SDL_GL_GetCurrentWindow(), &mode);
				int x = event->mgesture.x * mode.w;
				int y = event->mgesture.y * mode.h;
				BBObject * gesture = sdl_sdlsystem_TSDLMultiGesture__getGesture(event->mgesture.touchId, x, y, event->mgesture.dTheta, event->mgesture.dDist, event->mgesture.numFingers);
				bbSDLSystemEmitEvent(BBEVENT_MULTIGESTURE, source, event->mgesture.touchId, 0, x, y, gesture);
				sdl_sdlsystem_TSDLMultiGesture__freeGesture(gesture);
				return;
			}
		case SDL_WINDOWEVENT:
			switch (event->window.event) {
				case SDL_WINDOWEVENT_FOCUS_GAINED:
					bbSDLSystemEmitEvent(BBEVENT_APPRESUME, source, 0, 0, 0, 0, &bbNullObject);
					return;
				case SDL_WINDOWEVENT_FOCUS_LOST:
					bbSDLSystemEmitEvent(BBEVENT_APPSUSPEND, source, 0, 0, 0, 0, &bbNullObject);
					return;
				case SDL_WINDOWEVENT_RESIZED:
					bbSDLSystemEmitEvent(BBEVENT_WINDOWSIZE, source, event->window.windowID, 0, event->window.data1, event->window.data2, &bbNullObject);
					return;
				case SDL_WINDOWEVENT_MOVED:
					bbSDLSystemEmitEvent(BBEVENT_WINDOWMOVE, source, event->window.windowID, 0, event->window.data1, event->window.data2, &bbNullObject);
					return;
				case SDL_WINDOWEVENT_ENTER:
					bbSDLSystemEmitEvent(BBEVENT_MOUSEENTER, source, event->window.windowID, 0, 0, 0, &bbNullObject);
					return;
				case SDL_WINDOWEVENT_LEAVE:
					bbSDLSystemEmitEvent(BBEVENT_MOUSELEAVE, source, event->window.windowID, 0, 0, 0, &bbNullObject);
					return;
				case SDL_WINDOWEVENT_MINIMIZED:
					bbSDLSystemEmitEvent(BBEVENT_WINDOWMINIMIZE, source, event->window.windowID, 0, 0, 0, &bbNullObject);
					return;
				case SDL_WINDOWEVENT_MAXIMIZED:
					bbSDLSystemEmitEvent(BBEVENT_WINDOWMAXIMIZE, source, event->window.windowID, 0, 0, 0, &bbNullObject);
					return;
				case SDL_WINDOWEVENT_RESTORED:
					bbSDLSystemEmitEvent(BBEVENT_WINDOWRESTORE, source, event->window.windowID, 0, 0, 0, &bbNullObject);
					return;
				
			}
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


int mapkey(SDL_Keycode keycode) {
	switch(keycode) {
		case SDLK_BACKSPACE:
			return KEY_BACKSPACE;
		case SDLK_TAB:
			return KEY_TAB;
		case SDLK_RETURN:
			return KEY_ENTER;
		case SDLK_ESCAPE:
			return KEY_ESC;
		case SDLK_SPACE:
			return KEY_SPACE;
		case SDLK_PAGEUP:
			return KEY_PAGEUP;
		case SDLK_PAGEDOWN:
			return KEY_PAGEDOWN;
		case SDLK_END:
			return KEY_END;
		case SDLK_HOME:
			return KEY_HOME;
		case SDLK_LEFT:
			return KEY_LEFT;
		case SDLK_UP:
			return KEY_UP;
		case SDLK_RIGHT:
			return KEY_RIGHT;
		case SDLK_DOWN:
			return KEY_DOWN;
		case SDLK_INSERT:
			return KEY_INSERT;
		case SDLK_DELETE:
			return KEY_DELETE;
		case SDLK_0:
			return KEY_0;
		case SDLK_1:
			return KEY_1;
		case SDLK_2:
			return KEY_2;
		case SDLK_3:
			return KEY_3;
		case SDLK_4:
			return KEY_4;
		case SDLK_5:
			return KEY_5;
		case SDLK_6:
			return KEY_6;
		case SDLK_7:
			return KEY_7;
		case SDLK_8:
			return KEY_8;
		case SDLK_9:
			return KEY_9;
		case SDLK_a:
			return KEY_A;
		case SDLK_b:
			return KEY_B;
		case SDLK_c:
			return KEY_C;
		case SDLK_d:
			return KEY_D;
		case SDLK_e:
			return KEY_E;
		case SDLK_f:
			return KEY_F;
		case SDLK_g:
			return KEY_G;
		case SDLK_h:
			return KEY_H;
		case SDLK_i:
			return KEY_I;
		case SDLK_j:
			return KEY_J;
		case SDLK_k:
			return KEY_K;
		case SDLK_l:
			return KEY_L;
		case SDLK_m:
			return KEY_M;
		case SDLK_n:
			return KEY_N;
		case SDLK_o:
			return KEY_O;
		case SDLK_p:
			return KEY_P;
		case SDLK_q:
			return KEY_Q;
		case SDLK_r:
			return KEY_R;
		case SDLK_s:
			return KEY_S;
		case SDLK_t:
			return KEY_T;
		case SDLK_u:
			return KEY_U;
		case SDLK_v:
			return KEY_V;
		case SDLK_w:
			return KEY_W;
		case SDLK_x:
			return KEY_X;
		case SDLK_y:
			return KEY_Y;
		case SDLK_z:
			return KEY_Z;
		case SDLK_LGUI:
			return KEY_LSYS;
		case SDLK_RGUI:
			return KEY_RSYS;
		case SDLK_KP_0:
			return KEY_NUM0;
		case SDLK_KP_1:
			return KEY_NUM1;
		case SDLK_KP_2:
			return KEY_NUM2;
		case SDLK_KP_3:
			return KEY_NUM3;
		case SDLK_KP_4:
			return KEY_NUM4;
		case SDLK_KP_5:
			return KEY_NUM5;
		case SDLK_KP_6:
			return KEY_NUM6;
		case SDLK_KP_7:
			return KEY_NUM7;
		case SDLK_KP_8:
			return KEY_NUM8;
		case SDLK_KP_9:
			return KEY_NUM9;
		case SDLK_KP_MULTIPLY:
			return KEY_NUMMULTIPLY;
		case SDLK_KP_PLUS:
			return KEY_NUMADD;
		case SDLK_KP_EQUALS:
			return KEY_NUMSLASH;
		case SDLK_KP_MINUS:
			return KEY_NUMSUBTRACT;
		case SDLK_KP_PERIOD:
			return KEY_NUMDECIMAL;
		case SDLK_KP_DIVIDE:
			return KEY_NUMDIVIDE;
		case SDLK_F1:
			return KEY_F1;
		case SDLK_F2:
			return KEY_F2;
		case SDLK_F3:
			return KEY_F3;
		case SDLK_F4:
			return KEY_F4;
		case SDLK_F5:
			return KEY_F5;
		case SDLK_F6:
			return KEY_F6;
		case SDLK_F7:
			return KEY_F7;
		case SDLK_F8:
			return KEY_F8;
		case SDLK_F9:
			return KEY_F9;
		case SDLK_F10:
			return KEY_F10;
		case SDLK_F11:
			return KEY_F11;
		case SDLK_F12:
			return KEY_F12;
		case SDLK_LSHIFT:
			return KEY_LSHIFT;
		case SDLK_RSHIFT:
			return KEY_RSHIFT;
		case SDLK_LCTRL:
			return KEY_LCONTROL;
		case SDLK_RCTRL:
			return KEY_RCONTROL;
		case SDLK_LALT:
			return KEY_LALT;
		case SDLK_RALT:
			return KEY_RALT;
		case SDLK_AC_BACK:
			return KEY_BROWSER_BACK;
		case SDLK_AC_FORWARD:
			return KEY_BROWSER_FORWARD;
		case SDLK_AC_HOME:
			return KEY_BROWSER_HOME;
		case SDLK_AC_REFRESH:
			return KEY_BROWSER_REFRESH;
		case SDLK_AC_SEARCH:
			return KEY_BROWSER_SEARCH;
		case SDLK_AC_STOP:
			return KEY_BROWSER_STOP;
		case SDLK_BACKQUOTE:
			return KEY_TILDE;
		case SDLK_MINUS:
			return KEY_MINUS;
		case SDLK_EQUALS:
			return KEY_EQUALS;
		case SDLK_LEFTBRACKET:
			return KEY_OPENBRACKET;
		case SDLK_RIGHTBRACKET:
			return KEY_CLOSEBRACKET;
		case SDLK_BACKSLASH:
			return KEY_BACKSLASH;
		case SDLK_SEMICOLON:
			return KEY_SEMICOLON;
		case SDLK_QUOTE:
			return KEY_QUOTES;
		case SDLK_COMMA:
			return KEY_COMMA;
		case SDLK_PERIOD:
			return KEY_PERIOD;
		case SDLK_SLASH:
			return KEY_SLASH;
	}

	// we don't have a mapping
	return 0;
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


int bmx_SDL_ShowSimpleMessageBox(BBString * text, BBString * appTitle, int serious) {
	int flags = (serious) ? SDL_MESSAGEBOX_WARNING : SDL_MESSAGEBOX_INFORMATION;
	char * t = bbStringToUTF8String(appTitle);
	char * s = bbStringToUTF8String(text);
	int ret = SDL_ShowSimpleMessageBox(flags, t, s, NULL);
	bbMemFree(s);
	bbMemFree(t);
	return ret;
}

int bmx_SDL_ShowMessageBox_confirm(BBString * text, BBString * appTitle, int serious) {

	char * t = bbStringToUTF8String(appTitle);
	char * s = bbStringToUTF8String(text);

	SDL_MessageBoxButtonData buttons[] = {
		{ SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT, 0, "no" },
		{ SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT, 1, "yes" }
	};
	
	SDL_MessageBoxData messageboxdata = {
        (serious) ? SDL_MESSAGEBOX_WARNING : SDL_MESSAGEBOX_INFORMATION,
        NULL, t, s, SDL_arraysize(buttons), buttons, NULL
    };

	bbMemFree(s);
	bbMemFree(t);

	int buttonid;
	SDL_ShowMessageBox(&messageboxdata, &buttonid);
	if (buttonid == 1) {
		return 1;
	} else {
		return 0;
	}
}

int bmx_SDL_ShowMessageBox_proceed(BBString * text, BBString * appTitle, int serious) {

	char * t = bbStringToUTF8String(appTitle);
	char * s = bbStringToUTF8String(text);

	SDL_MessageBoxButtonData buttons[] = {
		{                                       0, 0, "no" },
		{ SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT, 1, "yes" },
		{ SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT, 2, "cancel" }
	};
	
	SDL_MessageBoxData messageboxdata = {
        (serious) ? SDL_MESSAGEBOX_WARNING : SDL_MESSAGEBOX_INFORMATION,
        NULL, t, s, SDL_arraysize(buttons), buttons, NULL
    };

	bbMemFree(s);
	bbMemFree(t);

	int buttonid;
	SDL_ShowMessageBox(&messageboxdata, &buttonid);
	switch (buttonid) {
		case 0: return 0;
		case 1: return 1;
	}
	return -1;
}

int bmx_SDL_EventFilter(void * userdata, SDL_Event * event) {
	switch (event->type) {
		case SDL_APP_TERMINATING:
		case SDL_APP_LOWMEMORY:
		case SDL_APP_WILLENTERBACKGROUND:
		case SDL_APP_DIDENTERBACKGROUND:
		case SDL_APP_WILLENTERFOREGROUND:
		case SDL_APP_DIDENTERFOREGROUND:
			return sdl_sdlsystem_TSDLSystemDriver__eventFilter(userdata, event->type);
	}
	return 1;
}

void bmx_SDL_SetEventFilter(BBObject * obj) {
	SDL_SetEventFilter(bmx_SDL_EventFilter, obj);
}

