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
Strict

Module SDL.SDLMixerAudio

Import SDL.SDL
Import BRL.Audio
Import BRL.LinkedList

?win32
ModuleInfo "LD_OPTS: -L%PWD%/lib/win32x86"

?win32x64
ModuleInfo "LD_OPTS: -L%PWD%/lib/win32x64"

?macos
ModuleInfo "LD_OPTS: -F%PWD%/lib/macos"
ModuleInfo "LD_OPTS: -Xlinker -rpath -Xlinker @loader_path/../Frameworks"

?linuxx86
ModuleInfo "LD_OPTS: -L%PWD%/lib/linuxx86"

?linuxx64
ModuleInfo "LD_OPTS: -L%PWD%/lib/linuxx64"

?linuxarm

?

Import "include/*.h"

?win32
Import "-lSDL2_mixer"
?linux
Import "-lSDL2_mixer"
?macos
Import "-framework SDL2_mixer"
?

Import "common.bmx"


Private

Global _driver:TSDLMixerAudioDriver

Public

Const SOUND_STREAM:Int=4

Const AUDIO_U8:Int = $0008  ' Unsigned 8-bit samples
Const AUDIO_S8:Int = $8008  ' Signed 8-bit samples
Const AUDIO_U16LSB:Int = $0010  ' Unsigned 16-bit samples
Const AUDIO_S16LSB:Int = $8010  ' Signed 16-bit samples
Const AUDIO_U16MSB:Int = $1010  ' As above, but big-endian Byte order
Const AUDIO_S16MSB:Int = $9010  ' As above, but big-endian Byte order
Const AUDIO_U16:Int = AUDIO_U16LSB
Const AUDIO_S16:Int = AUDIO_S16LSB
?bigendian
Const MIX_DEFAULT_FORMAT:Int = AUDIO_S16MSB
?littleendian
Const MIX_DEFAULT_FORMAT:Int = AUDIO_S16
?

New TSDLMixerAudioDriver

Type TSDLMixerAudioDriver Extends TAudioDriver

	Method Name$()
		Return "SDLMixerAudio"
	End Method
	
	Method Startup()
		SDL_InitSubSystem(SDL_INIT_AUDIO)
		Mix_Init(0)
		If Mix_OpenAudio(22050, MIX_DEFAULT_FORMAT, 2, 4096) Then
			Return False
		End If
		
		_driver = Self
		
		TSDLMixerChannel._Init()

		Return True
	End Method
	
	Method Shutdown()
	End Method

	Method CreateSound:TSound( sample:TAudioSample,loop_flag:Int )
		'Return New TSound
	End Method
	
	Method AllocChannel:TChannel()
		Return TSDLMixerChannel._pop()
	End Method

	Method LoadSound:TSound( url:Object, flags:Int = 0)
		Return TSDLMixerSound.Load(url, flags)
	End Method
	
End Type

Type TSDLMixerSound Extends TSound

	Field audioPtr:Byte Ptr
	Field isStream:Int
	Field loop:Int

	Method Play:TChannel( alloced_channel:TChannel = Null )
		Local channel:TChannel

		If isStream Then
			' return allocated channel for music - we don't need it.
			If TSDLMixerChannel(alloced_channel) Then
				TSDLMixerChannel._push(TSDLMixerChannel(alloced_channel))
			End If
			channel = New TSDLMixerMusic
			If loop Then
				Mix_PlayMusic(audioPtr, -1)
			Else
				Mix_PlayMusic(audioPtr, 0)
			End If
			Return channel
		End If
		
		' play a chunk
		channel = alloced_channel
		' get a new channel if required
		If Not channel Then
			channel = TSDLMixerChannel._pop()
		End If
		
		If loop Then
			Mix_PlayChannelTimed(TSDLMixerChannel(channel).id, audioPtr, -1, -1)
		Else
			Mix_PlayChannelTimed(TSDLMixerChannel(channel).id, audioPtr, 0, -1)
		End If
		
		Return channel
	End Method
	
	Method Cue:TChannel( alloced_channel:TChannel = Null )
		Local channel:TChannel
		
		If isStream Then
			' return allocated channel for music - we don't need it.
			If TSDLMixerChannel(alloced_channel) Then
				TSDLMixerChannel._push(TSDLMixerChannel(alloced_channel))
			End If
			channel = New TSDLMixerMusic
			TSDLMixerMusic(channel).cuedSound = Self
			Return channel
		End If

		' cue a chunk
		channel = alloced_channel
		' get a new channel if required
		If Not channel Then
			channel = TSDLMixerChannel._pop()
		End If

		TSDLMixerChannel(channel).cuedSound = Self

		Return channel		
	End Method
	
	Function Load:TSound( url:Object, loop_flag:Int )
		Local stream:TStream
		Local sound:TSDLMixerSound

		If String(url) Then
			stream = ReadStream(url)
		Else If TStream(url) Then
			stream = TStream(url)
		End If
		
		If stream Then
			sound = New TSDLMixerSound
			If loop_flag & SOUND_STREAM Then
				sound.isStream = True
				sound.audioPtr = Mix_LoadMUS_RW(bmx_SDL_AllocRW_stream(stream), True)
			Else
				sound.audioPtr = Mix_LoadWAV_RW(bmx_SDL_AllocRW_stream(stream), True)
			End If

			If loop_flag & SOUND_LOOP Then
				sound.loop = True
			End If
		End If
		
		Return sound
	End Function
	
	Method Delete()
		If audioPtr Then
			If isStream Then
				Mix_FreeMusic(audioPtr)
			Else
				Mix_FreeChunk(audioPtr)
			End If
			audioPtr = Null
		End If
	End Method

