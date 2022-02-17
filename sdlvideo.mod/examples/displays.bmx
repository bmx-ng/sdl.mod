SuperStrict

Framework SDL.SDLVideo
Import brl.standardio

SDLVideoInit(SDLGetVideoDrivers()[0])

Local displayCount:Int = SDLGetNumVideoDisplays()

Print "Displays = " + displayCount

For Local i:Int = 0 Until displayCount

	Local display:TSDLDisplay = TSDLDisplay.Create(i)
	Print "  " + display.GetName()
	
	Local w:Int, h:Int
	display.GetBounds(w, h)
	Print "    Bounds : " + w + " x " + h
	
	Local ddpi:Float, hdpi:Float, vdpi:Float
	display.GetDPI(ddpi, hdpi, vdpi)
	Print "    DPI    : " + ddpi + " - " + hdpi + " - " + vdpi
	
	display.GetUsableBounds(w, h)
	Print "    Usable : " + w + " x " + h

	Local modes:Int = display.GetNumDisplayModes()
	
	For Local m:Int = 0 Until modes
		Local mode:SDLDisplayMode
		If Not display.GetDisplayMode(m, mode) Then
			Print "      : " + (mode.width + " x " + mode.height + "             ")[..20] + ..
				(SDLGetPixelFormatName(mode.format) + "               ")[..30] + ..
				mode.refreshRate + " hz"
		End If
	Next
	
	Print ""
Next

