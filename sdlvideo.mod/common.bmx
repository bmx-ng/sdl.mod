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

	Function bmx_sdl_video_GetVideoDrivers:String[]()
	Function bmx_sdl_video_VideoInit:Int(driver:String)
	Function bmx_sdl_video_GetDisplayBounds:Int(index:Int, w:Int Ptr, h:Int Ptr)
	Function bmx_sdl_video_GetDisplayUsableBounds:Int(index:Int, w:Int Ptr, h:Int Ptr)
	Function bmx_sdl_video_GetDisplayMode:Byte Ptr(index:Int, modeIndex:Int)
	Function bmx_sdl_video_GetDesktopDisplayMode:Byte Ptr(index:Int)
	Function bmx_sdl_video_GetCurrentDisplayMode:Byte Ptr(index:Int)
	Function bmx_sdl_video_SDL_GetCurrentVideoDriver:String()

	Function SDL_GetNumVideoDisplays:Int()
	Function SDL_GetDisplayName:Byte Ptr(index:Int)
	Function SDL_GetDisplayDPI:Int(index:Int, ddpi:Float Ptr, hdpi:Float Ptr, vdpi:Float Ptr)
	Function SDL_GetNumDisplayModes:Int(index:Int)

	Function bmx_sdl_video_DisplayMode_new:Byte Ptr(format:UInt, width:Int, height:Int, refreshRate:Int)
	Function bmx_sdl_video_DisplayMode_free(handle:Byte Ptr)
	Function bmx_sdl_video_DisplayMode_format:UInt(handle:Byte Ptr)
	Function bmx_sdl_video_DisplayMode_width:Int(handle:Byte Ptr)
	Function bmx_sdl_video_DisplayMode_height:Int(handle:Byte Ptr)
	Function bmx_sdl_video_DisplayMode_refreshRate:Int(handle:Byte Ptr)
	Function bmx_sdl_video_DisplayMode_driverData:Byte Ptr(handle:Byte Ptr)
	Function bmx_sdl_video_GetClosestDisplayMode:Byte Ptr(handle:Byte Ptr, index:Int)

	Function bmx_sdl_video_CreateWindow:Byte Ptr(title:String, x:Int, y:Int, w:Int, h:Int, flags:UInt)
	Function bmx_sdl_video_GetWindowDisplayMode:Byte Ptr(handle:Byte Ptr)
	Function bmx_sdl_video_SetWindowTitle(handle:Byte Ptr, title:String)
	Function bmx_sdl_video_GetWindowHandle:Byte Ptr(handle:Byte Ptr)

	Function SDL_GetWindowDisplayIndex:Int(handle:Byte Ptr)
	Function SDL_GetWindowPixelFormat:UInt(handle:Byte Ptr)
	Function SDL_GetWindowID:UInt(handle:Byte Ptr)
	Function SDL_SetWindowDisplayMode:Int(handle:Byte Ptr, Mode:Byte Ptr)
	Function SDL_ShowWindow(handle:Byte Ptr)
	Function SDL_HideWindow(handle:Byte Ptr)
	Function SDL_RaiseWindow(handle:Byte Ptr)
	Function SDL_MaximizeWindow(handle:Byte Ptr)
	Function SDL_MinimizeWindow(handle:Byte Ptr)
	Function SDL_GetWindowTitle:Byte Ptr(handle:Byte Ptr)
	Function SDL_SetWindowPosition(handle:Byte Ptr, x:Int, y:Int)
	Function SDL_GetWindowPosition(handle:Byte Ptr, x:Int Ptr, y:Int Ptr)
	Function SDL_SetWindowSize(handle:Byte Ptr, w:Int, h:Int)
	Function SDL_GetWindowSize(handle:Byte Ptr, w:Int Ptr, h:Int Ptr)
	Function SDL_GetWindowBordersSize:Int(handle:Byte Ptr, wTop:Int Ptr, wLeft:Int Ptr, wBottom:Int Ptr, wRight:Int Ptr)
	Function SDL_SetWindowMinimumSize(handle:Byte Ptr, w:Int, h:Int)
	Function SDL_GetWindowMinimumSize(handle:Byte Ptr, w:Int Ptr, h:Int Ptr)
	Function SDL_SetWindowMaximumSize(handle:Byte Ptr, w:Int, h:Int)
	Function SDL_GetWindowMaximumSize(handle:Byte Ptr, w:Int Ptr, h:Int Ptr)
	Function SDL_SetWindowBordered(handle:Byte Ptr, bordered:Int)
	Function SDL_SetWindowResizable(handle:Byte Ptr, resizable:Int)
	Function SDL_SetWindowFullscreen:Int(handle:Byte Ptr, flags:UInt)
	Function SDL_GetWindowSurface:Byte Ptr(handle:Byte Ptr)
	Function SDL_UpdateWindowSurface:Int(handle:Byte Ptr)
	Function SDL_SetWindowGrab(handle:Byte Ptr, grabbed:Int)
	Function SDL_GetWindowGrab:Int(handle:Byte Ptr)
	Function SDL_SetWindowBrightness:Int(handle:Byte Ptr, brightness:Float)
	Function SDL_GetWindowBrightness:Float(handle:Byte Ptr)
	Function SDL_SetWindowOpacity:Int(handle:Byte Ptr, opacity:Float)
	Function SDL_GetWindowOpacity:Int(handle:Byte Ptr, opacity:Float Ptr)
	Function SDL_SetWindowModalFor:Int(handle:Byte Ptr, parent:Byte Ptr)
	Function SDL_SetWindowInputFocus:Int(handle:Byte Ptr)
	Function SDL_SetWindowGammaRamp:Int(handle:Byte Ptr, red:Short Ptr, green:Short Ptr, blue:Short Ptr)
	Function SDL_GetWindowGammaRamp:Int(handle:Byte Ptr, red:Short Ptr, green:Short Ptr, blue:Short Ptr)
	Function SDL_DestroyWindow(handle:Byte Ptr)
	Function SDL_RestoreWindow(handle:Byte Ptr)
	Function SDL_SetWindowIcon(handle:Byte Ptr, surface:Byte Ptr)

	Function SDL_GetGrabbedWindow:Byte Ptr()
	Function SDL_IsScreenSaverEnabled:Int()
	Function SDL_EnableScreenSaver()
	Function SDL_DisableScreenSaver()
	Function SDL_VideoQuit()
	
	Function SDL_GL_CreateContext:Byte Ptr(handle:Byte Ptr)
	Function SDL_GL_GetDrawableSize(handle:Byte Ptr, w:Int Ptr, h:Int Ptr)
	Function SDL_GL_MakeCurrent:Int(handle:Byte Ptr, context:Byte Ptr)
	Function SDL_GL_SwapWindow(handle:Byte Ptr)

	Function SDL_GL_ExtensionSupported:Int(extension:Byte Ptr)
	Function SDL_GL_GetAttribute:Int(attr:Int, value:Int Ptr)
	Function SDL_GL_GetCurrentContext:Byte Ptr()
	Function SDL_GL_GetCurrentWindow:Byte Ptr()
	Function SDL_GL_GetProcAddress:Byte Ptr(proc:Byte Ptr)
	Function SDL_GL_LoadLibrary:Int(path:Byte Ptr)
	Function SDL_GL_GetSwapInterval:Int()
	Function SDL_GL_SetSwapInterval:Int(value:Int)
	Function SDL_GL_ResetAttributes()
	Function SDL_GL_SetAttribute:Int(attr:Int, value:Int)
	Function SDL_GL_UnloadLibrary()
	Function SDL_GL_DeleteContext(handle:Byte Ptr)

	' for generating pixel formats
	'Function bmx_sdl_video_generatePixelFormats()	
