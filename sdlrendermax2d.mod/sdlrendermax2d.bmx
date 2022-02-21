' Copyright (c) 2021-2022 Bruce A Henderson
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
bbdoc: Graphics/SDLRender Max2D
about:
The SDLRender Max2D module provides an SDL-backend SDLRender driver for #Max2D.
End Rem
Module SDL.SDLRenderMax2D

ModuleInfo "Version: 1.00"
ModuleInfo "License: zlib/libpng"

ModuleInfo "History: 1.00"
ModuleInfo "History: Initial release"

Import BRL.Max2D
Import SDL.SDLGraphics
Import SDL.SDLRender

Private

Global _driver:TSDLRenderMax2DDriver
Global _preferredRenderer:Int = -1

Function Pow2Size:Int( n:Int )
	Local t:Int = 1
	While t < n
		t :* 2
	Wend
	Return t
End Function

Function AdjustTexSize( width:Int Var, height:Int Var )
	'calc texture size
	width = Pow2Size( width )
	height = Pow2Size( height )
End Function


Type TSDLRenderRenderImageContext Extends TRenderImageContext
	Field _gc:TSDLGraphics
	Field _renderer:TSDLRenderer

	Method Create:TSDLRenderRenderimageContext(gc:TGraphics, driver:TGraphicsDriver)
		_gc = TSDLGraphics(gc)
		_renderer = TSDLRenderMax2DDriver(driver).renderer

		Return Self
	EndMethod
	
	Method Destroy() override
		'needed by interface
	End Method
	
	Method GraphicsContext:TGraphics()
		Return _gc
	EndMethod

	Method CreateRenderImage:TRenderImage(width:Int, height:Int, UseImageFiltering:Int)
		Local renderimage:TSDLRenderRenderImage = New TSDLRenderRenderImage.CreateRenderImage(width, height)
		renderimage.Init(_renderer, UseImageFiltering, Null)
		Return renderimage
	EndMethod

	Method CreateRenderImageFromPixmap:TRenderImage(pixmap:TPixmap, UseImageFiltering:Int)
		Local renderimage:TSDLRenderRenderImage = New TSDLRenderRenderImage.CreateRenderImage(pixmap.width, pixmap.height)
		renderimage.Init(_renderer, UseImageFiltering, pixmap)
		Return renderimage
	EndMethod

	Method DestroyRenderImage(renderImage:TRenderImage)
		renderImage.DestroyRenderImage()
	EndMethod

	Method SetRenderImage(renderimage:TRenderimage)
		If Not renderimage
			_renderer.SetTarget(Null)
		Else
			renderimage.SetRenderImage()
		EndIf
	EndMethod

	Method CreatePixmapFromRenderImage:TPixmap(renderImage:TRenderImage)
		Return TSDLRenderRenderImage(renderImage).ToPixmap()
	EndMethod
EndType


