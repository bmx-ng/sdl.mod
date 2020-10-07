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
Strict

Module SDL.SDLGraphics

?raspberrypi
ModuleInfo "CC_OPTS: -D__RASPBERRYPI__"
ModuleInfo "CC_OPTS: -I/opt/vc/include -I/opt/vc/include/interface/vcos/pthreads"
ModuleInfo "LD_OPTS: -L/opt/vc/lib"
ModuleInfo "LD_OPTS: -L/usr/lib/arm-linux-gnueabihf"
?

Import SDL.SDLSystem
Import SDL.SDLVideo
Import BRL.Graphics

Import "common.bmx"

Private
Global _currentContext:TGraphicsContext
Public

Type TGraphicsContext
	Field Mode:Int
	Field width:Int
	Field height:Int
	Field depth:Int
	Field hertz:Int
	Field flags:Int
	Field sync:Int
	Field x:Int
	Field y:Int

	Field window:TSDLWindow
	Field context:TSDLGLContext
	Field info:Byte Ptr
	Field data:Object
End Type

Type TSDLGraphics Extends TGraphics

	Method Driver:TSDLGraphicsDriver() Override
		Assert _context
		Return SDLGraphicsDriver()
	End Method

	Method GetSettings( width:Int Var,height:Int Var,depth:Int Var,hertz:Int Var,flags:Int Var,x:Int Var,y:Int Var ) Override
		Assert _context
		'Local w:Int,h:Int,d:Int,r:Int,f:Int
		'bbSDLGraphicsGetSettings _context,w,h,d,r,f
		width=_context.width
		height=_context.height
		depth=_context.depth
		hertz=_context.hertz
		flags=_context.flags
		x=_context.x
		y=_context.y
	End Method

	Method Close() Override
		If Not _context Return
		'bbSDLGraphicsClose( _context )
		If _currentContext = _context Then
			_currentContext = Null
		End If
		If _context.context Then
			_context.context.Free()
		End If
		If _context.window Then
			_context.window.Destroy()
		End If
		_context=Null
	End Method

	Method GetHandle:Byte Ptr()
		If _context Then
			Return _context.window.GetWindowHandle()
		End If
	End Method

	Method Resize(width:Int, height:Int) Override
	End Method
	
	Method Position(x:Int, y:Int) Override
	End Method

	Field _context:TGraphicsContext

End Type

Type TSDLGraphicsMode Extends TGraphicsMode
End Type

