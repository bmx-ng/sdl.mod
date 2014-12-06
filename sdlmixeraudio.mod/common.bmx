' Copyright (c) 2014 Bruce A Henderson
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

	Function Mix_Init:Int(flags:Int)
	Function Mix_OpenAudio:Int(freq:Int, format:Int, channels:Int, chuksize:Int)
	Function Mix_GetError:Byte Ptr()

	Function Mix_HaltChannel:Int(id:Int)
	Function Mix_Pause:Int(id:Int)
	Function Mix_Resume:Int(id:Int)
	Function Mix_Volume:Int(id:Int, volume:Int)
	Function Mix_SetPanning:Int(id:Int, l:Int, r:Int)
	Function Mix_Playing:Int(id:Int)
	Function Mix_AllocateChannels:Int(count:Int)

	Function Mix_LoadMUS_RW:Byte Ptr(ops:Byte Ptr, freesrc:Int)
	Function Mix_FreeMusic(mus:Byte Ptr)
	Function Mix_PlayMusic:Int(music:Byte Ptr, loops:Int)
	Function Mix_HaltMusic:Int()
	Function Mix_PauseMusic:Int()
	Function Mix_ResumeMusic:Int()
	Function Mix_VolumeMusic:Int(vol:Int)
	Function Mix_PlayingMusic:Int()
	
	Function Mix_LoadWAV_RW:Byte Ptr(ops:Byte Ptr, freesrc:Int)
	Function Mix_FreeChunk(chunk:Byte Ptr)
	Function Mix_PlayChannelTimed:Int(channel:Int, chunks:Byte Ptr, loops:Int, time:Int)
	
	Function Mix_ChannelFinished(callback(channel:Int))
	
End Extern


