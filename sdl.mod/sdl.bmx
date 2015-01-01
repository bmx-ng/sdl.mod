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

?macos
ModuleInfo "LD_OPTS: -F%PWD%/lib/macos"
ModuleInfo "LD_OPTS: -Xlinker -rpath -Xlinker @loader_path/../Frameworks"
Import "include/macos/*.h"

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

Import "SDL/include/*.h"
?

?Not android
Import "include/*.h"
?

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
?macos
Import "-framework SDL2"
?linux
Import "-ldl"
?


Import "common.bmx"

Import "glue.c"


Type TSDLStream Extends TStream

	Field filePtr:Byte Ptr

	Method Pos:Long()
		Return SDL_RWtell(filePtr)
	End Method

	Method Size:Long()
		Return SDL_RWsize(filePtr)
	End Method

	Method Seek:Long( pos:Long, whence:Int = SEEK_SET_ )
		Return SDL_RWseek(filePtr, pos, whence)
	End Method

	Method Read:Long( buf:Byte Ptr,count:Long )
		Return SDL_RWread(filePtr, buf, count, 1)
	End Method

	Method Write:Long( buf:Byte Ptr,count:Long )
		Return SDL_RWwrite(filePtr, buf, count, 1)
	End Method

	Method Close:Int()
		If filePtr Then
			SDL_RWclose(filePtr)
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

