/*
 Copyright (c) 2014-2026 Bruce A Henderson

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
#include "brl.mod/blitz.mod/blitz.h"
#include "SDL.h"
#include "SDL_events.h"
#import <AppKit/AppKit.h>

typedef NSApplicationTerminateReply (*BBAppShouldTerminateHook)(NSApplication *app);
typedef int (*BBAppOpenFileHook)(NSApplication *app, BBString *path);

void bbRegisterAppShouldTerminateHook(BBAppShouldTerminateHook hook);
void bbRegisterAppOpenFileHook(BBAppOpenFileHook hook);

NSApplicationTerminateReply bmx_SDL_Callback_applicationShouldTerminate(NSApplication *app) {
    if (SDL_GetEventState(SDL_QUIT) == SDL_ENABLE) {
        SDL_Event event;
        event.type = SDL_QUIT;
        SDL_PushEvent(&event);
    }
    return NSTerminateCancel;
}

int bmx_SDL_Callback_applicationOpenFile(NSApplication *app, BBString *path) {
    if (SDL_GetEventState(SDL_DROPFILE) == SDL_ENABLE) {
        SDL_Event event;
        event.type = SDL_DROPFILE;
        char * p = bbStringToUTF8String(path);
        event.drop.file = SDL_strdup(p);
        bbMemFree(p);
        return (SDL_PushEvent(&event) > 0);
    }
    return 0;
}

void bmx_SDL_RegisterCallbacks()
{
    bbRegisterAppShouldTerminateHook(bmx_SDL_Callback_applicationShouldTerminate);
    bbRegisterAppOpenFileHook(bmx_SDL_Callback_applicationOpenFile);
}
