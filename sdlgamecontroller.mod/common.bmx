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

Import SDL.SDLJoystick

Extern

	Function SDL_IsGameController:Int(index:Int)
	Function SDL_GameControllerOpen:Byte Ptr(index:Int)
	Function SDL_GameControllerClose(handle:Byte Ptr)
	Function SDL_GameControllerGetAttached:Int(handle:Byte Ptr)
	Function SDL_GameControllerGetAxis:Int(handle:Byte Ptr, axis:ESDLGameControllerAxis)
	Function SDL_GameControllerGetButton:Int(handle:Byte Ptr, button:ESDLGameControllerButton)
	Function SDL_GameControllerName:Byte Ptr(handle:Byte Ptr)
	Function SDL_GameControllerGetStringForAxis:Byte Ptr(axis:ESDLGameControllerAxis)
	Function SDL_GameControllerGetStringForButton:Byte Ptr(button:ESDLGameControllerButton)
	Function SDL_GameControllerMapping:Byte Ptr(handle:Byte Ptr)
	Function SDL_GameControllerAddMapping:Int(mapping:Byte Ptr)
	Function SDL_GameControllerGetAxisFromString:ESDLGameControllerAxis(txt:Byte Ptr)
	Function SDL_GameControllerGetButtonFromString:ESDLGameControllerButton(txt:Byte Ptr)
	Function SDL_GameControllerNameForIndex:Byte Ptr(index:Int)
	
End Extern

Enum ESDLGameControllerAxis
	INVALID = -1
	LEFTX
	LEFTY
	RIGHTX
	RIGHTY
	TRIGGERLEFT
	TRIGGERRIGHT
End Enum

Enum ESDLGameControllerButton
	INVALID = -1
	A
	B
	X
	Y
	BACK
	GUIDE
	START
	LEFTSTICK
	RIGHTSTICK
	LEFTSHOULDER
	RIGHTSHOULDER
	DPAD_UP
	DPAD_DOWN
	DPAD_LEFT
	DPAD_RIGHT
End Enum
