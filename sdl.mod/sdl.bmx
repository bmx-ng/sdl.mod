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

Rem
bbdoc: SDL Core
End Rem
Module SDL.SDL

ModuleInfo "Version: 1.00"
ModuleInfo "License: zlib/libpng"

ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release."

?win32x86
ModuleInfo "CC_OPTS: -mmmx -msse -msse2"

Import "include/win32x86/*.h"
Import "-lsetupapi"

?win32x64
ModuleInfo "CC_OPTS: -mmmx -msse -msse2"

Import "include/win32x64/*.h"
Import "-lsetupapi"

?osx
ModuleInfo "CC_OPTS: -mmmx -msse -msse2 -DTARGET_API_MAC_CARBON -DTARGET_API_MAC_OSX"

Import "include/macos/*.h"

Import "-framework AudioUnit"
Import "-framework CoreAudio"
Import "-framework IOKit"
Import "-framework CoreVideo"
Import "-framework ForceFeedback"

?linuxx86
ModuleInfo "CC_OPTS: -mmmx -m3dnow -msse -msse2 -DHAVE_LINUX_VERSION_H"
ModuleInfo "CC_OPTS: -I/usr/include/dbus-1.0 -I/usr/lib/i386-linux-gnu/dbus-1.0/include"

Import "include/linuxx86/*.h"
?linuxx64
ModuleInfo "CC_OPTS: -mmmx -m3dnow -msse -msse2 -DHAVE_LINUX_VERSION_H"
ModuleInfo "CC_OPTS: -I/usr/include/dbus-1.0 -I/usr/lib/x86_64-linux-gnu/dbus-1.0/include"
ModuleInfo "CC_OPTS: -I/usr/lib64/dbus-1.0/include"

Import "include/linuxx64/*.h"
?raspberrypi
ModuleInfo "LD_OPTS: -L%PWD%/lib/raspberrypi"
ModuleInfo "CC_OPTS: -I/usr/include/dbus-1.0 -I/usr/lib/arm-linux-gnueabihf/dbus-1.0/include/"

Import "include/raspberrypi/*.h"
?android
ModuleInfo "CC_OPTS: -DGL_GLEXT_PROTOTYPES"

Import "include/android/*.h"
?emscripten
ModuleInfo "CC_OPTS: -DUSING_GENERATED_CONFIG_H"

Import "include/emscripten/*.h"
?ios
ModuleInfo "CC_OPTS: -fobjc-arc"

Import "include/ios/*.h"

?nx
ModuleInfo "LD_OPTS: -L%nx.devkitpro%/portlibs/switch/lib"
?haikux64
ModuleInfo "CC_OPTS: -mmmx -m3dnow -msse -msse2 -msse3"

Import "include/haikux64/*.h"
?win32
'
' Note : If you have XINPUT errors during the build, try uncommenting the following CC_OPTS.
'        Some versions of MinGW have it, some don't...
'
'ModuleInfo "CC_OPTS: -DHAVE_XINPUT_GAMEPAD_EX -DHAVE_XINPUT_STATE_EX"
'
' Source changes : 
'       SDL/src/thread/SDL_thread.c
'          Added thread register/unregister.
'
'
Import "-limm32"
Import "-lole32"
Import "-loleaut32"
Import "-lshell32"
Import "-lversion"

?linux
Import "-ldl"
?nx
Import "-lSDL2"
?

Import "SDL/include/*.h"

Import "common.bmx"

Import "glue.c"

Rem
bbdoc: An SDL-based data stream type.
about: #TSDLStream extends #TStream to provide methods for reading and writing various types of values
to and from an SDL-based Read/Write stream.
End Rem
Type TSDLStream Extends TStream

	Field filePtr:Byte Ptr

	Method Pos:Long() Override
		Return bmx_SDL_RWtell(filePtr)
	End Method

	Method Size:Long() Override
		Return bmx_SDL_RWsize(filePtr)
	End Method

	Method Seek:Long( pos:Long, whence:Int = SEEK_SET_ ) Override
		Return bmx_SDL_RWseek(filePtr, pos, whence)
	End Method

	Method Read:Long( buf:Byte Ptr,count:Long ) Override
		Return bmx_SDL_RWread(filePtr, buf, 1, count)
	End Method

	Method Write:Long( buf:Byte Ptr,count:Long ) Override
		Return bmx_SDL_RWwrite(filePtr, buf, 1, count)
	End Method

	Method Close() Override
		If filePtr Then
			bmx_SDL_RWclose(filePtr)
			filePtr = Null
		End If
	End Method

	Method Delete()
		Close()
	End Method

	Function Create:TSDLStream( file:String, readable:Int, writeMode:Int )
		Local stream:TSDLStream=New TSDLStream
		Local Mode:String

		If readable And writeMode = WRITE_MODE_OVERWRITE
			Mode="r+b"
		Else If readable And writeMode = WRITE_MODE_APPEND
			Mode="a+b"
		Else If writeMode = WRITE_MODE_OVERWRITE
			Mode="wb"
		Else If writeMode = WRITE_MODE_APPEND
			Mode="ab"
		Else
			Mode="rb"
		EndIf

		Local f:Byte Ptr = file.ToUTF8String()		
		stream.filePtr = SDL_RWFromFile(f, Mode)
		MemFree(f)
		
		If Not stream.filePtr Then
			Return Null
		End If
		
		Return stream
	End Function

