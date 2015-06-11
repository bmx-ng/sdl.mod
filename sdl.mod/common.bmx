' Copyright (c) 2014 Bruce A Henderson
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

Import BRL.Stream

?android
Import "source.bmx"
?emscripten
Import "source.bmx"
?raspberrypi
Import "-lrt"
?

Extern

	Function SDL_Init:Int(flags:Int)
	Function SDL_InitSubSystem:Int(flags:Int)
	Function SDL_QuitSubSystem(flags:Int)
	Function SDL_WasInit:Int(flags:Int)
	Function SDL_Quit()

	Function SDL_GetError:String()="bmx_SDL_GetError"

	Function bmx_SDL_AllocRW_stream:Byte Ptr(stream:TStream)
	
	Function SDL_CreateMutex:Byte Ptr()
	Function SDL_LockMutex(mutex:Byte Ptr)
	Function SDL_UnlockMutex(mutex:Byte Ptr)
	
	Function SDL_GetPlatform:String()="bmx_SDL_GetPlatform"
	
	Function SDL_GetCPUCacheLineSize:Int()
	Function SDL_GetCPUCount:Int()
	Function SDL_GetSystemRAM:Int()
	Function SDL_HasAVX:Int()
	Function SDL_HasAVX2:Int()
	Function SDL_HasAltiVec:Int()
	Function SDL_HasMMX:Int()
	Function SDL_HasRDTSC:Int()
	Function SDL_HasSSE:Int()
	Function SDL_HasSSE2:Int()
	Function SDL_HasSSE3:Int()
	Function SDL_HasSSE41:Int()
	Function SDL_HasSSE42:Int()

	Function SDL_RWFromFile:Byte Ptr(file:Byte Ptr, _mode$z)
	Function bmx_SDL_RWtell:Long(handle:Byte Ptr)
	Function bmx_SDL_RWsize:Long(handle:Byte Ptr)
	Function bmx_SDL_RWseek:Long(handle:Byte Ptr, offset:Long, whence:Int)
	Function bmx_SDL_RWread:Long(handle:Byte Ptr, buffer:Byte Ptr, size:Long, num:Long)
	Function bmx_SDL_RWwrite:Long(handle:Byte Ptr, buffer:Byte Ptr, size:Long, num:Long)
	Function bmx_SDL_RWclose:Int(handle:Byte Ptr)
	
End Extern


Const SDL_INIT_TIMER:Int = $00000001
Const SDL_INIT_AUDIO:Int = $00000010
Const SDL_INIT_VIDEO:Int = $00000020  ' SDL_INIT_VIDEO implies SDL_INIT_EVENTS
Const SDL_INIT_JOYSTICK:Int = $00000200  ' SDL_INIT_JOYSTICK implies SDL_INIT_EVENTS
Const SDL_INIT_HAPTIC:Int = $00001000
Const SDL_INIT_GAMECONTROLLER:Int = $00002000  ' SDL_INIT_GAMECONTROLLER implies SDL_INIT_JOYSTICK
Const SDL_INIT_EVENTS:Int = $00004000
Const SDL_INIT_NOPARACHUTE:Int = $00100000  ' Don't catch fatal signals
Const SDL_INIT_EVERYTHING:Int = SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | ..
	SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER
	
