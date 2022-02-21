' Copyright (c) 2014-2022 Bruce A Henderson
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

	Function SDL_CreateRenderer:Byte Ptr(window:Byte Ptr, index:Int, flags:UInt)
	Function SDL_CreateSoftwareRenderer:Byte Ptr(surface:Byte Ptr)
	Function SDL_DestroyRenderer(handle:Byte Ptr)
	Function SDL_CreateTexture:Byte Ptr(handle:Byte Ptr, format:UInt, access:Int, width:Int, height:Int)
	Function SDL_CreateTextureFromSurface:Byte Ptr(handle:Byte Ptr, surface:Byte Ptr)
	Function SDL_RenderClear:Int(handle:Byte Ptr)
	Function SDL_RenderDrawLine:Int(handle:Byte Ptr, x1:Int, y1:Int, x2:Int, y2:Int)
	Function SDL_RenderDrawLines:Int(handle:Byte Ptr, points:Int Ptr, count:Int)
	Function SDL_RenderDrawPoint:Int(handle:Byte Ptr, x:Int, y:Int)
	Function SDL_RenderDrawPoints:Int(handle:Byte Ptr, points:Int Ptr, count:Int)
	Function SDL_RenderDrawRects:Int(handle:Byte Ptr, rects:Int Ptr, count:Int)
	Function SDL_RenderFillRects:Int(handle:Byte Ptr, rects:Int Ptr, count:Int)
	Function SDL_RenderGetIntegerScale:Int(handle:Byte Ptr)
	Function SDL_RenderGetLogicalSize(handle:Byte Ptr, w:Int Ptr, h:Int Ptr)
	Function SDL_RenderGetScale(handle:Byte Ptr, x:Float Ptr, y:Float Ptr)
	Function SDL_RenderIsClipEnabled:Int(handle:Byte Ptr)
	Function SDL_RenderPresent(handle:Byte Ptr)
	Function SDL_GetRenderDrawBlendMode:Int(handle:Byte Ptr, blendMode:Int Ptr)
	Function SDL_GetRenderDrawColor:Int(handle:Byte Ptr, r:Byte Ptr, g:Byte Ptr, b:Byte Ptr, a:Byte Ptr)
	Function SDL_GetRenderTarget:Byte Ptr(handle:Byte Ptr)
	Function SDL_GetRendererOutputSize:Int(handle:Byte Ptr, w:Int Ptr, h:Int Ptr)
	Function SDL_RenderSetIntegerScale:Int(handle:Byte Ptr, enable:Int)
	Function SDL_RenderSetLogicalSize:Int(handle:Byte Ptr, w:Int, h:Int)
	Function SDL_RenderSetScale:Int(handle:Byte Ptr, scaleX:Float, scaleY:Float)
	Function SDL_RenderTargetSupported:Int(handle:Byte Ptr)
	Function SDL_SetRenderDrawBlendMode:Int(handle:Byte Ptr, blendMode:Int)
	Function SDL_SetRenderDrawColor:Int(handle:Byte Ptr, r:Byte, g:Byte, b:Byte, a:Byte)
	Function SDL_SetRenderTarget:Int(handle:Byte Ptr, texture:Byte Ptr)
	Function SDL_GetRenderer:Byte Ptr(window:Byte Ptr)
	Function SDL_RenderGeometry:Int(handle:Byte Ptr, texture:Byte Ptr, vertices:SDLVertex Ptr, numVertices:Int, indices:Int Ptr, numIndices:Int)
	Function SDL_GetRendererInfo(handle:Byte Ptr, info:SDLRendererInfo Var)
	Function SDL_GetRenderDriverInfo:Int(index:Int, info:SDLRendererInfo Var)

	Function SDL_GetTextureAlphaMod:Int(handle:Byte Ptr, alpha:Byte Ptr)
	Function SDL_GetTextureBlendMode:Int(handle:Byte Ptr, blendMode:Int Ptr)
	Function SDL_GetTextureColorMod:Int(handle:Byte Ptr, r:Byte Ptr, g:Byte Ptr, b:Byte Ptr)
	Function SDL_QueryTexture:Int(handle:Byte Ptr, format:UInt Ptr, access:Int Ptr, w:Int Ptr, h:Int Ptr)
	Function SDL_SetTextureAlphaMod:Int(handle:Byte Ptr, alpha:Byte)
	Function SDL_SetTextureBlendMode:Int(handle:Byte Ptr, blendMode:Int)
	Function SDL_SetTextureColorMod:Int(handle:Byte Ptr, r:Byte, g:Byte, b:Byte) 
	Function SDL_UnlockTexture(handle:Byte Ptr)
	Function SDL_DestroyTexture(handle:Byte Ptr)

	Function SDL_GetNumRenderDrivers:Int()
	
	Function bmx_SDL_RenderCopy:Int(handle:Byte Ptr, texture:Byte Ptr, sx:Int, sy:Int, sw:Int, sh:Int, dx:Int, dy:Int, dw:Int, dh:Int)
	Function bmx_SDL_RenderDrawRect:Int(handle:Byte Ptr, x:Int, y:Int, w:Int, h:Int)
	Function bmx_SDL_RenderFillRect:Int(handle:Byte Ptr, x:Int, y:Int, w:Int, h:Int)
	Function bmx_SDL_RenderGetClipRect(handle:Byte Ptr, x:Int Ptr, y:Int Ptr, w:Int Ptr, h:Int Ptr)
	Function bmx_SDL_RenderGetViewport(handle:Byte Ptr, x:Int Ptr, y:Int Ptr, w:Int Ptr, h:Int Ptr)
	Function bmx_SDL_RenderReadPixels:Int(handle:Byte Ptr, format:UInt, pixels:Byte Ptr, pitch:Int, x:Int, y:Int, w:Int, h:Int)
	Function bmx_SDL_RenderSetClipRect:Int(handle:Byte Ptr, x:Int, y:Int, w:Int, h:Int)
	Function bmx_SDL_RenderSetViewport:Int(handle:Byte Ptr, x:Int, y:Int, w:Int, h:Int)
	Function bmx_SDL_RenderCopyEx:Int(handle:Byte Ptr, texture:Byte Ptr, sx:Int, sy:Int, sw:Int, sh:Int, dx:Int, dy:Int, dw:Int, dh:Int, angle:Double, cx:Int, cy:Int, flipMode:Int)

	Function bmx_SDL_LockTexture:Int(handle:Byte Ptr, pixels:Byte Ptr Ptr, pitch:Int Ptr, x:Int, y:Int, w:Int, h:Int)
	Function bmx_SDL_UpdateTexture:Int(handle:Byte Ptr, pixels:Byte Ptr, pitch:Int, x:Int, y:Int, w:Int, h:Int)
	Function bmx_SDL_UpdateYUVTexture:Int(handle:Byte Ptr, yPlane:Byte Ptr, yPitch:Int, uPlane:Byte Ptr, uPitch:Int, vPlane:Byte Ptr, vPitch:Int, x:Int, y:Int, w:Int, h:Int)

