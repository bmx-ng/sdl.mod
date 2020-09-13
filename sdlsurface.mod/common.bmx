' Copyright (c) 2014-2020 Bruce A Henderson
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

	Function SDL_CreateRGBSurface:Byte Ptr(flags:UInt, width:Int, height:Int, depth:Int, Rmask:UInt, Gmask:UInt, Bmask:UInt, Amask:UInt)
	Function SDL_CreateRGBSurfaceWithFormat:Byte Ptr(flags:UInt, width:Int, height:Int, depth:Int, format:UInt)
	Function SDL_CreateRGBSurfaceFrom:Byte Ptr(pixels:Byte Ptr, width:Int, height:Int, depth:Int, pitch:Int, Rmask:UInt, Gmask:UInt, Bmask:UInt, Amask:UInt)
	Function SDL_FreeSurface(handle:Byte Ptr)

	Function SDL_LockSurface:Int(handle:Byte Ptr)
	Function SDL_UnlockSurface:Int(handle:Byte Ptr)
	Function SDL_SetColorKey:Int(handle:Byte Ptr, flag:Int, key:UInt)
	Function SDL_SetSurfaceAlphaMod:Int(handle:Byte Ptr, alpha:Byte)
	Function SDL_SetSurfaceBlendMode:Int(handle:Byte Ptr, blendMode:Int)
	Function SDL_SetSurfaceColorMod:Int(handle:Byte Ptr, r:Byte, g:Byte, b:Byte)
	Function SDL_SetSurfaceRLE:Int(handle:Byte Ptr, flag:Int)
	Function SDL_GetColorKey:Int(handle:Byte Ptr, key:UInt Ptr) 
	Function SDL_GetSurfaceAlphaMod:Int(handle:Byte Ptr, alpha:Byte Ptr)
	Function SDL_GetSurfaceBlendMode:Int(handle:Byte Ptr, blendMode:Int Ptr)
	Function SDL_GetSurfaceColorMod:Int(handle:Byte Ptr, r:Byte Ptr, g:Byte Ptr, b:Byte Ptr)
	Function SDL_ConvertSurfaceFormat:Byte Ptr(handle:Byte Ptr, pixelFormat:UInt, flags:UInt)
	Function SDL_ConvertSurface:Byte Ptr(handle:Byte Ptr, format:Byte Ptr, flags:UInt)
	Function SDL_FillRects:Int(handle:Byte Ptr, rects:Int Ptr, count:Int, color:UInt)
	
	Function bmx_sdl_surface_Format:Byte Ptr(handle:Byte Ptr)
	Function bmx_sdl_surface_Width:Int(handle:Byte Ptr)
	Function bmx_sdl_surface_Height:Int(handle:Byte Ptr)
	Function bmx_sdl_surface_Pitch:Int(handle:Byte Ptr)
	Function bmx_sdl_surface_Pixels:Byte Ptr(handle:Byte Ptr)
	Function bmx_sdl_surface_GetClipRect(handle:Byte Ptr, x:Int Ptr, y:Int Ptr, w:Int Ptr, h:Int Ptr)
	Function bmx_sdl_surface_SetClipRect(handle:Byte Ptr, x:Int, y:Int, w:Int, h:Int)
	Function bmx_sdl_surface_MustLock:Int(handle:Byte Ptr)
	Function bmx_sdl_surface_FillRect:Int(handle:Byte Ptr, x:Int, y:Int, w:Int, h:Int, color:UInt)
	Function bmx_sdl_surface_Blit:Int(handle:Byte Ptr, sx:Int, sy:Int, sw:Int, sh:Int, dest:Byte Ptr, dx:Int, dy:Int)
	Function bmx_sdl_surface_BlitScaled:Int(handle:Byte Ptr, sx:Int, sy:Int, sw:Int, sh:Int, dest:Byte Ptr, dx:Int, dy:Int)
	
	Function bmx_sdl_LoadBMP:Byte Ptr(file:String)
	
End Extern

Rem
bbdoc: no blending
about: dstRGBA = srcRGBA 
End Rem
Const SDL_BLENDMODE_NONE:Int = $00000000

Rem
bbdoc: alpha blending
about: dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))
<p>dstA = srcA + (dstA * (1-srcA)) </p>
End Rem
Const SDL_BLENDMODE_BLEND:Int = $00000001

Rem
bbdoc: additive blending
about: dstRGB = (srcRGB * srcA) + dstRGB
<p>dstA = dstA</p>
End Rem
Const SDL_BLENDMODE_ADD:Int = $00000002

Rem
bbdoc: color modulate
about: dstRGB = srcRGB * dstRGB
<p>dstA = dstA</p>
End Rem
Const SDL_BLENDMODE_MOD:Int = $00000004

Rem
bbdoc: dst + src: supported by all renderers
End Rem
Const SDL_BLENDOPERATION_ADD:Int = $1
Rem
bbdoc: dst - src : supported by D3D9, D3D11, OpenGL, OpenGLES
End Rem
Const SDL_BLENDOPERATION_SUBTRACT:Int = $2
Rem
bbdoc: src - dst : supported by D3D9, D3D11, OpenGL, OpenGLES
End Rem
Const SDL_BLENDOPERATION_REV_SUBTRACT:Int = $3
Rem
bbdoc: min(dst, src) : supported by D3D11
End Rem
Const SDL_BLENDOPERATION_MINIMUM:Int = $4
Rem
bbdoc: max(dst, src) : supported by D3D11
End Rem
Const SDL_BLENDOPERATION_MAXIMUM:Int = $5

Rem
bbdoc: 0, 0, 0, 0
End Rem
Const SDL_BLENDFACTOR_ZERO:Int = $1
Rem
bbdoc: 1, 1, 1, 1
End Rem
Const SDL_BLENDFACTOR_ONE:Int = $2
Rem
bbdoc: srcR, srcG, srcB, srcA
End Rem
Const SDL_BLENDFACTOR_SRC_COLOR:Int = $3
Rem
bbdoc: 1-srcR, 1-srcG, 1-srcB, 1-srcA
End Rem
Const SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR:Int = $4
Rem
bbdoc: srcA, srcA, srcA, srcA
End Rem
Const SDL_BLENDFACTOR_SRC_ALPHA:Int = $5
Rem
bbdoc: 1-srcA, 1-srcA, 1-srcA, 1-srcA
End Rem
Const SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA:Int = $6
Rem
bbdoc: dstR, dstG, dstB, dstA
End Rem
Const SDL_BLENDFACTOR_DST_COLOR:Int = $7
Rem
bbdoc: 1-dstR, 1-dstG, 1-dstB, 1-dstA
End Rem
Const SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR:Int = $8
Rem
bbdoc: dstA, dstA, dstA, dstA
End Rem
Const SDL_BLENDFACTOR_DST_ALPHA:Int = $9
Rem
bbdoc: 1-dstA, 1-dstA, 1-dstA, 1-dstA
end rem
Const SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA:Int = $A