End Type

Rem
bbdoc: Opens an SDL stream for reading/writing.
returns: A stream object.
End Rem
Function OpenSDLStream:TSDLStream( file:String, readable:Int, writeMode:Int )
	Return TSDLStream.Create( file, readable, writeMode )
End Function

Type TSDLStreamFactory Extends TStreamFactory

	Method CreateStream:TStream( url:Object, proto$, path$, readable:Int, writeMode:Int ) Override
		If proto="sdl" Then
			Return TSDLStream.Create( path, readable, writeMode )
		End If
	End Method
	
End Type

New TSDLStreamFactory

Function _sdl_rwops_seek:Int(stream:TStream, pos:Long, whence:Int)
	Return stream.seek(pos, whence)
End Function

Function _sdl_rwops_read:Long(stream:TStream, buf:Byte Ptr, count:Long)
	Return stream.Read(buf, count)
End Function

Function _sdl_rwops_write:Long(stream:TStream, buf:Byte Ptr, count:Long)
	Return stream.write(buf, count)
End Function

Function _sdl_rwops_close(stream:TStream)
	stream.close()
End Function

Rem
bbdoc: Get the directory where the application was run from.
about: This is where the application data directory is.
This is not necessarily a fast call, though, so you should call this once near startup and save the string if you need it.<br/>
Mac OS X and iOS Specific Functionality: If the application is in a ".app" bundle, this function returns the Resource directory
(e.g. MyApp.app/Contents/Resources/). This behaviour can be overridden by adding a property to the Info.plist file. Adding a string key with
the name #SDL_FILESYSTEM_BASE_DIR_TYPE with a supported value will change the behaviour.
End Rem
Function SDLGetBasePath:String()
	Return bmx_SDL_GetBasePath()
End Function