End Extern


Const SDL_WINDOWPOS_UNDEFINED:Int = $1FFF0000
Const SDL_WINDOWPOS_CENTERED:Int = $2FFF0000

Rem
bbdoc: fullscreen window
End Rem
Const SDL_WINDOW_FULLSCREEN:UInt = $00000001
Rem
bbdoc: window usable with OpenGL context
End Rem
Const SDL_WINDOW_OPENGL:UInt = $00000002
Rem
bbdoc: window is visible
End Rem
Const SDL_WINDOW_SHOWN:UInt = $00000004
Rem
bbdoc: window is not visible
End Rem
Const SDL_WINDOW_HIDDEN:UInt = $00000008
Rem
bbdoc: no window decoration
End Rem
Const SDL_WINDOW_BORDERLESS:UInt = $00000010
Rem
bbdoc: window can be resized
End Rem
Const SDL_WINDOW_RESIZABLE:UInt = $00000020
Rem
bbdoc: window is minimized
End Rem
Const SDL_WINDOW_MINIMIZED:UInt = $00000040
Rem
bbdoc: window is maximized
End Rem
Const SDL_WINDOW_MAXIMIZED:UInt = $00000080
Rem
bbdoc: window has grabbed input focus
End Rem
Const SDL_WINDOW_INPUT_GRABBED:UInt = $00000100
Rem
bbdoc: window has input focus
End Rem
Const SDL_WINDOW_INPUT_FOCUS:UInt = $00000200
Rem
bbdoc: window has mouse focus
End Rem
Const SDL_WINDOW_MOUSE_FOCUS:UInt = $00000400
Rem
bbdoc: full screen desktop
End Rem
Const SDL_WINDOW_FULLSCREEN_DESKTOP:UInt = SDL_WINDOW_FULLSCREEN | $00001000
Rem
bbdoc: window not created by SDL
End Rem
Const SDL_WINDOW_FOREIGN:UInt = $00000800
Rem
bbdoc: window should be created in high-DPI mode if supported
End Rem
Const SDL_WINDOW_ALLOW_HIGHDPI:UInt = $00002000
Rem
bbdoc: window has mouse captured (unrelated to INPUT_GRABBED)
End Rem
Const SDL_WINDOW_MOUSE_CAPTURE:UInt = $00004000
Rem
bbdoc: window should always be above others
End Rem
Const SDL_WINDOW_ALWAYS_ON_TOP:UInt = $00008000
Rem
bbdoc: window should not be added to the taskbar
End Rem
Const SDL_WINDOW_SKIP_TASKBAR:UInt = $00010000
Rem
bbdoc: window should be treated as a utility window
End Rem
Const SDL_WINDOW_UTILITY:UInt = $00020000
Rem
bbdoc: window should be treated as a tooltip
End Rem
Const SDL_WINDOW_TOOLTIP:UInt = $00040000
Rem
bbdoc: window should be treated as a popup menu
End Rem
Const SDL_WINDOW_POPUP_MENU:UInt = $00080000
Rem
bbdoc: window usable for Vulkan surface
End Rem
Const SDL_WINDOW_VULKAN:UInt = $10000000

