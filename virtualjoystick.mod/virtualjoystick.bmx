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

	Method RemoveJoystick(joystick:TVirtualJoystick)
		If joysticks.Length > 0 Then
			For Local i:Int = 0 Until joysticks.Length
				If joysticks[i] = joystick Then
					Local joys:TVirtualJoystick[0]
					If i > 0 Then
						joys :+ joysticks[..i]
					End If

					If i < joysticks.Length - 1 Then
						joys :+ joysticks[i + 1..]
					End If

					joysticks = joys
				End If
			Next

			If currentJoystick = joystick Then
				currentJoystick = Null
				currentPort = -1
			End If
		End If
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
			Return currentJoystick.GetFlags()
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
		For Local i:Int = 0 Until joysticks.length
			Local joy:TVirtualJoystick = joysticks[i]
			If joy And port_mask & i Then
				joy.Flush()
			End If
		Next
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
	
	Field stick:TVirtualStick
	Field buttons:TVirtualButton[0]
	Field buttoncaps:Int

	Field virtualWidth:Int
	Field virtualHeight:Int
	
	Rem
	bbdoc: Creates a new virtual joystick instance, using the specified configuration.
	End Rem
	Method New(name:String, x:Int, y:Int, stickRadius:Int, knobRadius:Int, flags:Int = VS_AXIS_XY)
		_driver.AddJoystick(Self)

		Self.name = name

		stick = New TVirtualStick(x, y, stickRadius, knobRadius, flags)
		
		AddHook EmitEventHook, Hook, Self, 0
	End Method
	
	Rem
	bbdoc: Creates a new virtual joystick instance, using the specified configuration.
	End Rem
	Method New(name:String)
		_driver.AddJoystick(Self)

		Self.name = name

		AddHook EmitEventHook, Hook, Self, 0
	End Method

	Method SetVirtualResolution(w:Int, h:Int)
		virtualWidth = w
		virtualHeight = h
	End Method

	Method Flush()
		For Local i:Int = 0 Until buttons.Length
			buttons[i].hits = 0
		Next
	End Method

	Rem
	bbdoc: Adds a circle button at the specified location.
	returns: The button id.
	End Rem
	Method AddButton:Int(x:Int, y:Int, radius:Int)
		Local id:Int = buttons.length
		buttons = buttons[..id + 1]
		buttons[id] = New TVirtualCircleButton(x, y, radius)
		buttoncaps :| (1 Shl id)
		Return id
	End Method

	Rem
	bbdoc: Adds a rect button at the specified location.
	returns: The button id.
	End Rem
	Method AddButton:Int(x:Int, y:Int, w:Int, h:Int)
		Local id:Int = buttons.length
		buttons = buttons[..id + 1]
		buttons[id] = New TVirtualRectButton(x, y, w, h)
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
				Local x:Int = virtualWidth * (event.x / 10000.0)
				Local y:Int = virtualHeight * (event.y / 10000.0)

				If stick And stick.Down(event, x, y) Then
					Return
				End If
				
				' test buttons
				For Local i:Int = 0 Until buttons.length
					Local button:TVirtualButton = buttons[i]
					
					If button.Down(event, x, y) Then
						Return
					End If
				Next

			Case EVENT_TOUCHUP
				If stick And stick.Up(event) Then
					Return
				End If
			
				' test buttons
				For Local i:Int = 0 Until buttons.length
					Local button:TVirtualButton = buttons[i]
					
					If button.Up(event) Then
						Return
					End If					
				Next

			Case EVENT_TOUCHMOVE
				If stick Then
					Local x:Int = virtualWidth * (event.x / 10000.0)
					Local y:Int = virtualHeight * (event.y / 10000.0)

					stick.Move(event, x, y)
				End If
		End Select
	End Method
	
	Method GetFlags:Int()
		If stick Then
			Return stick.flags
		End If
	End Method

	Rem
	bbdoc: Reports the horizontal position of the joystick.
	returns: Zero if the joystick is centered, -1 if Left, 1 if Right or a value in between.
	End Rem
	Method GetX:Float()
		If stick Then
			Return stick.GetX()
		End If
	End Method
	
	Rem
	bbdoc: Reports the vertical position of the joystick.
	returns: Zero if the joystick is centered, -1.0 if Up, 1.0 if Down or a value in between.
	End Rem
	Method GetY:Float()
		If stick Then
			Return stick.GetY()
		End If
	End Method
	
	Rem
	bbdoc: Test the status of a joystick button.
	returns: #True if the button is pressed.
	End Rem
	Method ButtonDown:Int(button:Int)
		If button < buttons.length Then
			Return buttons[button].isDown
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

	Method Remove()
		Free()
		_driver.RemoveJoystick(Self)
	End Method
	
	Method Free()
		RemoveHook EmitEventHook, Hook, Self
	End Method
	