Rem
bbdoc: Returns the preferences dir.
about: This is meant to be where the application can write personal files (Preferences and save games, etc.) that are specific to the application.
This directory is unique per user and per application. The path will be Null if there is a problem (creating directory failed, etc.)<br/>
The return path will be guaranteed to end with a path separator ('\' on Windows, '/' on most other platforms).
You should assume the path returned by this function is the only safe place to write files (and that GetBasePath(), while it might be writable, or even
the parent of the returned path, aren't where you should be writing things).<br/>
Both the org and app strings may become part of a directory name, so please follow these rules:<br/>
* Try to use the same org string (including case-sensitivity) for all your applications that use this function.<br/>
* Always use a unique app string for each one, and make sure it never changes for an app once you've decided on it.<br/>
* Only use letters, numbers, and spaces. Avoid punctuation like "Game Name 2: Bad Guy's Revenge!" ... "Game Name 2" is sufficient.
End Rem
Function SDLGetPrefPath:String(org:String, app:String)
	Return bmx_SDL_GetPrefPath(org, app)
End Function
?android
Rem
bbdoc: Gets the path used for external storage for this application.
returns: The path used for external storage for this application on success or NULL on failure; call #SDLGetError() for more information.
about: This path is unique to your application, but is public and can be written to by other applications.
Your external storage path is typically: /storage/sdcard0/Android/data/your.app.package/files.
End Rem
Function SDLAndroidGetExternalStoragePath:String()
	Return String.FromUTF8String(SDL_AndroidGetExternalStoragePath())
End Function

Rem
bbdoc: Gets the current state of external storage.
about: The current state of external storage, a bitmask of these values: #SDL_ANDROID_EXTERNAL_STORAGE_READ, #SDL_ANDROID_EXTERNAL_STORAGE_WRITE.
If external storage is currently unavailable, this will return 0.
End Rem
Function SDLAndroidGetExternalStorageState:Int()
	Return SDL_AndroidGetExternalStorageState()
End Function

Rem
bbdoc: Gets the path used for internal storage for this application.
returns: The path used for internal storage or NULL on failure; call #SDLGetError() for more information.
about: This path is unique to your application and cannot be written to by other applications.
Your internal storage path is typically: /data/data/your.app.package/files.
End Rem
Function SDLAndroidGetInternalStoragePath:String()
	Return String.FromUTF8String(SDL_AndroidGetInternalStoragePath())
End Function
?
Rem
bbdoc: Return a flag indicating whether the clipboard exists and contains a text string that is non-empty.
End Rem
Function SDLHasClipboardText:Int()
	Return SDL_HasClipboardText()
End Function

Rem
bbdoc: Returns the clipboard text.
End Rem
Function SDLGetClipboardText:String()
	Return bmx_SDL_GetClipboardText()
End Function

Rem
bbdoc: Puts text into the clipboard.
returns: 0 on success or a negative error code on failure.
End Rem
Function SDLSetClipboardText:Int(Text:String)
	Return SDL_SetClipboardText(Text.ToUTF8String())
End Function

Rem
bbdoc: Logs a message with #SDL_LOG_CATEGORY_APPLICATION and #SDL_LOG_PRIORITY_INFO.
End Rem
Function SDLLogAppInfo(Text:String)
	Local s:Byte Ptr = Text.ToUTF8String()
	SDL_Log(s)
	MemFree s
End Function

Rem
bbdoc: Logs a message with #SDL_LOG_PRIORITY_DEBUG.
End Rem
Function SDLLogDebug(category:Int, Text:String)
	Local s:Byte Ptr = Text.ToUTF8String()
	SDL_LogDebug(category, s)
	MemFree s
End Function

Rem
bbdoc: Logs a message with #SDL_LOG_PRIORITY_ERROR.
End Rem
Function SDLLogError(category:Int, Text:String)
	Local s:Byte Ptr = Text.ToUTF8String()
	SDL_LogError(category, s)
	MemFree s
End Function

Rem
bbdoc: Logs a message with #SDL_LOG_PRIORITY_CRITICAL.
End Rem
Function SDLLogCritical(category:Int, Text:String)
	Local s:Byte Ptr = Text.ToUTF8String()
	SDL_LogCritical(category, s)
	MemFree s
End Function

Rem
bbdoc: Logs a message with #SDL_LOG_PRIORITY_INFO.
End Rem
Function SDLLogInfo(category:Int, Text:String)
	Local s:Byte Ptr = Text.ToUTF8String()
	SDL_LogInfo(category, s)
	MemFree s
End Function

Rem
bbdoc: Logs a message with #SDL_LOG_PRIORITY_VERBOSE.
End Rem
Function SDLLogVerbose(category:Int, Text:String)
	Local s:Byte Ptr = Text.ToUTF8String()
	SDL_LogVerbose(category, s)
	MemFree s
End Function

Rem
bbdoc: Logs a message with #SDL_LOG_PRIORITY_WARN.
End Rem
Function SDLLogWarn(category:Int, Text:String)
	Local s:Byte Ptr = Text.ToUTF8String()
	SDL_LogWarn(category, s)
	MemFree s
End Function

Rem
bbdoc: Sets the priority of all log categories.
about: If you are debugging SDL, you might want to call this with #SDL_LOG_PRIORITY_WARN.
End Rem
Function SDLLogSetAllPriority(priority:Int)
	SDL_LogSetAllPriority(priority)
End Function

Rem
bbdoc: Gets the current power supply details.
returns: One of #SDL_POWERSTATE_UNKNOWN, #SDL_POWERSTATE_ON_BATTERY, #SDL_POWERSTATE_NO_BATTERY, #SDL_POWERSTATE_CHARGING, or #SDL_POWERSTATE_CHARGED.
about: You should never take a battery status as absolute truth. Batteries (especially failing batteries) are delicate hardware,
and the values reported here are best estimates based on what that hardware reports. It's not uncommon for older batteries to lose
stored power much faster than it reports, or completely drain when reporting it has 20 percent left, etc.
Battery status can change at any time; if you are concerned with power state, you should call this function frequently,
and perhaps ignore changes until they seem to be stable for a few seconds.
End Rem
Function SDLGetPowerInfo:Int(seconds:Int Var, percent:Int Var)
	Return SDL_GetPowerInfo(Varptr seconds, Varptr percent)
End Function

Rem
bbdoc: Gets the human readable name of a pixel format
End Rem
Function SDLGetPixelFormatName:String(format:UInt)
	Return String.FromUTF8String(SDL_GetPixelFormatName(format))
End Function

Rem
bbdoc: Gets the number of milliseconds since the SDL library initialization.
returns: A value representing the number of milliseconds since the SDL library initialized.
about: This value wraps if the program runs for more than ~49 days.
End Rem
Function SDLGetTicks:UInt()
	Return SDL_GetTicks()
End Function

Rem
bbdoc: Retrieves a message about the last error that occurred.
returns: A message with information about the specific error that occurred, or an empty string if there hasn't been an error message set since the last call to #SDLClearError(). The message is only applicable when an SDL function has signaled an error. You must check the return values of SDL function calls to determine when to appropriately call #SDLGetError().
End Rem
Function SDLGetError:String()
	Return bmx_SDL_GetError()
End Function

Rem
bbdoc: Clears any previous error message.
End Rem
Function SDLClearError()
	SDL_ClearError()
End Function

Rem
bbdoc: (re)Initialises the audio subsystem.
End Rem
Function SDLAudioInit:Int(name:String)
	Return bmx_SDL_AudioInit(name)
End Function

Rem
bbdoc: Returns the total number of logical CPU cores.
about: On CPUs that include technologies such as hyperthreading, the number of logical cores may be more than the number of physical cores.
End Rem
Function SDLGetCPUCount:Int()
	Return SDL_GetCPUCount()
End Function

' shutdown all the subsystems
atexit_(SDL_Quit)