Rem
bbdoc: the minimum number of bits for the red channel of the color buffer; defaults to 3
End Rem
Const SDL_GL_RED_SIZE:Int = 0

Rem
bbdoc: the minimum number of bits for the green channel of the color buffer; defaults to 3
End Rem
Const SDL_GL_GREEN_SIZE:Int = 1

Rem
bbdoc: the minimum number of bits for the blue channel of the color buffer; defaults to 2
End Rem
Const SDL_GL_BLUE_SIZE:Int = 2

Rem
bbdoc: the minimum number of bits for the alpha channel of the color buffer; defaults to 0
End Rem
Const SDL_GL_ALPHA_SIZE:Int = 3

Rem
bbdoc: the minimum number of bits for frame buffer size; defaults to 0
End Rem
Const SDL_GL_BUFFER_SIZE:Int = 4

Rem
bbdoc: whether the output is single or double buffered; defaults to double buffering on
End Rem
Const SDL_GL_DOUBLEBUFFER:Int = 5

Rem
bbdoc: the minimum number of bits in the depth buffer; defaults to 16
End Rem
Const SDL_GL_DEPTH_SIZE:Int = 6

Rem
bbdoc: the minimum number of bits in the stencil buffer; defaults to 0
End Rem
Const SDL_GL_STENCIL_SIZE:Int = 7

Rem
bbdoc: the minimum number of bits for the red channel of the accumulation buffer; defaults to 0
End Rem
Const SDL_GL_ACCUM_RED_SIZE:Int = 8

Rem
bbdoc: the minimum number of bits for the green channel of the accumulation buffer; defaults to 0
End Rem
Const SDL_GL_ACCUM_GREEN_SIZE:Int = 9

Rem
bbdoc: the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0
End Rem
Const SDL_GL_ACCUM_BLUE_SIZE:Int = 10

Rem
bbdoc: the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0
End Rem
Const SDL_GL_ACCUM_ALPHA_SIZE:Int = 11

Rem
bbdoc: whether the output is stereo 3D; defaults to off
End Rem
Const SDL_GL_STEREO:Int = 12

Rem
bbdoc: the number of buffers used for multisample anti-aliasing; defaults to 0; see Remarks for details
End Rem
Const SDL_GL_MULTISAMPLEBUFFERS:Int = 13

Rem
bbdoc: the number of samples used around the current pixel used for multisample anti-aliasing; defaults to 0; see Remarks for details
End Rem
Const SDL_GL_MULTISAMPLESAMPLES:Int = 14

Rem
bbdoc: set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either
End Rem
Const SDL_GL_ACCELERATED_VISUAL:Int = 15

Rem
bbdoc: not used (deprecated)
End Rem
Const SDL_GL_RETAINED_BACKING:Int = 16

Rem
bbdoc: OpenGL context major version; see Remarks for details
End Rem
Const SDL_GL_CONTEXT_MAJOR_VERSION:Int = 17

Rem
bbdoc: OpenGL context minor version; see Remarks for details
End Rem
Const SDL_GL_CONTEXT_MINOR_VERSION:Int = 18

Rem
bbdoc: some combination of 0 or more of elements of the SDL_GLcontextFlag enumeration; defaults to 0
End Rem
Const SDL_GL_CONTEXT_FLAGS:Int = 19

Rem
bbdoc: type of GL context (Core, Compatibility, ES). See SDL_GLprofile; default value depends on platform
End Rem
Const SDL_GL_CONTEXT_PROFILE_MASK:Int = 20

Rem
bbdoc: OpenGL context sharing; defaults to 0
End Rem
Const SDL_GL_SHARE_WITH_CURRENT_CONTEXT:Int = 21

Rem
bbdoc: requests sRGB capable visual; defaults to 0
End Rem
Const SDL_GL_FRAMEBUFFER_SRGB_CAPABLE:Int = 22

Rem
bbdoc: sets context the release behavior; defaults to 1
End Rem
Const SDL_GL_CONTEXT_RELEASE_BEHAVIOR:Int = 23
