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
bbdoc: Virtual Joystick
End Rem
Module SDL.VirtualJoystick

Import SDL.SDL
Import BRL.Event
Import Pub.Joystick
Import BRL.Math

Private
Global _driver:TVirtualJoystickDriver
Public

Type TVirtualJoystickDriver Extends TJoystickDriver

	Field joysticks:TVirtualJoystick[0]
	Field currentPort:Int = -1
	Field currentJoystick:TVirtualJoystick

	Method AddJoystick(joystick:TVirtualJoystick)
		Local port:Int = joysticks.length
		joysticks = joysticks[..port + 1]
		joysticks[port] = joystick
	End Method

	Method GetName:String() Override
		Return "Virtual Joystick"
	End Method

	Method JoyCount:Int() Override
		Return joysticks.length
	End Method
	
	Method JoyName:String(port:Int) Override
		SampleJoy port
		If currentJoystick Then
			Return currentJoystick.name
		End If
	End Method
	
	Method JoyButtonCaps:Int(port:Int) Override
		SampleJoy port
		If currentJoystick Then
			Return currentJoystick.buttoncaps
		End If
	End Method
	
	Method JoyAxisCaps:Int(port:Int) Override
		SampleJoy port
		If currentJoystick Then
			Return currentJoystick.flags
		End If
	End Method
	
	Method JoyDown:Int( button:Int, port:Int=0 ) Override
		SampleJoy port
		If currentJoystick Then
			Return currentJoystick.ButtonDown(button)
		End If
	End Method
	
	Method JoyHit:Int( button:Int, port:Int=0 ) Override
		SampleJoy port
		If currentJoystick Then
			Return currentJoystick.ButtonHit(button)
		End If
	End Method
	
	Method JoyX#( port:Int=0 ) Override
		SampleJoy port
		If currentJoystick Then
			Return currentJoystick.GetX()
		End If
	End Method
	
	Method JoyY#( port:Int=0 ) Override
		SampleJoy port
		If currentJoystick Then
			Return currentJoystick.GetY()
		End If
	End Method
	
	Method JoyZ#( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyR#( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyU#( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyV#( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyYaw#( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyPitch#( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyRoll#( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyHat#( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyWheel#( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyType:Int( port:Int=0 ) Override
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
		Return 0
	End Method
	
	Method JoyUDir:Int( port:Int=0 ) Override
		Return 0
	End Method
	
	Method JoyVDir:Int( port:Int=0 ) Override
		Return 0
	End Method
	
	Method FlushJoy( port_mask:Int=~0 ) Override
	End Method

	Method SampleJoy(port:Int)
		If currentPort = port Then
			Return
		End If
		
		If port >= joysticks.length Then
			Return
		End If
		
		currentJoystick = joysticks[port]
		currentPort = port
	End Method

End Type