End Extern


Rem
bbdoc: Changes rarely, not lockable
End Rem
Const SDL_TEXTUREACCESS_STATIC:UInt = 0

Rem
bbdoc: Changes frequently, lockable
End Rem
Const SDL_TEXTUREACCESS_STREAMING:UInt = 1

Rem
bbdoc: Can be used as a render target
End Rem
Const SDL_TEXTUREACCESS_TARGET:UInt = 2

Rem
bbdoc: Do not flip
End Rem
Const SDL_FLIP_NONE:Int = 0
Rem
bbdoc: Flip horizontally
End Rem
Const SDL_FLIP_HORIZONTAL:Int = 1

Rem
bbdoc: Flip vertically
End Rem
Const SDL_FLIP_VERTICAL:Int = 2

Rem
bbdoc: The renderer is a software fallback
End Rem
Const SDL_RENDERER_SOFTWARE:Int = $01
Rem
bbdoc: The renderer uses hardware acceleration
End Rem
Const SDL_RENDERER_ACCELERATED:Int = $02
Rem
bbdoc: Present is synchronized with the refresh rate
End Rem
Const SDL_RENDERER_PRESENTVSYNC:Int = $04
Rem
bbdoc: The renderer supports rendering to texture
End Rem
Const SDL_RENDERER_TARGETTEXTURE:Int = $08


Struct SDLFPoint
	Field x:Float
	Field y:Float
End Struct

Struct SDLColor
	Field r:Byte
	Field g:Byte
	Field b:Byte
	Field a:Byte

	Method New(r:Byte, g:Byte, b:Byte, a:Byte)
		self.r = r
		self.g = g
		self.b = b
		self.a = a
	End Method
End Struct

Struct SDLVertex
	Field position:SDLFPoint
    Field color:SDLColor
    Field texCoord:SDLFPoint
End Struct

Rem
bbdoc: A structure that contains information on the capabilities of a render driver or the current render context.
End Rem
Struct SDLRendererInfo
	Field name:Byte Ptr
	Rem
	bbdoc: A mask of supported renderer flags
	End Rem
	Field flags:UInt
	Rem
	bbdoc: The number of available texture formats
	End Rem
	Field numTextureFormats:UInt
	Rem
	bbdoc: The available texture formats
	End Rem
	Field StaticArray textureFormats:UInt[16]
	Rem
	bbdoc: The maximum texture width
	End Rem
	Field maxTextureWidth:Int
	Rem
	bbdoc: The maximum texture height
	End Rem
	Field maxTextureHeight:Int

	Rem
	bbdoc: Returns the name of the renderer.
	End Rem
	Method GetName:String()
		Return String.FromUTF8String(name)
	End Method
End Struct
