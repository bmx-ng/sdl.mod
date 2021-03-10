' Copyright (c) 2015-2021 Bruce A Henderson
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
bbdoc: GameController and Joystick Mapping
End Rem
Module SDL.SDLGameController

Import "common.bmx"


Rem
bbdoc: Checks if the given joystick is supported by the game controller interface.
returns: #True if the given joystick is supported by the game controller interface, #False if it isn't or it's an invalid index.
about: @port is joystick port, up to #JoyCount.
End Rem
Function SDLIsGameController:Int(port:Int)
	Return SDL_IsGameController(port)
End Function

Rem
bbdoc: A game controller or mapped joystick.
End Rem
Type TSDLGameController

	Field controllerPtr:Byte Ptr

	Rem
	bbdoc: Opens a game controller to use.
	returns: A #TSDLGameController instance or #Null if an error occurred; call #SDLGetError() for more information.
	about: The @port passed as an argument refers to the N'th game controller on the system.
	A call to #Close should be made when you have finished with this game controller.
	End Rem
	Function Open:TSDLGameController(port:Int)
		Local this:TSDLGameController = New TSDLGameController
		this.controllerPtr = SDL_GameControllerOpen(port)
		If this.controllerPtr Then
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Closes the game controller.
	End Rem
	Method Close()
		If controllerPtr Then
			SDL_GameControllerClose(controllerPtr)
			controllerPtr = Null
		End If
	End Method

	Rem
	bbdoc: Checks if a controller has been opened and is currently connected.
	returns: #True if the controller has been opened and currently connected, or #False if it has not.
	End Rem
	Method GetAttached:Int()
		Return SDL_GameControllerGetAttached(controllerPtr)
	End Method
	
	Rem
	bbdoc: Gets the current state of an axis control on a game controller.
	returns: Axis state (including 0) on success or 0 (also) on failure; call #SDLGetError for more information.
	about: The axis indices start at index 0.
	The state is a value ranging from -32768 to 32767. Triggers, however, range from 0 to 32767 (they never return a negative value).
	End Rem
	Method GetAxis:Int(axis:ESDLGameControllerAxis)
		Return SDL_GameControllerGetAxis(controllerPtr, axis)
	End Method
	
	Rem
	bbdoc: Gets the current state of a button on a game controller.
	returns: 1 for pressed state or 0 for not pressed state or error; call #SDLGetError for more information.
	about: The button indices start at index 0.
	End Rem
	Method GetButton:Int(button:ESDLGameControllerButton)
		Return SDL_GameControllerGetButton(controllerPtr, button)
	End Method
	
	Rem
	bbdoc: Gets the implementation dependent name for the game controller.
	returns: The implementation dependent name for the game controller, or #Null if there is no name or the controller is invalid.
	End Rem
	Method GetName:String()
		Local n:Byte Ptr = SDL_GameControllerName(controllerPtr)
		If n Then
			Return String.FromUTF8String(n)
		End If
	End Method
	
	Rem
	bbdoc: Gets the current mapping of the Game Controller.
	returns: A #String that has the controller's mapping or #Null if no mapping is available; call #SDLGetError for more information.
	about: More information about the mapping can be found at #AddMapping.
	End Rem
	Method GetMapping:String()
		Local n:Byte Ptr = SDL_GameControllerMapping(controllerPtr)
		If n Then
			Local s:String = String.FromUTF8String(n)
			SDL_free(n)
			Return s
		End If
	End Method
	
	Rem
	bbdoc: Returns the type of this currently opened controller.
	End Rem
	Method GetType:ESDLGameControllerType()
		Return SDL_GameControllerGetType(controllerPtr)
	End Method
	
	Rem
	bbdoc: Returns whether the game controller has a given axis.
	End Rem
	Method HasAxis:Int(axis:ESDLGameControllerAxis)
		Return SDL_GameControllerHasAxis(controllerPtr, axis)
	End Method
	
	Rem
	bbdoc: Returns whether the game controller has a given button.
	End Rem
	Method HasButton:Int(button:ESDLGameControllerButton)
		Return SDL_GameControllerHasButton(controllerPtr, button)
	End Method

	Rem
	bbdoc: Gets the number of touchpads on the game controller.
	End Rem
	Method GetNumTouchpads:Int()
		Return SDL_GameControllerGetNumTouchpads(controllerPtr)
	End Method
	
	Rem
	bbdoc: Gets the number of supported simultaneous fingers on a touchpad on the game controller.
	End Rem
	Method GetNumTouchpadFingers:Int(touchpad:Int)
		Return SDL_GameControllerGetNumTouchpadFingers(controllerPtr, touchpad)
	End Method
	
	Rem
	bbdoc: Gets the current state of a finger on a touchpad on the game controller.
	End Rem
	Method GetTouchpadFinger:Int(touchpad:Int, finger:Int, state:Byte Var, x:Float Var, y:Float Var, pressure:Float Var)
		Return SDL_GameControllerGetTouchpadFinger(controllerPtr, touchpad, finger, Varptr state, Varptr x, Varptr y, Varptr pressure)
	End Method
	
	Rem
	bbdoc: Returns whether the game controller has a particular sensor.
	returns: #True if the sensor exists, #False otherwise.
	End Rem
	Method HasSensor:Int(sensorType:ESDLSensorType)
		Return SDL_GameControllerHasSensor(controllerPtr, sensorType)
	End Method
	
	Rem
	bbdoc: Sets whether data reporting for the game controller sensor is enabled.
	returns: 0, or -1 if an error occurred.
	End Rem
	Method SetSensorEnabled:Int(sensorType:ESDLSensorType, enabled:Int)
		Return SDL_GameControllerSetSensorEnabled(controllerPtr, sensorType, enabled)
	End Method
	
	Rem
	bbdoc: Queries whether sensor data reporting is enabled for the game controller.
	returns: #True if the sensor is enabled, #False otherwise.
	End Rem
	Method IsSensorEnabled:Int(sensorType:ESDLSensorType)
		Return SDL_GameControllerIsSensorEnabled(controllerPtr, sensorType)
	End Method
	
	Rem
	bbdoc: Gets the current state of a game controller sensor.
	returns: 0, or -1 if an error occurred.
	about: The number of values and interpretation of the data is sensor dependent.
 	End Rem
	Method SDL_GameControllerGetSensorData:Int(sensorType:ESDLSensorType, data:Float Ptr, numValues:Int)
		Return SDL_GameControllerGetSensorData(controllerPtr, sensorType, data, numValues)
	End Method
	
	Rem
	bbdoc: Starts a rumble effect.
	returns: 0, or -1 if rumble isn't supported on this controller.
	about: Each call to this method cancels any previous rumble effect, and calling it with 0 intensity stops any rumbling.
	End Rem
	Method Rumble:Int(lowFrequencyRumble:Short, highFrequencyRumble:Short, durationMs:UInt)
		Return SDL_GameControllerRumble(controllerPtr, lowFrequencyRumble, highFrequencyRumble, durationMs)
	End Method
	
	Rem
	bbdoc: Starts a rumble effect in the game controller's triggers
	returns: 0, or -1 if rumble isn't supported on this controller.
	about: Each call to this function cancels any previous trigger rumble effect, and calling it with 0 intensity stops any rumbling.
	End Rem
	Method RumbleTriggers:Int(leftRumble:Short, rightRumble:Short, durationMs:UInt)
		Return SDL_GameControllerRumbleTriggers(controllerPtr, leftRumble, rightRumble, durationMs)
	End Method
	
	Rem
	bbdoc: Returns whether the controller has an LED.
	returns: #True, or #False if this controller does not have a modifiable LED.
	End Rem
	Method HasLED:Int()
		Return SDL_GameControllerHasLED(controllerPtr)
	End Method
	
	Rem
	bbdoc: Updates a controller's LED color.
	returns: 0, or -1 if this controller does not have a modifiable LED.
	End Rem
	Method SDL_GameControllerSetLED:Int(red:Byte, green:Byte, blue:Byte)
		Return SDL_GameControllerSetLED(controllerPtr, red, green, blue)
	End Method
	
	Rem
	bbdoc: Adds support for controllers that SDL is unaware of or to cause an existing controller to have a different binding.
	returns: 1 if a new mapping is added, 0 if an existing mapping is updated, -1 on error; call #SDLGetError for more information.
	about: The mapping string has the format "GUID,name,mapping", where GUID is the string value from #GetGUIDString, name is the human
	readable string for the device and mappings are controller mappings to joystick ones. Under Windows there is a
	reserved GUID of "xinput" that covers all XInput devices. The mapping format for joystick is:
	
	| Mapping  | Description  |
	|---|---|
	| bX   | a joystick button, index X  |
	| hX.Y | hat X with value Y |
	| aX | axis X of the joystick |

	Buttons can be used as a controller axes and vice versa.

	This string shows an example of a valid mapping for a controller: `"341a3608000000000000504944564944,Afterglow PS3 Controller,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7"`
	End Rem
	Function AddMapping:Int(mapping:String)
		Local m:Byte Ptr = mapping.ToUTF8String()
		Local res:Int = SDL_GameControllerAddMapping(m)
		MemFree(m)
		Return res
	End Function
	
	Rem
	bbdoc: Converts a string into an enum representation for an #ESDLGameControllerAxis.
	returns: The #ESDLGameControllerAxis enum corresponding to the input string, or ESDLGameControllerAxis.INVALID if no match was found.
	End Rem
	Function GetAxisFromString:ESDLGameControllerAxis(txt:String)
		Local t:Byte Ptr = txt.ToUTF8String()
		Local axis:ESDLGameControllerAxis = SDL_GameControllerGetAxisFromString(t)
		MemFree(t)
		Return axis
	End Function
	
	Rem
	bbdoc: Turns a string into a button mapping.
	returns: A button mapping (#ESDLGameControllerButton) on success or ESDLGameControllerButton.INVALID on failure.
	End Rem
	Function GetButtonFromString:ESDLGameControllerButton(txt:String)
		Local t:Byte Ptr = txt.ToUTF8String()
		Local button:ESDLGameControllerButton = SDL_GameControllerGetButtonFromString(t)
		MemFree(t)
		Return button
	End Function
	
	Rem
	bbdoc: Turns an axis enum into a string mapping.
	End Rem
	Function GetStringForAxis:String(axis:ESDLGameControllerAxis)
		Return String.FromUTF8String(SDL_GameControllerGetStringForAxis(axis))
	End Function
	
	Rem
	bbdoc: Turns a button enum into a string mapping.
	End Rem
	Function GetStringForButton:String(button:ESDLGameControllerButton)
		Return String.FromUTF8String(SDL_GameControllerGetStringForButton(button))
	End Function
	
	Rem
	bbdoc: Gets the implementation dependent name for the game controller.
	returns: The implementation dependent name for the game controller, or #Null if there is no name or the index is invalid.
	End Rem
	Function NameForIndex:String(port:Int)
		Local n:Byte Ptr = SDL_GameControllerNameForIndex(port)
		If n Then
			Return String.FromUTF8String(n)
		End If
	End Function
	
	Rem
	bbdoc: Gets the type of a game controller.
	about: This can be called before any controllers are opened.
	End Rem
	Function TypeForIndex:ESDLGameControllerType(port:Int)
		Return SDL_GameControllerTypeForIndex(port)
	End Function
	
End Type