Rem
bbdoc: A virtual touch joystick.
about: Can be extended to implement your own rendering of it.
End Rem
Type TVirtualJoystick

	Field name:String
	
	' stick location
	Field centerX:Int
	Field centerY:Int
	Field radius:Int
	
	Field radiusSqr:Int

	' current knob location (based on user input) and radius
	Field xPos:Int
	Field yPos:Int
	Field knobRadius:Int
	Field touchId:Int = - 1
	
	Field buttons:TVirtualButton[0]
	Field buttoncaps:Int
	
	' active axis flags - combination of VS_AXIS_X and VS_AXIS_Y
	Field flags:Int
	
	Method New()
		_driver.AddJoystick(Self)
	End Method
	
	Rem
	bbdoc: Creates a new virtual joystick instance, using the specified configuration.
	End Rem
	Method Create:TVirtualJoystick(name:String, x:Int, y:Int, stickRadius:Int, knobRadius:Int, flags:Int = VS_AXIS_XY)
		Self.name = name
		Self.centerX = x
		Self.centerY = y
		Self.radius = stickRadius
		Self.knobRadius = knobRadius
		Self.flags = flags
		
		xPos = x
		yPos = y
		
		radiusSqr = stickRadius * stickRadius
		
		AddHook EmitEventHook, Hook, Self, 0
		Return Self
	End Method
	
	Rem
	bbdoc: Adds a button at the specified location.
	returns: The button id.
	End Rem
	Method AddButton:Int(x:Int, y:Int, radius:Int)
		Local id:Int = buttons.length
		buttons = buttons[..id + 1]
		buttons[id] = New TVirtualButton.Create(x, y, radius)
		buttoncaps :| (1 Shl id)
		Return id
	End Method

	Function Hook:Object(id:Int, data:Object, context:Object )
	
		Local joystick:TVirtualJoystick = TVirtualJoystick(context)
		If Not joystick Return data
	
		Local ev:TEvent = TEvent(data)
		If Not ev Return data
		
		joystick.OnEvent(ev)
		
		Return data
	End Function
	
	Method OnEvent(event:TEvent)
		Select event.id
			Case EVENT_TOUCHDOWN
				' only test stick if we aren't already tracking
				If touchId = -1 Then
					Local dist:Int = (centerX - event.x) * (centerX - event.x) + (centerY - event.y) * (centerY - event.y)
					If dist < radiusSqr Then
						touchId = event.data
						xPos = event.x
						yPos = event.y
						Return
					End If
				End If
				
				' test buttons
				For Local i:Int = 0 Until buttons.length
					Local button:TVirtualButton = buttons[i]
					
					' only test button if we aren't already tracking
					If button.touchId = -1 Then
						Local dist:Int = (button.centerX - event.x) * (button.centerX - event.x) + (button.centerY - event.y) * (button.centerY - event.y)
						If dist < button.radiusSqr Then
							button.OnDown(event.data)
							Return
						End If
					End If
					
				Next

			Case EVENT_TOUCHUP
				' match tracked touch?
				If touchId = event.data Then
					touchId = -1
					xpos = centerX
					yPos = centerY
					Return
				End If
			
				' test buttons
				For Local i:Int = 0 Until buttons.length
					Local button:TVirtualButton = buttons[i]
					
					' match tracked touch?
					If button.touchId = event.data Then
						button.OnUp()
						Return
					End If
					
				Next

			Case EVENT_TOUCHMOVE
				' match tracked touch?
				If touchId = event.data Then
					Local dist:Int = (centerX - event.x) * (centerX - event.x) + (centerY - event.y) * (centerY - event.y)
					If dist < radiusSqr Then
						xPos = event.x
						yPos = event.y
					Else
						Local angle:Float = ATan2(event.y - centerY, event.x - centerX)
						xPos = centerX + radius * Cos(angle)
						yPos = centerY + radius * Sin(angle)
					End If
				End If

		End Select
	End Method
	
	Rem
	bbdoc: Reports the horizontal position of the joystick.
	returns: Zero if the joystick is centered, -1 if Left, 1 if Right or a value in between.
	End Rem
	Method GetX:Float()
		If flags & VS_AXIS_X Then
			Return Float(xPos - centerX) / radius
		End If
	End Method
	
	Rem
	bbdoc: Reports the vertical position of the joystick.
	returns: Zero if the joystick is centered, -1.0 if Up, 1.0 if Down or a value in between.
	End Rem
	Method GetY:Float()
		If flags & VS_AXIS_Y Then
			Return Float(yPos - centerY) / radius
		End If
	End Method
	
	Rem
	bbdoc: Test the status of a joystick button.
	returns: #True if the button is pressed.
	End Rem
	Method ButtonDown:Int(button:Int)
		If button < buttons.length Then
			Return buttons[button].down
		End If
	End Method
	
	Rem
	bbdoc: Checks for a joystick button press.
	returns: Number of times @button has been hit.
	about: The returned value represents the number of the times @button has been hit since the last call to #ButtonHit with the same specified @button.
	End Rem
	Method ButtonHit:Int(button:Int)
		If button < buttons.length Then
			Return buttons[button].Hit()
		End If
	End Method
	
	Method Free()
		RemoveHook EmitEventHook, Hook, Self
	End Method
	
End Type

Type TVirtualButton

	Field centerX:Int
	Field centerY:Int
	Field radius:Int
	
	Field radiusSqr:Int
	
	Field touchId:Int = -1
	Field down:Int
	Field hits:Int

	Method Create:TVirtualButton(x:Int, y:Int, radius:Int)
		centerX = x
		centerY = y
		Self.radius = radius
		radiusSqr = radius * radius
		Return Self
	End Method
	
	Method OnDown(id:Int)
		touchId = id
		down = True
	End Method
	
	Method OnUp()
		touchId = -1
		down = False
		hits :+ 1
	End Method
	
	Method Hit:Int()
		Local _hits:Int = hits
		hits = 0
		Return _hits
	End Method
	
End Type

Const VS_AXIS_X:Int = $001
Const VS_AXIS_Y:Int = $002
Const VS_AXIS_XY:Int = VS_AXIS_X | VS_AXIS_Y


' init driver
_driver = New TVirtualJoystickDriver

' make ourself the default
GetJoystickDriver("Virtual Joystick")