Type TSDLRenderRenderImageFrame Extends TSDLRenderImageFrame
	Method Clear(r:Int=0, g:Int=0, b:Int=0, a:Float=0.0)
		if not texture or not renderer then Return
		
		local oldTarget:TSDLTexture = renderer.GetTarget()
		Local oldR:Byte, oldG:Byte, oldB:Byte, oldA:Byte
		renderer.GetDrawColor(oldR, oldG, oldB, oldA)

		renderer.SetTarget(texture)
		renderer.SetDrawColor(Byte(r), Byte(g), Byte(b), Byte(a * 255))
		renderer.Clear()
		renderer.SetDrawColor(oldR, oldG, oldB, oldA)
		
		renderer.SetTarget(oldTarget)
	End Method

	Method CreateRenderTarget:TSDLRenderRenderImageFrame(renderer:TSDLRenderer, width:Int, height:Int, UseImageFiltering:Int, pixmap:TPixmap)
		If pixmap
			width = Min(pixmap.width, width)
			height = Min(pixmap.height, height)

			'other r2t backends compare to RGBA also for RGB888!
			If pixmap.format <> PF_RGBA8888 And pixmap.format <> PF_RGB888 Then
				pixmap = pixmap.Convert( PF_RGBA8888 )
			EndIf
		EndIf

		self.renderer = renderer
		self.pixmap = Null
		self.surface = Null
		'Ronny: Seems SDL wants ABGR here (RGBA leads to wrong colours) 
		'       This way we avoid converting pixel data within BlitzMax
		'self.texture = renderer.CreateTexture(SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, width, height)
		self.texture = renderer.CreateTexture(SDL_PIXELFORMAT_ABGR8888, SDL_TEXTUREACCESS_TARGET, width, height)

		'copy content of passed pixmap
		If pixmap
			'calling update() (or SDL_UpdateTexture()) is a "slow operation"
			'and we might consider using the streamed-texture approach.
			'see: https://wiki.libsdl.org/SDL_UpdateTexture
			'but this comes with disadvantages too!
			self.texture.update(pixmap.pixels, pixmap.pitch, 0,0, pixmap.width, pixmap.height)
		Else
			'clear to a default colour
			Clear(0,0,0,0)
		EndIf

		'Ronny: should this now better use texture's width/height ?
		self.uscale = 1.0 / width
		self.vscale = 1.0 / height
		'Ronny: needed?
		self.u1 = width * self.uscale
		self.v1 = height * self.vscale

		Return Self
	EndMethod

	Method DestroyRenderTarget()
		'TODO: something to destroy?
	EndMethod

	Method ToPixmap:TPixmap(width:Int, height:Int)
		Local p:TPixmap = CreatePixmap(width, height, PF_RGBA8888)

		'set to self as target
		local oldTarget:TSDLTexture = renderer.GetTarget()
		renderer.SetTarget(texture)
		renderer.ReadPixels(SDL_PIXELFORMAT_ABGR8888, p.pixels, p.pitch, 0, 0, width, height)
		renderer.SetTarget(oldTarget)
		
		Return p
	EndMethod
EndType

Type TSDLRenderRenderImage Extends TRenderImage
	Field _matrix:Float[16]

	Method CreateRenderImage:TSDLRenderRenderImage(width:Int, height:Int)
		Self.width = width		' TImage.width
		Self.height = height	' TImage.height

		_matrix = [	2.0/width, 0.0, 0.0, 0.0,..
					0.0, 2.0/height, 0.0, 0.0,..
					0.0, 0.0, 1.0, 0.0,..
					-1-(1.0/width), -1-(1.0/height), 1.0, 1.0 ]

		Return Self
	EndMethod

	Method DestroyRenderImage()
		TSDLRenderRenderImageFrame(frames[0]).DestroyRenderTarget()
	EndMethod

	Method Init(renderer:TSDLRenderer, UseImageFiltering:Int, pixmap:TPixmap)
		frames = New TSDLRenderRenderImageFrame[1]
		frames[0] = New TSDLRenderRenderImageFrame.CreateRenderTarget(renderer, width, height, UseImageFiltering, pixmap)
	EndMethod

	Method Clear(r:Int=0, g:Int=0, b:Int=0, a:Float=0.0)
		If frames[0] Then TSDLRenderRenderImageFrame(frames[0]).Clear(r, g, b, a)
	End Method

	Method Frame:TImageFrame(index:Int=0)
		Return frames[0]
	EndMethod

	Method SetRenderImage()
		if not frames[0] then return
		
		Local f:TSDLRenderImageFrame = TSDLRenderImageFrame(frames[0])
		if not f or not f.renderer then return
		f.renderer.SetTarget(f.texture)
	EndMethod

	Method ToPixmap:TPixmap()
		Return TSDLRenderRenderImageFrame(frames[0]).ToPixmap(width, height)
	EndMethod

	Method SetViewport(x:Int, y:Int, width:Int, height:Int)
		'SDL handles that already
	EndMethod
EndType


Public

