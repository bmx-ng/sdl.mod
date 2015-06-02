SuperStrict

Framework sdl.gl2sdlmax2d

Import sdl.virtualjoystick


Local joy:TRenderedJoystick = TRenderedJoystick(New TRenderedJoystick.Create("VJ", 100, 100, 50, 20))
joy.AddButton(200, 80, 30)


Graphics 800, 600, 0

SetBlend alphablend

SetClsColor 255, 255, 255
SetColor 0, 0, 0

While Not KeyDown(key_escape)

	Cls
	
	' draw joystick
	joy.Render()
	
	' get some stats
	SetColor 0, 0, 0
	
	Local x:Float = JoyX()
	DrawText "JoyX : " + x, 100, 300
	DrawLine 150, 330, 150, 360, False
	DrawRect 150, 330, x * 50, 30
	
	Local y:Float = JoyY()
	DrawText "JoyY : " + y, 300, 300
	DrawLine 260, 310, 290, 310, False
	DrawRect 260, 310, 30, y * 50
	
	If JoyDown(0) Then
		DrawText "Button 0 : DOWN", 100, 380
	Else
		DrawText "Button 0 : UP", 100, 380
	End If
	
	Flip

Wend


Type TRenderedJoystick Extends TVirtualJoystick

	Method Render()
		If touchId <> -1 Then
			SetColor 200, 200, 100
		Else
			SetColor 100, 200, 100
		End If
		DrawOval centerX - radius, centerY - radius, radius * 2, radius * 2
		
		SetColor 100, 100, 200
		DrawOval xPos - knobRadius, yPos - knobRadius, knobRadius * 2, knobRadius * 2
		
		For Local i:Int = 0 Until buttons.length
			Local button:TVirtualButton = buttons[i]
			If JoyDown(i) Then
				SetColor 255, 100, 100
			Else
				SetColor 100, 100, 100 + i * 50
			End If
			DrawOval button.centerX - button.radius, button.centerY - button.radius, button.radius * 2, button.radius * 2 
		Next
	End Method

End Type
