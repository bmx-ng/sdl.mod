' simple stream example.

SuperStrict

Framework brl.standardio
Import SDL.SDLAudio

SetAudioDriver("SDLAudio")

Local sound:TSound = LoadSound("media/I Wish (You Were Mine).ogg", SOUND_STREAM)

If sound Then
	Print "Sound loaded"
Else
Print " :( "
	End
End If

Local channel:TChannel = CueSound(sound)

' wait for it...
Delay(1000)

' just to prove the cueing works!
channel.SetPaused(False)

' keep ticking until the music has finished
Repeat
	Delay(500)
	Print "tick..."
Until Not channel.Playing()
