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
bbdoc: SDL FreeAudio Driver
End Rem
Module SDL.SDLFreeAudio

Import SDL.SDL
Import BRL.FreeAudioAudio

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

?ios
Import "../../sdl.mod/sdl.mod/include/ios/*.h"

?haikux64
Import "../../sdl.mod/sdl.mod/include/haikux64/*.h"

?

Import "../../sdl.mod/sdl.mod/SDL/include/*.h"

Import "glue.cpp"


Type TSDLFreeAudioDriver Extends TFreeAudioAudioDriver

	Method Startup:Int() Override
		Local device:Byte Ptr = OpenSDLAudioDevice()
		Local res:Int=-1
		If device Then
			res=fa_Reset(device)
		End If
		Return res <> -1
	End Method

	Function Create:TFreeAudioAudioDriver( name$,Mode:Int ) Override
		Local t:TSDLFreeAudioDriver = New TSDLFreeAudioDriver
		t._name=name
		t._mode=Mode
		Return t
	End Function

End Type

Extern
Function OpenSDLAudioDevice:Byte Ptr()
End Extern

TSDLFreeAudioDriver.Create "FreeAudio SDL", 8

