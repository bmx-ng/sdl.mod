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

Rem
bbdoc: Control of haptic (force feedback) devices.
End Rem
Module SDL.SDLHaptic

Import SDL.SDLJoystick

Import "common.bmx"

Rem
bbdoc: A haptic device.
End Rem
Type TSDLHaptic

	Field hapticPtr:Byte Ptr
	
	Function _create:TSDLHaptic(hapticPtr:Byte Ptr)
		If hapticPtr Then
			Local this:TSDLHaptic = New TSDLHaptic
			this.hapticPtr = hapticPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Opens a haptic device for use.
	about: The device passed as an argument refers to the N'th haptic device on this system.
	When opening a haptic device, its gain will be set to maximum and autocenter will be disabled.
	To modify these values use SetGain() and SetAutocenter().
	End Rem
	Function Open:TSDLHaptic(device:Int)
		Return _create(SDL_HapticOpen(device))
	End Function
	
	Rem
	bbdoc: Opens a haptic device for use from a joystick device.
	returns:Aa valid haptic device on success or NULL on failure.
	about: You must still close the haptic device separately. It will not be closed with the joystick.
	When opened from a joystick you should first close the haptic device before closing the joystick device.
	If not, on some implementations the haptic device will also get unallocated and you'll be unable to use force feedback on that device.
	End Rem
	Function OpenFromJoystick:TSDLHaptic(joystick:TSDLJoystick)
		Return _create(SDL_HapticOpenFromJoystick(joystick.joystickPtr))
	End Function
	
	Rem
	bbdoc: Gets whether or not the current mouse has haptic capabilities.
	End Rem
	Function MouseIsHaptic:Int()
		Return SDL_MouseIsHaptic()
	End Function
	
	Rem
	bbdoc: Opens a haptic device from the current mouse.
	returns: The haptic device or NULL on failure.
	End Rem
	Function OpenFromMouse:TSDLHaptic()
		Return _create(SDL_HapticOpenFromMouse())
	End Function
	
	Rem
	bbdoc: Counts the number of haptic devices attached to the system.
	End Rem
	Function NumHaptics:Int()
		Return SDL_NumHaptics()
	End Function
	
	Rem
	bbdoc: Gets the haptic device's supported features in bitwise manner.
	returns: A list of supported haptic features in bitwise manner (OR'd), or 0 on failure.
	End Rem
	Method Query:UInt()
		Return SDL_HapticQuery(hapticPtr)
	End Method
	
	Rem
	bbdoc: Gets the implementation dependent name of the haptic device.
	End Rem
	Function Name:String(device:Int)
		Return String.FromUTF8String(SDL_HapticName(device))
	End Function
	
	Rem
	bbdoc: Gets the index of the haptic device.
	End Rem
	Method Index:Int()
		Return SDL_HapticIndex(hapticPtr)
	End Method
	
	Rem
	bbdoc: Checks if the haptic device at the designated index has been opened.
	returns: Returns True if it has been opened, False if it hasn't or on failure.
	End Rem
	Function Opened:Int(device:Int)
		Return SDL_HapticOpened(device)
	End Function
	
	Rem
	bbdoc: Pauses the haptic device.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Method Pause:Int()
		Return SDL_HapticPause(hapticPtr)
	End Method
	
	Rem
	bbdoc: Unpauses the haptic device.
	about: 0 on success or a negative error code on failure.
	End Rem
	Method Unpause:Int()
		Return SDL_HapticUnpause(hapticPtr)
	End Method
	
	Rem
	bbdoc: Stops all the currently playing effects on the haptic device.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Method StopAll:Int()
		Return SDL_HapticStopAll(hapticPtr)
	End Method
	
	Rem
	bbdoc: Gets the number of haptic axes the device has.
	about: The number of haptic axes might be useful if working with the #Direction effect.
	End Rem
	Method NumAxes:Int()
		Return SDL_HapticNumAxes(hapticPtr)
	End Method
	
	Rem
	bbdoc: Checks to see if an effect is supported by a haptic device.
	about: True if effect is supported, False if it isn't, or a negative error code on failure.
	End Rem
	Method EffectSupported:Int(effect:TSDLHapticEffect)
		Return SDL_HapticEffectSupported(hapticPtr, effect.effectPtr)
	End Method
	
	Rem
	bbdoc: Gets the number of effects a haptic device can store.
	about: On some platforms this isn't fully supported, and therefore is an approximation.
	Always check to see if your created effect was actually created and do not rely solely on #NumEffects().
	End Rem
	Method NumEffects:Int()
		Return SDL_HapticNumEffects(hapticPtr)
	End Method
	
	Rem
	bbdoc: Gets the number of effects a haptic device can play at the same time.
	about: This is not supported on all platforms, but will always return a value. Added here for the sake of completeness.
	End Rem
	Method NumEffectsPlaying:Int()
		Return SDL_HapticNumEffectsPlaying(hapticPtr)
	End Method
	
	Rem
	bbdoc: Creates a new haptic effect on the device.
	returns: The ID of the effect on success or a negative error code on failure.
	End Rem
	Method NewEffect:Int(effect:TSDLHapticEffect)
		Return SDL_HapticNewEffect(hapticPtr, effect.effectPtr)
	End Method
	
	Rem
	bbdoc: Runs the effect on the device.
	returns: 0 on success or a negative error code on failure.
	about: If iterations are SDL_HAPTIC_INFINITY, it'll run the effect over and over repeating the envelope (attack and fade) every time.
	If you only want the effect to last forever, set SDL_HAPTIC_INFINITY in the effect's length parameter.
	End Rem
	Method RunEffect:Int(effect:Int, iterations:UInt)
		Return SDL_HapticRunEffect(hapticPtr, effect, iterations)
	End Method
	
	Rem
	bbdoc: Stops the haptic effect on the device.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Method StopEffect:Int(effect:Int)
		Return SDL_HapticStopEffect(hapticPtr, effect)
	End Method
	
	Rem
	bbdoc: Gets the status of the current effect on the haptic device.
	returns: 0 if it isn't playing, 1 if it is playing, or a negative error code on failure.
	about: Device must support the #SDL_HAPTIC_STATUS feature.
	End Rem
	Method EffectStatus:Int(effect:Int)
		Return SDL_HapticGetEffectStatus(hapticPtr, effect)
	End Method
	
	Rem
	bbdoc: Destroys the haptic effect on the device.
	about: This will stop the effect if it's running. Effects are automatically destroyed when the device is closed.
	End Rem
	Method DestroyEffect(effect:Int)
		SDL_HapticDestroyEffect(hapticPtr, effect)
	End Method
	
	Rem
	bbdoc: Initializes the haptic device for simple rumble playback.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Method RumbleInit:Int()
		Return SDL_HapticRumbleInit(hapticPtr)
	End Method
	
	Rem
	bbdoc: Runs a simple rumble effect on a haptic device.
	End Rem
	Method RumblePlay:Int(strength:Float, length:UInt)
		Return SDL_HapticRumblePlay(hapticPtr, strength, length)
	End Method
	
	Rem
	bbdoc: Stops the simple rumble on the haptic device.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Method RumbleStop:Int()
		Return SDL_HapticRumbleStop(hapticPtr)
	End Method
	
	Rem
	bbdoc: Checks whether rumble is supported on the haptic device.
	End Rem
	Method RumbleSupported:Int()
		Return SDL_HapticRumbleSupported(hapticPtr)
	End Method
	
	Rem
	bbdoc: Sets the global autocenter of the haptic device.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Method SetAutocenter:Int(value:Int)
		Return SDL_HapticSetAutocenter(hapticPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the global gain of the haptic device.
	End Rem
	Method SetGain:Int(value:Int)
		Return SDL_HapticSetGain(hapticPtr, value)
	End Method
	
	Rem
	bbdoc: Closes the haptic device.
	End Rem
	Method Close()
		If hapticPtr Then
			SDL_HapticClose(hapticPtr)
			hapticPtr = Null
		End If
	End Method
	
	Method Delete()
		If hapticPtr Then
			Close()
		End If
	End Method
	
End Type

Rem
bbdoc: The direction where the force comes from, instead of the direction in which the force is exerted.
about: Cardinal directions of the haptic device are relative to the positioning of the device. North is
considered to be away from the user. South is toward the user, east is right, and west is left of the user.
End Rem
Type TSDLHapticDirection
	
	Field dirPtr:Byte Ptr
	
	Function _create:TSDLHapticDirection(dirPtr:Byte Ptr)
		If dirPtr Then
			Local this:TSDLHapticDirection = New TSDLHapticDirection
			this.dirPtr = dirPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Sets the type of encoding.
	about: One of #SDL_HAPTIC_POLAR, #SDL_HAPTIC_CARTESIAN or #SDL_HAPTIC_SPHERICAL.
	End Rem
	Method SetType(value:Int)
		bmx_sdl_haptic_SDLHapticDirection_SetType(dirPtr, value)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SetDir(x:Short, y:Short = 0, z:Short = 0)
		bmx_sdl_haptic_SDLHapticDirection_SetDir(dirPtr, x, y, z)
	End Method
	
End Type

Rem
bbdoc: A generic template for any haptic effect.
End Rem
Type TSDLHapticEffect

	Field effectPtr:Byte Ptr
	
	Rem
	bbdoc: Frees the effect.
	End Rem
	Method Free()
		If effectPtr Then
			bmx_sdl_haptic_SDLHapticEffect_free(effectPtr)
			effectPtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method
	
End Type

Rem
bbdoc: A constant effect applies a constant force to the joystick in the specified direction.
End Rem
Type TSDLHapticConstant Extends TSDLHapticEffect
	
	Rem
	bbdoc: Creates a new instance of the effect.
	End Rem
	Method New()
		effectPtr = bmx_sdl_haptic_SDLHapticConstant_new()
	End Method

	Rem
	bbdoc: Returns the duration of effect (ms).
	End Rem
	Method GetLength:UInt()
		Return bmx_sdl_haptic_SDLHapticConstant_GetLength(effectPtr)
	End Method

	Rem
	bbdoc: Returns the delay before starting effect.
	End Rem
	Method GetDelay:Short()
		Return bmx_sdl_haptic_SDLHapticConstant_GetDelay(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the button that triggers effect.
	End Rem
	Method GetButton:Short()
		Return bmx_sdl_haptic_SDLHapticConstant_GetButton(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns how soon before effect can be triggered again.
	End Rem
	Method GetInterval:Short()
		Return bmx_sdl_haptic_SDLHapticConstant_GetInterval(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the duration of the attack (ms).
	End Rem
	Method GetAttackLength:Short()
		Return bmx_sdl_haptic_SDLHapticConstant_GetAttackLength(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the level at the start of the attack.
	End Rem
	Method GetAttackLevel:Short()
		Return bmx_sdl_haptic_SDLHapticConstant_GetAttackLevel(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the duration of the fade out (ms).
	End Rem
	Method GetFadeLength:Short()
		Return bmx_sdl_haptic_SDLHapticConstant_GetFadeLength(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the level at the end of the fade.
	End Rem
	Method GetFadeLevel:Short()
		Return bmx_sdl_haptic_SDLHapticConstant_GetFadeLevel(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the effect direction.
	about: This instance is owned by the effect, and any changes will apply only to this effect.
	End Rem
	Method Direction:TSDLHapticDirection()
		Return TSDLHapticDirection._create(bmx_sdl_haptic_SDLHapticConstant_Direction(effectPtr))
	End Method
	
	Rem
	bbdoc: Sets the duration of the effect.
	about: You can pass SDL_HAPTIC_INFINITY to length instead of a 0-32767 value.
	End Rem
	Method SetLength(value:UInt)
		bmx_sdl_haptic_SDLHapticConstant_SetLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the delay before starting the effect.
	End Rem
	Method SetDelay(value:Short)
		bmx_sdl_haptic_SDLHapticConstant_SetDelay(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the button that triggers the effect.
	End Rem
	Method SetButton(value:Short)
		bmx_sdl_haptic_SDLHapticConstant_SetButton(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets how soon it can be triggered again after button.
	End Rem
	Method SetInterval(value:Short)
		bmx_sdl_haptic_SDLHapticConstant_SetInterval(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the strength of the constant effect.
	End Rem
	Method SetLevel(value:Int)
		bmx_sdl_haptic_SDLHapticConstant_SetLevel(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the duration of the attack.
	End Rem
	Method SetAttackLength(value:Short)
		bmx_sdl_haptic_SDLHapticConstant_SetAttackLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the level at the start of the attack.
	End Rem
	Method SetAttackLevel(value:Short)
		bmx_sdl_haptic_SDLHapticConstant_SetAttackLevel(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the duration of the fade.
	End Rem
	Method SetFadeLength(value:Short)
		bmx_sdl_haptic_SDLHapticConstant_SetFadeLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the level at the end of the fade.
	End Rem
	Method SetFadeLevel(value:Short)
		bmx_sdl_haptic_SDLHapticConstant_SetFadeLevel(effectPtr, value)
	End Method
	
End Type

Rem
bbdoc: A wave-shaped effect that repeats itself over time.
about: The type determines the shape of the wave and the other parameters determine the dimensions of the wave.
End Rem
Type TSDLHapticPeriodic Extends TSDLHapticEffect

	Rem
	bbdoc: Creates a new instance of the effect.
	about: @waveType one of #SDL_HAPTIC_SINE, #SDL_HAPTIC_LEFTRIGHT, #SDL_HAPTIC_TRIANGLE, #SDL_HAPTIC_SAWTOOTHUP or #SDL_HAPTIC_SAWTOOTHDOWN.
	End Rem
	Method New(waveType:Int)
		effectPtr = bmx_sdl_haptic_SDLHapticPeriodic_new(waveType)
	End Method

	Rem
	bbdoc: Returns the duration of effect (ms).
	End Rem
	Method GetLength:UInt()
		Return bmx_sdl_haptic_SDLHapticPeriodic_GetLength(effectPtr)
	End Method

	Rem
	bbdoc: Returns the delay before starting effect.
	End Rem
	Method GetDelay:Short()
		Return bmx_sdl_haptic_SDLHapticPeriodic_GetDelay(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the button that triggers effect.
	End Rem
	Method GetButton:Short()
		Return bmx_sdl_haptic_SDLHapticPeriodic_GetButton(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns how soon before effect can be triggered again.
	End Rem
	Method GetInterval:Short()
		Return bmx_sdl_haptic_SDLHapticPeriodic_GetInterval(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the duration of the attack (ms).
	End Rem
	Method GetAttackLength:Short()
		Return bmx_sdl_haptic_SDLHapticPeriodic_GetAttackLength(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the level at the start of the attack.
	End Rem
	Method GetAttackLevel:Short()
		Return bmx_sdl_haptic_SDLHapticPeriodic_GetAttackLevel(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the duration of the fade out (ms).
	End Rem
	Method GetFadeLength:Short()
		Return bmx_sdl_haptic_SDLHapticPeriodic_GetFadeLength(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the level at the end of the fade.
	End Rem
	Method GetFadeLevel:Short()
		Return bmx_sdl_haptic_SDLHapticPeriodic_GetFadeLevel(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the effect direction.
	about: This instance is owned by the effect, and any changes will apply only to this effect.
	End Rem
	Method Direction:TSDLHapticDirection()
		Return TSDLHapticDirection._create(bmx_sdl_haptic_SDLHapticPeriodic_Direction(effectPtr))
	End Method

	Rem
	bbdoc: Sets the duration of the effect.
	about: You can pass SDL_HAPTIC_INFINITY to length instead of a 0-32767 value.
	End Rem
	Method SetLength(value:UInt)
		bmx_sdl_haptic_SDLHapticPeriodic_SetLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the delay before starting the effect.
	End Rem
	Method SetDelay(value:Short)
		bmx_sdl_haptic_SDLHapticPeriodic_SetDelay(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the button that triggers the effect.
	End Rem
	Method SetButton(value:Short)
		bmx_sdl_haptic_SDLHapticPeriodic_SetButton(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets how soon it can be triggered again after button.
	End Rem
	Method SetInterval(value:Short)
		bmx_sdl_haptic_SDLHapticPeriodic_SetInterval(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the period of the wave.
	End Rem
	Method SetPeriod(value:Short)
		bmx_sdl_haptic_SDLHapticPeriodic_SetPeriod(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the peak value
	about: Ff negative, equivalent to 180 degrees extra phase shift
	End Rem
	Method SetMagnitude(value:Int)
		bmx_sdl_haptic_SDLHapticPeriodic_SetMagnitude(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the mean value of the wave.
	End Rem
	Method SetOffset(value:Int)
		bmx_sdl_haptic_SDLHapticPeriodic_SetOffset(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the positive phase shift given by hundredth of a degree.
	about: Phase is given by hundredths of a degree, meaning that giving the phase a value of 9000
	will displace it 25% of its period. Here are sample values:
	<p>0 - No phase displacement</p>
	<p>9000 - Displaced 25% of its period</p>
	<p>18000 - Displaced 50% of its period</p>
	<p>27000 - Displaced 75% of its period</p>
	<p>36000 - Displaced 100% of its period, same as 0, but 0 is preferred</p>
	End Rem
	Method SetPhase(value:Short)
		bmx_sdl_haptic_SDLHapticPeriodic_SetPhase(effectPtr, value)
	End Method

	Rem
	bbdoc: Sets the duration of the attack.
	End Rem
	Method SetAttackLength(value:Short)
		bmx_sdl_haptic_SDLHapticPeriodic_SetAttackLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the level at the start of the attack.
	End Rem
	Method SetAttackLevel(value:Short)
		bmx_sdl_haptic_SDLHapticPeriodic_SetAttackLevel(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the duration of the fade.
	End Rem
	Method SetFadeLength(value:Short)
		bmx_sdl_haptic_SDLHapticPeriodic_SetFadeLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the level at the end of the fade.
	End Rem
	Method SetFadeLevel(value:Short)
		bmx_sdl_haptic_SDLHapticPeriodic_SetFadeLevel(effectPtr, value)
	End Method

End Type

Rem
bbdoc: A template for a condition effect.
End Rem
Type TSDLHapticCondition Extends TSDLHapticEffect

	Rem
	bbdoc: Creates a new instance of the effect.
	about: @effectType one of #SDL_HAPTIC_SPRING, #SDL_HAPTIC_DAMPER, #SDL_HAPTIC_INERTIA, #SDL_HAPTIC_FRICTION
	End Rem
	Method New(effectType:Int)
		effectPtr = bmx_sdl_haptic_SDLHapticCondition_new(effectType)
	End Method

	Rem
	bbdoc: Returns the duration of effect (ms).
	End Rem
	Method GetLength:UInt()
		Return bmx_sdl_haptic_SDLHapticCondition_GetLength(effectPtr)
	End Method

	Rem
	bbdoc: Returns the delay before starting effect.
	End Rem
	Method GetDelay:Short()
		Return bmx_sdl_haptic_SDLHapticCondition_GetDelay(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the button that triggers effect.
	End Rem
	Method GetButton:Short()
		Return bmx_sdl_haptic_SDLHapticCondition_GetButton(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns how soon before effect can be triggered again.
	End Rem
	Method GetInterval:Short()
		Return bmx_sdl_haptic_SDLHapticCondition_GetInterval(effectPtr)
	End Method

	Rem
	bbdoc: Returns the effect direction.
	about: This instance is owned by the effect, and any changes will apply only to this effect.
	End Rem
	Method Direction:TSDLHapticDirection()
		Return TSDLHapticDirection._create(bmx_sdl_haptic_SDLHapticCondition_Direction(effectPtr))
	End Method

	Rem
	bbdoc: Sets the duration of the effect.
	about: You can pass SDL_HAPTIC_INFINITY to length instead of a 0-32767 value.
	End Rem
	Method SetLength(value:UInt)
		bmx_sdl_haptic_SDLHapticCondition_SetLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the delay before starting the effect.
	End Rem
	Method SetDelay(value:Short)
		bmx_sdl_haptic_SDLHapticCondition_SetDelay(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the button that triggers the effect.
	End Rem
	Method SetButton(value:Short)
		bmx_sdl_haptic_SDLHapticCondition_SetButton(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets how soon it can be triggered again after button.
	End Rem
	Method SetInterval(value:Short)
		bmx_sdl_haptic_SDLHapticCondition_SetInterval(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets level when joystick is to the positive side.
	about: max = $FFFF
	End Rem
	Method SetRightSat(x:Short, y:Short = 0, z:Short = 0)
		bmx_sdl_haptic_SDLHapticCondition_SetRightSat(effectPtr, x, y, z)
	End Method
	
	Rem
	bbdoc: Sets level when joystick is to the negative side.
	about: max = $FFFF
	End Rem
	Method SetLeftSat(x:Short, y:Short = 0, z:Short = 0)
		bmx_sdl_haptic_SDLHapticCondition_SetLeftSat(effectPtr, x, y, z)
	End Method
	
	Rem
	bbdoc: Sets how fast to increase the force towards the positive side.
	End Rem
	Method SetRightCoeff(x:Int, y:Int = 0, z:Int = 0)
		bmx_sdl_haptic_SDLHapticCondition_SetRightCoeff(effectPtr, x, y, z)
	End Method
	
	Rem
	bbdoc: Sets how fast to increase the force towards the negative side.
	End Rem
	Method SetLeftCoeff(x:Int, y:Int = 0, z:Int = 0)
		bmx_sdl_haptic_SDLHapticCondition_SetLeftCoeff(effectPtr, x, y, z)
	End Method
	
	Rem
	bbdoc: Sets the size of the dead zone.
	about: max = $FFFF: whole axis-range when 0-centered
	End Rem
	Method SetDeadband(x:Short, y:Short = 0, z:Short = 0)
		bmx_sdl_haptic_SDLHapticCondition_SetDeadband(effectPtr, x, y, z)
	End Method
	
	Rem
	bbdoc: Sets the position of the dead zone.
	End Rem
	Method SetCenter(x:Int, y:Int = 0, z:Int = 0)
		bmx_sdl_haptic_SDLHapticCondition_SetCenter(effectPtr, x, y, z)
	End Method
	
End Type

Rem
bbdoc: A template for a ramp effect.
about: The ramp effect starts at start strength and ends at end strength.
It augments in linear fashion. If you use attack and fade with a ramp the effects get added to the ramp effect
making the effect become quadratic instead of linear.
End Rem
Type TSDLHapticRamp Extends TSDLHapticEffect

	Rem
	bbdoc: Creates a new instance of the effect.
	End Rem
	Method New()
		effectPtr = bmx_sdl_haptic_SDLHapticRamp_new()
	End Method

	Rem
	bbdoc: Returns the duration of effect (ms).
	End Rem
	Method GetLength:UInt()
		Return bmx_sdl_haptic_SDLHapticRamp_GetLength(effectPtr)
	End Method

	Rem
	bbdoc: Returns the delay before starting effect.
	End Rem
	Method GetDelay:Short()
		Return bmx_sdl_haptic_SDLHapticRamp_GetDelay(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the button that triggers effect.
	End Rem
	Method GetButton:Short()
		Return bmx_sdl_haptic_SDLHapticRamp_GetButton(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns how soon before effect can be triggered again.
	End Rem
	Method GetInterval:Short()
		Return bmx_sdl_haptic_SDLHapticRamp_GetInterval(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the duration of the attack (ms).
	End Rem
	Method GetAttackLength:Short()
		Return bmx_sdl_haptic_SDLHapticRamp_GetAttackLength(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the level at the start of the attack.
	End Rem
	Method GetAttackLevel:Short()
		Return bmx_sdl_haptic_SDLHapticRamp_GetAttackLevel(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the duration of the fade out (ms).
	End Rem
	Method GetFadeLength:Short()
		Return bmx_sdl_haptic_SDLHapticRamp_GetFadeLength(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the level at the end of the fade.
	End Rem
	Method GetFadeLevel:Short()
		Return bmx_sdl_haptic_SDLHapticRamp_GetFadeLevel(effectPtr)
	End Method

	Rem
	bbdoc: Returns the effect direction.
	about: This instance is owned by the effect, and any changes will apply only to this effect.
	End Rem
	Method Direction:TSDLHapticDirection()
		Return TSDLHapticDirection._create(bmx_sdl_haptic_SDLHapticRamp_Direction(effectPtr))
	End Method

	Rem
	bbdoc: Sets the duration of the effect.
	about: This effect does not support a duration of SDL_HAPTIC_INFINITY.
	End Rem
	Method SetLength(value:UInt)
		bmx_sdl_haptic_SDLHapticRamp_SetLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the delay before starting the effect.
	End Rem
	Method SetDelay(value:Short)
		bmx_sdl_haptic_SDLHapticRamp_SetDelay(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the button that triggers the effect.
	End Rem
	Method SetButton(value:Short)
		bmx_sdl_haptic_SDLHapticRamp_SetButton(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets how soon it can be triggered again after button.
	End Rem
	Method SetInterval(value:Short)
		bmx_sdl_haptic_SDLHapticRamp_SetInterval(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the beginning strength level.
	End Rem
	Method SetStart(value:Int)
		bmx_sdl_haptic_SDLHapticRamp_SetStart(effectPtr, value)
	End Method

	Rem
	bbdoc: Sets the ending strength level.
	End Rem
	Method SetEnd(value:Int)
		bmx_sdl_haptic_SDLHapticRamp_SetEnd(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the duration of the attack.
	End Rem
	Method SetAttackLength(value:Short)
		bmx_sdl_haptic_SDLHapticRamp_SetAttackLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the level at the start of the attack.
	End Rem
	Method SetAttackLevel(value:Short)
		bmx_sdl_haptic_SDLHapticRamp_SetAttackLevel(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the duration of the fade.
	End Rem
	Method SetFadeLength(value:Short)
		bmx_sdl_haptic_SDLHapticRamp_SetFadeLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the level at the end of the fade.
	End Rem
	Method SetFadeLevel(value:Short)
		bmx_sdl_haptic_SDLHapticRamp_SetFadeLevel(effectPtr, value)
	End Method

End Type

Rem
bbdoc: Controls the large and small motors, commonly found in modern game controllers.
about: One motor is high frequency, the other is low frequency.
End Rem
Type TSDLHapticLeftRight Extends TSDLHapticEffect

	Rem
	bbdoc: Creates a new instance of the effect.
	End Rem
	Method New()
		effectPtr = bmx_sdl_haptic_SDLHapticLeftRight_new()
	End Method

	Rem
	bbdoc: Sets the duration of the effect.
	End Rem
	Method SetLength(value:UInt)
		bmx_sdl_haptic_SDLHapticLeftRight_SetLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the control of the large controller motor.
	End Rem
	Method SetLargeMagnitude(value:Short)
		bmx_sdl_haptic_SDLHapticLeftRight_SetLargeMagnitude(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the control of the small controller motor.
	End Rem
	Method SetSmallMagnitude(value:Short)
		bmx_sdl_haptic_SDLHapticLeftRight_SetSmallMagnitude(effectPtr, value)
	End Method
	
End Type

Rem
bbdoc: A custom force feedback effect.
about: The effect is much like a periodic effect, where the application can define its exact shape.
You will have to allocate the data yourself. data should consist of channels * samples Short samples.
If channels is 1, the effect is rotated using the defined direction. Otherwise it uses the samples in data for the different axes.
End Rem
Type TSDLHapticCustom Extends TSDLHapticEffect

	Rem
	bbdoc: Creates a new instance of the effect.
	End Rem
	Method New()
		effectPtr = bmx_sdl_haptic_SDLHapticCustom_new()
	End Method

	Rem
	bbdoc: Returns the duration of effect (ms).
	End Rem
	Method GetLength:UInt()
		Return bmx_sdl_haptic_SDLHapticCustom_GetLength(effectPtr)
	End Method

	Rem
	bbdoc: Returns the delay before starting effect.
	End Rem
	Method GetDelay:Short()
		Return bmx_sdl_haptic_SDLHapticCustom_GetDelay(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the button that triggers effect.
	End Rem
	Method GetButton:Short()
		Return bmx_sdl_haptic_SDLHapticCustom_GetButton(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns how soon before effect can be triggered again.
	End Rem
	Method GetInterval:Short()
		Return bmx_sdl_haptic_SDLHapticCustom_GetInterval(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the duration of the attack (ms).
	End Rem
	Method GetAttackLength:Short()
		Return bmx_sdl_haptic_SDLHapticCustom_GetAttackLength(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the level at the start of the attack.
	End Rem
	Method GetAttackLevel:Short()
		Return bmx_sdl_haptic_SDLHapticCustom_GetAttackLevel(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the duration of the fade out (ms).
	End Rem
	Method GetFadeLength:Short()
		Return bmx_sdl_haptic_SDLHapticCustom_GetFadeLength(effectPtr)
	End Method
	
	Rem
	bbdoc: Returns the level at the end of the fade.
	End Rem
	Method GetFadeLevel:Short()
		Return bmx_sdl_haptic_SDLHapticCustom_GetFadeLevel(effectPtr)
	End Method

	Rem
	bbdoc: Returns the effect direction.
	about: This instance is owned by the effect, and any changes will apply only to this effect.
	End Rem
	Method Direction:TSDLHapticDirection()
		Return TSDLHapticDirection._create(bmx_sdl_haptic_SDLHapticCustom_Direction(effectPtr))
	End Method

	Rem
	bbdoc: Sets the duration of the effect.
	about: You can pass SDL_HAPTIC_INFINITY to length instead of a 0-32767 value.
	End Rem
	Method SetLength(value:UInt)
		bmx_sdl_haptic_SDLHapticCustom_SetLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the delay before starting the effect.
	End Rem
	Method SetDelay(value:Short)
		bmx_sdl_haptic_SDLHapticCustom_SetDelay(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the button that triggers the effect.
	End Rem
	Method SetButton(value:Short)
		bmx_sdl_haptic_SDLHapticCustom_SetButton(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets how soon it can be triggered again after button.
	End Rem
	Method SetInterval(value:Short)
		bmx_sdl_haptic_SDLHapticCustom_SetInterval(effectPtr, value)
	End Method

	Rem
	bbdoc: Sets the axes to use, minimum of 1.
	about: If channels is 1, the effect is rotated using the defined direction. Otherwise it uses the samples in data for the different axes.
	End Rem
	Method SetChannels(value:Byte)
		bmx_sdl_haptic_SDLHapticCustom_SetChannels(effectPtr, value)
	End Method

	Rem
	bbdoc: Sets the sample periods.
	End Rem
	Method SetPeriod(value:Byte)
		bmx_sdl_haptic_SDLHapticCustom_SetChannels(effectPtr, value)
	End Method

	Rem
	bbdoc: Sets the samples data.
	End Rem
	Method SetData(data:Short[])
		bmx_sdl_haptic_SDLHapticCustom_SetData(effectPtr, data, data.length)
	End Method

	Rem
	bbdoc: Sets the duration of the attack.
	End Rem
	Method SetAttackLength(value:Short)
		bmx_sdl_haptic_SDLHapticCustom_SetAttackLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the level at the start of the attack.
	End Rem
	Method SetAttackLevel(value:Short)
		bmx_sdl_haptic_SDLHapticCustom_SetAttackLevel(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the duration of the fade.
	End Rem
	Method SetFadeLength(value:Short)
		bmx_sdl_haptic_SDLHapticCustom_SetFadeLength(effectPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the level at the end of the fade.
	End Rem
	Method SetFadeLevel(value:Short)
		bmx_sdl_haptic_SDLHapticCustom_SetFadeLevel(effectPtr, value)
	End Method

End Type

SDL_InitSubSystem(SDL_INIT_HAPTIC)
