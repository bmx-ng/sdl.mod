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

Extern

	Function SDL_JoystickOpen:Byte Ptr(port:Int)
	Function SDL_NumJoysticks:Int()
	Function SDL_JoystickNameForIndex:Byte Ptr(port:Int)
	Function SDL_JoystickNumButtons:Int(handle:Byte Ptr)
	Function SDL_JoystickNumAxes:Int(handle:Byte Ptr)
	Function SDL_JoystickGetButton:Int(handle:Byte Ptr, button:Int)
	Function SDL_JoystickGetAxis:Int(handle:Byte Ptr, direction:Int)
	Function SDL_JoystickClose(handle:Byte Ptr)
	Function SDL_JoystickIsHaptic:Int(handle:Byte Ptr)
	
End Extern

