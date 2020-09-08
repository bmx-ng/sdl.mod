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

Rem
bbdoc: SDL System driver
End Rem
Module SDL.SDLSystem


Import SDL.SDL
Import BRL.System
Import BRL.LinkedList
Import Pub.NFD
Import Brl.StringBuilder

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

	Method Poll() Override
		bmx_SDL_Poll()
	End Method
	
	Method Wait() Override
		bmx_SDL_WaitEvent()
	End Method

	Method Emit( osevent:Byte Ptr,source:Object )
		' TODO
	End Method

	Method SetMouseVisible( visible:Int ) Override
		SDL_ShowCursor(visible)
	End Method

	Method MoveMouse( x:Int,y:Int ) Override
		If _sdl_WarpMouse Then
			_sdl_WarpMouse(x, y)
		End If
	End Method

	Method Notify( Text$,serious:Int ) Override
		Local res:Int = bmx_SDL_ShowSimpleMessageBox(Text, AppTitle, serious)
		' failed to display message box?
		If res Then
			WriteStdout Text+"~r~n"
		End If
	End Method
	
	Method Confirm:Int( Text$,serious:Int ) Override
		Return bmx_SDL_ShowMessageBox_confirm(Text, AppTitle, serious)
	End Method
	
	Method Proceed:Int( Text$,serious:Int ) Override
		Return bmx_SDL_ShowMessageBox_proceed(Text, AppTitle, serious)
	End Method

	Method RequestFile$( Text$,exts$,save:Int,file$ ) Override
		Local requestedFile:String
		
		Local res:Int
		Local defaultPath:Byte Ptr
		Local outPath:Byte Ptr
		Local filterList:Byte Ptr
		If file Then
			defaultPath = file.ToUTF8String()
		End If
		If exts Then
			Local groups:String[] = exts.Split(";")

			Local sb:TStringBuilder = New TStringBuilder
			For Local group:String = EachIn groups				
				Local i:Int = group.Find(":")
				Local ext:String
				If i > -1 Then
					ext = group[i + 1..]
				Else
					ext = group
				End If
				If ext <> "*" Then
					If sb.Length() Then
						sb.Append(";")
					End If
					sb.Append(ext)
				End If
			Next

			filterList = sb.ToString().ToUTF8String()
		End If
		
		If save Then
			res = NFD_SaveDialog(filterList, defaultPath, Varptr outPath)
		Else
			res = NFD_OpenDialog(filterList, defaultPath, Varptr outPath)
		End If
		
		If res = 1 And outPath Then
			requestedFile = String.FromUTF8String(outPath)
			free_(outPath)
		End If
		
		If defaultPath Then
			MemFree(defaultPath)
		End If
		If filterList Then
			MemFree(filterList)
		End If
		
		Return requestedFile
	End Method
	
	Method RequestDir$( Text$,path$ ) Override
		Local requestedDir:String
		
		Local res:Int
		Local defaultPath:Byte Ptr
		Local outPath:Byte Ptr
		If path Then
			defaultPath = path.ToUTF8String()
		End If
		
		res = NFD_PickFolder(defaultPath, Varptr outPath)

		If res = 1 And outPath Then
			requestedDir = String.FromUTF8String(outPath)
			free_(outPath)
		End If
		
		If defaultPath Then
			MemFree(defaultPath)
		End If
	
		Return requestedDir
	End Method

	Method OpenURL:Int( url$ ) Override
		' TODO
	End Method

	Method DesktopWidth:Int() Override
		Return bmx_SDL_GetDisplayWidth(0)
	End Method
	
	Method DesktopHeight:Int() Override
		Return bmx_SDL_GetDisplayHeight(0)
	End Method
	
	Method DesktopDepth:Int() Override
		Return bmx_SDL_GetDisplayDepth(0)
	End Method
	
	Method DesktopHertz:Int() Override
		Return bmx_SDL_GetDisplayhertz(0)
	End Method

	Function _eventFilter:Int(driver:TSDLSystemDriver, event:Int) { nomangle }
		If driver._eventFilterCallback Then
			Return driver._eventFilterCallback(driver._eventFilterUserData, event)
		End If
		Return 1
	End Function

	Method Name:String() Override
		Return "SDLSystemDriver"
	End Method
	
End Type

Rem
bbdoc: 
End Rem
Function SetEventFilterCallback(callback:Int(data:Object, event:Int), data:Object = Null)
	TSDLSystemDriver(SystemDriver())._eventFilterCallback = callback
	TSDLSystemDriver(SystemDriver())._eventFilterUserData = data
End Function

InitSystemDriver(New TSDLSystemDriver)

Rem
bbdoc: Information about multiple finger gestures.
End Rem
Type TSDLMultiGesture
	Rem
	bbdoc: The touch device id.
	End Rem
	Field touchId:Long
	Rem
	bbdoc: The center of the gesture.
	End Rem
	Field x:Int
	Rem
	bbdoc: The center of the gesture.
	End Rem
	Field y:Int
	Rem
	bbdoc: The amount that the fingers rotated during this motion.
	End Rem
	Field dTheta:Float
	Rem
	bbdoc: The amount that the fingers pinched during this motion.
	End Rem
	Field dDist:Float
	Rem
	bbdoc: The number of fingers used in the gesture.
	End Rem
	Field numFingers:Int
	
	Global _gestures:TList = New TList
	
	Function _getGesture:TSDLMultiGesture(touchId:Long, x:Int, y:Int, dTheta:Float, dDist:Float, numFingers:Int) { nomangle }
		Local gesture:TSDLMultiGesture = TSDLMultiGesture(_gestures.RemoveFirst())
		If Not gesture Then
			gesture = New TSDLMultiGesture
		End If
		
		gesture.touchId = touchId
		gesture.x = x
		gesture.y = y
		gesture.dTheta = dTheta
		gesture.dDist = dDist
		gesture.numFingers = numFingers
		
		Return gesture
	End Function
	
	Function _freeGesture(gesture:TSDLMultiGesture) { nomangle }
		_gestures.AddLast(gesture)
	End Function
	
End Type

Private

Extern
	Function NFD_OpenDialog:Int(filterList:Byte Ptr, defaultPath:Byte Ptr, outPath:Byte Ptr Ptr)
	Function NFD_SaveDialog:Int(filterList:Byte Ptr, defaultPath:Byte Ptr, outPath:Byte Ptr Ptr)
	Function NFD_PickFolder:Int(defaultPath:Byte Ptr, outPath:Byte Ptr Ptr)
	Function free_(buf:Byte Ptr)="void free(void *)!"
End Extern
