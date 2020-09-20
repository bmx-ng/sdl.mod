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
bbdoc: SDL Surface
End Rem
Module SDL.SDLSurface

Import SDL.SDL

Import "common.bmx"

Rem
bbdoc: A collection of pixels used in software blitting.
End Rem
Type TSDLSurface

	Field surfacePtr:Byte Ptr
	
	Function _create:TSDLSurface(surfacePtr:Byte Ptr)
		If surfacePtr Then
			Local this:TSDLSurface = New TSDLSurface
			this.surfacePtr = surfacePtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Allocates a new RGB surface.
	returns: The new surface that is created or Null if it fails.
	about: If depth is 4 or 8 bits, an empty palette is allocated for the surface.
	If depth is greater than 8 bits, the pixel format is set using the [RGBA]mask parameters.
	The [RGBA]mask parameters are the bitmasks used to extract that color from a pixel. For instance,
	Rmask being FF000000 means the red data is stored in the most significant byte. Using zeros for the RGB masks sets a default value,
	based on the depth. (e.g. #CreateRGB(0,w,h,32,0,0,0,0);) However, using zero for the Amask results in an Amask of 0.
	By default surfaces with an alpha mask are set up for blending as with #SetBlendMode(#SDL_BLENDMODE_BLEND)
	You can change this by calling #SetBlendMode() and selecting a different blendMode.
	End Rem
	Function CreateRGB:TSDLSurface(width:Int, height:Int, depth:Int, Rmask:UInt, Gmask:UInt, Bmask:UInt, Amask:UInt)
		Return _create(SDL_CreateRGBSurface(0, width, height, depth, Rmask, Gmask, Bmask, Amask))
	End Function

	Rem
	bbdoc: Allocates an RGB surface.
	returns: A new surface on success or Null on failure.
	about: If the method runs out of memory, it will return Null.
	End Rem
	Function CreateRGBWithFormat:TSDLSurface(width:Int, height:Int, depth:Int, format:UInt)
		Return _create(SDL_CreateRGBSurfaceWithFormat(0, width, height, depth, format))
	End Function
	
	Rem
	bbdoc: Allocates a new RGB surface with existing pixel data.
	returns: The new surface that is created or Null if it fails.
	about: If depth is 4 or 8 bits, an empty palette is allocated for the surface.
	If depth is greater than 8 bits, the pixel format is set using the [RGBA]mask parameters.
	The [RGBA]mask parameters are the bitmasks used to extract that color from a pixel. For instance,
	Rmask being FF000000 means the red data is stored in the most significant byte. Using zeros for the RGB masks sets a default value,
	based on the depth. (e.g. #CreateRGB(0,w,h,32,0,0,0,0);) However, using zero for the Amask results in an Amask of 0.
	By default surfaces with an alpha mask are set up for blending as with #SetBlendMode(#SDL_BLENDMODE_BLEND)
	You can change this by calling #SetBlendMode() and selecting a different blendMode.
	Note: No copy is made of the pixel data. Pixel data is not managed automatically; you must free the surface before you free the pixel data.
	End Rem
	Function CreateRGBFrom:TSDLSurface(pixels:Byte Ptr, width:Int, height:Int, depth:Int, pitch:Int, Rmask:UInt, Gmask:UInt, Bmask:UInt, Amask:UInt)
		Return _create(SDL_CreateRGBSurfaceFrom(pixels, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask))
	End Function
	
	Rem
	bbdoc: Loads a surface from a BMP file.
	End Rem
	Function LoadBMP:TSDLSurface(file:String)
		Return _create(bmx_sdl_LoadBMP(file))
	End Function
	
	Rem
	bbdoc: Copies the surface to a new surface of the specified format.
	returns: The new surface, or Null on failure.
	about: This method is used to optimize images for faster repeat blitting. This is accomplished by converting the original
	and storing the result as a new surface. The new, optimized surface can then be used as the source for future blits, making them faster.
	End Rem
	Method ConvertFormat:TSDLSurface(pixelFormat:UInt)
		Return _create(SDL_ConvertSurfaceFormat(surfacePtr, pixelFormat, 0))
	End Method
	
	Rem
	bbdoc: Copies an existing surface into a new one that is optimized for blitting to a surface of a specified pixel format.
	returns: The new surface that is created or NULL if it fails
	End Rem
	Method Convert:TSDLSurface(format:TSDLPixelFormat)
		Return _create(SDL_ConvertSurface(surfacePtr, format.pixelPtr, 0))
	End Method
	
	Rem
	bbdoc: Returns the format of the pixels stored in the surface.
	End Rem
	Method Format:TSDLPixelFormat()
		Return TSDLPixelFormat._create(bmx_sdl_surface_Format(surfacePtr))
	End Method
	
	Rem
	bbdoc: Returns the width in pixels.
	End Rem
	Method Width:Int()
		Return bmx_sdl_surface_Width(surfacePtr)
	End Method
	
	Rem
	bbdoc: Returns the height in pixels.
	End Rem
	Method Height:Int()
		Return bmx_sdl_surface_Height(surfacePtr)
	End Method
	
	Rem
	bbdoc: Returns the length of a row of pixels in bytes.
	End Rem
	Method Pitch:Int()
		Return bmx_sdl_surface_Pitch(surfacePtr)
	End Method
	
	Rem
	bbdoc: Returns the pointer to the actual pixel data.
	End Rem
	Method Pixels:Byte Ptr()
		Return bmx_sdl_surface_Pixels(surfacePtr)
	End Method
	
	Rem
	bbdoc: Gets the clipping rectangle for the surface.
	about: When the surface is the destination of a blit, only the area within the clip rectangle is drawn into.
	End Rem
	Method GetClipRect(x:Int Var, y:Int Var, w:Int Var, h:Int Var)
		bmx_sdl_surface_GetClipRect(surfacePtr, Varptr x, Varptr y, Varptr w, Varptr h)
	End Method
	
	Rem
	bbdoc: Sets the clipping rectangle for a surface.
	returns: True if the rectangle intersects the surface, otherwise False and blits will be completely clipped.
	about: When the surface is the destination of a blit, only the area within the clip rectangle is drawn into.
	Note that blits are automatically clipped to the edges of the source and destination surfaces.
	End Rem
	Method SetClipRect(x:Int, y:Int, w:Int, h:Int)
		bmx_sdl_surface_SetClipRect(surfacePtr, x, y, w, h)
	End Method
	
	Rem
	bbdoc: Gets the color key (transparent pixel) for a surface.
	returns: 0 on success or a negative error code on failure.
	about: The color key is a pixel of the format used by the surface, as generated by #SDLMapRGB.
	If the surface doesn't have color key enabled this method returns -1.
	End Rem
	Method GetColorKey:Int(key:UInt Var)
		Return SDL_GetColorKey(surfacePtr, Varptr key) 
	End Method
	
	Rem
	bbdoc: Gets the additional alpha value used in blit operations.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Method GetAlphaMod:Int(alpha:Byte Var)
		Return SDL_GetSurfaceAlphaMod(surfacePtr, Varptr alpha)
	End Method
	
	Rem
	bbdoc: Gets the blend mode used for blit operations.
	returns: 0 on success or a negative error code on failure
	about: @blendMode will be filled in with one of the following : #SDL_BLENDMODE_NONE, #SDL_BLENDMODE_BLEND, #SDL_BLENDMODE_ADD or #SDL_BLENDMODE_MOD.
	End Rem
	Method GetBlendMode:Int(blendMode:Int Var)
		Return SDL_GetSurfaceBlendMode(surfacePtr, Varptr blendMode)
	End Method
	
	Rem
	bbdoc: Gets the additional color value multiplied into blit operations.
	returns: 0 on success or a negative error code on failure.
	End Rem
	Method GetColorMod:Int(r:Byte Var, g:Byte Var, b:Byte Var)
		Return SDL_GetSurfaceColorMod(surfacePtr, Varptr r, Varptr g, Varptr b)
	End Method
	
	Rem
	bbdoc: Sets up a surface for directly accessing the pixels.
	returns: 0 on success or a negative error code on failure
	about: Between calls to #Lock() / #Unlock(), you can write to and read from surface->pixels, using the pixel format stored
	in surface->format. Once you are done accessing the surface, you should use #Unlock() to release it.
	Not all surfaces require locking. If #MustLock() evaluates to 0, then you can read and write to the surface at any time,
	and the pixel format of the surface will not change.
	End Rem
	Method Lock:Int()
		Return SDL_LockSurface(surfacePtr)
	End Method
	
	Rem
	bbdoc: Releases a surface after directly accessing the pixels.
	returns: 0 on success or a negative error code on failure.
	about: Between calls to #Lock() / #Unlock(), you can write to and read from surface->pixels, using the pixel format stored
	in surface->format. Once you are done accessing the surface, you should use #Unlock() to release it.
	Not all surfaces require locking. If #MustLock() evaluates to 0, then you can read and write to the surface at any time,
	and the pixel format of the surface will not change.
	End Rem
	Method Unlock:Int()
		Return SDL_UnlockSurface(surfacePtr)
	End Method
	
	Rem
	bbdoc: Determines whether a surface must be locked for access.
	returns: True if the surface must be locked for access, False if not.
	End Rem
	Method MustLock:Int()
		Return bmx_sdl_surface_MustLock(surfacePtr)
	End Method
	
	Rem
	bbdoc: Sets the color key (transparent pixel) in a surface.
	returns: 0 on success or a negative error code on failure/
	about: The color key defines a pixel value that will be treated as transparent in a blit. It is a pixel of the format used by
	the surface, as generated by #SDLMapRGB().
	RLE acceleration can substantially speed up blitting of images with large horizontal runs of transparent pixels. See #SetRLE() for details.
	End Rem
	Method SetColorKey:Int(flag:Int, key:UInt)
		Return SDL_SetColorKey(surfacePtr, flag, key)
	End Method
	
	Rem
	bbdoc: Sets an additional alpha value used in blit operations.
	returns: 0 on success or a negative error code on failure.
	about: When this surface is blitted, during the blit operation the source alpha value is modulated by this alpha
	value according to the following formula: srcA = srcA * (alpha / 255)
	End Rem
	Method SetAlphaMod:Int(alpha:Byte)
		Return SDL_SetSurfaceAlphaMod(surfacePtr, alpha)
	End Method
	
	Rem
	bbdoc: Sets the blend mode used for blit operations.
	returns: 0 on success or a negative error code on failure.
	about: @blendMode may be one of the following: #SDL_BLENDMODE_NONE, #SDL_BLENDMODE_BLEND, #SDL_BLENDMODE_ADD or #SDL_BLENDMODE_MOD.
	To copy a surface to another surface (or texture) without blending with the existing data, the blendmode of the
	SOURCE surface should be set to #SDL_BLENDMODE_NONE.
	End Rem
	Method SetBlendMode:Int(blendMode:Int)
		Return SDL_SetSurfaceBlendMode(surfacePtr, blendMode)
	End Method
	
	Rem
	bbdoc: Sets an additional color value multiplied into blit operations.
	about: When this surface is blitted, during the blit operation each source color channel is modulated by the
	appropriate color value according to the following formula: srcC = srcC * (color / 255)
	End Rem
	Method SetColorMod:Int(r:Byte, g:Byte, b:Byte)
		Return SDL_SetSurfaceColorMod(surfacePtr, r, g, b)
	End Method
	
	Rem
	bbdoc: Sets the RLE acceleration hint for a surface.
	End Rem
	Method SetRLE:Int(flag:Int)
		Return SDL_SetSurfaceRLE(surfacePtr, flag)
	End Method
	
	Rem
	bbdoc: Perform a fast fill of a rectangle with a specific color.
	returns: 0 on success or a negative error code on failure.
	about: @color should be a pixel of the format used by the surface, and can be generated by #SDLMapRGB() or #SDLMapRGBA().
	If the color value contains an alpha component then the destination is simply filled with that alpha information, no blending takes place.
	If there is a clip rectangle set on the destination (set via SDL_SetClipRect()), then this function will fill based on the intersection of the clip rectangle and rect.
	End Rem
	Method FillRect:Int(x:Int, y:Int, w:Int, h:Int, color:UInt)
		Return bmx_sdl_surface_FillRect(surfacePtr, x, y, w, h, color)
	End Method
	
	Rem
	bbdoc: Performs a fast fill of a set of rectangles with a specific color.
	returns: 0 on success or a negative error code on failure.
	about: @rects consists of @count sets of x,y,w,h Ints packed together.
	@color should be a pixel of the format used by the surface, and can be generated by #SDLMapRGB or #SDLMapRGBA().
	If the color value contains an alpha component then the destination is simply filled with that alpha information, no blending takes place.
	If there is a clip rectangle set on the destination (set via #SetClipRect()), then this method will fill based on the
	intersection of the clip rectangle and rects.
	End Rem
	Method FillRects:Int(rects:Int Ptr, count:Int, color:UInt)
		Return SDL_FillRects(surfacePtr, rects, count, color)
	End Method
	
	Rem
	bbdoc: 
	about: Use all zero source coords to copy the entire surface.
	Use all zero destination coords to copy into the entire surface.
	You should call #Blit() unless you know exactly how SDL blitting works internally and how to use the other blit functions.
	The blit method should NOT be called on a locked surface.
	
	End Rem
	Method Blit:Int(sx:Int, sy:Int, sw:Int, sh:Int, dest:TSDLSurface, dx:Int = 0, dy:Int = 0)
		Return bmx_sdl_surface_Blit(surfacePtr, sx, sy, sw, sh, dest.surfacePtr, dx, dy)
	End Method
	
	Rem
	bbdoc: Performs a scaled surface copy to a destination surface.
	returns: 0 on success or a negative error code on failure.
	about: Use all zero source coords to copy the entire surface.
	Use all zero destination coords to copy into the entire surface.
	End Rem
	Method BlitScaled:Int(sx:Int, sy:Int, sw:Int, sh:Int, dest:TSDLSurface, dx:Int = 0, dy:Int = 0)
		Return bmx_sdl_surface_BlitScaled(surfacePtr, sx, sy, sw, sh, dest.surfacePtr, dx, dy)
	End Method
	
	Rem
	bbdoc: Frees the surface.
	End Rem
	Method Free()
		If surfacePtr Then
			SDL_FreeSurface(surfacePtr)
			surfacePtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method
	
End Type


Rem
bbdoc: 
End Rem
Type TSDLPixelFormat

	Field pixelPtr:Byte Ptr
	
	Function _create:TSDLPixelFormat(pixelPtr:Byte Ptr)
		If pixelPtr Then
			Local this:TSDLPixelFormat = New TSDLPixelFormat
			this.pixelPtr = pixelPtr
			Return this
		End If
	End Function
	
End Type


