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
bbdoc: 2D Rendering.
End Rem
Module SDL.SDLRender

Import SDL.SDLVideo

Import "common.bmx"

Rem
bbdoc: A 2D rendering context.
End Rem
Type TSDLRenderer

	Field rendererPtr:Byte Ptr
	
	Function _create:TSDLRenderer(rendererPtr:Byte Ptr)
		If rendererPtr Then
			Local this:TSDLRenderer = New TSDLRenderer
			this.rendererPtr = rendererPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Creates a 2D rendering context for a window.
	about: Note that providing no flags gives priority to available #SDL_RENDERER_ACCELERATED renderers
	End Rem
	Function Create:TSDLRenderer(window:TSDLWindow, index:Int = -1, flags:UInt = 0)
		Return _create(SDL_CreateRenderer(window.windowPtr, index, flags))
	End Function
	
	Rem
	bbdoc: Creates a 2D software rendering context for a surface.
	End Rem
	Function CreateSoftwareRenderer:TSDLRenderer(surface:TSDLSurface)
		Return _create(SDL_CreateSoftwareRenderer(surface.surfacePtr))
	End Function
	
	Rem
	bbdoc: Gets the renderer associated with a window.
	End Rem
	Function GetRenderer:TSDLRenderer(window:TSDLWindow)
		Return _create(SDL_GetRenderer(window.windowPtr))
	End Function
	
	Rem
	bbdoc: Creates a texture for a rendering context.
	End Rem
	Method CreateTexture:TSDLTexture(format:UInt, access:Int, width:Int, height:Int)
		Return TSDLTexture._create(SDL_CreateTexture(rendererPtr, format, access, width, height))
	End Method
	
	Rem
	bbdoc: Creates a texture from an existing surface.
	End Rem
	Method CreateTextureFromSurface:TSDLTexture(surface:TSDLSurface)
		Return TSDLTexture._create(SDL_CreateTextureFromSurface(rendererPtr, surface.surfacePtr))
	End Method
	
	Rem
	bbdoc: Gets the blend mode used for drawing operations.
	End Rem
	Method GetDrawBlendMode:Int(blendMode:Int Var)
		Return SDL_GetRenderDrawBlendMode(rendererPtr, Varptr blendMode)
	End Method

	Rem
	bbdoc: Gets the color used for drawing operations (Rect, Line and Clear).
	End Rem
	Method GetDrawColor:Int(r:Byte Var, g:Byte Var, b:Byte Var, a:Byte Var)
		Return SDL_GetRenderDrawColor(rendererPtr, Varptr r, Varptr g, Varptr b, Varptr a)
	End Method
	
	Rem
	bbdoc: Getsthe current render target.
	End Rem
	Method GetTarget:TSDLSurface()
		Return TSDLSurface._create(SDL_GetRenderTarget(rendererPtr))
	End Method
	
	Rem
	bbdoc: Gets the output size in pixels of a rendering context.
	End Rem
	Method GetOutputSize:Int(w:Int Var, h:Int Var)
		Return SDL_GetRendererOutputSize(rendererPtr, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Clears the current rendering target with the drawing color.
	End Rem
	Method Clear:Int()
		Return SDL_RenderClear(rendererPtr)
	End Method
	
	Rem
	bbdoc: Copies a portion of the texture to the current rendering target.
	End Rem
	Method Copy:Int(texture:TSDLTexture, sx:Int = -1, sy:Int = -1, sw:Int = -1, sh:Int = -1, dx:Int = -1, dy:Int = -1, dw:Int = -1, dh:Int = -1)
		Return bmx_SDL_RenderCopy(rendererPtr, texture.texturePtr, sx, sy, sw, sh, dx, dy, dw, dh)
	End Method
	
	Rem
	bbdoc: Copies a portion of the texture to the current rendering target, optionally rotating it by angle around the given center and also flipping it top-bottom and/or left-right.
	End Rem
	Method CopyEx:Int(texture:TSDLTexture, sx:Int = -1, sy:Int = -1, sw:Int = -1, sh:Int = -1, dx:Int = -1, dy:Int = -1, dw:Int = -1, dh:Int = -1, angle:Double = 0, cx:Int = -1, cy:Int = -1, flipMode:Int = SDL_FLIP_NONE)
		Return bmx_SDL_RenderCopyEx(rendererPtr, texture.texturePtr, sx, sy, sw, sh, dx, dy, dw, dh, angle, cx, cy, flipMode)
	End Method
	
	Rem
	bbdoc: Draws a line on the current rendering target.
	End Rem
	Method DrawLine:Int(x1:Int, y1:Int, x2:Int, y2:Int)
		Return SDL_RenderDrawLine(rendererPtr, x1, y1, x2, y2)
	End Method
	
	Rem
	bbdoc: Draws a series of connected lines on the current rendering target.
	about: A point consists of a pair of Ints (x, y), where @count is the count of pairs.
	End Rem
	Method DrawLines:Int(points:Int Ptr, count:Int)
		Return SDL_RenderDrawLines(rendererPtr, points, count)
	End Method
	
	Rem
	bbdoc: Draws a point on the current rendering target.
	End Rem
	Method DrawPoint:Int(x:Int, y:Int)
		Return SDL_RenderDrawPoint(rendererPtr, x, y)
	End Method
	
	Rem
	bbdoc: Draws multiple points on the current rendering target.
	End Rem
	Method DrawPoints:Int(points:Int Ptr, count:Int)
		Return SDL_RenderDrawPoints(rendererPtr, points, count)
	End Method
	
	Rem
	bbdoc: Draws a rectangle on the current rendering target.
	End Rem
	Method DrawRect:Int(x:Int = -1, y:Int = -1, w:Int = -1, h:Int = -1)
		Return bmx_SDL_RenderDrawRect(rendererPtr, x, y, w, h)
	End Method
	
	Rem
	bbdoc: Draws some number of rectangles on the current rendering target.
	End Rem
	Method DrawRects:Int(rects:Int Ptr, count:Int)
		Return SDL_RenderDrawRects(rendererPtr, rects, count)
	End Method
	
	Rem
	bbdoc: Fills a rectangle on the current rendering target with the drawing color.
	End Rem
	Method FillRect:Int(x:Int = -1, y:Int = -1, w:Int = -1, h:Int = -1)
		Return bmx_SDL_RenderFillRect(rendererPtr, x, y, w, h)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method FillRects:Int(rects:Int Ptr, count:Int)
		Return SDL_RenderFillRects(rendererPtr, rects, count)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetClipRect(x:Int Var, y:Int Var, w:Int Var, h:Int Var)
		bmx_SDL_RenderGetClipRect(rendererPtr, Varptr x, Varptr y, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Gets whether integer scales are forced for resolution-independent rendering.
	End Rem
	Method GetIntegerScale:Int()
		Return SDL_RenderGetIntegerScale(rendererPtr)
	End Method
	
	Rem
	bbdoc: Gets device independent resolution for rendering.
	End Rem
	Method GetLogicalSize(w:Int Var, h:Int Var)
		SDL_RenderGetLogicalSize(rendererPtr, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Gets the drawing scale for the current target.
	End Rem
	Method GetScale(x:Float Var, y:Float Var)
		SDL_RenderGetScale(rendererPtr, Varptr x, Varptr y)
	End Method
	
	Rem
	bbdoc: Gets the drawing area for the current target.
	End Rem
	Method GetViewport(x:Int Var, y:Int Var, w:Int Var, h:Int Var)
		bmx_SDL_RenderGetViewport(rendererPtr, Varptr x, Varptr y, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Gets whether clipping is enabled on the given renderer.
	End Rem
	Method IsClipEnabled:Int()
		Return SDL_RenderIsClipEnabled(rendererPtr)
	End Method
	
	Rem
	bbdoc: Updates the screen with any rendering performed since the previous call.
	End Rem
	Method Present()
		SDL_RenderPresent(rendererPtr)
	End Method
	
	Rem
	bbdoc: Reads pixels from the current rendering target.
	End Rem
	Method ReadPixels:Int(format:UInt, pixels:Byte Ptr, pitch:Int, x:Int = -1, y:Int = -1, w:Int = -1, h:Int = -1)
		Return bmx_SDL_RenderReadPixels(rendererPtr, format, pixels, pitch, x, y, w, h)
	End Method
	
	Rem
	bbdoc: Sets the clip rectangle for rendering on the specified target.
	End Rem
	Method SetClipRect:Int(x:Int = -1, y:Int = -1, w:Int = -1, h:Int = -1)
		Return bmx_SDL_RenderSetClipRect(rendererPtr, x, y, w, h)
	End Method
	
	Rem
	bbdoc: Sets whether to force integer scales for resolution-independent rendering.
	End Rem
	Method SetIntegerScale:Int(enable:Int)
		Return SDL_RenderSetIntegerScale(rendererPtr, enable)
	End Method
	
	Rem
	bbdoc: Sets a device independent resolution for rendering.
	End Rem
	Method SetLogicalSize:Int(w:Int, h:Int)
		Return SDL_RenderSetLogicalSize(rendererPtr, w, h)
	End Method
	
	Rem
	bbdoc: Sets the drawing scale for rendering on the current target.
	End Rem
	Method SetScale:Int(scaleX:Float, scaleY:Float)
		Return SDL_RenderSetScale(rendererPtr, scaleX, scaleY)
	End Method
	
	Rem
	bbdoc: Sets the drawing area for rendering on the current target.
	End Rem
	Method SetViewport:Int(x:Int = -1, y:Int = -1, w:Int = -1, h:Int = -1)
		Return bmx_SDL_RenderSetViewport(rendererPtr, x, y, w, h)
	End Method
	
	Rem
	bbdoc: Determines whether a window supports the use of render targets.
	End Rem
	Method TargetSupported:Int()
		Return SDL_RenderTargetSupported(rendererPtr)
	End Method
	
	Rem
	bbdoc: Sets the blend mode used for drawing operations (Fill and Line).
	End Rem
	Method SetDrawBlendMode:Int(blendMode:Int)
		Return SDL_SetRenderDrawBlendMode(rendererPtr, blendMode)
	End Method
	
	Rem
	bbdoc: Sets the color used for drawing operations (Rect, Line and Clear).
	End Rem
	Method SetDrawColor:Int(r:Byte, g:Byte, b:Byte, a:Byte)
		Return SDL_SetRenderDrawColor(rendererPtr, r, g, b, a)
	End Method
	
	Rem
	bbdoc: Sets a texture as the current rendering target.
	End Rem
	Method SetTarget:Int(texture:TSDLTexture)
		If texture Then
			Return SDL_SetRenderTarget(rendererPtr, texture.texturePtr)
		Else
			Return SDL_SetRenderTarget(rendererPtr, Null)
		End If
	End Method
	
	Rem
	bbdoc: Destroys the rendering context for a window and free associated textures.
	End Rem
	Method Destroy()
		If rendererPtr Then
			SDL_DestroyRenderer(rendererPtr)
			rendererPtr = Null
		End If
	End Method
	
End Type

Rem
bbdoc: An efficient driver-specific representation of pixel data.
End Rem
Type TSDLTexture

	Field texturePtr:Byte Ptr
	
	Function _create:TSDLTexture(texturePtr:Byte Ptr)
		If texturePtr Then
			Local this:TSDLTexture = New TSDLTexture
			this.texturePtr = texturePtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Gets the additional alpha value multiplied into render copy operations.
	End Rem
	Method GetAlphaMod:Int(alpha:Byte Var)
		Return SDL_GetTextureAlphaMod(texturePtr, Varptr alpha)
	End Method
	
	Rem
	bbdoc: Gets the blend mode used for texture copy operations.
	End Rem
	Method GetBlendMode:Int(blendMode:Int Var)
		Return SDL_GetTextureBlendMode(texturePtr, Varptr blendMode)
	End Method
	
	Rem
	bbdoc: Gets the additional color value multiplied into render copy operations.
	End Rem
	Method GetColorMod:Int(r:Byte Var, g:Byte Var, b:Byte Var)
		Return SDL_GetTextureColorMod(texturePtr, Varptr r, Varptr g, Varptr b)
	End Method
	
	Rem
	bbdoc: Locks a portion of the texture for write-only pixel access.
	End Rem
	Method Lock:Int(pixels:Byte Ptr Ptr, pitch:Int Var, x:Int = -1, y:Int = -1, w:Int = -1, h:Int = -1)
		Return bmx_SDL_LockTexture(texturePtr, pixels, Varptr pitch, x, y, w, h)
	End Method
	
	Rem
	bbdoc: Queries the attributes of a texture.
	End Rem
	Method Query:Int(format:UInt Var, access:Int Var, w:Int Var, h:Int Var)
		Return SDL_QueryTexture(texturePtr, Varptr format, Varptr access, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Sets an additional alpha value multiplied into render copy operations.
	End Rem
	Method SetAlphaMod:Int(alpha:Byte)
		Return SDL_SetTextureAlphaMod(texturePtr, alpha)
	End Method
	
	Rem
	bbdoc: Sets the blend mode for a texture, used by TSDLRenderer.Copy().
	End Rem
	Method SetBlendMode:Int(blendMode:Int)
		Return SDL_SetTextureBlendMode(texturePtr, blendMode)
	End Method
	
	Rem
	bbdoc: Sets an additional color value multiplied into render copy operations.
	End Rem
	Method SetColorMod:Int(r:Byte, g:Byte, b:Byte)
		Return SDL_SetTextureColorMod(texturePtr, r, g, b) 
	End Method
	
	Rem
	bbdoc: Unlocks a texture, uploading the changes to video memory, if needed.
	End Rem
	Method Unlock()
		SDL_UnlockTexture(texturePtr)
	End Method
	
	Rem
	bbdoc: Updates the given texture rectangle with new pixel data.
	End Rem
	Method Update:Int(pixels:Byte Ptr, pitch:Int, x:Int = -1, y:Int = -1, w:Int = -1, h:Int = -1)
		Return bmx_SDL_UpdateTexture(texturePtr, pixels, pitch, x, y, w, h)
	End Method
	
	Rem
	bbdoc: Updates a rectangle within a planar YV12 or IYUV texture with new pixel data.
	End Rem
	Method UpdateYUV:Int(yPlane:Byte Ptr, yPitch:Int, uPlane:Byte Ptr, uPitch:Int, vPlane:Byte Ptr, vPitch:Int, x:Int = -1, y:Int = -1, w:Int = -1, h:Int = -1)
		Return bmx_SDL_UpdateYUVTexture(texturePtr, yPlane, yPitch, uPlane, uPitch, vPlane, vPitch, x, y, w, h)
	End Method
	
	Rem
	bbdoc: Destroys the texture.
	End Rem
	Method Destroy()
		If texturePtr Then
			SDL_DestroyTexture(texturePtr)
			texturePtr = Null
		End If
	End Method
	
End Type

Rem
bbdoc: Gets the number of 2D rendering drivers available for the current display.
End Rem
Function SDLGetNumRenderDrivers:Int()
	Return SDL_GetNumRenderDrivers()
End Function



