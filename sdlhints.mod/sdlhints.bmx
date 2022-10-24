' Copyright (c) 2022 Bruce A Henderson
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
bbdoc: SDL Hints
End Rem
Module SDL.SDLHints

Import "common.bmx"

Rem
bbdoc: Resets a hint to the default value.
returns: #True if the hint was set, #False otherwise
about: This will reset a hint to the value of the environment variable, or #Null if
the environment isn't set. Callbacks will be called normally with this change.
End Rem
Function SDLResetHint:Int(name:String)
	Local n:Byte Ptr = name.ToUTF8String()
	Local result:Int = SDL_ResetHint(n)
	MemFree(n)
	Return result
End Function

Rem
bbdoc: Resets all hints to the default values.
about: This will reset all hints to the value of the associated environment
variable, or #Null if the environment isn't set. Callbacks will be called normally with this change.
End Rem
Function ResetHints()
	SDL_ResetHints()
End Function

Rem
bbdoc: Gets the value of a hint.
about: The string value of a hint or #Null if the hint isn't set.
End Rem
Function SDLGetHint:String(name:String)
	Local n:Byte Ptr = name.ToUTF8String()
	Local v:Byte Ptr = SDL_GetHint(n)
	MemFree(n)
	If v Then
		Return String.FromUTF8String(v)
	End If
End Function

Rem
bbdoc: Sets a hint with normal priority.
returns: #True if the hint was set, #False otherwise.
about: Hints will not be set if there is an existing override hint or environment
variable that takes precedence. You can use #SDLSetHintWithPriority() to
set the hint with override priority instead.
End Rem
Function SDLSetHint:Int(name:String, value:String)
	Local n:Byte Ptr = name.ToUTF8String()
	Local v:Byte Ptr = value.ToUTF8String()
	Local result:Int = SDL_SetHint(n, v)
	MemFree(v)
	MemFree(n)
	Return result
End Function
