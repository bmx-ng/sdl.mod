' Copyright (c) 2014-2019 Bruce A Henderson
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
Import "-framework Metal"
?osx
Import "-framework AudioToolbox"
Import "-framework Metal"
Import "source.bmx"
?linux
Import "source.bmx"
?raspberrypi
Import "-lrt"
?win32
Import "source.bmx"
?

Extern

	Function SDL_Init:Int(flags:Int)
	Function SDL_InitSubSystem:Int(flags:Int)
	Function SDL_QuitSubSystem(flags:Int)
	Function SDL_WasInit:Int(flags:Int)
	Function SDL_Quit()
	Function bmx_SDL_AudioInit:Int(name:String)

	Function bmx_SDL_GetError:String()
	Function SDL_ClearError()
	Function SDL_free(handle:Byte Ptr)

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
	
	Function SDL_GetPowerInfo:Int(seconds:Int Ptr, percent:Int Ptr)
	
	Function SDL_GetPixelFormatName:Byte Ptr(format:UInt)
	Function SDL_GetTicks:UInt()
	
End Extern


Const SDL_INIT_TIMER:Int = $00000001
Const SDL_INIT_AUDIO:Int = $00000010
Const SDL_INIT_VIDEO:Int = $00000020  ' SDL_INIT_VIDEO implies SDL_INIT_EVENTS
Const SDL_INIT_JOYSTICK:Int = $00000200  ' SDL_INIT_JOYSTICK implies SDL_INIT_EVENTS
Const SDL_INIT_HAPTIC:Int = $00001000
Const SDL_INIT_GAMECONTROLLER:Int = $00002000  ' SDL_INIT_GAMECONTROLLER implies SDL_INIT_JOYSTICK
Const SDL_INIT_EVENTS:Int = $00004000
Const SDL_INIT_SENSOR:Int = $00008000
Const SDL_INIT_NOPARACHUTE:Int = $00100000  ' Don't catch fatal signals
Const SDL_INIT_EVERYTHING:Int = SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | ..
	SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER | SDL_INIT_SENSOR
	
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

Rem
bbdoc: Cannot determine power status
End Rem
Const SDL_POWERSTATE_UNKNOWN:Int = 0
Rem
bbdoc: Not plugged in, running on the battery
End Rem
Const SDL_POWERSTATE_ON_BATTERY:Int = 1
Rem
bbdoc: Plugged in, no battery available
End Rem
Const SDL_POWERSTATE_NO_BATTERY:Int = 2
Rem
bbdoc: Plugged in, charging battery
End Rem
Const SDL_POWERSTATE_CHARGING:Int = 3
Rem
bbdoc: Plugged in, battery charged
End Rem
Const SDL_POWERSTATE_CHARGED:Int = 4


Const SDL_PIXELFORMAT_UNKNOWN:UInt = $0
Const SDL_PIXELFORMAT_INDEX1LSB:UInt = $11100100
Const SDL_PIXELFORMAT_INDEX1MSB:UInt = $11200100
Const SDL_PIXELFORMAT_INDEX4LSB:UInt = $12100400
Const SDL_PIXELFORMAT_INDEX4MSB:UInt = $12200400
Const SDL_PIXELFORMAT_INDEX8:UInt = $13000801
Const SDL_PIXELFORMAT_RGB332:UInt = $14110801
Const SDL_PIXELFORMAT_RGB444:UInt = $15120C02
Const SDL_PIXELFORMAT_RGB555:UInt = $15130F02
Const SDL_PIXELFORMAT_BGR555:UInt = $15530F02
Const SDL_PIXELFORMAT_ARGB4444:UInt = $15321002
Const SDL_PIXELFORMAT_RGBA4444:UInt = $15421002
Const SDL_PIXELFORMAT_ABGR4444:UInt = $15721002
Const SDL_PIXELFORMAT_BGRA4444:UInt = $15821002
Const SDL_PIXELFORMAT_ARGB1555:UInt = $15331002
Const SDL_PIXELFORMAT_RGBA5551:UInt = $15441002
Const SDL_PIXELFORMAT_ABGR1555:UInt = $15731002
Const SDL_PIXELFORMAT_BGRA5551:UInt = $15841002
Const SDL_PIXELFORMAT_RGB565:UInt = $15151002
Const SDL_PIXELFORMAT_BGR565:UInt = $15551002
Const SDL_PIXELFORMAT_RGB24:UInt = $17101803
Const SDL_PIXELFORMAT_BGR24:UInt = $17401803
Const SDL_PIXELFORMAT_RGB888:UInt = $16161804
Const SDL_PIXELFORMAT_RGBX8888:UInt = $16261804
Const SDL_PIXELFORMAT_BGR888:UInt = $16561804
Const SDL_PIXELFORMAT_BGRX8888:UInt = $16661804
Const SDL_PIXELFORMAT_ARGB8888:UInt = $16362004
Const SDL_PIXELFORMAT_RGBA8888:UInt = $16462004
Const SDL_PIXELFORMAT_ABGR8888:UInt = $16762004
Const SDL_PIXELFORMAT_BGRA8888:UInt = $16862004
Const SDL_PIXELFORMAT_ARGB2101010:UInt = $16372004
Const SDL_PIXELFORMAT_YV12:UInt = $32315659
Const SDL_PIXELFORMAT_IYUV:UInt = $56555949
Const SDL_PIXELFORMAT_YUY2:UInt = $32595559
Const SDL_PIXELFORMAT_UYVY:UInt = $59565955
Const SDL_PIXELFORMAT_YVYU:UInt = $55595659
Const SDL_PIXELFORMAT_NV12:UInt = $3231564E
Const SDL_PIXELFORMAT_NV21:UInt = $3132564E

?bigendian
Const SDL_PIXELFORMAT_RGBA32:UInt = SDL_PIXELFORMAT_RGBA8888
Const SDL_PIXELFORMAT_ARGB32:UInt = SDL_PIXELFORMAT_ARGB8888
Const SDL_PIXELFORMAT_BGRA32:UInt = SDL_PIXELFORMAT_BGRA8888
Const SDL_PIXELFORMAT_ABGR32:UInt = SDL_PIXELFORMAT_ABGR8888
?litteendian
Const SDL_PIXELFORMAT_RGBA32:UInt = SDL_PIXELFORMAT_ABGR8888
Const SDL_PIXELFORMAT_ARGB32:UInt = SDL_PIXELFORMAT_BGRA8888
Const SDL_PIXELFORMAT_BGRA32:UInt = SDL_PIXELFORMAT_ARGB8888
Const SDL_PIXELFORMAT_ABGR32:UInt = SDL_PIXELFORMAT_RGBA8888
?