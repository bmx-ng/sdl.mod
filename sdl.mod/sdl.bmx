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

Rem
bbdoc: SDL Core
End Rem
Module SDL.SDL

ModuleInfo "Version: 1.00"
ModuleInfo "License: zlib/libpng"

ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release."

?win32x86
ModuleInfo "LD_OPTS: -L%PWD%/lib/win32x86"
Import "include/win32x86/*.h"

?win32x64
ModuleInfo "LD_OPTS: -L%PWD%/lib/win32x64"
Import "include/win32x64/*.h"

?osx
ModuleInfo "CC_OPTS: -mmmx -msse -msse2 -DTARGET_API_MAC_CARBON -DTARGET_API_MAC_OSX"

Import "include/macos/*.h"

Import "-framework AudioUnit"
Import "-framework CoreAudio"
Import "-framework IOKit"
Import "-framework CoreVideo"
Import "-framework ForceFeedback"

?linuxx86
ModuleInfo "LD_OPTS: -L%PWD%/lib/linuxx86"

Import "include/linuxx86/*.h"
?linuxx64
ModuleInfo "LD_OPTS: -L%PWD%/lib/linuxx64"

Import "include/linuxx64/*.h"
?raspberrypi
ModuleInfo "LD_OPTS: -L%PWD%/lib/raspberrypi"

Import "include/raspberrypi/*.h"
?android
ModuleInfo "CC_OPTS: -DGL_GLEXT_PROTOTYPES"

Import "include/android/*.h"
?emscripten
ModuleInfo "CC_OPTS: -DUSING_GENERATED_CONFIG_H"

Import "include/emscripten/*.h"
?ios
ModuleInfo "CC_OPTS: -fobjc-arc"

Import "include/ios/*.h"
?win32
Import "-lSDL2main"
Import "-lSDL2"
Import "-limm32" ' required in BlitzMax/lib
Import "-lole32"
Import "-loleaut32"
Import "-lshell32"
Import "-lversion" ' required in BlitzMax/lib
?linuxx86
Import "-lSDL2"
?linuxx64
Import "-lSDL2"
?raspberrypi
Import "-lSDL2"
?linux
Import "-ldl"
?

Import "SDL/include/*.h"

Import "common.bmx"

Import "glue.c"


Type TSDLStream Extends TStream

	Field filePtr:Byte Ptr

	Method Pos:Long()
		Return bmx_SDL_RWtell(filePtr)
	End Method

	Method Size:Long()
		Return bmx_SDL_RWsize(filePtr)
	End Method

	Method Seek:Long( pos:Long, whence:Int = SEEK_SET_ )
		Return bmx_SDL_RWseek(filePtr, pos, whence)
	End Method

	Method Read:Long( buf:Byte Ptr,count:Long )
		Return bmx_SDL_RWread(filePtr, buf, count, 1)
	End Method

	Method Write:Long( buf:Byte Ptr,count:Long )
		Return bmx_SDL_RWwrite(filePtr, buf, count, 1)
	End Method

	Method Close:Int()
		If filePtr Then
			bmx_SDL_RWclose(filePtr)
			filePtr = Null
		End If
	End Method

	Method Delete()
		Close()
	End Method

	Function Create:TSDLStream( file:String, readable:Int, writeable:Int )
		Local stream:TSDLStream=New TSDLStream
		Local Mode:String

		If readable And writeable
			Mode="r+b"
		Else If writeable
			Mode="wb"
		Else
			Mode="rb"
		EndIf

		Local f:Byte Ptr = file.ToUTF8String()		
		stream.filePtr = SDL_RWFromFile(f, Mode)
		MemFree(f)
		
		If Not stream.filePtr Then
			Return Null
		End If
		
		Return stream
	End Function

End Type

Function CreateSDLStream:TSDLStream( file:String, readable:Int, writeable:Int )
	Return TSDLStream.Create( file, readable, writeable )
End Function

Type TSDLStreamFactory Extends TStreamFactory

	Method CreateStream:TStream( url:Object, proto$, path$, readable:Int, writeable:Int )
		If proto="sdl" Then
			Return TSDLStream.Create( path, readable, writeable )
		End If
	End Method
	
End Type

Function _sdl_rwops_seek:Int(stream:TStream, pos:Long, whence:Int)
	Return stream.seek(pos, whence)
End Function

Function _sdl_rwops_read:Long(stream:TStream, buf:Byte Ptr, count:Long)
	Return stream.read(buf, count)
End Function

Function _sdl_rwops_write:Long(stream:TStream, buf:Byte Ptr, count:Long)
	Return stream.write(buf, count)
End Function

Function _sdl_rwops_close:Int(stream:TStream)
	Return stream.close()
End Function