End Type

Type TSDLMixerChannel Extends TChannel

	Field id:Int
	Field popped:Int
	Field cuedSound:TSDLMixerSound
	
	Global maxChannels:Int = 0
	
	Global channels:TList = New TList
	Global chanArray:TSDLMixerChannel[0]
	
	Global sdlMutex:Byte Ptr
	
	Function _Init()
		sdlMutex = SDL_CreateMutex()
		_AddChannels(8)
		Mix_ChannelFinished(_finished)
	End Function
	
	' add new channels
	Function _AddChannels(count:Int)
		chanArray = chanArray[..maxChannels + count]

		For Local i:Int = 0 Until count
			Local channel:TSDLMixerChannel = New TSDLMixerChannel
			channel.id = maxChannels
			channels.AddLast(channel)

			chanArray[maxChannels] = channel

			maxChannels :+ 1
		Next
		' increase allocation
		Mix_AllocateChannels(maxChannels)
	End Function
	
	' pop channel from stack
	' create more channels if required.
	Function _pop:TSDLMixerChannel()
		SDL_LockMutex(sdlMutex)

		If channels.IsEmpty() Then
			maxChannels :+ 4
			_AddChannels(4)
		End If
		
		Local channel:TSDLMixerChannel = TSDLMixerChannel(channels.First())
		channel.popped = True

		SDL_UnlockMutex(sdlMutex)
		
		Return channel
	End Function

	' add channel to stack
	Function _push(channel:TSDLMixerChannel)
		If channel.popped Then
			SDL_LockMutex(sdlMutex)

			channels.AddLast(channel)
			channel.popped = False

			SDL_UnlockMutex(sdlMutex)
		End If
	End Function
	
	' return channel to stack
	Function _finished(channel:Int)
		_push(chanArray[channel])
	End Function

	Method Stop()
		Mix_HaltChannel(id)
	End Method

	Method SetPaused( paused:Int )
		If cuedSound Then
			If Not paused Then
				If cuedSound.loop Then
					Mix_PlayChannelTimed(id, cuedSound.audioPtr, -1, -1)
				Else
					Mix_PlayChannelTimed(id, cuedSound.audioPtr, 0, -1)
				End If
				cuedSound = Null
			End If
			Return
		End If
		
		If paused Then
			Mix_Pause(id)
		Else
			Mix_Resume(id)
		End If
	End Method

	Method SetVolume( volume# )
		Mix_Volume(id, volume * 128)
	End Method

	Method SetPan( pan# )
		Local r:Int = 127 + (pan * 127)
		Mix_SetPanning(id, 254 - r, r)
	End Method

	Method SetDepth( depth# )
		' TODO
	End Method

	Method SetRate( rate# )
		' N/A ?
	End Method

	Method Playing:Int()
		Return Mix_Playing(id)
	End Method

End Type

Type TSDLMixerMusic Extends TChannel

	Field cuedSound:TSDLMixerSound

	Method Stop()
		Mix_HaltMusic()
	End Method

	Method SetPaused( paused:Int )
		If cuedSound Then
			If Not paused Then
				If cuedSound.loop Then
					Mix_PlayMusic(cuedSound.audioPtr, -1)
				Else
					Mix_PlayMusic(cuedSound.audioPtr, 0)
				End If
				cuedSound = Null
			End If
			Return
		End If

		If paused Then
			Mix_PauseMusic()
		Else
			Mix_ResumeMusic()
		End If
	End Method

	Method SetVolume( volume# )
		Mix_VolumeMusic(volume * 128)
	End Method

	Method SetPan( pan# )
		' N/A
	End Method

	Method SetDepth( depth# )
		' N/A
	End Method

	Method SetRate( rate# )
		' N/A ?
	End Method

	Method Playing:Int()
		Return Mix_PlayingMusic()
	End Method

End Type
