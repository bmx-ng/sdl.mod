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
bbdoc: SDL Timer
End Rem
Module SDL.SDLTimer

ModuleInfo "Version: 1.01"
ModuleInfo "Author: Simon Armstrong, Mark Sibly, Bruce A Henderson"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: Blitz Research Ltd"
ModuleInfo "Modserver: BRL"

ModuleInfo "History: 1.01"
ModuleInfo "History: Updated to use new factory-based timer."

Import SDL.SDLSystem
Import BRL.Event
Import BRL.Timer

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

?emscripten
Import "../../sdl.mod/sdl.mod/include/emscripten/*.h"

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

Import "glue.c"

Private

Extern
Function bmx_sdl_timer_start:Byte Ptr( hertz#,timer:TTimer )
Function bmx_sdl_timer_stop( handle:Byte Ptr,timer:TTimer )
Function bmx_sdl_timer_fire( id:Int, obj:Object, ticks:Int )
End Extern

Function _TimerFired( timer:TTimer )
	timer.Fire
End Function

Public

Rem
bbdoc: An SDL implementation of a #TTimer.
End Rem
Type TSDLTimer Extends TTimer

	Rem
	bbdoc: Gets timer tick counter.
	returns: The number of times the timer has ticked over
	End Rem
	Method Ticks:Int() Override
		Return _ticks
	End Method
	
	Rem
	bbdoc: Stops the timer
	about: Once stopped, the timer can no longer be used.
	End Rem
	Method Stop() Override
		If Not _handle Return
		bmx_sdl_timer_stop _handle,Self
		_handle=0
		_event=Null
	End Method
	
	Method Fire() Override
		If Not _handle Return
		_ticks:+1
		If _event
			bmx_sdl_timer_fire ($802, _event, 0)
		Else
			bmx_sdl_timer_fire (EVENT_TIMERTICK, Self, _ticks)
		EndIf
	End Method

	Rem
	bbdoc: Waits until the timer ticks.
	returns: The number of ticks since the last call to #Wait.
	End Rem
	Method Wait:Int() Override
		If Not _handle Return 0
		Local n:Int
		Repeat
			WaitSystem
			n=_ticks-_wticks
		Until n
		_wticks:+n
		Return n
	End Method
	
	Function Create:TTimer( hertz#,event:TEvent=Null ) Override
		Local t:TSDLTimer =New TSDLTimer
		Local handle:Byte Ptr=bmx_sdl_timer_start( hertz,t )
		If Not handle Return Null
		t._event=event
		t._handle=handle
		Return t
	End Function

	Field _ticks:Int
	Field _wticks:Int
	Field _event:TEvent
	Field _handle:Byte Ptr

End Type

Type TSDLTimerFactory Extends TTimerFactory
	
	Method GetName:String() Override
		Return "SDLTimer"
	End Method
	
	Method Create:TTimer(hertz#,event:TEvent=Null) Override
		Return TSDLTimer.Create( hertz,event )
	End Method
		
End Type

New TSDLTimerFactory


SDL_InitSubSystem(SDL_INIT_TIMER)
