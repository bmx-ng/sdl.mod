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
Import Math.Polygon

Private

Global _driver:TSDLRenderMax2DDriver
Global _preferredRenderer:Int = -1
Global _BackbufferRenderImageFrame:TSDLRenderImageFrame
Global _CurrentRenderImageFrame:TSDLRenderImageFrame
Global _ClipRect_BMaxViewport:Rect = New Rect


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

Public

Type TSDLRenderImageFrame Extends TImageFrame


	Field u0:Float, v0:Float, u1:Float, v1:Float, uscale:Float, vscale:Float
	Field width:Int
	Field height:Int

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
	
	Method Draw( x0:Float,y0:Float,x1:Float,y1:Float,tx:Float,ty:Float,sx:Float,sy:Float,sw:Float,sh:Float ) Override

		Local u0:Float = sx * uscale
		Local v0:Float = sy * vscale
		Local u1:Float = ( sx + sw ) * uscale
		Local v1:Float = ( sy + sh ) * vscale

		_driver.DrawTexture( texture, u0, v0, u1, v1, x0, y0, x1, y1, tx, ty, Self )

	End Method
	
	Function CreateFromPixmap:TSDLRenderImageFrame( src:TPixmap,flags:Int )
		
		Local tex_w:Int = src.width
		Local tex_h:Int = src.height
		
		If src.format <> PF_RGBA8888 And src.format <> PF_RGB888 Then
			src = src.Convert( PF_RGBA8888 )
		End If

		'done!
		Local frame:TSDLRenderImageFrame=New TSDLRenderImageFrame
		frame.width = Min( src.width, tex_w )
		frame.height = Min( src.height, tex_h )

		frame.renderer = _driver.renderer
		frame.pixmap = src
		frame.surface = TSDLSurface.CreateRGBFrom(src.pixels, src.width, src.height, BitsPerPixel[src.format], src.pitch, $000000ff:UInt, $0000ff00:UInt, $00ff0000:UInt, $ff000000:UInt)
		frame.texture = frame.renderer.CreateTextureFromSurface(frame.surface)
		frame.uscale = 1.0 / tex_w
		frame.vscale = 1.0 / tex_h
		frame.u1 = frame.width * frame.uscale
		frame.v1 = frame.height * frame.vscale
		Return frame
	End Function

End Type

