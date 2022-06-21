' Copyright (c) 2015-2022 Bruce A Henderson
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
bbdoc: SDL Joystick driver
End Rem
Module SDL.SDLJoystick

Import SDL.SDL
Import Pub.Joystick
Import BRL.Map

Import "common.bmx"

Private
Global _hatPositions:Float[] = [-1, 0, 0.25, 0.125, 0.5, -1, 0.375, -1, 0.75, 0.875]
Public

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
		SampleJoy port
		Local pos:Int = SDL_JoystickGetHat(currentJoystick.joystickPtr, 0)
		Return _hatPositions[pos]
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
bbdoc: An SDL joystick instance.
End Rem
Type TSDLJoystick
	Field joystickPtr:Byte Ptr
	
	Method Create:TSDLJoystick(port:Int)
		joystickPtr = SDL_JoystickOpen(port)
		Return Self
	End Method
	
	Rem
	bbdoc: Returns whether the joystick has an LED.
	returns: #True, or #False if this joystick does not have a modifiable LED.
	End Rem
	Method HasLED:Int()
		Return SDL_JoystickHasLED(joystickPtr)
	End Method
	
	Rem
	bbdoc: Returns #True if the joystick has haptic features.
	End Rem
	Method IsHaptic:Int()
		Return SDL_JoystickIsHaptic(joystickPtr)
	End Method
	
	Rem
	bbdoc: Returns the battery level of this joystick.
	returns: One of #SDL_JOYSTICK_POWER_UNKNOWN, #SDL_JOYSTICK_POWER_EMPTY, #SDL_JOYSTICK_POWER_LOW, #SDL_JOYSTICK_POWER_MEDIUM, #SDL_JOYSTICK_POWER_FULL, or #SDL_JOYSTICK_POWER_WIRED.
	End Rem
	Method PowerLevel:Int()
		Return SDL_JoystickCurrentPowerLevel(joystickPtr)
	End Method
	
	Rem
	bbdoc: Starts a rumble effect.
	returns: 0, or -1 if rumble isn't supported on this joystick.
	about: Each call to this method cancels any previous rumble effect, and calling it with 0 rumble intensity stops any rumbling.
	End Rem
	Method Rumble:Int(lowFrequencyRumble:Short, highFrequencyRumble:Short, durationMs:UInt)
		Return SDL_JoystickRumble(joystickPtr, lowFrequencyRumble, highFrequencyRumble, durationMs)
	End Method
	
	Rem
	bbdoc: 0, or -1 if trigger rumble isn't supported on this joystick.
	End Rem
	Method RumbleTriggers:Int(leftRumble:Short, rightRumble:Short, durationMs:UInt)
		Return SDL_JoystickRumbleTriggers(joystickPtr, leftRumble, rightRumble, durationMs)
	End Method
	
	Rem
	bbdoc: Updates the joystick's LED color.
	returns: 0, or -1 if this joystick does not have a modifiable LED.
	End Rem
	Method SetLED:Int(red:Byte, green:Byte, blue:Byte)
		Return SDL_JoystickSetLED(joystickPtr, red, green, blue)
	End Method

	Rem
	bbdoc: Queries whether the joystick has rumble support.
	returns: #True if the joystick has rumble, #False otherwise.
	End Rem
	Method HasRumble:Int()
		Return SDL_JoystickHasRumble(joystickPtr)
	End Method

	Rem
	bbdoc: Queries whether the joystick has rumble support on triggers.
	returns: #True if the joystick has trigger rumble, #False otherwise.
	End Rem
	Method HasRumbleTriggers:Int()
		Return SDL_JoystickHasRumbleTriggers(joystickPtr)
	End Method

	Rem
	bbdoc: Gets the implementation dependent name of a joystick.
	returns: The name of the joystick. If no name can be found, this method returns #Null - call SDLGetError() for more information.
	End Rem
	Method Name:String()
		Local n:Byte Ptr = SDL_JoystickName(joystickPtr)
		If n Then
			Return String.FromUTF8String(n)
		End If
	End Method

	Rem
	bbdoc: Gets the player index for the joystick.
	returns: The player index, or -1 if it's not available.
	about: For XInput controllers this returns the XInput user index. Many joysticks will not be able to supply this information.
	End Rem
	Method GetPlayerIndex:Int()
		Return SDL_JoystickGetPlayerIndex(joystickPtr)
	End Method

	Rem
	bbdoc: Sets the player index of the joystick.
	End Rem
	Method SetPlayerIndex(index:Int)
		SDL_JoystickSetPlayerIndex(joystickPtr, index)
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
