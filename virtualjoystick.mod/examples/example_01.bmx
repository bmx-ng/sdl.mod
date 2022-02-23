SuperStrict

Framework sdl.sdlrenderMax2d

Import sdl.virtualjoystick

Local joy:TRenderedJoystick = TRenderedJoystick(New TRenderedJoystick("VJ", 100, 100, 50, 20))
joy.AddButton(200, 80, 30)
joy.SetVirtualResolution(800, 600)


Graphics 1024, 768, 0,,SDL_WINDOW_ALLOW_HIGHDPI|SDL_WINDOW_BORDERLESS|SDL_WINDOW_FULLSCREEN
SetVirtualResolution( 800, 600 )

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
	
	DrawText MouseX() + "," + MouseY(), 0, 0

	Flip

Wend


Type TRenderedJoystick Extends TVirtualJoystick

	Method Render()
		
		If stick.touchId <> -1 Then
			SetColor 200, 200, 100
		Else
			SetColor 100, 200, 100
		End If
		DrawOval stick.centerX - stick.radius, stick.centerY - stick.radius, stick.radius * 2, stick.radius * 2
		
		SetColor 0,0,0
		Local angle:Float = (450 + ATan2(stick.yPos - stick.centerY, stick.xPos - stick.centerX)) Mod 360
		DrawText "Angle: " + angle, 100, 420

		SetColor 100, 100, 200
		DrawOval stick.xPos - stick.knobRadius, stick.yPos - stick.knobRadius, stick.knobRadius * 2, stick.knobRadius * 2
		
		For Local i:Int = 0 Until buttons.length
			Local button:TVirtualCircleButton = TVirtualCircleButton(buttons[i])
			If JoyDown(i) Then
				SetColor 255, 100, 100
			Else
				SetColor 100, 100, 100 + i * 50
			End If
			DrawOval button.centerX - button.radius, button.centerY - button.radius, button.radius * 2, button.radius * 2 
		Next
	End Method

End Type