Type TSDLRenderImageFrame Extends TImageFrame

	Field u0#, v0#, u1#, v1#, uscale#, vscale#

	Field pixmap:TPixmap
	Field surface:TSDLSurface
	Field texture:TSDLTexture
	Field renderer:TSDLRenderer
	
	Method New()
	End Method
	
	Method Delete()
		If texture Then
			texture.Destroy()
			texture = Null
		End If
		If surface Then
			surface.Free()
			surface = Null
		End If
		pixmap = Null
	End Method
	
	Method Draw( x0#,y0#,x1#,y1#,tx#,ty#,sx#,sy#,sw#,sh# ) Override

		Local u0# = sx * uscale
		Local v0# = sy * vscale
		Local u1# = ( sx + sw ) * uscale
		Local v1# = ( sy + sh ) * vscale

		_driver.DrawTexture( texture, u0, v0, u1, v1, x0, y0, x1, y1, tx, ty, Self )

	End Method
	
	Function CreateFromPixmap:TSDLRenderImageFrame( src:TPixmap,flags:Int )
		
		Local tex_w:Int = src.width
		Local tex_h:Int = src.height
		
		Local width:Int = Min( src.width, tex_w )
		Local height:Int = Min( src.height, tex_h )
		
		If src.format <> PF_RGBA8888 And src.format <> PF_RGB888 Then
			src = src.Convert( PF_RGBA8888 )
		End If

		'done!
		Local frame:TSDLRenderImageFrame=New TSDLRenderImageFrame
		frame.renderer = _driver.renderer
		frame.pixmap = src
		frame.surface = TSDLSurface.CreateRGBFrom(src.pixels, src.width, src.height, BitsPerPixel[src.format], src.pitch, $000000ff:UInt, $0000ff00:UInt, $00ff0000:UInt, $ff000000:UInt)
		frame.texture = frame.renderer.CreateTextureFromSurface(frame.surface)
		frame.uscale = 1.0 / tex_w
		frame.vscale = 1.0 / tex_h
		frame.u1 = width * frame.uscale
		frame.v1 = height * frame.vscale
		Return frame
	End Function

End Type

Type TSDLRenderMax2DDriver Extends TMax2DDriver

	Field drawColor:SDLColor = New SDLColor(255, 255, 255, 255)
	Field clsColor:SDLColor = New SDLColor(0, 0, 0, 255)

	Field renderer:TSDLRenderer
	Field ix#,iy#,jx#,jy#
	Field state_blend:Int

	Method Create:TSDLRenderMax2DDriver()
		If Not SDLGraphicsDriver() Return Null
		
		Return Self
	End Method

	'graphics driver overrides
	Method GraphicsModes:TGraphicsMode[]() Override
		Return SDLGraphicsDriver().GraphicsModes()
	End Method
	
	Method AttachGraphics:TMax2DGraphics( widget:Byte Ptr,flags:Long ) Override
		Local g:TSDLGraphics=SDLGraphicsDriver().AttachGraphics( widget,flags )
		If g Return TMax2DGraphics.Create( g,Self )
	End Method
	
	Method CreateGraphics:TMax2DGraphics( width:Int,height:Int,depth:Int,hertz:Int,flags:Long,x:Int,y:Int ) Override
		Local g:TSDLGraphics=SDLGraphicsDriver().CreateGraphics( width,height,depth,hertz,flags,x,y )
		If g Return TMax2DGraphics.Create( g,Self )
	End Method
	
	Method SetGraphics( g:TGraphics ) Override
		If Not g
			TMax2DGraphics.ClearCurrent
			SDLGraphicsDriver().SetGraphics Null
			Return
		EndIf
	
		Local t:TMax2DGraphics=TMax2DGraphics(g)
		Assert t And TSDLGraphics( t._graphics )

		Local gfx:TSDLGraphics = TSDLGraphics( t._graphics )

		SDLGraphicsDriver().SetGraphics gfx

		Local flags:UInt
		If gfx._context.flags & GRAPHICS_SWAPINTERVAL1 Then
			flags :| SDL_RENDERER_PRESENTVSYNC
		End If

		renderer = TSDLRenderer.Create(gfx._context.window, _preferredRenderer, flags)
		
		t.MakeCurrent
	End Method

	Method Flip:Int( sync:Int ) Override
		renderer.Present()
	End Method
	
	Method ToString$() Override
		Return "SDLRenderer"
	End Method

	Method CreateRenderImageContext:Object(g:TGraphics) Override
		Return new TSDLRenderRenderImageContext.Create(g, self)
	End Method
	
	Method CreateFrameFromPixmap:TSDLRenderImageFrame( pixmap:TPixmap,flags:Int ) Override
		Local frame:TSDLRenderImageFrame
		frame=TSDLRenderImageFrame.CreateFromPixmap( pixmap,flags )
		Return frame
	End Method

	Method SetBlend( blend:Int ) Override
		If blend=state_blend Return
		state_blend=blend
		Select blend
		Case MASKBLEND
			renderer.SetDrawBlendMode(SDL_BLENDMODE_BLEND)
		Case SOLIDBLEND
			renderer.SetDrawBlendMode(SDL_BLENDMODE_NONE)
		Case ALPHABLEND
			renderer.SetDrawBlendMode(SDL_BLENDMODE_BLEND)
		Case LIGHTBLEND
			renderer.SetDrawBlendMode(SDL_BLENDMODE_ADD)
		Case SHADEBLEND
			renderer.SetDrawBlendMode(SDL_BLENDMODE_MOD)
		Default
			renderer.SetDrawBlendMode(SDL_BLENDMODE_NONE)
		End Select
	End Method

	Method SetAlpha( alpha# ) Override
		If alpha>1.0 alpha=1.0
		If alpha<0.0 alpha=0.0
		drawColor.a=alpha*255
	End Method

	Method SetLineWidth( width# ) Override
		'glLineWidth width
	End Method
	
	Method SetColor( red:Int,green:Int,blue:Int ) Override
		drawColor.r = Min(Max(red,0),255)
		drawColor.g = Min(Max(green,0),255)
		drawColor.b = Min(Max(blue,0),255)
		renderer.SetDrawColor(drawColor.r, drawColor.g, drawColor.b, drawColor.a)
	End Method

	Method SetColor( color:SColor8 ) Override
		drawColor.r=color.r
		drawColor.g=color.g
		drawColor.b=color.b
		renderer.SetDrawColor(drawColor.r, drawColor.g, drawColor.b, drawColor.a)
	End Method

	Method SetClsColor( red:Int,green:Int,blue:Int ) Override
		clsColor.r = Min(Max(red,0),255)
		clsColor.g = Min(Max(green,0),255)
		clsColor.b = Min(Max(blue,0),255)
		clsColor.a = 255
	End Method

	Method SetClsColor( color:SColor8 ) Override
		clsColor.r=color.r
		clsColor.g=color.g
		clsColor.b=color.b
		clsColor.a = 255
	End Method
	
	Method SetViewport( x:Int,y:Int,w:Int,h:Int ) Override
		If x=0 And y=0 And w=GraphicsWidth() And h=GraphicsHeight()
			renderer.SetClipRect()
		Else
			renderer.SetClipRect(x, y, w, h)
		EndIf
	End Method

	Method SetTransform( xx#,xy#,yx#,yy# ) Override
		ix=xx
		iy=xy
		jx=yx
		jy=yy
	End Method

	Method Cls() Override
		renderer.SetDrawColor(clsColor.r, clsColor.g, clsColor.b, clsColor.a)
		renderer.Clear()
		renderer.SetDrawColor(drawColor.r, drawColor.g, drawColor.b, drawColor.a)
	End Method

	Method Plot( x#,y# ) Override
		renderer.DrawPoint(Int(x+.5),Int(y+.5))
	End Method

	Method DrawLine( x0#,y0#,x1#,y1#,tx#,ty# ) Override
		renderer.DrawLine(Int(x0*ix+y0*iy+tx+.5), Int(x0*jx+y0*jy+ty+.5), Int(x1*ix+y1*iy+tx+.5), Int(x1*jx+y1*jy+ty+.5))
	End Method

	Method DrawRect( x0#,y0#,x1#,y1#,tx#,ty# ) Override
		Local StaticArray vertices:SDLVertex[4]
		Local vert:SDLVertex Ptr = vertices

		vert.position.x = x0 * ix + y0 * iy + tx
		vert.position.y = x0 * jx + y0 * jy + ty
		vert.color = _driver.drawColor

		vert :+ 1

		vert.position.x = x1 * ix + y0 * iy + tx
		vert.position.y = x1 * jx + y0 * jy + ty
		vert.color = _driver.drawColor

		vert :+ 1

		vert.position.x = x1 * ix + y1 * iy + tx
		vert.position.y = x1 * jx + y1 * jy + ty
		vert.color = _driver.drawColor

		vert :+ 1

		vert.position.x = x0 * ix + y1 * iy + tx
		vert.position.y = x0 * jx + y1 * jy + ty
		vert.color = _driver.drawColor

		Local StaticArray indices:Int[6]
		indices[0] = 0
		indices[1] = 2
		indices[2] = 1
		indices[3] = 0
		indices[4] = 3
		indices[5] = 2

		renderer.Geometry(Null, vertices, 4, indices, 6)
	End Method
	
	Method DrawOval( x0#,y0#,x1#,y1#,tx#,ty# ) Override

		Local StaticArray vertices:SDLVertex[50]
		Local vert:SDLVertex Ptr = vertices
		Local vc:int

		Local StaticArray indices:Int[147]
		local ic:int

		Local xr#=(x1-x0)*.5
		Local yr#=(y1-y0)*.5
		local r:Float = (xr + yr) * 0.5

		Local segs:Int = Min(49, 360 / acos(2 * (1 - 0.5 / r)^2 - 1))

		x0:+xr
		y0:+yr

		' center
		vert.position.x = x0 * ix + y0 * iy + tx
		vert.position.y = x0 * jx + y0 * jy + ty
		vert.color = _driver.drawColor

		vert :+ 1
		vc :+ 1
		
		For Local i:Int=0 Until segs
			Local th#=i*360#/segs
			Local x#=x0+Cos(th)*xr
			Local y#=y0-Sin(th)*yr

			vert.position.x = x * ix + y * iy + tx
			vert.position.y = x * jx + y * jy + ty
			vert.color = _driver.drawColor

			vert :+ 1
			vc :+ 1
		Next

		For Local i:Int=0 Until segs - 1
			indices[i * 3] = 0
			indices[i * 3 + 1] = i + 1
			indices[i * 3 + 2] = i + 2
			ic :+ 3
		Next

		' connect last & first
		Local i:Int = segs - 1
		indices[i * 3] = 0
		indices[i * 3 + 1] = i + 1
		indices[i * 3 + 2] = 1
		ic :+ 3

		renderer.Geometry(Null, vertices, vc, indices, ic)
	End Method
	
	Method DrawPoly( xy#[],handle_x#,handle_y#,origin_x#,origin_y# ) Override
		rem
		If xy.length<6 Or (xy.length&1) Return
		
		DisableTex
		glBegin GL_POLYGON
		For Local i:Int=0 Until Len xy Step 2
			Local x#=xy[i+0]+handle_x
			Local y#=xy[i+1]+handle_y
			glVertex2f x*ix+y*iy+origin_x,x*jx+y*jy+origin_y
		Next
		glEnd
		end rem
	End Method
		
	Method DrawPixmap( p:TPixmap,x:Int,y:Int ) Override
		rem
		Local blend:Int=state_blend
		DisableTex
		SetBlend SOLIDBLEND
	
		Local t:TPixmap=p
		If t.format<>PF_RGBA8888 t=ConvertPixmap( t,PF_RGBA8888 )

		glPixelZoom 1,-1
		glRasterPos2i 0,0
		glBitmap 0,0,0,0,x,-y,Null
		glPixelStorei GL_UNPACK_ROW_LENGTH, t.pitch Shr 2
		glDrawPixels t.width,t.height,GL_RGBA,GL_UNSIGNED_BYTE,t.pixels
		glPixelStorei GL_UNPACK_ROW_LENGTH,0
		glPixelZoom 1,1
		
		SetBlend blend
		end rem
	End Method

	Method DrawTexture( texture:TSDLTexture, u0#, v0#, u1#, v1#, x0#, y0#, x1#, y1#, tx#, ty#, img:TImageFrame = Null )

		Local StaticArray vertices:SDLVertex[4]
		Local vert:SDLVertex Ptr = vertices

		vert.position.x = x0 * ix + y0 * iy + tx
		vert.position.y = x0 * jx + y0 * jy + ty
		vert.color = _driver.drawColor
		vert.texCoord.x = u0
		vert.texCoord.y = v0

		vert :+ 1

		vert.position.x = x1 * ix + y0 * iy + tx
		vert.position.y = x1 * jx + y0 * jy + ty
		vert.color = _driver.drawColor
		vert.texCoord.x = u1
		vert.texCoord.y = v0

		vert :+ 1

		vert.position.x = x1 * ix + y1 * iy + tx
		vert.position.y = x1 * jx + y1 * jy + ty
		vert.color = _driver.drawColor
		vert.texCoord.x = u1
		vert.texCoord.y = v1

		vert :+ 1

		vert.position.x = x0 * ix + y1 * iy + tx
		vert.position.y = x0 * jx + y1 * jy + ty
		vert.color = _driver.drawColor
		vert.texCoord.x = u0
		vert.texCoord.y = v1

		Local StaticArray indices:Int[6]
		indices[0] = 0
		indices[1] = 2
		indices[2] = 1
		indices[3] = 0
		indices[4] = 3
		indices[5] = 2

		Select state_blend
			Case ALPHABLEND
				texture.SetBlendMode(SDL_BLENDMODE_BLEND)
			Case MASKBLEND
				texture.SetBlendMode(SDL_BLENDMODE_BLEND)
			Case SOLIDBLEND
				texture.SetBlendMode(SDL_BLENDMODE_NONE)
			Case LIGHTBLEND
				texture.SetBlendMode(SDL_BLENDMODE_ADD)
			Case SHADEBLEND
				texture.SetBlendMode(SDL_BLENDMODE_MOD)
			Default
				texture.SetBlendMode(SDL_BLENDMODE_NONE)
		End Select


		renderer.Geometry(texture, vertices, 4, indices, 6)
	End Method

	Method GrabPixmap:TPixmap( x:Int,y:Int,w:Int,h:Int ) Override
		Local blend:Int = state_blend
		SetBlend SOLIDBLEND
		Local p:TPixmap = CreatePixmap( w,h,PF_RGBA8888 )
		renderer.ReadPixels(SDL_PIXELFORMAT_ABGR8888, p.pixels, p.pitch, x, y, w, h)
		SetBlend blend
		Return p
	End Method
	
	Method SetResolution( width#,height# ) Override
		renderer.SetLogicalSize(Int(width), Int(height))
	End Method
	
End Type

Rem
bbdoc: Get SDLRender Max2D Driver
about:
The returned driver can be used with #SetGraphicsDriver to enable SDLRender Max2D 
rendering.
End Rem
Function SDLRenderMax2DDriver:TSDLRenderMax2DDriver()
	Global _done:Int
	If Not _done
		_driver=New TSDLRenderMax2DDriver.Create()
		_done=True
	EndIf
	Return _driver
End Function

Local driver:TSDLRenderMax2DDriver=SDLRenderMax2DDriver()
If driver SetGraphicsDriver driver

Rem
bbdoc: Defines the preferred renderer, by name.
about: Available renderers vary by platform. If @renderer is not found, default will be used.
End Rem
Function SDLSetPreferredRenderer( renderer:String )
	For Local i:int = 0 Until SDLGetNumRenderDrivers()
		Local info:SDLRendererInfo
		SDLGetRenderDriverInfo(i, info)
		If info.GetName() = renderer Then
			_preferredRenderer = i
			Return
		End If
	Next
	_preferredRenderer = -1
End Function


Rem
bbdoc: Marks a renderer to be prioritized over others, by name.
about: Available renderers vary by platform. If @renderer is not found or
       cannot be initialized later then, normal default will be used.
End Rem
Function SDLPrioritizeRenderer( renderer:String, priority:ESDLHintPriority = ESDLHintPriority.SDL_HINT_DEFAULT)
	For Local i:Int = 0 Until SDLGetNumRenderDrivers()
		Local info:SDLRendererInfo
		SDLGetRenderDriverInfo(i, info)
		If info.GetName() = renderer Then
			SDLSetHintWithPriority("SDL_RENDER_DRIVER", renderer, priority)
			Exit
		End If
	Next
End Function
