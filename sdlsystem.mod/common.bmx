' Copyright (c) 2014-2020 Bruce A Henderson
'
' This software is provided 'as-is', without any express or implied
' warranty. In no event will the authors be held liable for any damages
' arising from the use of this software.
'
' Permission is granted to anyone to use this software for any purpose,
' including commercial applications, and to alter it and redistribute it
' freely, subject to the following restrictions:
'
'    1. The origin of this software must not be misrepresented; you must not
'    claim that you wrote the original software. If you use this software
'    in a product, an acknowledgment in the product documentation would be
'    appreciated but is not required.
'
'    2. Altered source versions must be plainly marked as such, and must not be
'    misrepresented as being the original software.
'
'    3. This notice may not be removed or altered from any source
'    distribution.
'
SuperStrict

?win32x86
Import "../../sdl.mod/sdl.mod/include/win32x86/*.h"

?win32x64
Import "../../sdl.mod/sdl.mod/include/win32x64/*.h"

?osx
Import "../../sdl.mod/sdl.mod/include/macos/*.h"

?linuxx86
Import "../../sdl.mod/sdl.mod/include/linuxx86/*.h"

?linuxx64
Import "../../sdl.mod/sdl.mod/include/linuxx64/*.h"

?raspberrypi
Import "../../sdl.mod/sdl.mod/include/raspberrypi/*.h"

?android
Import "../../sdl.mod/sdl.mod/include/android/*.h"
?

?emscripten
Import "../../sdl.mod/sdl.mod/include/emscripten/*.h"

?ios
Import "../../sdl.mod/sdl.mod/include/ios/*.h"

?haikux64
Import "../../sdl.mod/sdl.mod/include/haikux64/*.h"

?

Import "../../sdl.mod/sdl.mod/SDL/include/*.h"


Import "glue.c"

Extern

	
	
	' system stuff
	Function SDL_ShowCursor:Int(visible:Int)
	
	' text input
	Function SDL_StartTextInput()
	Function SDL_StopTextInput()
	Function SDL_IsTextInputActive:Int()
	
	Function bmx_SDL_GetDisplayWidth:Int(display:Int)
	Function bmx_SDL_GetDisplayHeight:Int(display:Int)
	Function bmx_SDL_GetDisplayDepth:Int(display:Int)
	Function bmx_SDL_GetDisplayhertz:Int(display:Int)

	Function bmx_SDL_Poll()
	Function bmx_SDL_WaitEvent()

	Function MouseState:Int(x:Int Ptr, y:Int Ptr)="SDL_GetMouseState"
	
	Function bmx_SDL_ShowSimpleMessageBox:Int(Text:String, _appTitle:String, serious:Int)
	Function bmx_SDL_ShowMessageBox_confirm:Int(Text:String, _appTitle:String, serious:Int)
	Function bmx_SDL_ShowMessageBox_proceed:Int(Text:String, _appTitle:String, serious:Int)

	Function bmx_SDL_SetEventFilter(driver:Object)
	
End Extern

