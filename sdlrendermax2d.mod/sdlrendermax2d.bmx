
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

		renderer = TSDLRenderer.Create(gfx._context.window)
		'ResetGLContext t
		
		t.MakeCurrent
	End Method

	Method Flip:Int( sync:Int ) Override
		renderer.Present()
	End Method
	
	Method ToString$() Override
		Return "SDLRenderer"
	End Method

	Method CreateFrameFromPixmap:TSDLRenderImageFrame( pixmap:TPixmap,flags:Int ) Override
		Local frame:TSDLRenderImageFrame
		frame=TSDLRenderImageFrame.CreateFromPixmap( pixmap,flags )
		Return frame
	End Method

	Method SetBlend( blend:Int ) Override
		rem
		If blend=state_blend Return
		state_blend=blend
		Select blend
		Case MASKBLEND
			glDisable GL_BLEND
			glEnable GL_ALPHA_TEST
			glAlphaFunc GL_GEQUAL,.5
		Case SOLIDBLEND
			glDisable GL_BLEND
			glDisable GL_ALPHA_TEST
		Case ALPHABLEND
			glEnable GL_BLEND
			glBlendFunc GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA
			glDisable GL_ALPHA_TEST
		Case LIGHTBLEND
			glEnable GL_BLEND
			glBlendFunc GL_SRC_ALPHA,GL_ONE
			glDisable GL_ALPHA_TEST
		Case SHADEBLEND
			glEnable GL_BLEND
			glBlendFunc GL_DST_COLOR,GL_ZERO
			glDisable GL_ALPHA_TEST
		Default
			glDisable GL_BLEND
			glDisable GL_ALPHA_TEST
		End Select
		end rem
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
	End Method

	Method SetColor( color:SColor8 ) Override
		drawColor.r=color.r
		drawColor.g=color.g
		drawColor.b=color.b
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
			renderer.SetViewport()
		Else
			renderer.SetViewport(x, y, w, h)
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
		Local StaticArray points:Float[8]
		points[0] = x0*ix+y0*iy+tx
		points[1] = x0*jx+y0*jy+ty
		points[2] = x1*ix+y0*iy+tx
		points[3] = x1*jx+y0*jy+ty
		points[4] = x1*ix+y1*iy+tx
		points[5] = x1*jx+y1*jy+ty
		points[6] = x0*ix+y1*iy+tx
		points[7] = x0*jx+y1*jy+ty
		renderer.DrawLines(points, 4)
	End Method
	
	Method DrawOval( x0#,y0#,x1#,y1#,tx#,ty# ) Override
		Local StaticArray points:Float[24]

		Local xr#=(x1-x0)*.5
		Local yr#=(y1-y0)*.5
		Local segs:Int=Abs(xr)+Abs(yr)
		
		segs=Max(segs,12)&~3

		x0:+xr
		y0:+yr
		
		For Local i:Int=0 Until segs
			Local th#=i*360#/segs
			Local x#=x0+Cos(th)*xr
			Local y#=y0-Sin(th)*yr
			points[i * 2] = x*ix+y*iy+tx
			points[i * 2 + 1] = x*jx+y*jy+ty
		Next
		renderer.DrawLines(points, segs)
		
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

		renderer.Geometry(texture, vertices, 4, indices, 6)
	End Method

	Method GrabPixmap:TPixmap( x:Int,y:Int,w:Int,h:Int ) Override
		rem
		Local blend:Int=state_blend
		SetBlend SOLIDBLEND
		Local p:TPixmap=CreatePixmap( w,h,PF_RGBA8888 )
		glReadPixels x,GraphicsHeight()-h-y,w,h,GL_RGBA,GL_UNSIGNED_BYTE,p.pixels
		p=YFlipPixmap( p )
		SetBlend blend
		Return p
		end rem
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
