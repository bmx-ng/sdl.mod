SuperStrict

Framework SDL.SDLGameController
Import brl.standardio

For Local i:Int = 0 Until JoyCount()
	Print TSDLGameController.NameForIndex(i)
Next
