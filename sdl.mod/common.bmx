' Copyright (c) 2014-2015 Bruce A Henderson
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
?ios
Import "source.bmx"
?osx
Import "source.bmx"
?linux
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
	
	Function bmx_SDL_GetBasePath:String()
	Function bmx_SDL_GetPrefPath:String(org:String, app:String)
?android
	Function SDL_AndroidGetExternalStoragePath:Byte Ptr()
	Function SDL_AndroidGetExternalStorageState:Int()
	Function SDL_AndroidGetInternalStoragePath:Byte Ptr()
?
	Function SDL_HasClipboardText:Int()
	Function bmx_SDL_GetClipboardText:String()
	Function SDL_SetClipboardText:Int(Text:Byte Ptr)
	
	Function SDL_Log(txt:Byte Ptr)
	Function SDL_LogCritical(category:Int, txt:Byte Ptr)
	Function SDL_LogInfo(category:Int, txt:Byte Ptr)
	Function SDL_LogDebug(category:Int, txt:Byte Ptr)
	Function SDL_LogError(category:Int, txt:Byte Ptr)
	Function SDL_LogMessage(category:Int, priority:Int, txt:Byte Ptr)
	Function SDL_LogVerbose(category:Int, txt:Byte Ptr)
	Function SDL_LogWarn(category:Int, txt:Byte Ptr)
	Function SDL_LogSetAllPriority(priority:Int)
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
	
Rem
bbdoc: The application is being terminated by the OS.
about: Called on iOS in applicationWillTerminate().
       Called on Android in onDestroy()
End Rem
Const SDL_APP_TERMINATING:Int         = $101
Rem
bbdoc: The application is low on memory, free memory if possible.
about: Called on iOS in applicationDidReceiveMemoryWarning().
       Called on Android in onLowMemory()
End Rem
Const SDL_APP_LOWMEMORY:Int           = $102
Rem
bbdoc: The application is about to enter the background.
about: Called on iOS in applicationWillResignActive().
       Called on Android in onPause()
End Rem
Const SDL_APP_WILLENTERBACKGROUND:Int = $103
Rem
bbdoc: The application did enter the background and may not get CPU for some time.
about: Called on iOS in applicationDidEnterBackground().
       Called on Android in onPause()
End Rem
Const SDL_APP_DIDENTERBACKGROUND:Int  = $104
Rem
bbdoc: The application is about to enter the foreground.
about: Called on iOS in applicationWillEnterForeground().
       Called on Android in onResume()
End Rem
Const SDL_APP_WILLENTERFOREGROUND:Int = $105
Rem
bbdoc: The application is now interactive.
about: Called on iOS in applicationDidBecomeActive().
       Called on Android in onResume()
End Rem
Const SDL_APP_DIDENTERFOREGROUND:Int  = $106


Const SDL_ANDROID_EXTERNAL_STORAGE_READ:Int = $01
Const SDL_ANDROID_EXTERNAL_STORAGE_WRITE:Int = $02


Rem
bbdoc: Application log category.
about: Has a default log priority of SDL_LOG_PRIORITY_INFO.
End Rem
Const SDL_LOG_CATEGORY_APPLICATION:Int = 0
Rem
bbdoc: Error log category.
about: Has a default log priority of SDL_LOG_PRIORITY_CRITICAL.
End Rem
Const SDL_LOG_CATEGORY_ERROR:Int = 1
Rem
bbdoc: Assertion log category.
about: Has a default log priority of SDL_LOG_PRIORITY_WARN.
End Rem
Const SDL_LOG_CATEGORY_ASSERT:Int = 2
Rem
bbdoc: System log category.
about: Has a default log priority of SDL_LOG_PRIORITY_CRITICAL.
End Rem
Const SDL_LOG_CATEGORY_SYSTEM:Int = 3
Rem
bbdoc: Audio log category.
about: Has a default log priority of SDL_LOG_PRIORITY_CRITICAL.
End Rem
Const SDL_LOG_CATEGORY_AUDIO:Int = 4
Rem
bbdoc: Video log category.
about: Has a default log priority of SDL_LOG_PRIORITY_CRITICAL.
End Rem
Const SDL_LOG_CATEGORY_VIDEO:Int = 5
Rem
bbdoc: Render log category.
about: Has a default log priority of SDL_LOG_PRIORITY_CRITICAL.
End Rem
Const SDL_LOG_CATEGORY_RENDER:Int = 6
Rem
bbdoc: Input log category.
about: Has a default log priority of SDL_LOG_PRIORITY_CRITICAL.
End Rem
Const SDL_LOG_CATEGORY_INPUT:Int = 7
Rem
bbdoc: Test log category.
about: Has a default log priority of SDL_LOG_PRIORITY_VERBOSE.
End Rem
Const SDL_LOG_CATEGORY_TEST:Int = 8
Rem
bbdoc: Application defined starting category.
about: An application can use subsequent category numbers as required, e.g. SDL_LOG_CATEGORY_CUSTOM + 1, etc.
End Rem
Const SDL_LOG_CATEGORY_CUSTOM:Int = 19

Rem
bbdoc: Verbose log priority.
End Rem
Const SDL_LOG_PRIORITY_VERBOSE:Int = 1
Rem
bbdoc: Debug log priority.
End Rem
Const SDL_LOG_PRIORITY_DEBUG:Int = 2
Rem
bbdoc: Info log priority.
End Rem
Const SDL_LOG_PRIORITY_INFO:Int = 3
Rem
bbdoc: Warn log priority.
End Rem
Const SDL_LOG_PRIORITY_WARN:Int = 4
Rem
bbdoc: Error log priority.
End Rem
Const SDL_LOG_PRIORITY_ERROR:Int = 5
Rem
bbdoc: Critical log priority.
End Rem
Const SDL_LOG_PRIORITY_CRITICAL:Int = 6
