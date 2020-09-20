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

Rem
bbdoc: SDL Video
End Rem
Module SDL.SDLVideo

Import SDL.SDLSurface

Import "common.bmx"

Rem
bbdoc: An SDL Window.
End Rem
Type TSDLWindow

	Field windowPtr:Byte Ptr
	
	Function _create:TSDLWindow(windowPtr:Byte Ptr)
		If windowPtr Then
			Local this:TSDLWindow = New TSDLWindow
			this.windowPtr = windowPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Creates a window with the specified position, dimensions, and flags.
	returns: The window that was created or Null on failure.
	End Rem
	Function Create:TSDLWindow(title:String, x:Int, y:Int, w:Int, h:Int, flags:UInt)
		Return _create(bmx_sdl_video_CreateWindow(title, x, y, w, h, flags))
	End Function
	
	Rem
	bbdoc: Gets the display associated with the window.
	returns: Returns the display containing the center of the window on success or Null on failure.
	End Rem
	Method GetDisplay:TSDLDisplay()
		Return TSDLDisplay.Create(SDL_GetWindowDisplayIndex(windowPtr))
	End Method
	
	Rem
	bbdoc: Sets the display mode to use when the window is visible at fullscreen.
	returns: 0 on success or a negative error code on failure.
	about: This only affects the display mode used when the window is fullscreen. To change the window size when the window is not fullscreen,
	use #SetSize().
	End Rem
	Method SetDisplayMode:Int(Mode:TSDLDisplayMode)
		Return SDL_SetWindowDisplayMode(windowPtr, Mode.modePtr)
	End Method
	
	Rem
	bbdoc: Gets information about the display mode to use when a window is visible at fullscreen.
	returns: The display mode on success or Null on failure.
	End Rem
	Method GetDisplayMode:TSDLDisplayMode()
		Return TSDLDisplayMode._create(bmx_sdl_video_GetWindowDisplayMode(windowPtr))
	End Method
	
	Rem
	bbdoc: Gets the pixel format associated with the window.
	returns: The pixel format of the window on success or #SDL_PIXELFORMAT_UNKNOWN on failure.
	End Rem
	Method GetPixelFormat:UInt()
		Return SDL_GetWindowPixelFormat(windowPtr)
	End Method
	
	Rem
	bbdoc: Gets the numeric ID of the window, for logging purposes.
	returns: The ID of the window on success or 0 on failure.
	End Rem
	Method GetID:UInt()
		Return SDL_GetWindowID(windowPtr)
	End Method
	
	Rem
	bbdoc: Gets the title of the window.
	End Rem
	Method GetTitle:String()
		Return String.FromUTF8String(SDL_GetWindowTitle(windowPtr))
	End Method
	
	Rem
	bbdoc: Sets the title of the window.
	End Rem
	Method SetTitle(title:String)
		bmx_sdl_video_SetWindowTitle(windowPtr, title)
	End Method
	
	Rem
	bbdoc: Sets the icon for the window.
	End Rem
	Method SetIcon(icon:TSDLSurface)
		SDL_SetWindowIcon(windowPtr, icon.surfacePtr)
	End Method
	
	Rem
	bbdoc: Sets the position of the window.
	about: The window coordinate origin is the upper left of the display.
	End Rem
	Method SetPosition(x:Int, y:Int)
		SDL_SetWindowPosition(windowPtr, x, y)
	End Method
	
	Rem
	bbdoc: Gets the position of the window.
	End Rem
	Method GetPosition(x:Int Var, y:Int Var)
		SDL_GetWindowPosition(windowPtr, Varptr x, Varptr y)
	End Method
	
	Rem
	bbdoc: Sets the size of the window's client area.
	about: The window size in screen coordinates may differ from the size in pixels, if the window was created with
	#SDL_WINDOW_ALLOW_HIGHDPI on a platform with high-dpi support (e.g. iOS or OS X).
	Use #GLGetDrawableSize() or #SDLGetRendererOutputSize() to get the real client area size in pixels.
	Fullscreen windows automatically match the size of the display mode, and you should use #SetWindowDisplayMode() to change their size.
	End Rem
	Method SetSize(w:Int, h:Int)
		SDL_SetWindowSize(windowPtr, w, h)
	End Method
	
	Rem
	bbdoc: Gets the size of the window's client area.
	about: The window size in screen coordinates may differ from the size in pixels, if the window was created with
	#SDL_WINDOW_ALLOW_HIGHDPI on a platform with high-dpi support (e.g. iOS or OS X).
	Use #GLGetDrawableSize() or #SDLGetRendererOutputSize() to get the real client area size in pixels.
	End Rem
	Method GetSize(w:Int Var, h:Int Var)
		SDL_GetWindowSize(windowPtr, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Gets the size of the window's borders (decorations) around the client area.
	about: Note: If this method fails (returns -1), the size values will be initialized to 0, 0, 0, 0, as if the window in question was borderless.
	This method also returns -1 if getting the information is not supported.
	This method is only supported on X11.
	End Rem
	Method GetBorderSize:Int(wTop:Int Var, wLeft:Int Var, wBottom:Int Var, wRight:Int Var)
		Return SDL_GetWindowBordersSize(windowPtr, Varptr wTop, Varptr wLeft, Varptr wBottom, Varptr wRight)
	End Method
	
	Rem
	bbdoc: Sets the minimum size of the window's client area.
	End Rem
	Method SetMinimumSize(w:Int, h:Int)
		SDL_SetWindowMinimumSize(windowPtr, w, h)
	End Method
	
	Rem
	bbdoc: Gets the minimum size of a window's client area.
	End Rem
	Method GetMinimumSize(w:Int Var, h:Int Var)
		SDL_GetWindowMinimumSize(windowPtr, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Sets the maximum size of the window's client area.
	End Rem
	Method SetMaximumSize(w:Int, h:Int)
		SDL_SetWindowMaximumSize(windowPtr, w, h)
	End Method
	
	Rem
	bbdoc: Gets the maximum size of the window's client area.
	End Rem
	Method GetMaximumSize(w:Int Var, h:Int Var)
		SDL_GetWindowMaximumSize(windowPtr, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Sets the border state of the window.
	about: This will add or remove the window's SDL_WINDOW_BORDERLESS flag and add or remove the border from the actual window.
	This is a no-op if the window's border already matches the requested state.
	You can't change the border state of a fullscreen window.
	End Rem
	Method SetBordered(bordered:Int)
		SDL_SetWindowBordered(windowPtr, bordered)
	End Method
	
	Rem
	bbdoc: Sets the user-resizable state of the window.
	about: This will add or remove the window's SDL_WINDOW_RESIZABLE flag and allow/disallow user resizing of the window.
	This is a no-op if the window's resizable state already matches the requested state.
	You can't change the resizable state of a fullscreen window.
	End Rem
	Method SetResizable(resizable:Int)
		SDL_SetWindowResizable(windowPtr, resizable)
	End Method
	
	Rem
	bbdoc: Shows the window.
	End Rem
	Method Show()
		SDL_ShowWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Hides the window.
	End Rem
	Method Hide()
		SDL_HideWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Raises the window above other windows and sets the input focus.
	End Rem
	Method Raise()
		SDL_RaiseWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Makes the window as large as possible.
	End Rem
	Method Maximize()
		SDL_MaximizeWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Minimizes the window to an iconic representation.
	End Rem
	Method Minimize()
		SDL_MinimizeWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Restores the size and position of a minimized or maximized window.
	End Rem
	Method Restore()
		SDL_RestoreWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Sets the window's fullscreen state.
	returns: 0 on success or a negative error code on failure.
	about: @flags may be SDL_WINDOW_FULLSCREEN, for "real" fullscreen with a videomode change; SDL_WINDOW_FULLSCREEN_DESKTOP
	for "fake" fullscreen that takes the size of the desktop; and 0 for windowed mode.
	End Rem
	Method SetFullScreen:Int(flags:UInt)
		Return SDL_SetWindowFullscreen(windowPtr, flags)
	End Method
	
	Rem
	bbdoc: Gets the SDL surface associated with the window.
	returns: The surface associated with the window, or Null on failure.
	about: A new surface will be created with the optimal format for the window, if necessary.
	This surface will be freed when the window is destroyed. Do not free this surface.
	This surface will be invalidated if the window is resized. After resizing a window this method must be called again to return a valid surface.
	You may not combine this with 3D or the rendering API on this window.
	End Rem
	Method GetSurface:TSDLSurface()
		Return TSDLSurface._create(SDL_GetWindowSurface(windowPtr))
	End Method
	
	Rem
	bbdoc: Copies the window surface to the screen.
	returns: 0 on success or a negative error code on failure.
	about: This is the method you use to reflect any changes to the surface on the screen.
	End Rem
	Method UpdateSurface:Int()
		Return SDL_UpdateWindowSurface(windowPtr)
	End Method
	
	Rem
	bbdoc: Sets the window's input grab mode.
	about: When input is grabbed the mouse is confined to the window.
	If the caller enables a grab while another window is currently grabbed, the other window loses its grab in favor of the caller's window.
	End Rem
	Method SetGrab(grabbed:Int)
		SDL_SetWindowGrab(windowPtr, grabbed)
	End Method
	
	Rem
	bbdoc: Gets a window's input grab mode.
	returns: True if input is grabbed, False otherwise.
	End Rem
	Method GetGrab:Int()
		Return SDL_GetWindowGrab(windowPtr)
	End Method
	
	Rem
	bbdoc: Sets the brightness (gamma multiplier) for the display that owns the window.
	returns: 0 on success or a negative error code on failure.
	about: Despite the name and signature, this method sets the brightness of the entire display, not an individual window.
	A window is considered to be owned by the display that contains the window's center pixel. (The index of this display can be
	retrieved using #GetDisplay().) The brightness set will not follow the window if it is moved to another display
	End Rem
	Method SetBrightness:Int(brightness:Float)
		Return SDL_SetWindowBrightness(windowPtr, brightness)
	End Method
	
	Rem
	bbdoc: Gets the brightness (Gamma multiplier) For the display that owns the window.
	returns: The brightness for the display where 0.0 is completely dark and 1.0 is normal brightness.
	about: Despite the name and signature, this method sets the brightness of the entire display, not an individual window.
	A window is considered to be owned by the display that contains the window's center pixel. (The index of this display can be
	retrieved using #GetDisplay().) The brightness set will not follow the window if it is moved to another display
	End Rem
	Method GetBrightness:Float()
		Return SDL_GetWindowBrightness(windowPtr)
	End Method
	
	Rem
	bbdoc: Sets the opacity for the window.
	returns: 0 on success or a negative error code on failure.
	about: The parameter @opacity will be clamped internally between 0.0f (transparent) and 1.0f (opaque).
	This method also returns -1 if setting the opacity isn't supported.
	This method is only supported on DirectFB, X11, Cocoa (Apple Mac OS X) and Microsoft Windows.
	End Rem
	Method SetOpacity:Int(opacity:Float)
		Return SDL_SetWindowOpacity(windowPtr, opacity)
	End Method
	
	Rem
	bbdoc: Gets the opacity of the window.
	returns: 0 on success or a negative error code on failure.
	about: If transparency isn't supported on this platform, opacity will be reported as 1.0f without error.
	This method also returns -1 if the window is invalid.
	This method is only supported on DirectFB, X11, Cocoa (Apple Mac OS X) and Microsoft Windows.
	End Rem
	Method GetOpacity:Int(opacity:Float Var)
		Return SDL_GetWindowOpacity(windowPtr, Varptr opacity)
	End Method
	
	Rem
	bbdoc: Sets the window as a modal for another window.
	returns: 0 on success or a negative error code on failure.
	about: This function is only supported on X11.
	End Rem
	Method SetModalFor:Int(parent:TSDLWindow)
		Return SDL_SetWindowModalFor(windowPtr, parent.windowPtr)
	End Method
	
	Rem
	bbdoc: Explicitly sets input focus to the window.
	returns: 0 on success or a negative error code on failure.
	about: You almost certainly want #Raise() instead of this function. Use this with caution, as you might give
	focus to a window that is completely obscured by other windows.
	This method is only supported on X11.
	End Rem
	Method SetInputFocus:Int()
		Return SDL_SetWindowInputFocus(windowPtr)
	End Method
	
	Rem
	bbdoc: Sets the gamma ramp for the display that owns a given window.
	returns: 0 on success or a negative error code on failure.
	about: Set the gamma translation table for the red, green, and blue channels of the video hardware. Each table is an
	array of 256 16-bit quantities, representing a mapping between the input and output for that channel. The input is
	the index into the array, and the output is the 16-bit gamma value at that index, scaled to the output color precision.
	Despite the name and signature, this method sets the gamma ramp of the entire display, not an individual window.
	A window is considered to be owned by the display that contains the window's center pixel. (The index of this display
	can be retrieved using #GetDisplay().) The gamma ramp set will not follow the window if it is moved to another display.
	End Rem
	Method SetGammaRamp:Int(red:Short Ptr, green:Short Ptr, blue:Short Ptr)
		Return SDL_SetWindowGammaRamp(windowPtr, red, green, blue)
	End Method
	
	Rem
	bbdoc: Gets the gamma ramp for the display that owns the window.
	returns: 0 on success or a negative error code on failure.
	about: 	Despite the name and signature, this method sets the gamma ramp of the entire display, not an individual window.
	A window is considered to be owned by the display that contains the window's center pixel. (The index of this display
	can be retrieved using #GetDisplay().) The gamma ramp set will not follow the window if it is moved to another display.
	End Rem
	Method GetGammaRamp:Int(red:Short Ptr, green:Short Ptr, blue:Short Ptr)
		Return SDL_GetWindowGammaRamp(windowPtr, red, green, blue)
	End Method
	
	Rem
	bbdoc: Destroys the window.
	End Rem
	Method Destroy()
		SDL_DestroyWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Creates an OpenGL context for use with an OpenGL window, and makes it current.
	returns: The OpenGL context associated with window or Null on error.
	about: Windows users new to OpenGL should note that, for historical reasons, GL functions added after OpenGL version 1.1 are
	not available by default. Those functions must be loaded at run-time, either with an OpenGL extension-handling
	library or with #GLGetProcAddress() and its related functions.
	End Rem
	Method GLCreateContext:TSDLGLContext()
		Return TSDLGLContext._create(SDL_GL_CreateContext(windowPtr))
	End Method
	
	Rem
	bbdoc: Gets the size of a window's underlying drawable in pixels (for use with glViewport).
	about: This may differ from #GetSize() if we're rendering to a high-DPI drawable, i.e. the window was created with
	#SDL_WINDOW_ALLOW_HIGHDPI on a platform with high-DPI support (Apple calls this "Retina"), and not disabled by
	the #SDL_HINT_VIDEO_HIGHDPI_DISABLED hint.
	End Rem
	Method GLGetDrawableSize(w:Int Var, h:Int Var)
		SDL_GL_GetDrawableSize(windowPtr, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Sets up an OpenGL context for rendering into an OpenGL window.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Method GLMakeCurrent:Int(context:TSDLGLContext)
		Return SDL_GL_MakeCurrent(windowPtr, context.contextPtr)
	End Method
	
	Rem
	bbdoc: Updates a window with OpenGL rendering.
	about: This is used with double-buffered OpenGL contexts, which are the default.
	End Rem
	Method GLSwap()
		SDL_GL_SwapWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetWindowHandle:Byte Ptr()
		Return bmx_sdl_video_GetWindowHandle(windowPtr)
	End Method
	
End Type

Rem
bbdoc: An Open GL context.
End Rem
Type TSDLGLContext
	
	Field contextPtr:Byte Ptr
	
	Function _create:TSDLGLContext(contextPtr:Byte Ptr)
		If contextPtr Then
			Local this:TSDLGLContext = New TSDLGLContext
			this.contextPtr = contextPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Checks if an OpenGL extension is supported for the current context.
	returns: True if the extension is supported, False otherwise.
	about: This method operates on the current GL context; you must have created a context and it must be current before calling this method.
	Do not assume that all contexts you create will have the same set of extensions available, or that recreating an existing context
	will offer the same extensions again.
	While it's probably not a massive overhead, this method is not an O(1) operation. Check the extensions you care about after creating
	the GL context and save that information somewhere instead of calling the method every time you need to know.
	End Rem
	Function ExtensionSupported:Int(extension:String)
		Local e:Byte Ptr = extension.ToUTF8String()
		Local res:Int = SDL_GL_ExtensionSupported(e)
		MemFree(e)
		Return res
	End Function
	
	Rem
	bbdoc: Gets the actual value for an attribute from the current context.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Function GetAttribute:Int(attr:Int, value:Int Var)
		Return SDL_GL_GetAttribute(attr:Int, Varptr value)
	End Function
	
	Rem
	bbdoc: Gets the currently active OpenGL context.
	returns: The currently active OpenGL context or Null on failure.
	End Rem
	Function GetCurrentContext:TSDLGLContext()
		Return TSDLGLContext._create(SDL_GL_GetCurrentContext())
	End Function
	
	Rem
	bbdoc: Gets the currently active OpenGL window.
	returns: The currently active OpenGL window on success or Null on failure.
	End Rem
	Function GetCurrentWindow:TSDLWindow()
		Return TSDLWindow._create(SDL_GL_GetCurrentWindow())
	End Function
	
	Rem
	bbdoc: Gets an OpenGL function by name.
	returns: A pointer to the named OpenGL function. The returned pointer should be cast to the appropriate function signature.
	about: If the GL library is loaded at runtime with #GLLoadLibrary(), then all GL functions must be retrieved this way. 
	Usually this is used to retrieve function pointers to OpenGL extensions.
	End Rem
	Function GetProcAddress:Byte Ptr(proc:String)
		Local p:Byte Ptr = proc.ToUTF8String()
		Local a:Byte Ptr = SDL_GL_GetProcAddress(p)
		MemFree(p)
		Return a
	End Function
	
	Rem
	bbdoc: Dynamically loads an OpenGL library.
	returns: 0 on success or a negative error code on failure.
	about: This should be done after initializing the video driver, but before creating any OpenGL windows.
	If no OpenGL library is loaded, the default library will be loaded upon creation of the first OpenGL window.
	If you do this, you need to retrieve all of the GL functions used in your program from the dynamic library using #GLGetProcAddress().
	End Rem
	Function LoadLibrary:Int(path:String)
		Local p:Byte Ptr = path.ToUTF8String()
		Local res:Int = SDL_GL_LoadLibrary(p)
		MemFree(p)
		Return res
	End Function
	
	Rem
	bbdoc: Gets the swap interval for the current OpenGL context.
	returns: 0 if there is no vertical retrace synchronization, 1 if the buffer swap is synchronized with the vertical retrace, and -1 if late swaps happen immediately instead of waiting for the next retrace.
	about: If the system can't determine the swap interval, or there isn't a valid current context, this method will return 0 as a safe default.
	End Rem
	Function GetSwapInterval:Int()
		Return SDL_GL_GetSwapInterval()
	End Function
	
	Rem
	bbdoc: Sets the swap interval for the current OpenGL context.
	returns: 0 on success or -1 if setting the swap interval is not supported.
	about: Some systems allow specifying -1 for the interval, to enable late swap tearing. Late swap tearing works the same as vsync,
	but if you've already missed the vertical retrace for a given frame, it swaps buffers immediately, which might be less jarring for
	the user during occasional framerate drops. If application requests late swap tearing and the system does not support it, this 
	method will fail and return -1. In such a case, you should probably retry the call with 1 for the interval.
	Late swap tearing is implemented for some glX drivers with GLX_EXT_swap_control_tear and for some Windows drivers with WGL_EXT_swap_control_tear.
	End Rem
	Function SetSwapInterval:Int(value:Int)
		Return SDL_GL_SetSwapInterval(value)
	End Function
	
	Rem
	bbdoc: Resets all previously set OpenGL context attributes to their default values.
	End Rem
	Function ResetAttributes()
		SDL_GL_ResetAttributes()
	End Function
	
	Rem
	bbdoc: Sets an OpenGL window attribute before window creation.
	returns: 0 on success or a negative error code on failure.
	about: Sets the OpenGL attribute @attr to @value. The requested attributes should be set before creating an OpenGL window.
	You should use #GetAttribute() to check the values after creating the OpenGL context, since the values obtained can differ from
	the requested ones.
	End Rem
	Function SetAttribute:Int(attr:Int, value:Int)
		Return SDL_GL_SetAttribute(attr, value)
	End Function
	
	Rem
	bbdoc: Unloads the OpenGL library previously loaded by #LoadLibrary()
	End Rem
	Function UnloadLibrary()
		SDL_GL_UnloadLibrary()
	End Function
	
	Rem
	bbdoc: Frees the GL Context.
	End Rem
	Method Free()
		If contextPtr Then
			SDL_GL_DeleteContext(contextPtr)
			contextPtr = Null
		End If
	End Method
	
End Type

Rem
bbdoc: Represents an indexed video display.
End Rem
Type TSDLDisplay

	Field index:Int

	Rem
	bbdoc: 
	End Rem
	Function Create:TSDLDisplay(index:Int)
		If index < 0 Or index >= SDL_GetNumVideoDisplays() Then
			Return Null
		End If
		Local this:TSDLDisplay = New TSDLDisplay
		this.index = index
		Return this
	End Function

	Rem
	bbdoc: Gets the name of the display.
	End Rem
	Method GetName:String()
		Return String.FromUTF8String(SDL_GetDisplayName(index))
	End Method
	
	Rem
	bbdoc: Gets the desktop area represented by the display, with the primary display located at 0,0.
	End Rem
	Method GetBounds:Int(w:Int Var, h:Int Var)
		Return bmx_sdl_video_GetDisplayBounds(index, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Gets the diagonal, horizontal and vertical dots/pixels-per-inch for the display.
	returns: 0 on success, or -1 if no DPI information is available.
	End Rem
	Method GetDPI:Int(ddpi:Float Var, hdpi:Float Var, vdpi:Float Var)
		Return SDL_GetDisplayDPI(index, Varptr ddpi, Varptr hdpi, Varptr vdpi)
	End Method
	
	Rem
	bbdoc: Gets the usable desktop area represented by a display, with the primary display located at 0,0.
	about: This is the same area as SDL_GetDisplayBounds() reports, but with portions reserved by the system removed.
	For example, on Mac OS X, this subtracts the area occupied by the menu bar and dock.
	Setting a window to be fullscreen generally bypasses these unusable areas, so these are good guidelines for the
	maximum space available to a non-fullscreen window.
	End Rem
	Method GetUsableBounds:Int(w:Int Var, h:Int Var)
		Return bmx_sdl_video_GetDisplayUsableBounds(index, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Returns the number of available display modes.
	End Rem
	Method GetNumDisplayModes:Int()
		Return SDL_GetNumDisplayModes(index)
	End Method
	
	Rem
	bbdoc: Gets information about a specific display mode.
	returns: A display mode or Null on failure.
	End Rem
	Method GetDisplayMode:TSDLDisplayMode(modeIndex:Int)
		If modeIndex >= 0 And modeIndex < SDL_GetNumDisplayModes(index) Then
			Return TSDLDisplayMode._create(bmx_sdl_video_GetDisplayMode(index, modeIndex), index)
		End If
	End Method
	
	Rem
	bbdoc: Gets information about the desktop display mode.
	returns: A display mode or Null on failure.
	End Rem
	Method GetDesktopDisplayMode:TSDLDisplayMode()
		Return TSDLDisplayMode._create(bmx_sdl_video_GetDesktopDisplayMode(index), index)
	End Method
	
	Rem
	bbdoc: Gets information about the current display mode.
	returns: A display mode or Null on failure.
	End Rem
	Method GetCurrentDisplayMode:TSDLDisplayMode()
		Return TSDLDisplayMode._create(bmx_sdl_video_GetCurrentDisplayMode(index), index)
	End Method

End Type

Rem
bbdoc: The description of a display mode.
End Rem
Type TSDLDisplayMode

	Field displayIndex:Int
	Field modePtr:Byte Ptr
	
	Function _create:TSDLDisplayMode(modePtr:Byte Ptr, displayIndex:Int = -1)
		If modePtr Then
			Local this:TSDLDisplayMode = New TSDLDisplayMode
			this.displayIndex = displayIndex
			this.modePtr = modePtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Creates a new custom display mode, useful for calling #GetClosestDisplayMode.
	End Rem
	Function Create:TSDLDisplayMode(format:UInt, width:Int, height:Int, refreshRate:Int)
		Return _create(bmx_sdl_video_DisplayMode_new(format, width, height, refreshRate))
	End Function
	
	Rem
	bbdoc: One of the SDL pixel formats.
	End Rem
	Method Format:UInt()
		Return bmx_sdl_video_DisplayMode_format(modePtr)
	End Method
	
	Rem
	bbdoc: The width, in screen coordinates.
	End Rem
	Method Width:Int()
		Return bmx_sdl_video_DisplayMode_width(modePtr)
	End Method
	
	Rem
	bbdoc: The height, in screen coordinates.
	End Rem
	Method Height:Int()
		Return bmx_sdl_video_DisplayMode_height(modePtr)
	End Method
	
	Rem
	bbdoc: The refresh rate (in Hz), or 0 for unspecified.
	End Rem
	Method RefreshRate:Int()
		Return bmx_sdl_video_DisplayMode_refreshRate(modePtr)
	End Method
	
	Rem
	bbdoc: Driver-specific data.
	End Rem
	Method DriverData:Byte Ptr()
		Return bmx_sdl_video_DisplayMode_driverData(modePtr)
	End Method

	Rem
	bbdoc: Gets the closest match to this display mode.
	returns: The closest mode or Null if no matching display mode was available.
	about: The available display modes are scanned and the closest mode matching the requested mode and returned.
	The mode format and refresh rate default to the desktop mode if they are set to 0.
	The modes are scanned with size being first priority, format being second priority, and finally checking the refresh rate.
	If all the available modes are too small, then Null is returned.
	End Rem
	Method GetClosestDisplayMode:TSDLDisplayMode(display:TSDLDisplay)
		Return _create(bmx_sdl_video_GetClosestDisplayMode(modePtr, display.index), display.index)
	End Method
	
	Method Delete()
		If modePtr Then
			bmx_sdl_video_DisplayMode_free(modePtr)
			modePtr = Null
		End If
	End Method
	
End Type


Rem
bbdoc: Returns the list of built-in video drivers.
about: The video drivers are presented in the order in which they are normally checked during initialization.
End Rem
Function SDLGetVideoDrivers:String[]()
	Return bmx_sdl_video_GetVideoDrivers()
End Function

Rem
bbdoc: Initializes the video subsystem, optionally specifying a video driver.
about: Initializes the video subsystem; setting up a connection to the window manager, 
etc, and determines the available display modes and pixel formats, but does not initialize a window or graphics mode.
End Rem
Function SDLVideoInit:Int(driver:String)
	Return bmx_sdl_video_VideoInit(driver)
End Function

Rem
bbdoc: Shuts down the video subsystem.
about: Closes all windows, and restores the original video mode.
End Rem
Function SDLVideoQuit()
	SDL_VideoQuit()
End Function

Rem
bbdoc: Gets the name of the currently initialized video driver.
returns: The name of the current video driver or NULL if no driver has been initialized.
End Rem
Function SDLGetCurrentVideoDriver:String()
	Return bmx_sdl_video_SDL_GetCurrentVideoDriver()
End Function

Rem
bbdoc: Gets the number of available video displays.
returns: A number >= 1 or a negative error code on failure. Call #SDLGetError() for more information.
End Rem
Function SDLGetNumVideoDisplays:Int()
	Return SDL_GetNumVideoDisplays()
End Function

Rem
bbdoc: Gets the window that currently has an input grab enabled.
returns: The window if input is grabbed, and Null otherwise.
End Rem
Function SDLGetGrabbedWindow:TSDLWindow()
	Return TSDLWindow._create(SDL_GetGrabbedWindow())
End Function

Rem
bbdoc: Returns whether the screensaver is currently enabled (Default off).
about: The screensaver is disabled by default since SDL 2.0.2. Before SDL 2.0.2 the screensaver was enabled by default.
End Rem
Function SDLIsScreenSaverEnabled:Int()
	Return SDL_IsScreenSaverEnabled()
End Function

Rem
bbdoc: Allows the screen to be blanked by a screensaver.
End Rem
Function SDLEnableScreenSaver()
	SDL_EnableScreenSaver()
End Function

Rem
bbdoc: Prevents the screen from being blanked by a screensaver.
about: If you disable the screensaver, it is automatically re-enabled when SDL quits.
End Rem
Function SDLDisableScreenSaver()
	SDL_DisableScreenSaver()
End Function



