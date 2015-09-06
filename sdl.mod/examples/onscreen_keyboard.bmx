SuperStrict

Framework sdl.gl2sdlmax2d
Import brl.eventqueue

Graphics 1024, 768, 0

	
Global blinktimer:Int
Global show:Int
Global paused:Int
Local text:String

SetEventFilterCallback(handleEvents)

SDL_StartTextInput()

While Not AppTerminate() And Not KeyDown(key_escape)

	' is the app sleeping?
	'   The user has put the app in the background on iOS/Android
	While paused
		Delay 500
		PollEvent
	Wend

	Cls
	
	DrawText "Text   :", 20, 50
	If SDL_IsTextInputActive() Then
		text = GetInput(text,100,50,500)
	Else
		SetColor 100, 255, 100
		DrawText text, 100, 50
		SetColor 255, 255, 255
	End If
	
	Flip
	
	Delay 1
Wend

End

Function GetInput:String(text:String, x:Int, y:Int, blinkRate:Int) 

	If Not blinktimer Then
		blinktimer = MilliSecs() 
	EndIf

	Local key:Int = GetChar()

	If key > 0 Then
		blinktimer = 0
		show = False	
		
		If key = 13 Then
			SDL_StopTextInput()
			Return text
		Else If key = 8 Or key = 4 Then
			If text Then
				text = text[..text.length-1]
			End If
		Else
			text :+ Chr(key)
		EndIf
		
	EndIf
	

	If blinkRate > 0 Then
		If MilliSecs() > blinktimer + blinkRate Then
			If show	Then
				show = False
				blinktimer = MilliSecs() 
			Else
				show = True
				blinktimer = MilliSecs() 
			End If
		End If
	End If
	
	If show = True
		DrawText text + "|", x, y
	Else
		DrawText text, x, y
	End If
	
	Return text
End Function

Function handleEvents:Int(data:Object, event:Int)
	Select event
		Case SDL_APP_WILLENTERBACKGROUND
			paused = True
			Return False
		Case SDL_APP_DIDENTERBACKGROUND
		Case SDL_APP_WILLENTERFOREGROUND
		Case SDL_APP_DIDENTERFOREGROUND
			paused = False
			Return False
	End Select
	Return True
End Function
 