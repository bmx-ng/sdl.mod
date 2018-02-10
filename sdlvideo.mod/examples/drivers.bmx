SuperStrict

Framework SDL.SDLVideo
Import brl.standardio

Local drivers:String[] = SDLGetVideoDrivers()

For Local driver:String = EachIn drivers
	Print driver
Next