Type TSDLRenderMax2DDriver Extends TMax2DDriver

	Field drawColor:SDLColor = New SDLColor(255, 255, 255, 255)
	Field clsColor:SDLColor = New SDLColor(0, 0, 0, 255)

	Field renderer:TSDLRenderer
	Field ix:Float,iy:Float,jx:Float,jy:Float
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
		Assert t And TSDLGraphics( t._backendGraphics )

		Local gfx:TSDLGraphics = TSDLGraphics( t._backendGraphics )

		SDLGraphicsDriver().SetGraphics( gfx )

		Local flags:UInt
		If gfx._context.flags & GRAPHICS_SWAPINTERVAL1 Then
			flags :| SDL_RENDERER_PRESENTVSYNC
		End If

		renderer = TSDLRenderer.Create(gfx._context.window, _preferredRenderer, flags)

		' Create default back buffer render image
		Local BackBufferRenderImageFrame:TSDLRenderImageFrame = New TSDLRenderImageFrame
		BackBufferRenderImageFrame.width = GraphicsWidth()
		BackBufferRenderImageFrame.height = GraphicsHeight()
	
		' cache it
		_BackBufferRenderImageFrame = BackBufferRenderImageFrame
		_CurrentRenderImageFrame = _BackBufferRenderImageFrame
		
		t.MakeCurrent
	End Method

	Method Flip:Int( sync:Int ) Override
		renderer.Present()
	End Method
	
	Method ToString:String() Override
		Return "SDLRenderer"
	End Method

	Method CreateFrameFromPixmap:TSDLRenderImageFrame( pixmap:TPixmap,flags:Int ) Override
		Return TSDLRenderImageFrame.CreateFromPixmap( pixmap,flags )
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

	Method SetAlpha( alpha:Float ) Override
		If alpha>1.0 alpha=1.0
		If alpha<0.0 alpha=0.0
		drawColor.a=alpha*255
		renderer.SetDrawColor(drawColor.r, drawColor.g, drawColor.b, drawColor.a)
	End Method

	Method SetLineWidth( width:Float ) Override
		'glLineWidth width
	End Method
	
	Method SetColor( red:Int,green:Int,blue:Int ) Override
		drawColor.r = Min(Max(red,0),255)
		drawColor.g = Min(Max(green,0),255)
		drawColor.b = Min(Max(blue,0),255)
		renderer.SetDrawColor(drawColor.r, drawColor.g, drawColor.b, drawColor.a)
	End Method

	Method SetClsColor( red:Int,green:Int,blue:Int, alpha:Float) Override
		clsColor.r = Min(Max(red,0),255)
		clsColor.g = Min(Max(green,0),255)
		clsColor.b = Min(Max(blue,0),255)
		clsColor.a = alpha
	End Method

	Method SetViewport( x:Int,y:Int,w:Int,h:Int ) Override
		If x=0 And y=0 And w=GraphicsWidth() And h=GraphicsHeight()
			renderer.SetClipRect()
		Else
			renderer.SetClipRect(x, y, w, h)
		EndIf
		_ClipRect_BMaxViewport.x = x
		_ClipRect_BMaxViewport.y = y
		_ClipRect_BMaxViewport.width = w
		_ClipRect_BMaxViewport.height = h
	End Method

	Method SetTransform( xx:Float,xy:Float,yx:Float,yy:Float ) Override
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

	Method Plot( x:Float,y:Float ) Override
		renderer.DrawPoint(Int(x+.5),Int(y+.5))
	End Method

	Method DrawLine( x0:Float,y0:Float,x1:Float,y1:Float,tx:Float,ty:Float ) Override
		renderer.DrawLine(Int(x0*ix+y0*iy+tx+.5), Int(x0*jx+y0*jy+ty+.5), Int(x1*ix+y1*iy+tx+.5), Int(x1*jx+y1*jy+ty+.5))
	End Method

	Method DrawRect( x0:Float,y0:Float,x1:Float,y1:Float,tx:Float,ty:Float ) Override
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
	
	Method DrawOval( x0:Float,y0:Float,x1:Float,y1:Float,tx:Float,ty:Float ) Override

		Local StaticArray vertices:SDLVertex[50]
		Local vert:SDLVertex Ptr = vertices
		Local vc:int

		Local StaticArray indices:Int[147]
		local ic:int

		Local xr:Float=(x1-x0)*.5
		Local yr:Float=(y1-y0)*.5
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
			Local th:Float=i*360:Float/segs
			Local x:Float=x0+Cos(th)*xr
			Local y:Float=y0-Sin(th)*yr

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
	
	Method DrawPoly( xy:Float[],handle_x:Float,handle_y:Float,origin_x:Float,origin_y:Float, indices:Int[] ) Override

		If xy.length<6 Or (xy.length&1) Return
		
		If Not indices Then
			indices = TriangulatePoly(xy)
		End If
		Local verts:Int = xy.Length / 2

		Local v:Byte Ptr = StackAlloc(verts * SizeOf(SDLVertex))
		Local vertPtr:SDLVertex Ptr = bmx_SDL_bptr_to_SDLVertexPtr(v)
		Local vert:SDLVertex Ptr = vertPtr

		For Local i:Int=0 Until verts
			Local x:Float = xy[i * 2] + handle_x
			Local y:Float = xy[i * 2 + 1] + handle_y

			vert.position.x = x*ix+y*iy+origin_x
			vert.position.y = x*jx+y*jy+origin_y
			vert.color = _driver.drawColor

			vert :+ 1
		Next

		renderer.Geometry(Null, vertPtr, verts, indices, indices.Length)
	End Method
		
	Method DrawPixmap( p:TPixmap,x:Int,y:Int ) Override

		Local img:TImage = LoadImage(p, 0)

		DrawImage(img, x, y)

	End Method

	Method DrawTexture( texture:TSDLTexture, u0:Float, v0:Float, u1:Float, v1:Float, x0:Float, y0:Float, x1:Float, y1:Float, tx:Float, ty:Float, img:TImageFrame = Null )

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
	
	Method SetResolution( width:Float,height:Float ) Override
		renderer.SetLogicalSize(Int(width), Int(height))
	End Method

	Method CreateRenderImageFrame:TImageFrame(width:UInt, height:UInt, flags:Int) Override
		Local frame:TSDLRenderImageFrame = New TSDLRenderImageFrame
		frame.renderer = _driver.renderer
'Ronny: TODO - still needed?
		frame.pixmap = CreatePixmap( width, height, PF_RGBA8888 )

		frame.surface = TSDLSurface.CreateRGB(width, height, 4, $000000ff:UInt, $0000ff00:UInt, $00ff0000:UInt, $ff000000:UInt)
		frame.texture = frame.renderer.CreateTexture(SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, width, height)

		frame.uscale = 1.0 / width
		frame.vscale = 1.0 / height
		frame.u1 = width * frame.uscale
		frame.v1 = height * frame.vscale
		Return frame
	EndMethod
	
	Method SetRenderImageFrame(RenderImageFrame:TImageFrame) Override
		If RenderImageFrame = _CurrentRenderImageFrame
			Return
		EndIf
		If not TSDLRenderImageFrame(RenderImageFrame) Then Return
		
		renderer.SetTarget(TSDLRenderImageFrame(RenderImageFrame).texture)
		_CurrentRenderImageFrame = TSDLRenderImageFrame(RenderImageFrame)
		
		Local vp:Rect = _ClipRect_BMaxViewport
		renderer.SetClipRect(vp.x, vp.y, vp.width, vp.height)
		SetMatrixAndViewportToCurrentRenderImage()
	EndMethod
	
	Method SetBackbuffer()
		SetRenderImageFrame(_BackBufferRenderImageFrame)
	EndMethod
	

	Method SetMatrixAndViewportToCurrentRenderImage()
'Ronny: TODO - still needed?
rem
		glMatrixMode(GL_PROJECTION)
		glLoadIdentity()
		glOrtho(0, _CurrentRenderImageFrame.width, _CurrentRenderImageFrame.height, 0, -1, 1)
		glMatrixMode(GL_MODELVIEW)
		glLoadIdentity()
		glViewport(0, 0, _CurrentRenderImageFrame.width, _CurrentRenderImageFrame.height)
endrem
	EndMethod
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


Function SDLGetRendererNames:String[]()
	Local result:String[] = New String[ SDLGetNumRenderDrivers() ]

	For Local i:int = 0 Until SDLGetNumRenderDrivers()
		Local info:SDLRendererInfo
		SDLGetRenderDriverInfo(i, info)

		result[i] = info.GetName()
	Next
	Return result
End Function