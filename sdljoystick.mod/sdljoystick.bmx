' Copyright (c) 2015-2020 Bruce A Henderson
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
bbdoc: 
End Rem
Module SDL.SDLJoystick

Import SDL.SDL
Import Pub.Joystick
Import BRL.Map

Import "common.bmx"

Type TSDLJoystickDriver Extends TJoystickDriver

	Field joysticks:TIntMap = New TIntMap
	Field currentPort:Int = -1
	Field currentJoystick:TSDLJoystick
	
	Method GetName:String() Override
		Return "SDL Joystick"
	End Method

	Method JoyCount:Int() Override
		Return SDL_NumJoysticks()
	End Method
	
	Method JoyName:String(port:Int) Override
		Return String.FromUTF8String(SDL_JoystickNameForIndex(port))
	End Method
	
	Method JoyButtonCaps:Int(port:Int) Override
		SampleJoy port
		Return SDL_JoystickNumButtons(currentJoystick.joystickPtr)
	End Method
	
	Method JoyAxisCaps:Int(port:Int) Override
		SampleJoy port
		Return SDL_JoystickNumAxes(currentJoystick.joystickPtr)
	End Method
	
	Method JoyDown:Int( button:Int, port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetButton(currentJoystick.joystickPtr, button)
	End Method
	
	Method JoyHit:Int( button:Int, port:Int=0 ) Override
	End Method
	
	Method JoyX#( port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetAxis(currentJoystick.joystickPtr, JOY_X)/32767.0
	End Method
	
	Method JoyY#( port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetAxis(currentJoystick.joystickPtr, JOY_Y)/32767.0
	End Method
	
	Method JoyZ#( port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetAxis(currentJoystick.joystickPtr, JOY_Z)/32767.0
	End Method
	
	Method JoyR#( port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetAxis(currentJoystick.joystickPtr, JOY_R)/32767.0
	End Method
	
	Method JoyU#( port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetAxis(currentJoystick.joystickPtr, JOY_U)/32767.0
	End Method
	
	Method JoyV#( port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetAxis(currentJoystick.joystickPtr, JOY_V)/32767.0
	End Method
	
	Method JoyYaw#( port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetAxis(currentJoystick.joystickPtr, JOY_YAW)/32767.0
	End Method
	
	Method JoyPitch#( port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetAxis(currentJoystick.joystickPtr, JOY_PITCH)/32767.0
	End Method
	
	Method JoyRoll#( port:Int=0 ) Override
		SampleJoy port
		Return SDL_JoystickGetAxis(currentJoystick.joystickPtr, JOY_ROLL)/32767.0
	End Method
	
	Method JoyHat#( port:Int=0 ) Override
	End Method
	
	Method JoyWheel#( port:Int=0 ) Override
	End Method
	
	Method JoyType:Int( port:Int=0 ) Override
		If port<JoyCount() Return 1
		Return 0
	End Method
	
	Method JoyXDir:Int( port:Int=0 ) Override
		Local t#=JoyX( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method

	Method JoyYDir:Int( port:Int=0 ) Override
		Local t#=JoyY( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method

	Method JoyZDir:Int( port:Int=0 ) Override
		Local t#=JoyZ( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method

	Method JoyUDir:Int( port:Int=0 ) Override
		Local t#=JoyU( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method

	Method JoyVDir:Int( port:Int=0 ) Override
		Local t#=JoyV( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method
	
	Method FlushJoy( port_mask:Int=~0 ) Override
		' TODO ?
	End Method
	
	Method SampleJoy(port:Int)
		If currentPort = port Then
			Return
		End If
		
		Local joystick:TSDLJoystick = TSDLJoystick(joysticks.ValueForKey(port))
		If Not joystick Then
			joystick = New TSDLJoystick.Create(port)
			
			joysticks.Insert(port, joystick)
		End If
		
		currentJoystick = joystick
		currentPort = port
	End Method
	
End Type

Rem
bbdoc: 
End Rem
Type TSDLJoystick
	Field joystickPtr:Byte Ptr
	
	Method Create:TSDLJoystick(port:Int)
		joystickPtr = SDL_JoystickOpen(port)
		Return Self
	End Method
	
	Rem
	bbdoc: Returns True if the joystick has haptic features.
	End Rem
	Method IsHaptic:Int()
		Return SDL_JoystickIsHaptic(joystickPtr)
	End Method
	
	Method Delete()
		If joystickPtr Then
			SDL_JoystickClose(joystickPtr)
			joystickPtr = Null
		End If
	End Method
End Type

SDL_InitSubSystem(SDL_INIT_JOYSTICK)

' init driver
New TSDLJoystickDriver

' make ourself the default
GetJoystickDriver("SDL Joystick")
