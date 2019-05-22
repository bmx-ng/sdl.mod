SuperStrict

Framework SDL.SDLGameController
Import brl.standardio

For Local i:Int = 0 Until JoyCount()
	If SDLIsGameController(i) Then
		Print "Device " + i + " is a game controller"
	End If
Next
