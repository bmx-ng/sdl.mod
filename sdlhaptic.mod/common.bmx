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

?win32x86
Import "../../sdl.mod/sdl.mod/include/win32x86/*.h"

?win32x64
Import "../../sdl.mod/sdl.mod/include/win32x64/*.h"

?osx
Import "../../sdl.mod/sdl.mod/include/macos/*.h"

?linuxx86
Import "../../sdl.mod/sdl.mod/include/linuxx86/*.h"

?linuxx64
Import "../../sdl.mod/sdl.mod/include/linuxx64/*.h"

?raspberrypi
Import "../../sdl.mod/sdl.mod/include/raspberrypi/*.h"

?android
Import "../../sdl.mod/sdl.mod/include/android/*.h"
?

?emscripten
Import "../../sdl.mod/sdl.mod/include/emscripten/*.h"

?ios
Import "../../sdl.mod/sdl.mod/include/ios/*.h"

?haikux64
Import "../../sdl.mod/sdl.mod/include/haikux64/*.h"

?

Import "../../sdl.mod/sdl.mod/SDL/include/*.h"

Import "glue.c"

Extern

	Function SDL_HapticOpen:Byte Ptr(device:Int)
	Function SDL_HapticOpenFromJoystick:Byte Ptr(joystick:Byte Ptr)
	Function SDL_MouseIsHaptic:Int()
	Function SDL_HapticOpenFromMouse:Byte Ptr()
	Function SDL_HapticClose(handle:Byte Ptr)
	Function SDL_HapticName:Byte Ptr(device:Int)
	Function SDL_HapticOpened:Int(device:Int)
	Function SDL_HapticQuery:UInt(handle:Byte Ptr)
	Function SDL_HapticPause:Int(handle:Byte Ptr)
	Function SDL_HapticUnpause:Int(handle:Byte Ptr)
	Function SDL_HapticStopAll:Int(handle:Byte Ptr)
	Function SDL_NumHaptics:Int()

	Function SDL_HapticSetAutocenter:Int(handle:Byte Ptr, value:Int)
	Function SDL_HapticSetGain:Int(handle:Byte Ptr, value:Int)
	Function SDL_HapticIndex:Int(handle:Byte Ptr)
	Function SDL_HapticNumAxes:Int(handle:Byte Ptr)
	Function SDL_HapticNewEffect:Int(handle:Byte Ptr, effect:Byte Ptr)
	Function SDL_HapticRunEffect:Int(handle:Byte Ptr, effect:Int, iterations:UInt)
	Function SDL_HapticStopEffect:Int(handle:Byte Ptr, effect:Int)
	Function SDL_HapticDestroyEffect(handle:Byte Ptr, effect:Int)
	Function SDL_HapticGetEffectStatus:Int(handle:Byte Ptr, effect:Int)
	Function SDL_HapticEffectSupported:Int(handle:Byte Ptr, effect:Byte Ptr)
	Function SDL_HapticNumEffects:Int(handle:Byte Ptr)
	Function SDL_HapticNumEffectsPlaying:Int(handle:Byte Ptr)
	
	Function SDL_HapticRumbleInit:Int(handle:Byte Ptr)
	Function SDL_HapticRumblePlay:Int(handle:Byte Ptr, strength:Float, length:UInt)
	Function SDL_HapticRumbleStop:Int(handle:Byte Ptr)
	Function SDL_HapticRumbleSupported:Int(handle:Byte Ptr)
	
	Function bmx_sdl_haptic_SDLHapticEffect_free(handle:Byte Ptr)
	
	Function bmx_sdl_haptic_SDLHapticConstant_new:Byte Ptr()
	Function bmx_sdl_haptic_SDLHapticConstant_Direction:Byte Ptr(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticConstant_SetLength(handle:Byte Ptr, value:UInt)
	Function bmx_sdl_haptic_SDLHapticConstant_SetDelay(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticConstant_SetButton(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticConstant_SetInterval(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticConstant_SetLevel(handle:Byte Ptr, value:Int)
	Function bmx_sdl_haptic_SDLHapticConstant_SetAttackLength(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticConstant_SetAttackLevel(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticConstant_SetFadeLength(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticConstant_SetFadeLevel(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticConstant_GetLength:UInt(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticConstant_GetDelay:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticConstant_GetButton:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticConstant_GetInterval:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticConstant_GetAttackLength:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticConstant_GetAttackLevel:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticConstant_GetFadeLength:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticConstant_GetFadeLevel:Short(handle:Byte Ptr)

	Function bmx_sdl_haptic_SDLHapticPeriodic_new:Byte Ptr(waveType:Int)
	Function bmx_sdl_haptic_SDLHapticPeriodic_Direction:Byte Ptr(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetLength(handle:Byte Ptr, value:UInt)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetDelay(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetButton(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetInterval(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetPeriod(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetMagnitude(handle:Byte Ptr, value:Int)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetOffset(handle:Byte Ptr, value:Int)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetPhase(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetAttackLength(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetAttackLevel(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetFadeLength(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticPeriodic_SetFadeLevel(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticPeriodic_GetLength:UInt(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticPeriodic_GetDelay:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticPeriodic_GetButton:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticPeriodic_GetInterval:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticPeriodic_GetAttackLength:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticPeriodic_GetAttackLevel:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticPeriodic_GetFadeLength:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticPeriodic_GetFadeLevel:Short(handle:Byte Ptr)

	Function bmx_sdl_haptic_SDLHapticCondition_new:Byte Ptr(effectType:Int)
	Function bmx_sdl_haptic_SDLHapticCondition_Direction:Byte Ptr(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCondition_SetLength(handle:Byte Ptr, value:UInt)
	Function bmx_sdl_haptic_SDLHapticCondition_SetDelay(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCondition_SetButton(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCondition_SetInterval(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCondition_SetRightSat(handle:Byte Ptr, value1:Short, value2:Short, value3:Short)
	Function bmx_sdl_haptic_SDLHapticCondition_SetLeftSat(handle:Byte Ptr, value1:Short, value2:Short, value3:Short)
	Function bmx_sdl_haptic_SDLHapticCondition_SetRightCoeff(handle:Byte Ptr, value1:Int, value2:Int, value3:Int)
	Function bmx_sdl_haptic_SDLHapticCondition_SetLeftCoeff(handle:Byte Ptr, value1:Int, value2:Int, value3:Int)
	Function bmx_sdl_haptic_SDLHapticCondition_SetDeadband(handle:Byte Ptr, value1:Short, value2:Short, value3:Short)
	Function bmx_sdl_haptic_SDLHapticCondition_SetCenter(handle:Byte Ptr, value1:Int, value2:Int, value3:Int)
	Function bmx_sdl_haptic_SDLHapticCondition_GetLength:UInt(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCondition_GetDelay:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCondition_GetButton:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCondition_GetInterval:Short(handle:Byte Ptr)

	Function bmx_sdl_haptic_SDLHapticRamp_new:Byte Ptr()
	Function bmx_sdl_haptic_SDLHapticRamp_Direction:Byte Ptr(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticRamp_SetLength(handle:Byte Ptr, value:UInt)
	Function bmx_sdl_haptic_SDLHapticRamp_SetDelay(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticRamp_SetButton(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticRamp_SetInterval(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticRamp_SetStart(handle:Byte Ptr, value:Int)
	Function bmx_sdl_haptic_SDLHapticRamp_SetEnd(handle:Byte Ptr, value:Int)
	Function bmx_sdl_haptic_SDLHapticRamp_SetAttackLength(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticRamp_SetAttackLevel(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticRamp_SetFadeLength(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticRamp_SetFadeLevel(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticRamp_GetLength:UInt(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticRamp_GetDelay:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticRamp_GetButton:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticRamp_GetInterval:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticRamp_GetAttackLength:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticRamp_GetAttackLevel:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticRamp_GetFadeLength:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticRamp_GetFadeLevel:Short(handle:Byte Ptr)

	Function bmx_sdl_haptic_SDLHapticLeftRight_new:Byte Ptr()
	Function bmx_sdl_haptic_SDLHapticLeftRight_SetLength(handle:Byte Ptr, value:Int)
	Function bmx_sdl_haptic_SDLHapticLeftRight_SetLargeMagnitude(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticLeftRight_SetSmallMagnitude(handle:Byte Ptr, value:Short)

	Function bmx_sdl_haptic_SDLHapticCustom_new:Byte Ptr()
	Function bmx_sdl_haptic_SDLHapticCustom_Direction:Byte Ptr(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCustom_SetLength(handle:Byte Ptr, value:UInt)
	Function bmx_sdl_haptic_SDLHapticCustom_SetDelay(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCustom_SetButton(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCustom_SetInterval(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCustom_SetChannels(handle:Byte Ptr, value:Byte)
	Function bmx_sdl_haptic_SDLHapticCustom_SetPeriod(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCustom_SetData(handle:Byte Ptr, data:Short Ptr, samples:Int)
	Function bmx_sdl_haptic_SDLHapticCustom_SetAttackLength(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCustom_SetAttackLevel(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCustom_SetFadeLength(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCustom_SetFadeLevel(handle:Byte Ptr, value:Short)
	Function bmx_sdl_haptic_SDLHapticCustom_GetLength:UInt(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCustom_GetDelay:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCustom_GetButton:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCustom_GetInterval:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCustom_GetAttackLength:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCustom_GetAttackLevel:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCustom_GetFadeLength:Short(handle:Byte Ptr)
	Function bmx_sdl_haptic_SDLHapticCustom_GetFadeLevel:Short(handle:Byte Ptr)

	Function bmx_sdl_haptic_SDLHapticDirection_SetType(handle:Byte Ptr, value:Int)
	Function bmx_sdl_haptic_SDLHapticDirection_SetDir(handle:Byte Ptr, value1:Short, value2:Short, value3:Short)

End Extern

Rem
bbdoc: Used to play a device an infinite number of times.
End Rem
Const SDL_HAPTIC_INFINITY:UInt = 4294967295:UInt

Rem
bbdoc: Uses polar coordinates for the direction.
End Rem
Const SDL_HAPTIC_POLAR:Int = 0
Rem
bbdoc: Uses cartesian coordinates for the direction.
End Rem
Const SDL_HAPTIC_CARTESIAN:Int = 1
Rem
bbdoc: Uses spherical coordinates for the direction.
End Rem
Const SDL_HAPTIC_SPHERICAL:Int = 2

Rem
bbdoc: Constant effect supported.
about: Constant haptic effect.
End Rem
Const SDL_HAPTIC_CONSTANT:Int = 1 Shl 0
Rem
bbdoc: Sine wave effect supported.
about: Periodic haptic effect that simulates sine waves.
End Rem
Const SDL_HAPTIC_SINE:Int = 1 Shl 1
Rem
bbdoc: Left/Right effect supported.
about: Haptic effect for direct control over high/low frequency motors.
End Rem
Const SDL_HAPTIC_LEFTRIGHT:Int = 1 Shl 2
Rem
bbdoc: Triangle wave effect supported.
about: Periodic haptic effect that simulates triangular waves.
End Rem
Const SDL_HAPTIC_TRIANGLE:Int = 1 Shl 3
Rem
bbdoc: Sawtoothup wave effect supported.
about: Periodic haptic effect that simulates saw tooth up waves.
End Rem
Const SDL_HAPTIC_SAWTOOTHUP:Int = 1 Shl 4
Rem
bbdoc: Sawtoothdown wave effect supported.
about: Periodic haptic effect that simulates saw tooth down waves.
End Rem
Const SDL_HAPTIC_SAWTOOTHDOWN:Int = 1 Shl 5
Rem
bbdoc: Ramp effect supported.
about: Ramp haptic effect.
End Rem
Const SDL_HAPTIC_RAMP:Int = 1 Shl 6
Rem
bbdoc: Spring effect supported - uses axes position.
about: Condition haptic effect that simulates a spring. Effect is based on the axes position.
End Rem
Const SDL_HAPTIC_SPRING:Int = 1 Shl 7
Rem
bbdoc: Damper effect supported - uses axes velocity.
about: Condition haptic effect that simulates dampening. Effect is based on the axes velocity.
End Rem
Const SDL_HAPTIC_DAMPER:Int = 1 Shl 8
Rem
bbdoc: Inertia effect supported - uses axes acceleration.
about: Condition haptic effect that simulates inertia. Effect is based on the axes acceleration.
End Rem
Const SDL_HAPTIC_INERTIA:Int = 1 Shl 9
Rem
bbdoc: Friction effect supported - uses axes movement.
about: Condition haptic effect that simulates friction. Effect is based on the axes movement.
End Rem
Const SDL_HAPTIC_FRICTION:Int = 1 Shl 10
Rem
bbdoc: Custom effect is supported.
about: User defined custom haptic effect.
End Rem
Const SDL_HAPTIC_CUSTOM:Int = 1 Shl 11
Rem
bbdoc: Device supports setting the global gain.
End Rem
Const SDL_HAPTIC_GAIN:Int = 1 Shl 12
Rem
bbdoc: Device supports setting autocenter.
End Rem
Const SDL_HAPTIC_AUTOCENTER:Int = 1 Shl 13
Rem
bbdoc: Device supports querying effect status.
End Rem
Const SDL_HAPTIC_STATUS:Int = 1 Shl 14
Rem
bbdoc: Devices supports being paused.
End Rem
Const SDL_HAPTIC_PAUSE:Int = 1 Shl 15





