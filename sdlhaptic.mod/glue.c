/*
 Copyright (c) 2014-2020 Bruce A Henderson

 This software is provided 'as-is', without any express or implied
 warranty. In no event will the authors be held liable for any damages
 arising from the use of this software.

 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
*/
#include "SDL_haptic.h"
#include <stdlib.h>

void bmx_sdl_haptic_SDLHapticEffect_free(SDL_HapticEffect  * effect) {
	free(effect);
}

// --------------------------------------------------------

SDL_HapticConstant * bmx_sdl_haptic_SDLHapticConstant_new() {
	SDL_HapticConstant * effect = (SDL_HapticConstant*)calloc(1, sizeof(SDL_HapticConstant));
	effect->type = SDL_HAPTIC_CONSTANT;
	return effect;
}

SDL_HapticDirection * bmx_sdl_haptic_SDLHapticConstant_Direction(SDL_HapticConstant * effect) {
	return &effect->direction;
}

void bmx_sdl_haptic_SDLHapticConstant_SetLength(SDL_HapticConstant * effect, Uint32 value) {
	effect->length = value;
}

void bmx_sdl_haptic_SDLHapticConstant_SetDelay(SDL_HapticConstant * effect, Uint16 value) {
	effect->delay = value;
}

void bmx_sdl_haptic_SDLHapticConstant_SetButton(SDL_HapticConstant * effect, Uint16 value) {
	effect->button = value;
}

void bmx_sdl_haptic_SDLHapticConstant_SetInterval(SDL_HapticConstant * effect, Uint16 value) {
	effect->interval = value;
}

void bmx_sdl_haptic_SDLHapticConstant_SetLevel(SDL_HapticConstant * effect, int value) {
	effect->level = value;
}

void bmx_sdl_haptic_SDLHapticConstant_SetAttackLength(SDL_HapticConstant * effect, Uint16 value) {
	effect->attack_length = value;
}

void bmx_sdl_haptic_SDLHapticConstant_SetAttackLevel(SDL_HapticConstant * effect, Uint16 value) {
	effect->attack_level = value;
}

void bmx_sdl_haptic_SDLHapticConstant_SetFadeLength(SDL_HapticConstant * effect, Uint16 value) {
	effect->fade_length = value;
}

void bmx_sdl_haptic_SDLHapticConstant_SetFadeLevel(SDL_HapticConstant * effect, Uint16 value) {
	effect->fade_level = value;
}

Uint32 bmx_sdl_haptic_SDLHapticConstant_GetLength(SDL_HapticConstant * effect) {
	return effect->length;
}

Uint16 bmx_sdl_haptic_SDLHapticConstant_GetDelay(SDL_HapticConstant * effect) {
	return effect->delay;
}

Uint16 bmx_sdl_haptic_SDLHapticConstant_GetButton(SDL_HapticConstant * effect) {
	return effect->button;
}

Uint16 bmx_sdl_haptic_SDLHapticConstant_GetInterval(SDL_HapticConstant * effect) {
	return effect->interval;
}

Uint16 bmx_sdl_haptic_SDLHapticConstant_GetAttackLength(SDL_HapticConstant * effect) {
	return effect->attack_length;
}

Uint16 bmx_sdl_haptic_SDLHapticConstant_GetAttackLevel(SDL_HapticConstant * effect) {
	return effect->attack_level;
}

Uint16 bmx_sdl_haptic_SDLHapticConstant_GetFadeLength(SDL_HapticConstant * effect) {
	return effect->fade_length;
}

Uint16 bmx_sdl_haptic_SDLHapticConstant_GetFadeLevel(SDL_HapticConstant * effect) {
	return effect->fade_level;
}

// --------------------------------------------------------

SDL_HapticPeriodic * bmx_sdl_haptic_SDLHapticPeriodic_new(int waveType) {
	SDL_HapticPeriodic * effect = (SDL_HapticPeriodic*)calloc(1, sizeof(SDL_HapticPeriodic));
	effect->type = waveType;
	return effect;
}