End Type

Type TVirtualStick
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

	' active axis flags - combination of VS_AXIS_X and VS_AXIS_Y
	Field flags:Int

	Method New(x:Int, y:Int, stickRadius:Int, knobRadius:Int, flags:Int = VS_AXIS_XY)
		Self.centerX = x
		Self.centerY = y
		Self.radius = stickRadius
		Self.knobRadius = knobRadius
		Self.flags = flags
		
		xPos = x
		yPos = y
		
		radiusSqr = stickRadius * stickRadius
	End Method

	Method GetX:Float()
		If flags & VS_AXIS_X Then
			Return Float(xPos - centerX) / radius
		End If
	End Method

	Method GetY:Float()
		If flags & VS_AXIS_Y Then
			Return Float(yPos - centerY) / radius
		End If
	End Method

	Method Down:Int(event:TEvent, x:Int, y:Int)
		' only test stick if we aren't already tracking
		If touchId = -1 Then
			Local dist:Int = (centerX - x) * (centerX - x) + (centerY - y) * (centerY - y)
			If dist < radiusSqr Then
				touchId = event.data
				xPos = x
				yPos = y
				Return True
			End If
		End If
	End Method

	Method Up:Int(event:TEvent)
		' match tracked touch?
		If touchId = event.data Then
			touchId = -1
			xpos = centerX
			yPos = centerY
			Return True
		End If
	End Method

	Method Move(event:TEvent, x:Int, y:Int)
		' match tracked touch?
		If touchId = event.data Then
			Local dist:Int = (centerX - x) * (centerX - x) + (centerY - y) * (centerY - y)
			If dist < radiusSqr Then
				xPos = x
				yPos = y
			Else
				Local angle:Float = ATan2(y - centerY, x - centerX)
				xPos = centerX + radius * Cos(angle)
				yPos = centerY + radius * Sin(angle)
			End If
		End If
	End Method
End Type

Type TVirtualButton
	
	Field touchId:Int = -1
	Field isDown:Int
	Field hits:Int

	Method OnDown(id:Int)
		touchId = id
		isDown = True
	End Method
	
	Method OnUp()
		touchId = -1
		isDown = False
		hits :+ 1
	End Method
	
	Method Hit:Int()
		Local _hits:Int = hits
		hits = 0
		Return _hits
	End Method

	Method Up:Int(event:TEvent)
		' match tracked touch?
		If touchId = event.data Then
			OnUp()
			Return True
		End If
	End Method

	Method Down:Int(event:TEvent, x:Int, y:Int) Abstract
	Method GetType:EButtonType() Abstract
End Type

Type TVirtualCircleButton Extends TVirtualButton

	Field centerX:Int
	Field centerY:Int
	Field radius:Int
	
	Field radiusSqr:Int

	Method New(centerX:Int, centerY:Int, radius:Int)
		Self.centerX = centerX
		Self.centerY = centerY
		Self.radius = radius
		radiusSqr = radius * radius
	End Method

	Method Down:Int(event:TEvent, x:Int, y:Int) Override
		' only test button if we aren't already tracking
		If touchId = -1 Then
			Local dist:Int = (centerX - x) * (centerX - x) + (centerY - y) * (centerY - y)
			If dist < radiusSqr Then
				OnDown(event.data)
				Return True
			End If
		End If
	End Method
	
	Method GetType:EButtonType() Override
		Return EButtonType.Circle
	End Method
End Type

Type TVirtualRectButton Extends TVirtualButton

	Field x:Int
	Field y:Int
	Field x1:Int
	Field y1:Int

	Method New(x:Int, y:Int, w:Int, h:Int)
		Self.x = x
		Self.y = y
		Self.x1 = x + w
		Self.y1 = y + h
	End Method

	Method Down:Int(event:TEvent, x:Int, y:Int) Override
		If touchId = -1 Then
			If Self.x <= x And x1 >= x And Self.y <= y And y1 >= y Then
				OnDown(event.data)
				Return True
			End If
		End If
	End Method

	Method GetType:EButtonType() Override
		Return EButtonType.Rect
	End Method
End Type

Const VS_AXIS_X:Int = $001
Const VS_AXIS_Y:Int = $002
Const VS_AXIS_XY:Int = VS_AXIS_X | VS_AXIS_Y

Enum EButtonType
	Circle
	Rect
End Enum

' init driver
_driver = New TVirtualJoystickDriver

' make ourself the default
GetJoystickDriver("Virtual Joystick")
