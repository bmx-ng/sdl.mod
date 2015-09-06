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
Strict

Rem
bbdoc: SDL System driver
End Rem
Module SDL.SDLSystem


Import SDL.SDL
Import BRL.System

Import "common.bmx"



Global _sdl_WarpMouse(x:Int, y:Int)


Type TSDLSystemDriver Extends TSystemDriver

	Field _eventFilterCallback:Int(data:Object, event:Int)
	Field _eventFilterUserData:Object

	Method New()
		SDL_Init(SDL_INIT_EVENTS)
		bmx_SDL_SetEventFilter(Self)
		OnEnd(SDL_Quit)
	End Method

	Method Poll()
		bmx_SDL_Poll()
	End Method
	
	Method Wait()
		bmx_SDL_WaitEvent()
	End Method

	Method Emit( osevent:Byte Ptr,source:Object )
		' TODO
	End Method

	Method SetMouseVisible( visible )
		SDL_ShowCursor(visible)
	End Method

	Method MoveMouse( x,y )
		If _sdl_WarpMouse Then
			_sdl_WarpMouse(x, y)
		End If
	End Method

	Method Notify( text$,serious )
		Local res:Int = bmx_SDL_ShowSimpleMessageBox(text, AppTitle, serious)
		' failed to display message box?
		If res Then
			WriteStdout text+"~r~n"
		End If
	End Method
	
	Method Confirm( text$,serious )
		Return bmx_SDL_ShowMessageBox_confirm(text, AppTitle, serious)
	End Method
	
	Method Proceed( text$,serious )
		Return bmx_SDL_ShowMessageBox_proceed(text, AppTitle, serious)
	End Method

	Method RequestFile$( text$,exts$,save,file$ )
		' TODO
	End Method
	
	Method RequestDir$( text$,path$ )
		' TODO
	End Method

	Method OpenURL( url$ )
		' TODO
	End Method

	Method DesktopWidth:Int()
		Return bmx_SDL_GetDisplayWidth(0)
	End Method
	
	Method DesktopHeight:Int()
		Return bmx_SDL_GetDisplayHeight(0)
	End Method
	
	Method DesktopDepth:Int()
		Return bmx_SDL_GetDisplayDepth(0)
	End Method
	
	Method DesktopHertz:Int()
		Return bmx_SDL_GetDisplayhertz(0)
	End Method

	Function _eventFilter:Int(driver:TSDLSystemDriver, event:Int)
		If driver._eventFilterCallback Then
			Return driver._eventFilterCallback(driver._eventFilterUserData, event)
		End If
		Return 1
	End Function
	 
End Type

Function SetEventFilterCallback(callback:Int(data:Object, event:Int), data:Object = Null)
	TSDLSystemDriver(Driver)._eventFilterCallback = callback
	TSDLSystemDriver(Driver)._eventFilterUserData = data
End Function

Driver = New TSDLSystemDriver

