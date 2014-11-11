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

Rem
bbdoc: SDL Timer
End Rem
Module SDL.SDLTimer

ModuleInfo "Version: 1.00"
ModuleInfo "Author: Simon Armstrong, Mark Sibly"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: Blitz Research Ltd"
ModuleInfo "Modserver: BRL"

ModuleInfo "History: 1.03"
ModuleInfo "History: Update to use Byte Ptr instead of int."

Import SDL.SDLSystem
Import BRL.Event

?win32x86
Import "../../sdl.mod/sdl.mod/include/win32x86/*.h"

?win32x64
Import "../../sdl.mod/sdl.mod/include/win32x64/*.h"

?macos
Import "../../sdl.mod/sdl.mod/include/macos/*.h"

?linuxx86
Import "../../sdl.mod/sdl.mod/include/linuxx86/*.h"

?linuxx64
Import "../../sdl.mod/sdl.mod/include/linuxx64/*.h"

?linuxarm
Import "../../sdl.mod/sdl.mod/include/linuxarm/*.h"

?

Import "../../sdl.mod/sdl.mod/include/*.h"

Import "glue.c"

Extern
Function bmx_sdl_timer_start:Byte Ptr( hertz#,timer:TTimer )
Function bmx_sdl_timer_stop( handle:Byte Ptr,timer:TTimer )
Function bmx_sdl_timer_fire( id:Int, obj:Object, ticks:Int )
End Extern

Function _TimerFired( timer:TTimer )
	timer.Fire
End Function

Type TTimer

	Method Ticks:Int()
		Return _ticks
	End Method
	
	Method Stop()
		If Not _handle Return
		bmx_sdl_timer_stop _handle,Self
		_handle=0
		_event=Null
	End Method
	
	Method Fire()
		If Not _handle Return
		_ticks:+1
		If _event
			bmx_sdl_timer_fire ($802, _event, 0)
		Else
			bmx_sdl_timer_fire (EVENT_TIMERTICK, Self, _ticks)
		EndIf
	End Method

	Method Wait:Int()
		If Not _handle Return 0
		Local n:Int
		Repeat
			WaitSystem
			n=_ticks-_wticks
		Until n
		_wticks:+n
		Return n
	End Method
	
	Function Create:TTimer( hertz#,event:TEvent=Null )
		Local t:TTimer=New TTimer
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

Rem
bbdoc: Create a timer
returns: A new timer object
about:
#CreateTimer creates a timer object that 'ticks' @hertz times per second.

Each time the timer ticks, @event will be emitted using #EmitEvent.

If @event is Null, an event with an @id equal to EVENT_TIMERTICK and 
@source equal to the timer object will be emitted instead.
End Rem
Function CreateTimer:TTimer( hertz#,event:TEvent=Null )
	Return TTimer.Create( hertz,event )
End Function

Rem
bbdoc: Get timer tick counter
returns: The number of times @timer has ticked over
End Rem
Function TimerTicks:Int( timer:TTimer )
	Return timer.Ticks()
End Function

Rem
bbdoc: Wait until a timer ticks
returns: The number of ticks since the last call to #WaitTimer
End Rem
Function WaitTimer:Int( timer:TTimer )
	Return timer.Wait()
End Function

Rem
bbdoc: Stop a timer
about:Once stopped, a timer can no longer be used.
End Rem
Function StopTimer( timer:TTimer )
	timer.Stop
End Function

SDL_InitSubSystem(SDL_INIT_TIMER)
