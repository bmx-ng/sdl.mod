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

Import SDL.SDL

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

?emscripten
Import "../../sdl.mod/sdl.mod/include/emscripten/*.h"

?ios
Import "../../sdl.mod/sdl.mod/include/ios/*.h"

?haikux64
Import "../../sdl.mod/sdl.mod/include/haikux64/*.h"

?

Import "../../sdl.mod/sdl.mod/SDL/include/*.h"

Import "glue.c"
?raspberrypi
Import "rpi_glue.c"
?

Extern

	Function bbSDLGraphicsGraphicsModes:Int( display:Int, buf:Byte Ptr,size:Int )
	Function bbSDLGraphicsShareContexts()
	'Function bbSDLGraphicsAttachGraphics:Byte Ptr( widget:Byte Ptr,flags )
	Function bbSDLGraphicsCreateGraphics:Byte Ptr( width:Int,height:Int,depth:Int,hertz:Int,flags:Int )
	Function bbSDLGraphicsGetSettings( context:Byte Ptr,width:Int Var,height:Int Var,depth:Int Var,hertz:Int Var,flags:Int Var )
	Function bbSDLGraphicsClose( context:Byte Ptr )	
	Function bbSDLGraphicsSetGraphics( context:Byte Ptr )
	Function bbSDLGraphicsFlip( sync:Int )
	Function bbSDLExit()
	Function bbSDLGraphicsGetHandle:Byte Ptr(context:Byte Ptr)
	
	Function SDL_GetNumVideoDisplays:Int()
	
	
	' system stuff
'	Function SDL_ShowCursor(visible:Int)
	Function bmx_SDL_WarpMouseInWindow(x:Int, y:Int)
	
?raspberrypi
	Function bmx_tvservice_init()
	Function bmx_tvservice_modes:Int(modes:Byte Ptr, maxcount:Int, withMode:Int)
	Function bmx_reset_screen()
?
	
'	Function bmx_SDL_GetDisplayWidth:Int(display:Int)
'	Function bmx_SDL_GetDisplayHeight:Int(display:Int)
'	Function bmx_SDL_GetDisplayDepth:Int(display:Int)
'	Function bmx_SDL_GetDisplayhertz:Int(display:Int)

'	Function bmx_SDL_Poll()
'	Function bmx_SDL_WaitEvent()
	
End Extern
Rem
Const SDL_WINDOW_FULLSCREEN:Int = $00000001         ' fullscreen window
Const SDL_WINDOW_OPENGL:Int = $00000002             ' window usable with OpenGL context
Const SDL_WINDOW_SHOWN:Int = $00000004              ' window is visible
Const SDL_WINDOW_HIDDEN:Int = $00000008             ' window is Not visible
Const SDL_WINDOW_BORDERLESS:Int = $00000010         ' no window decoration
Const SDL_WINDOW_RESIZABLE:Int = $00000020          ' window can be resized
Const SDL_WINDOW_MINIMIZED:Int = $00000040          ' window is minimized
Const SDL_WINDOW_MAXIMIZED:Int = $00000080          ' window is maximized
Const SDL_WINDOW_INPUT_GRABBED:Int = $00000100      ' window has grabbed Input focus
Const SDL_WINDOW_INPUT_FOCUS:Int = $00000200        ' window has Input focus
Const SDL_WINDOW_MOUSE_FOCUS:Int = $00000400        ' window has mouse focus
Const SDL_WINDOW_FULLSCREEN_DESKTOP:Int = SDL_WINDOW_FULLSCREEN | $00001000
Const SDL_WINDOW_FOREIGN:Int = $00000800            ' window Not created by SDL
Const SDL_WINDOW_ALLOW_HIGHDPI:Int = $00002000       ' window should be created in high-DPI Mode If supported
End Rem
Const GRAPHICS_RPI_TV_FULLSCREEN:Int = $1000
Const GRAPHICS_WIN32_DX:Int = $1000000

Const SDL_GRAPHICS_BACKBUFFER:Int    = $00800000
Const SDL_GRAPHICS_ALPHABUFFER:Int   = $01000000
Const SDL_GRAPHICS_DEPTHBUFFER:Int   = $02000000
Const SDL_GRAPHICS_STENCILBUFFER:Int = $04000000
Const SDL_GRAPHICS_ACCUMBUFFER:Int   = $08000000

Const SDL_GRAPHICS_GL:Int            = $20000000
Const SDL_GRAPHICS_NATIVE:Int        = $40000000