SDL_HapticDirection * bmx_sdl_haptic_SDLHapticPeriodic_Direction(SDL_HapticPeriodic * effect) {
	return &effect->direction;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetLength(SDL_HapticPeriodic * effect, Uint32 value) {
	effect->length = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetDelay(SDL_HapticPeriodic * effect, Uint16 value) {
	effect->delay = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetButton(SDL_HapticPeriodic * effect, Uint16 value) {
	effect->button = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetInterval(SDL_HapticPeriodic * effect, Uint16 value) {
	effect->interval = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetPeriod(SDL_HapticPeriodic * effect, Uint16 value) {
	effect->period = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetMagnitude(SDL_HapticPeriodic * effect, int value) {
	effect->magnitude = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetOffset(SDL_HapticPeriodic * effect, int value) {
	effect->offset = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetPhase(SDL_HapticPeriodic * effect, Uint16 value) {
	effect->phase = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetAttackLength(SDL_HapticPeriodic * effect, Uint16 value) {
	effect->attack_length = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetAttackLevel(SDL_HapticPeriodic * effect, Uint16 value) {
	effect->attack_level = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetFadeLength(SDL_HapticPeriodic * effect, Uint16 value) {
	effect->fade_length = value;
}

void bmx_sdl_haptic_SDLHapticPeriodic_SetFadeLevel(SDL_HapticPeriodic * effect, Uint16 value) {
	effect->fade_level = value;
}

Uint32 bmx_sdl_haptic_SDLHapticPeriodic_GetLength(SDL_HapticPeriodic * effect) {
	return effect->length;
}

Uint16 bmx_sdl_haptic_SDLHapticPeriodic_GetDelay(SDL_HapticPeriodic * effect) {
	return effect->delay;
}

Uint16 bmx_sdl_haptic_SDLHapticPeriodic_GetButton(SDL_HapticPeriodic * effect) {
	return effect->button;
}

Uint16 bmx_sdl_haptic_SDLHapticPeriodic_GetInterval(SDL_HapticPeriodic * effect) {
	return effect->interval;
}

Uint16 bmx_sdl_haptic_SDLHapticPeriodic_GetAttackLength(SDL_HapticPeriodic * effect) {
	return effect->attack_length;
}

Uint16 bmx_sdl_haptic_SDLHapticPeriodic_GetAttackLevel(SDL_HapticPeriodic * effect) {
	return effect->attack_level;
}

Uint16 bmx_sdl_haptic_SDLHapticPeriodic_GetFadeLength(SDL_HapticPeriodic * effect) {
	return effect->fade_length;
}

Uint16 bmx_sdl_haptic_SDLHapticPeriodic_GetFadeLevel(SDL_HapticPeriodic * effect) {
	return effect->fade_level;
}

// --------------------------------------------------------

SDL_HapticCondition * bmx_sdl_haptic_SDLHapticCondition_new(int effectType) {
	SDL_HapticCondition * effect = (SDL_HapticCondition*)calloc(1, sizeof(SDL_HapticCondition));
	effect->type = effectType;
	return effect;
}

SDL_HapticDirection * bmx_sdl_haptic_SDLHapticCondition_Direction(SDL_HapticCondition * effect) {
	return &effect->direction;
}

void bmx_sdl_haptic_SDLHapticCondition_SetLength(SDL_HapticCondition * effect, Uint32 value) {
	effect->length = value;
}

void bmx_sdl_haptic_SDLHapticCondition_SetDelay(SDL_HapticCondition * effect, Uint16 value) {
	effect->delay = value;
}

void bmx_sdl_haptic_SDLHapticCondition_SetButton(SDL_HapticCondition * effect, Uint16 value) {
	effect->button = value;
}

void bmx_sdl_haptic_SDLHapticCondition_SetInterval(SDL_HapticCondition * effect, Uint16 value) {
	effect->interval = value;
}

void bmx_sdl_haptic_SDLHapticCondition_SetRightSat(SDL_HapticCondition * effect, Uint16 value1, Uint16 value2, Uint16 value3) {
	effect->right_sat[0] = value1;
	effect->right_sat[1] = value2;
	effect->right_sat[2] = value3;
}

void bmx_sdl_haptic_SDLHapticCondition_SetLeftSat(SDL_HapticCondition * effect, Uint16 value1, Uint16 value2, Uint16 value3) {
	effect->left_sat[0] = value1;
	effect->left_sat[1] = value2;
	effect->left_sat[2] = value3;
}

void bmx_sdl_haptic_SDLHapticCondition_SetRightCoeff(SDL_HapticCondition * effect, int value1, int value2, int value3) {
	effect->right_coeff[0] = value1;
	effect->right_coeff[1] = value2;
	effect->right_coeff[2] = value3;
}

void bmx_sdl_haptic_SDLHapticCondition_SetLeftCoeff(SDL_HapticCondition * effect, int value1, int value2, int value3) {
	effect->left_coeff[0] = value1;
	effect->left_coeff[1] = value2;
	effect->left_coeff[2] = value3;
}

void bmx_sdl_haptic_SDLHapticCondition_SetDeadband(SDL_HapticCondition * effect, Uint16 value1, Uint16 value2, Uint16 value3) {
	effect->deadband[0] = value1;
	effect->deadband[1] = value2;
	effect->deadband[2] = value3;
}

void bmx_sdl_haptic_SDLHapticCondition_SetCenter(SDL_HapticCondition * effect, int value1, int value2, int value3) {
	effect->center[0] = value1;
	effect->center[1] = value2;
	effect->center[2] = value3;
}

Uint32 bmx_sdl_haptic_SDLHapticCondition_GetLength(SDL_HapticCondition * effect) {
	return effect->length;
}

Uint16 bmx_sdl_haptic_SDLHapticCondition_GetDelay(SDL_HapticCondition * effect) {
	return effect->delay;
}

Uint16 bmx_sdl_haptic_SDLHapticCondition_GetButton(SDL_HapticCondition * effect) {
	return effect->button;
}

Uint16 bmx_sdl_haptic_SDLHapticCondition_GetInterval(SDL_HapticCondition * effect) {
	return effect->interval;
}

// --------------------------------------------------------

SDL_HapticRamp * bmx_sdl_haptic_SDLHapticRamp_new() {
	SDL_HapticRamp * effect = (SDL_HapticRamp*)calloc(1, sizeof(SDL_HapticRamp));
	effect->type = SDL_HAPTIC_RAMP;
	return effect;
}

SDL_HapticDirection * bmx_sdl_haptic_SDLHapticRamp_Direction(SDL_HapticRamp * effect) {
	return &effect->direction;
}

void bmx_sdl_haptic_SDLHapticRamp_SetLength(SDL_HapticRamp * effect, Uint32 value) {
	effect->length = value;
}

void bmx_sdl_haptic_SDLHapticRamp_SetDelay(SDL_HapticRamp * effect, Uint16 value) {
	effect->delay = value;
}

void bmx_sdl_haptic_SDLHapticRamp_SetButton(SDL_HapticRamp * effect, Uint16 value) {
	effect->button = value;
}

void bmx_sdl_haptic_SDLHapticRamp_SetInterval(SDL_HapticRamp * effect, Uint16 value) {
	effect->interval = value;
}

void bmx_sdl_haptic_SDLHapticRamp_SetStart(SDL_HapticRamp * effect, int value) {
	effect->start = value;
}

void bmx_sdl_haptic_SDLHapticRamp_SetEnd(SDL_HapticRamp * effect, int value) {
	effect->end = value;
}

void bmx_sdl_haptic_SDLHapticRamp_SetAttackLength(SDL_HapticRamp * effect, Uint16 value) {
	effect->attack_length = value;
}

void bmx_sdl_haptic_SDLHapticRamp_SetAttackLevel(SDL_HapticRamp * effect, Uint16 value) {
	effect->attack_level = value;
}

void bmx_sdl_haptic_SDLHapticRamp_SetFadeLength(SDL_HapticRamp * effect, Uint16 value) {
	effect->fade_length = value;
}

void bmx_sdl_haptic_SDLHapticRamp_SetFadeLevel(SDL_HapticRamp * effect, Uint16 value) {
	effect->fade_level = value;
}

Uint32 bmx_sdl_haptic_SDLHapticRamp_GetLength(SDL_HapticRamp * effect) {
	return effect->length;
}

Uint16 bmx_sdl_haptic_SDLHapticRamp_GetDelay(SDL_HapticRamp * effect) {
	return effect->delay;
}

Uint16 bmx_sdl_haptic_SDLHapticRamp_GetButton(SDL_HapticRamp * effect) {
	return effect->button;
}

Uint16 bmx_sdl_haptic_SDLHapticRamp_GetInterval(SDL_HapticRamp * effect) {
	return effect->interval;
}

Uint16 bmx_sdl_haptic_SDLHapticRamp_GetAttackLength(SDL_HapticRamp * effect) {
	return effect->attack_length;
}

Uint16 bmx_sdl_haptic_SDLHapticRamp_GetAttackLevel(SDL_HapticRamp * effect) {
	return effect->attack_level;
}

Uint16 bmx_sdl_haptic_SDLHapticRamp_GetFadeLength(SDL_HapticRamp * effect) {
	return effect->fade_length;
}

Uint16 bmx_sdl_haptic_SDLHapticRamp_GetFadeLevel(SDL_HapticRamp * effect) {
	return effect->fade_level;
}

// --------------------------------------------------------

SDL_HapticLeftRight * bmx_sdl_haptic_SDLHapticLeftRight_new() {
	SDL_HapticLeftRight * effect = (SDL_HapticLeftRight*)calloc(1, sizeof(SDL_HapticLeftRight));
	effect->type = SDL_HAPTIC_LEFTRIGHT;
	return effect;
}

void bmx_sdl_haptic_SDLHapticLeftRight_SetLength(SDL_HapticLeftRight * effect, Uint32 value) {
	effect->length = value;
}

void bmx_sdl_haptic_SDLHapticLeftRight_SetLargeMagnitude(SDL_HapticLeftRight * effect, Uint16 value) {
	effect->large_magnitude = value;
}

void bmx_sdl_haptic_SDLHapticLeftRight_SetSmallMagnitude(SDL_HapticLeftRight * effect, Uint16 value) {
	effect->small_magnitude = value;
}

// --------------------------------------------------------

SDL_HapticCustom * bmx_sdl_haptic_SDLHapticCustom_new() {
	SDL_HapticCustom * effect = (SDL_HapticCustom*)calloc(1, sizeof(SDL_HapticCustom));
	effect->type = SDL_HAPTIC_CUSTOM;
	return effect;
}

SDL_HapticDirection * bmx_sdl_haptic_SDLHapticCustom_Direction(SDL_HapticCustom * effect) {
	return &effect->direction;
}

void bmx_sdl_haptic_SDLHapticCustom_SetLength(SDL_HapticCustom * effect, Uint32 value) {
	effect->length = value;
}

void bmx_sdl_haptic_SDLHapticCustom_SetDelay(SDL_HapticCustom * effect, Uint16 value) {
	effect->delay = value;
}

void bmx_sdl_haptic_SDLHapticCustom_SetButton(SDL_HapticCustom * effect, Uint16 value) {
	effect->button = value;
}

void bmx_sdl_haptic_SDLHapticCustom_SetInterval(SDL_HapticCustom * effect, Uint16 value) {
	effect->interval = value;
}

void bmx_sdl_haptic_SDLHapticCustom_SetChannels(SDL_HapticCustom * effect, Uint8 value) {
	effect->channels = value;
}

void bmx_sdl_haptic_SDLHapticCustom_SetPeriod(SDL_HapticCustom * effect, Uint16 value) {
	effect->period = value;
}

void bmx_sdl_haptic_SDLHapticCustom_SetData(SDL_HapticCustom * effect, Uint16 * data, int samples) {
	effect->samples = samples;
	effect->data = data;
}

void bmx_sdl_haptic_SDLHapticCustom_SetAttackLength(SDL_HapticCustom * effect, Uint16 value) {
	effect->attack_length = value;
}

void bmx_sdl_haptic_SDLHapticCustom_SetAttackLevel(SDL_HapticCustom * effect, Uint16 value) {
	effect->attack_level = value;
}

void bmx_sdl_haptic_SDLHapticCustom_SetFadeLength(SDL_HapticCustom * effect, Uint16 value) {
	effect->fade_length = value;
}

void bmx_sdl_haptic_SDLHapticCustom_SetFadeLevel(SDL_HapticCustom * effect, Uint16 value) {
	effect->fade_level = value;
}

Uint32 bmx_sdl_haptic_SDLHapticCustom_GetLength(SDL_HapticCustom * effect) {
	return effect->length;
}

Uint16 bmx_sdl_haptic_SDLHapticCustom_GetDelay(SDL_HapticCustom * effect) {
	return effect->delay;
}

Uint16 bmx_sdl_haptic_SDLHapticCustom_GetButton(SDL_HapticCustom * effect) {
	return effect->button;
}

Uint16 bmx_sdl_haptic_SDLHapticCustom_GetInterval(SDL_HapticCustom * effect) {
	return effect->interval;
}

Uint16 bmx_sdl_haptic_SDLHapticCustom_GetAttackLength(SDL_HapticCustom * effect) {
	return effect->attack_length;
}

Uint16 bmx_sdl_haptic_SDLHapticCustom_GetAttackLevel(SDL_HapticCustom * effect) {
	return effect->attack_level;
}

Uint16 bmx_sdl_haptic_SDLHapticCustom_GetFadeLength(SDL_HapticCustom * effect) {
	return effect->fade_length;
}

Uint16 bmx_sdl_haptic_SDLHapticCustom_GetFadeLevel(SDL_HapticCustom * effect) {
	return effect->fade_level;
}

// --------------------------------------------------------

void bmx_sdl_haptic_SDLHapticDirection_SetType(SDL_HapticDirection * direction, int value) {
	direction->type = value;
}

void bmx_sdl_haptic_SDLHapticDirection_SetDir(SDL_HapticDirection * direction, Uint16 value1, Uint16 value2, Uint16 value3) {
	direction->dir[0] = value1;
	direction->dir[1] = value2;
	direction->dir[2] = value3;
}