Type TSDLGraphicsDriver Extends TGraphicsDriver
	Const MODE_SIZE:Int = 4

	Method GraphicsModes:TGraphicsMode[]() Override
		Local buf:Int[1024*MODE_SIZE]
		Local count:Int=bbSDLGraphicsGraphicsModes( 0, buf,1024 )
		Local modes:TGraphicsMode[count],p:Int Ptr=buf
		For Local i:Int=0 Until count
			Local t:TSDLGraphicsMode=New TSDLGraphicsMode
			t.width=p[0]
			t.height=p[1]
			t.depth=p[2]
			t.hertz=p[3]

			modes[i]=t

			p :+ MODE_SIZE

		Next
		Return modes
	End Method

	Method AttachGraphics:TSDLGraphics( widget:Byte Ptr,flags:Int ) Override
		Local t:TSDLGraphics=New TSDLGraphics
		't._context=bbGLGraphicsAttachGraphics( widget,flags )
		Return t
	End Method

	Method CreateGraphics:TSDLGraphics( width:Int,height:Int,depth:Int,hertz:Int,flags:Int,x:Int,y:Int ) Override
		Local t:TSDLGraphics=New TSDLGraphics
		t._context=SDLGraphicsCreateGraphics( width,height,depth,hertz,flags,x,y )
		Return t
	End Method

	Method SDLGraphicsCreateGraphics:TGraphicsContext(width:Int,height:Int,depth:Int,hertz:Int,flags:Int,x:Int,y:Int)
		Local context:TGraphicsContext = New TGraphicsContext

		Local windowFlags:UInt = SDL_WINDOW_ALLOW_HIGHDPI | SDL_WINDOW_OPENGL
		Local gFlags:UInt
		Local glFlags:UInt = flags & SDL_GRAPHICS_GL

		If flags & SDL_GRAPHICS_NATIVE Then

			flags :~ SDL_GRAPHICS_NATIVE

			gFlags = flags & (SDL_GRAPHICS_BACKBUFFER | SDL_GRAPHICS_ALPHABUFFER | SDL_GRAPHICS_DEPTHBUFFER | SDL_GRAPHICS_STENCILBUFFER | SDL_GRAPHICS_ACCUMBUFFER)

			flags :~ SDL_GRAPHICS_GL

			flags :~ (SDL_GRAPHICS_BACKBUFFER | SDL_GRAPHICS_ALPHABUFFER | SDL_GRAPHICS_DEPTHBUFFER | SDL_GRAPHICS_STENCILBUFFER | SDL_GRAPHICS_ACCUMBUFFER)

			windowFlags :| flags

			If glFlags Then
				If gFlags & SDL_GRAPHICS_BACKBUFFER Then SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
				If gFlags & SDL_GRAPHICS_ALPHABUFFER Then SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 1)
				If gFlags & SDL_GRAPHICS_DEPTHBUFFER Then SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
				If gFlags & SDL_GRAPHICS_STENCILBUFFER Then SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 1)
			End If

		Else

			If depth Then
				windowFlags :| SDL_WINDOW_FULLSCREEN
				' mode = MODE_DISPLAY
			Else
				If flags & $80000000 Then
					windowFlags :| SDL_WINDOW_FULLSCREEN_DESKTOP
				End If
				' mode = MODE_WINDOW
			End If

			gFlags = flags & (GRAPHICS_BACKBUFFER | GRAPHICS_ALPHABUFFER | GRAPHICS_DEPTHBUFFER | GRAPHICS_STENCILBUFFER | GRAPHICS_ACCUMBUFFER)

			If glFlags Then
				If gFlags & GRAPHICS_BACKBUFFER Then SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
				If gFlags & GRAPHICS_ALPHABUFFER Then SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 1)
				If gFlags & GRAPHICS_DEPTHBUFFER Then SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
				If gFlags & GRAPHICS_STENCILBUFFER Then SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 1)
			End If
		End If


		'End If
		If x < 0 Then
			x = SDL_WINDOWPOS_CENTERED
		End If
		If y < 0 Then
			y = SDL_WINDOWPOS_CENTERED
		End If

		context.window = TSDLWindow.Create(AppTitle, x, y, width, height, windowFlags)
		If glFlags Then
			context.context = context.window.GLCreateContext()
			SDL_GL_SetSwapInterval(-1)
			context.sync = -1
		End If

		context.width = width
		context.height = height
		context.depth = depth
		context.hertz = hertz
		context.flags = flags

		AddHook EmitEventHook,GraphicsHook,context,0

		Return context
	End Method

	Method SetGraphics( g:TGraphics ) Override
		Local context:TGraphicsContext
		Local t:TSDLGraphics=TSDLGraphics( g )
		If t context=t._context
		'bbSDLGraphicsSetGraphics context
		If context And context.context Then
			context.window.GLMakeCurrent(context.context)
		End If
		_currentContext = context
	End Method

	Method Flip( sync:Int ) Override
		'BRL  SDL
		'-1   -1   sdl: adaptive vsync, brl: "use graphics object's refresh rate"
		' 1    1   vsync
		' 0    0   sdl: immediate, brl: "as soon as possible"

		'bbSDLGraphicsFlip sync
		If Not _currentContext Then
			Return
		End If

		If sync <> _currentContext.sync Then
			_currentContext.sync = sync
			If _currentContext.context Then
				_currentContext.context.SetSwapInterval(sync)
			End If
		End If

		If _currentContext.context Then
			_currentContext.window.GLSwap()
		End If
	End Method

	Function GraphicsHook:Object( id,data:Object,context:Object )
		Local ev:TEvent=TEvent(data)
		If Not ev Return data

		Select ev.id
			Case EVENT_WINDOWSIZE
				Local ctxt:TGraphicsContext = TGraphicsContext(context)
				If ctxt Then
					If ctxt.window.GetID() = ev.data Then
						ctxt.width = ev.x
						ctxt.height = ev.y
						GraphicsResize(ev.x, ev.y)
					End If
				End If
			Case EVENT_WINDOWMOVE
				Local ctxt:TGraphicsContext = TGraphicsContext(context)
				If ctxt Then
					If ctxt.window.GetID() = ev.data Then
						ctxt.x = ev.x
						ctxt.y = ev.y
						GraphicsPosition(ev.x, ev.y)
					End If
				End If
		End Select

		Return data
	End Function

	Method CanResize:Int() Override
		Return True
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

