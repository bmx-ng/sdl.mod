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
	Function SDL_JoystickHasLED:Int(handle:Byte Ptr)
	Function SDL_JoystickRumble:Int(handle:Byte Ptr, lowFrequencyRumble:Short, highFrequencyRumble:Short, durationMs:UInt)
	Function SDL_JoystickRumbleTriggers:Int(handle:Byte Ptr, leftRumble:Short, rightRumble:Short, durationMs:UInt)
	Function SDL_JoystickSetLED:Int(handle:Byte Ptr, red:Byte, green:Byte, blue:Byte)
	Function SDL_JoystickCurrentPowerLevel:Int(handle:Byte Ptr)
	Function SDL_JoystickGetHat:Byte(handle:Byte Ptr, hat:Int)
	
End Extern

Rem
bbdoc: Unknown power.
end rem
Const SDL_JOYSTICK_POWER_UNKNOWN:Int = -1

Rem
bbdoc: Power is empty ( <= 5% )
end rem
Const SDL_JOYSTICK_POWER_EMPTY:Int = 0

Rem
bbdoc: Power is low ( <= 20% )
end rem
Const SDL_JOYSTICK_POWER_LOW:Int = 1

Rem
bbdoc: Power is medium ( <= 70% )
end rem
Const SDL_JOYSTICK_POWER_MEDIUM:Int = 2

Rem
bbdoc: Power is full ( <= 100% )
end rem
Const SDL_JOYSTICK_POWER_FULL:Int = 3

Rem
bbdoc: Joystick is wired.
end rem
Const SDL_JOYSTICK_POWER_WIRED:Int = 4
