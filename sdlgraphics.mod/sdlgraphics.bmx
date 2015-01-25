' Copyright (c) 2014 Bruce A Henderson
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
Strict

Module SDL.SDLGraphics

?raspberrypi
ModuleInfo "LD_OPTS: -L/opt/vc/lib"
?

Import SDL.SDLSystem
Import BRL.Graphics

Import "common.bmx"

Type TSDLGraphics Extends TGraphics

	Method Driver:TSDLGraphicsDriver()
		Assert _context
		Return SDLGraphicsDriver()
	End Method
	
	Method GetSettings( width:Int Var,height:Int Var,depth:Int Var,hertz:Int Var,flags:Int Var )
		Assert _context
		Local w:Int,h:Int,d:Int,r:Int,f:Int
		bbSDLGraphicsGetSettings _context,w,h,d,r,f
		width=w
		height=h
		depth=d
		hertz=r
		flags=f
	End Method
	
	Method Close()
		If Not _context Return
		bbSDLGraphicsClose( _context )
		_context=0
	End Method
	
	Field _context:Byte Ptr
	
End Type

Type TSDLGraphicsDriver Extends TGraphicsDriver

	Method GraphicsModes:TGraphicsMode[]()
		Local buf:Int[1024*4]
		Local count:Int=bbSDLGraphicsGraphicsModes( 0, buf,1024 )
		Local modes:TGraphicsMode[count],p:Int Ptr=buf
		For Local i:Int=0 Until count
			Local t:TGraphicsMode=New TGraphicsMode
			t.width=p[0]
			t.height=p[1]
			t.depth=p[2]
			t.hertz=p[3]
			modes[i]=t
			p:+4
		Next
		Return modes
	End Method
	
	Method AttachGraphics:TSDLGraphics( widget:Byte Ptr,flags:Int )
		Local t:TSDLGraphics=New TSDLGraphics
		't._context=bbGLGraphicsAttachGraphics( widget,flags )
		Return t
	End Method
	
	Method CreateGraphics:TSDLGraphics( width:Int,height:Int,depth:Int,hertz:Int,flags:Int )
		Local t:TSDLGraphics=New TSDLGraphics
		t._context=bbSDLGraphicsCreateGraphics( width,height,depth,hertz,flags )
		Return t
	End Method
	
	Method SetGraphics( g:TGraphics )
		Local context:Byte Ptr
		Local t:TSDLGraphics=TSDLGraphics( g )
		If t context=t._context
		bbSDLGraphicsSetGraphics context
	End Method
	
	Method Flip( sync:Int )
		bbSDLGraphicsFlip sync
	End Method
	
End Type

Rem
bbdoc: Get SDL Graphics driver
returns: An SDL Graphics driver
about:
The returned driver can be used with #SetGraphicsDriver
End Rem
Function SDLGraphicsDriver:TSDLGraphicsDriver()
	Global _driver:TSDLGraphicsDriver=New TSDLGraphicsDriver
	Return _driver
End Function

Rem
bbdoc: Create SDL Graphics
returns: An SDL Graphics Object
about:
This is a convenience Function that allows you to easily Create an SDL Graphics context.
End Rem
Function SDLGraphics:TGraphics( width:Int,height:Int,depth:Int=0,hertz:Int=60,flags:Int=GRAPHICS_BACKBUFFER|GRAPHICS_DEPTHBUFFER )
	SetGraphicsDriver SDLGraphicsDriver()
	Return Graphics( width,height,depth,hertz,flags )
End Function
	
SDL_Init(SDL_INIT_VIDEO)

' cleanup context on exit
OnEnd(bbSDLExit)
' set mouse warp function
_sdl_WarpMouse = bmx_SDL_WarpMouseInWindow

SetGraphicsDriver SDLGraphicsDriver()

