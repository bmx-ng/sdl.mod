Strict

Import brl.Max2D
Import SDL.SDLGraphics
Import brl.StandardIO
?Not opengles
Import pub.glew
Import Pub.OpenGL
?opengles
Import Pub.OpenGLES
?

Private

'Const GLMAX2D_USE_LEGACY = False
Global _driver:TGL2Max2DDriver

'Naughty!
Const GL_BGR = $80E0
Const GL_BGRA = $80E1
Const GL_CLAMP_TO_EDGE = $812F
Const GL_CLAMP_TO_BORDER = $812D

Global ix#, iy#, jx#, jy#
Global color4ub:Byte[4]

Global state_blend
Global state_boundtex
Global state_texenabled

Function BindTex( name )
	If name = state_boundtex Return
	glBindTexture( GL_TEXTURE_2D, name )
	state_boundtex = name
End Function

Function EnableTex( name )
	BindTex( name )
	If state_texenabled Return
	glEnable( GL_TEXTURE_2D )
	state_texenabled = True
End Function

Function DisableTex()
	BindTex( 0 )
	If Not state_texenabled Return
	glDisable( GL_TEXTURE_2D )
	state_texenabled = False
End Function

Function Pow2Size( n )
	Local t = 1
	While t < n
		t :* 2
	Wend
	Return t
End Function

Global dead_texs[],n_dead_texs,dead_tex_seq,n_live_texs

Extern
	Function bbAtomicAdd:Int( target:Int Ptr,value:Int )="int bbAtomicAdd( int *,int )!"
End Extern

'Enqueues a texture for deletion, to prevent release textures on wrong thread.
Function DeleteTex( name,seq )
	If seq<>dead_tex_seq Return
	
	Local n:Int = bbAtomicAdd(Varptr n_dead_texs, 1)
	bbAtomicAdd(Varptr n_live_texs, -1)

	dead_texs[n] = name
End Function

Function _ManageDeadTexArray()
	If dead_texs.length <= n_live_texs
		' expand array so it's large enough to hold all the current live textures.
		dead_texs=dead_texs[..n_live_texs+20]
	EndIf
End Function

Function CreateTex( width, height, flags )

	'alloc new tex
	Local name
	glGenTextures( 1, Varptr name )

	n_live_texs :+ 1
	_ManageDeadTexArray()

	'flush dead texs
	If dead_tex_seq = GraphicsSeq
		For Local i = 0 Until n_dead_texs
			glDeleteTextures( 1, Varptr dead_texs[i] )
		Next
	EndIf
	n_dead_texs = 0
	dead_tex_seq = GraphicsSeq

	'bind new tex
	BindTex( name )

	'set texture parameters
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE )
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE )

	If flags & FILTEREDIMAGE
		glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
		If flags & MIPMAPPEDIMAGE
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR )
		Else
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR )
		EndIf
	Else
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST )
		If flags & MIPMAPPEDIMAGE
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST )
		Else
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST )
		EndIf
	EndIf

	Local mip_level
	Repeat
		glTexImage2D( GL_TEXTURE_2D, mip_level, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null )
		If Not ( flags & MIPMAPPEDIMAGE ) Exit
		If width = 1 And height = 1 Exit
		If width > 1 width :/ 2
		If height > 1 height :/ 2
		mip_level :+ 1
	Forever

	Return name

End Function

'NOTE: Assumes a bound texture.
Function UploadTex( pixmap:TPixmap, flags )

	Local mip_level
	Repeat

		glTexImage2D( GL_TEXTURE_2D, mip_level, GL_RGBA, pixmap.width, pixmap.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null )
		For Local y = 0 Until pixmap.height
			Local row:Byte Ptr = pixmap.pixels + ( y * pixmap.width ) * 4
			glTexSubImage2D( GL_TEXTURE_2D, mip_level, 0, y, pixmap.width, 1, GL_RGBA, GL_UNSIGNED_BYTE, row )
		Next

		If Not ( flags & MIPMAPPEDIMAGE ) Exit
		If pixmap.width > 1 And pixmap.height > 1
			pixmap = ResizePixmap( pixmap, pixmap.width / 2, pixmap.height / 2 )
		Else If pixmap.width > 1
			pixmap = ResizePixmap( pixmap, pixmap.width / 2, pixmap.height )
		Else If pixmap.height > 1
			pixmap = ResizePixmap( pixmap, pixmap.width, pixmap.height / 2 )
		Else
			Exit
		EndIf
		mip_level :+ 1
	Forever

End Function

Function AdjustTexSize( width Var, height Var )

	'calc texture size
	width = Pow2Size( width )
	height = Pow2Size( height )

	Return ' assume this size is fine...
	Repeat
		Local t
		glTexImage2D( GL_TEXTURE_2D, 0, 4, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null )
		?Not opengles
		glGetTexLevelParameteriv( GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, Varptr t )
		?opengles
		Return
		?
		If t Return
		If width = 1 And height = 1 Then RuntimeError "Unable to calculate tex size"
		If width > 1 width :/ 2
		If height > 1 height :/ 2
	Forever

End Function

Function DefaultVShaderSource:String()

	Local str:String = ""

	?opengles	
	str :+ "#version 100~n"
	?Not opengles
	str :+ "#version 120~n"
	?
	str :+ "attribute vec2 vertex_pos;~n"
	str :+ "attribute vec4 vertex_col;~n"
	str :+ "varying vec4 v4_col;~n"
	str :+ "uniform mat4 u_pmatrix;~n"
	str :+ "void main(void) {~n"
	str :+ "	gl_Position=u_pmatrix*vec4(vertex_pos, -1.0, 1.0);~n"
	str :+ "	v4_col=vertex_col;~n"
	str :+ "    gl_PointSize = 1.0;~n"
	str :+ "}"
	
	Return str

End Function

Function DefaultFShaderSource:String()

	Local str:String = ""
	
	?opengles	
	str :+ "#version 100~n"
	str :+ "precision mediump float;~n"
	str :+ "varying vec4 v4_col;~n"
	str :+ "void main(void) {~n"
	str :+ "	gl_FragColor=vec4(v4_col);~n"
	str :+ "}~n"
	?Not opengles
	str :+ "#version 120~n"
	str :+ "varying vec4 v4_col;~n"
	str :+ "void main(void) {~n"
	str :+ "	gl_FragColor=v4_col;~n"
	str :+ "}~n"
	?
	
	Return str

End Function

Function DefaultTextureVShaderSource:String()

	Local str:String = ""

	?opengles
	str :+ "#version 100~n"
	?Not opengles
	str :+ "#version 120~n"
	?
	str :+ "attribute vec2 vertex_pos;~n"
	str :+ "attribute vec4 vertex_col;~n"
	str :+ "attribute vec2 vertex_uv;~n"
	str :+ "varying vec4 v4_col;~n"
	str :+ "varying vec2 v2_tex;~n"
	str :+ "uniform mat4 u_pmatrix;~n"
	str :+ "void main(void) {~n"
	str :+ "	gl_Position=u_pmatrix*vec4(vertex_pos, -1.0, 1.0);~n"
	str :+ "	v4_col=vertex_col;~n"
	str :+ "	v2_tex=vertex_uv;~n"
	str :+ "}"

	Return str

End Function

Function DefaultTextureFShaderSource:String()

	Local str:String = ""

	?opengles	
	str :+ "#version 100~n"
	str :+ "precision mediump float;~n"
	str :+ "uniform sampler2D u_texture0;~n"
	str :+ "varying vec4 v4_col;~n"
	str :+ "varying vec2 v2_tex;~n"
	str :+ "void main(void) {~n"
	str :+ "  vec4 tex=texture2D(u_texture0, v2_tex);~n"
	str :+ "	gl_FragColor.rgb=tex.rgb*v4_col.rgb;~n"
	str :+ "    gl_FragColor.a=tex.a*v4_col.a;~n"
	str :+ "}~n"
	?Not opengles
	str :+ "#version 120~n"
	str :+ "uniform sampler2D u_texture0;~n"
	str :+ "varying vec4 v4_col;~n"
	str :+ "varying vec2 v2_tex;~n"
	str :+ "void main(void) {~n"
	str :+ "    vec4 tex=texture2D(u_texture0, v2_tex);~n"
	str :+ "	gl_FragColor.rgb=tex.rgb*v4_col.rgb;~n"
	str :+ "    gl_FragColor.a=tex.a*v4_col.a;~n"
	str :+ "}~n"
	?

	Return str

End Function


Global glewIsInit:Int

Type TGL2SDLRenderImageContext Extends TRenderImageContext
	Field _gc:TGraphics
	Field _driver:TGraphicsDriver
	Field _backbuffer:Int
	Field _width:Int
	Field _height:Int
	Field _renderimages:TList
	
	Field _matrix:TMatrix

	Method Delete()
		Destroy()
	EndMethod

	Method Destroy()
		_gc = Null

		If _renderimages
			For Local ri:TGL2SDLRenderImage = EachIn _renderimages
				ri.DestroyRenderImage()
			Next
		EndIf
	EndMethod

	Method Create:TGL2SDLRenderimageContext(gc:TGraphics, driver:TGraphicsDriver)
		If Not glewIsInit
			glewInit
			glewIsInit = True
		EndIf

		_renderimages = New TList
		_gc = TMax2DGraphics(gc)
		_driver = TMax2DDriver(driver)
		
		_width = GraphicsWidth()
		_height = GraphicsHeight()

		' get the backbuffer - usually 0
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, Varptr _backbuffer)
		
		'glGetFloatv(GL_PROJECTION_MATRIX, _matrix)
		_matrix = TGL2Max2DDriver(driver).u_pmatrix
		
		Return Self
	EndMethod

	Method GraphicsContext:TGraphics()
		Return _gc
	EndMethod

	Method CreateRenderImage:TRenderImage(width:Int, height:Int, UseImageFiltering:Int)
		Local renderimage:TGL2SDLRenderImage = New TGL2SDLRenderImage.CreateRenderImage(width, height)
		renderimage.Init(_gc, _driver, UseImageFiltering, Null)
		Return  renderimage
	EndMethod
	
	Method CreateRenderImageFromPixmap:TRenderImage(pixmap:TPixmap, UseImageFiltering:Int)
		Local renderimage:TGL2SDLRenderImage = New TGL2SDLRenderImage.CreateRenderImage(pixmap.width, pixmap.height)
		renderimage.Init(_gc, _driver, UseImageFiltering, pixmap)
		Return  renderimage
	EndMethod
	
	Method DestroyRenderImage(renderImage:TRenderImage)
		renderImage.DestroyRenderImage()
		_renderImages.Remove(renderImage)
	EndMethod

	Method SetRenderImage(renderimage:TRenderimage)
		Local driver:TGL2Max2DDriver = TGL2Max2DDriver(_driver)
		driver.Flush()
			
		If Not renderimage
			glBindFramebuffer(GL_FRAMEBUFFER,_backbuffer)
		
			driver.u_pmatrix = _matrix
			
			glViewport(0,0,_width,_height)
		Else
			renderimage.SetRenderImage()
		EndIf
	EndMethod
	
	Method CreatePixmapFromRenderImage:TPixmap(renderImage:TRenderImage)
		Return TGL2SDLRenderImage(renderImage).ToPixmap()
	EndMethod
EndType



Type TGL2SDLRenderImageFrame Extends TGLImageFrame
	Field _fbo:Int
	
	Method Delete()
		DeleteFramebuffer
	EndMethod
	
	Method DeleteFramebuffer()
		If _fbo
			glDeleteFramebuffers(1, Varptr _fbo)
			_fbo = -1 '???
		EndIf
	EndMethod
	
	Method Clear(r:Int=0, g:Int=0, b:Int=0, a:Float=0.0)
		'backup current
		Local c:Float[4]
		glGetFloatv(GL_COLOR_CLEAR_VALUE, c)		

		glClearColor(r/255.0, g/255.0, b/255.0, a)
		glClear(GL_COLOR_BUFFER_BIT)

		glClearColor(c[0], c[1], c[2], c[3])
	End Method

	Method CreateRenderTarget:TGL2SDLRenderImageFrame(width, height, UseImageFiltering:Int, pixmap:TPixmap)
		If pixmap pixmap = ConvertPixmap(pixmap, PF_RGBA)
		
		glDisable(GL_SCISSOR_TEST)

		glGenTextures(1, Varptr name)
		glBindTexture(GL_TEXTURE_2D, name)
		If pixmap
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixmap.pixels)
		Else
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
		EndIf

		If UseImageFiltering
			glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR
			glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR
		Else
			glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST
			glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST
		EndIf
		
		glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE
		glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE
		
		glGenFramebuffers(1,Varptr _fbo)
		glBindFramebuffer GL_FRAMEBUFFER,_fbo

		glBindTexture GL_TEXTURE_2D,name
		glFramebufferTexture2D GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,name,0

		If Not pixmap
			Clear()
		EndIf

		uscale = 1.0 / width
		vscale = 1.0 / height

		Return Self
	EndMethod
	
	Method DestroyRenderTarget()
		DeleteFramebuffer()
	EndMethod
	
	Method ToPixmap:TPixmap(width:Int, height:Int)
		Local prevTexture:Int
		Local prevFBO:Int
		
		glGetIntegerv(GL_TEXTURE_BINDING_2D,Varptr prevTexture)
		glBindTexture(GL_TEXTURE_2D,name)

		Local pixmap:TPixmap = CreatePixmap(width, height, PF_RGBA8888)		
		glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixmap.pixels)
		
		glBindTexture(GL_TEXTURE_2D,prevTexture)
				
		Return pixmap
	EndMethod
EndType

Type TGL2SDLRenderImage Extends TRenderImage
	'Field _matrix:Float[16]
	Field _matrix:TMatrix
	Field _driver:TGL2Max2DDriver

	Method CreateRenderImage:TGL2SDLRenderImage(width:Int, height:Int)
		Self.width = width	' TImage.width
		Self.height = height	' TImage.height

		Return Self
	EndMethod
	
	Method DestroyRenderImage()
		TGL2SDLRenderImageFrame(frames[0]).DestroyRenderTarget()
	EndMethod
	
	Method Init(g:TGraphics, driver:TGraphicsDriver, UseImageFiltering:Int, pixmap:TPixmap)
		_driver = TGL2Max2DDriver(driver)
		_matrix = New TMatrix
	
		'_matrix.SetOrthographic( 0, width, 0, height, -1, 1 )
		_matrix.SetOrthographic( 0, width, height, 0, -1, 1 )
	
		Local prevFBO:Int
		Local prevTexture:Int
		Local prevScissorTest:Int

		glGetIntegerv(GL_FRAMEBUFFER_BINDING, Varptr prevFBO)
		glGetIntegerv(GL_TEXTURE_BINDING_2D,Varptr prevTexture)
		glGetIntegerv(GL_SCISSOR_TEST, Varptr prevScissorTest)
		
		frames = New TGL2SDLRenderImageFrame[1]
		frames[0] = New TGL2SDLRenderImageFrame.CreateRenderTarget(width, height, UseImageFiltering, pixmap)
		
		If prevScissorTest glEnable(GL_SCISSOR_TEST)
		glBindTexture GL_TEXTURE_2D,prevTexture
		glBindFramebuffer GL_FRAMEBUFFER,prevFBO
	EndMethod
	
	Method Clear(r:Int=0, g:Int=0, b:Int=0, a:Float=0.0)
		If frames[0] Then TGL2SDLRenderImageFrame(frames[0]).Clear(r, g, b, a)
	End Method

	Method Frame:TImageFrame(index=0)
		Return frames[0]
	EndMethod
	
	Method SetRenderImage()
		glBindFrameBuffer(GL_FRAMEBUFFER, TGL2SDLRenderImageFrame(frames[0])._fbo)
		_driver.u_pmatrix = _matrix
		glViewport 0,0,width,height 
	EndMethod
	
	Method ToPixmap:TPixmap()
		Return TGL2SDLRenderImageFrame(frames[0]).ToPixmap(width, height)
	EndMethod
	
	Method SetViewport(x:Int, y:Int, width:Int, height)
		If x = 0 And y = 0 And width = Self.width And height = Self.height
			glDisable GL_SCISSOR_TEST
		Else
			glEnable GL_SCISSOR_TEST
			glScissor x, y, width, height
		EndIf
	EndMethod
EndType


Public

'============================================================================================'
'============================================================================================'

Type TGLImageFrame Extends TImageFrame

	Field u0#, v0#, u1#, v1#, uscale#, vscale#
	Field name, seq

	Method New()

		seq = GraphicsSeq

	End Method

	Method Delete()

		If Not seq Then Return
		DeleteTex( name, seq )
		seq = 0

	End Method

	Method Draw( x0#, y0#, x1#, y1#, tx#, ty#, sx#, sy#, sw#, sh# ) Override

		Assert seq = GraphicsSeq Else "Image does not exist"

		Local u0# = sx * uscale
		Local v0# = sy * vscale
		Local u1# = ( sx + sw ) * uscale
		Local v1# = ( sy + sh ) * vscale

		_driver.DrawTexture( name, u0, v0, u1, v1, x0, y0, x1, y1, tx, ty, Self )

	End Method
	
	Function CreateFromPixmap:TGLImageFrame( src:TPixmap, flags )

		'determine tex size
		Local tex_w = src.width
		Local tex_h = src.height
		AdjustTexSize( tex_w, tex_h )
		
		'make sure pixmap fits texture
		Local width = Min( src.width, tex_w )
		Local height = Min( src.height, tex_h )
		If src.width <> width Or src.height <> height Then src = ResizePixmap( src, width, height )

		'create texture pixmap
		Local tex:TPixmap = src
		
		'"smear" right/bottom edges if necessary
		If width < tex_w Or height < tex_h
			tex = TPixmap.Create( tex_w, tex_h, PF_RGBA8888 )
			tex.Paste( src, 0, 0 )
			If width < tex_w
				tex.Paste( src.Window( width - 1, 0, 1, height ), width, 0 )
			EndIf
			If height < tex_h
				tex.Paste( src.Window( 0, height - 1, width, 1 ), 0, height )
				If width < tex_w 
					tex.Paste( src.Window( width - 1, height - 1, 1, 1 ), width, height )
				EndIf
			EndIf
		Else
			If tex.format <> PF_RGBA8888 tex = tex.Convert( PF_RGBA8888 )
		EndIf
		
		'create tex
		Local name = CreateTex( tex_w, tex_h, flags )
		
		'upload it
		UploadTex( tex, flags )

		'clean up
		DisableTex()

		'done!
		Local frame:TGLImageFrame = New TGLImageFrame
		frame.name = name
		frame.uscale = 1.0 / tex_w
		frame.vscale = 1.0 / tex_h
		frame.u1 = width * frame.uscale
		frame.v1 = height * frame.vscale
		Return frame

	End Function

End Type

'============================================================================================'
'============================================================================================'

Type TMatrix

	Field grid:Float Ptr = Float Ptr( MemAlloc( 4 * 16 ) )
	
	Method SetOrthographic( pl:Float, pr:Float, pt:Float, pb:Float, pn:Float, pf:Float )

		LoadIdentity()
		grid[00] =  2.0 / ( pr - pl )
		grid[05] =  2.0 / ( pt - pb )
		grid[10] = -2.0 / ( pf - pn )
		grid[12] = -( ( pr + pl ) / ( pr - pl ) )
		grid[13] = -( ( pt + pb ) / ( pt - pb ) )
		grid[14] = -( ( pf + pn ) / ( pf - pn ) )
		grid[15] =  1.0

	End Method
	
	Method Clear()

		For Local i:Int = 0 To 15
			grid[i] = 0.0
		Next

	End Method
	
	Method LoadIdentity()

		Clear()
		grid[00] = 1.0
		grid[05] = 1.0
		grid[10] = 1.0
		grid[15] = 1.0

	End Method

End Type

Type TGLSLShader

	Field source:String
	Field kind:Int
	
	Field id:Int
	
	Method Create:TGLSLShader( source:Object, kind:Int )

		Self.kind = kind
		If Not Load( source ) Then Return Null
		Compile()
		If Not id Then Return Null

		Return Self

	End Method
	
	Method Load:Int( source:Object )

		If String( source ) Then
			Self.source = String( source )
			Return True
		EndIf

		Return False

	End Method

	Method Compile()
		
		If source = "" Then
			'Print "ERROR (CompileShader) No shader source!"
			Return 0
		EndIf
		
		Select kind
		Case GL_VERTEX_SHADER
			'Print "(CompileShader) Compiling vertex shader"
		Case GL_FRAGMENT_SHADER
			'Print "(CompileShader) Compiling fragment shader"
		Default 
			'Print "(CompileShader) Invalid shader type!"
			Return 0
		End Select
		
		id = glCreateShader( kind )
		Local str:Byte Ptr = source.ToCString()
		
		glShaderSource( id, 1, Varptr str, Null )
		glCompileShader( id )
		
		MemFree str
		
		Local success:Int = 0
		glGetShaderiv( id, GL_COMPILE_STATUS, Varptr success )
		
		If Not success Then
			'Print GetShaderErrorLog(id)
			Return 0
		EndIf
		
		'Print "(CompileShader) Successfully compiled shader!"
		'Return id
		
	End Method
	
	Method GetErrorLog:String( pid:Int )

		Local logsize:Int = 0
		glGetShaderiv( pid, GL_INFO_LOG_LENGTH, Varptr logsize )

		Local msg:Byte[logsize]
		Local size:Int = 0

		glGetShaderInfoLog( pid, logsize, Varptr size, Varptr msg[0] )

		Local str:String = ""
		For Local i:Int = 0 To MSG.length - 1
			str :+ Chr( msg[i] )
		Next

		Return str

	End Method
	
End Type

Type TGLSLProgram

	Field id:Int

	Field attrib_pos:Int
	Field attrib_uv:Int
	Field attrib_col:Int

	Field uniform_ProjMatrix:Int	'NOTE: Acts as glModelViewProjectionMatrix.
	Field uniform_Texture0:Int
	'Field uniform_Color:Int

	Method Create:TGLSLProgram( vs:TGLSLShader, fs:TGLSLShader )

		If glIsShader( vs.id ) = GL_FALSE Then 
			'Print "ERROR (CreateShaderProgram) pvshader is not a valid shader!"
			Return Null
		EndIf

		If glIsShader( fs.id ) = GL_FALSE Then
			'Print "ERROR (CreateShaderProgram) pfshader is not a valid shader!"
			Return Null
		EndIf

		id = glCreateProgram()
		glAttachShader( id, vs.id )
		glAttachShader( id, fs.id )
		glLinkProgram( id )
		UpdateLayout()

		Return Self
		
	End Method

	Method Validate()

		If glIsProgram( id ) = GL_FALSE Then
			'Print "ERROR (ValidateShaderProgram) Supplied id is not a shader program!"
			Return
		EndIf
		
		Local status:Int
		
		glValidateProgram( id )
		glGetProgramiv( id, GL_VALIDATE_STATUS, Varptr status )
		
		If status = GL_FALSE Then
			'Print "ERROR (ValidateShaderprogram) Supplied program is not valid! (in context)"
			Return
		EndIf
		
		Return
	
	End Method

	Method Use()

		glUseProgram( id )
		If uniform_Texture0 > -1 Then glActiveTexture( GL_TEXTURE0 )

	End Method

	Method UpdateLayout()

		If Not glIsProgram( id ) Then
			'Print "(UpdateShaderLayout) Active is not a valid shader program!"
			Return
		EndIf

		attrib_pos = glGetAttribLocation( id, "vertex_pos" )
		attrib_uv = glGetAttribLocation( id, "vertex_uv" )
		attrib_col = glGetAttribLocation( id, "vertex_col" )

		uniform_ProjMatrix = glGetUniformLocation( id, "u_pmatrix" )
		uniform_Texture0 = glGetUniformLocation( id, "u_texture0" )
		'uniform_Color = glGetUniformLocation( id, "u_color" )

	End Method

	'Method EnableData( vert_buffer:Int, uv_buffer:Int, col_buffer:Int, matrix:Float Ptr )
	Method EnableData( vert_array:Float Ptr, uv_array:Float Ptr, col_array:Float Ptr, matrix:Float Ptr )

		If attrib_pos >= 0 Then
			glEnableVertexAttribArray( attrib_pos )
			glVertexAttribPointer( attrib_pos, 2, GL_FLOAT, GL_FALSE, 0, vert_array )
		EndIf

		If attrib_uv >= 0 Then
			glEnableVertexAttribArray( attrib_uv )
			glVertexAttribPointer( attrib_uv, 2, GL_FLOAT, GL_FALSE, 0, uv_array )
		EndIf

		If attrib_col >= 0 Then
			glEnableVertexAttribArray( attrib_col )
			glVertexAttribPointer( attrib_col, 4, GL_FLOAT, GL_FALSE, 0, col_array )
		EndIf

		If uniform_ProjMatrix >= 0 Then
			glUniformMatrix4fv( uniform_ProjMatrix, 1, False, matrix )
		EndIf

		If uniform_Texture0 >= 0 Then
			glUniform1i( uniform_Texture0, 0 )
		EndIf

		'If uniform_Color >= 0 Then
		'	glUniform4f( uniform_Color, color4f[0], color4f[1], color4f[2], color4f[3] )
		'EndIf

	End Method
	
	Method DisableData()

		If attrib_pos >= 0 Then
			glDisableVertexAttribArray( attrib_pos )
		EndIf

		If attrib_uv >= 0 Then
			glDisableVertexAttribArray( attrib_uv )
		EndIf

		If attrib_col >= 0 Then
			glDisableVertexAttribArray( attrib_col )
		EndIf

	End Method

End Type

'============================================================================================'
'============================================================================================'

Type TGL2Max2DDriver Extends TMax2DDriver

?Not emscripten
	Const BATCHSIZE:Int = 32767 ' how many entries that can be stored in batch before a draw call is required
?emscripten
	Const BATCHSIZE:Int = 8192  ' how many entries that can be stored in batch before a draw call is required
?

	' has driver been initialized?

	Field inited:Int

	' pre-built element arrays

	Field TRI_INDS:Short Ptr = Short Ptr( MemAlloc(2 * BATCHSIZE * 3) )
	Field QUAD_INDS:Short Ptr = Int Ptr( MemAlloc(2 * BATCHSIZE * 6) )

	' vertex attribute arrays

	Field vert_array:Float Ptr = Float Ptr( MemAlloc( 4 * BATCHSIZE * 3 ) )
	Field uv_array:Float Ptr = Float Ptr( MemAlloc( 4 * BATCHSIZE * 2 ) )
	Field col_array:Float Ptr = Float Ptr( MemAlloc( 4 * BATCHSIZE * 4 ) )
	
	' colo(u)rs
	Field color4f:Float Ptr = Float Ptr( MemAlloc( 4 * 4 ) )
	
	Field imgCache:TList = New TList

	' constants for primitive_id rendering

	Const PRIMITIVE_PLAIN_TRIANGLE:Int = 1
	Const PRIMITIVE_DOT:Int = 2
	Const PRIMITIVE_LINE:Int = 3
	Const PRIMITIVE_IMAGE:Int = 4
	Const PRIMITIVE_TRIANGLE_FAN:Int = 5
	Const PRIMITIVE_TRIANGLE_STRIP:Int = 6
	Const PRIMITIVE_TEXTURED_TRIANGLE:Int = 7

	Const PRIMITIVE_CLS:Int = 8
	Const PRIMITIVE_VIEWPORT:Int = 9

	' variables for tracking

	Field vert_index:Int
	Field quad_index:Int
	Field primitive_id:Int
	Field texture_id:Int
	Field blend_id:Int
'	Field element_array:Int[BATCHSIZE * 2]
'	Field element_index:Int
'	Field vert_buffer:Int
'	Field uv_buffer:Int
'	Field col_buffer:Int
'	Field element_buffer:Int

	' projection matrix

	Field u_pmatrix:TMatrix

	' current shader program and defaults

	Field activeProgram:TGLSLProgram
	Field defaultVShader:TGLSLShader
	Field defaultFShader:TGLSLShader
	Field defaultProgram:TGLSLProgram
	Field defaultTextureVShader:TGLSLShader
	Field defaultTextureFShader:TGLSLShader
	Field defaultTextureProgram:TGLSLProgram

	' current z layer for drawing (NOT USED)

	Field layer:Float

	Method Create:TGL2Max2DDriver()

		If Not SDLGraphicsDriver() Then Return Null

		Return Self

	End Method

	'graphics driver overrides
	Method GraphicsModes:TGraphicsMode[]() Override

		Return SDLGraphicsDriver().GraphicsModes()

	End Method

	Method AttachGraphics:TMax2DGraphics( widget:Byte Ptr, flags ) Override

		Local g:TSDLGraphics = SDLGraphicsDriver().AttachGraphics( widget, flags )

		If g Then Return TMax2DGraphics.Create( g, Self )

	End Method
	
	Method CreateGraphics:TMax2DGraphics( width, height, depth, hertz, flags, x, y ) Override

		Local g:TSDLGraphics = SDLGraphicsDriver().CreateGraphics( width, height, depth, hertz, flags | SDL_GRAPHICS_GL, x, y )
		
		If g Then Return TMax2DGraphics.Create( g, Self )

	End Method

	Method SetGraphics( g:TGraphics ) Override

		If Not g
			TMax2DGraphics.ClearCurrent

			SDLGraphicsDriver().SetGraphics Null
			
			inited = Null

			Return
		EndIf

		Local t:TMax2DGraphics = TMax2DGraphics( g )
		?Not opengles
		Assert t And TSDLGraphics( t._graphics )
		?

		SDLGraphicsDriver().SetGraphics t._graphics

		ResetGLContext t
		t.MakeCurrent

	End Method
	
	Method ResetGLContext( g:TGraphics )

		Local gw, gh, gd, gr, gf, gx, gy
		g.GetSettings( gw, gh, gd, gr, gf, gx, gy )

		If Not inited Then
			Init()
			inited = True
		End If

		state_blend = 0
		state_boundtex = 0
		state_texenabled = 0
		glDisable( GL_TEXTURE_2D )

		'glMatrixMode( GL_PROJECTION )
		'glLoadIdentity()
		'glOrtho( 0, gw, gh, 0, -1, 1 )
		'glMatrixMode( GL_MODELVIEW )
		'glLoadIdentity()
		'glViewport( 0, 0, gw, gh )

		u_pmatrix = New TMatrix
		u_pmatrix.SetOrthographic( 0, gw, 0, gh, -1, 1 )

	End Method
	
	Method Flip( sync ) Override

		Flush()

		SDLGraphicsDriver().Flip sync
?ios
		glViewport(0, 0, GraphicsWidth(), GraphicsHeight())
?
	End Method

	Method ToString$() Override

		Return "OpenGL"

	End Method

	Method CreateRenderImageContext:Object(g:TGraphics) Override
		Return new TGL2SDLRenderImageContext.Create(g, self)
	End Method
	
	Method CreateFrameFromPixmap:TGLImageFrame( pixmap:TPixmap, flags ) Override

		Local frame:TGLImageFrame
		frame = TGLImageFrame.CreateFromPixmap( pixmap, flags )
		Return frame

	End Method

	Method SetBlend( blend ) Override

		If state_blend = blend Return
		state_blend=blend

		Select blend
		?Not opengles
		Case MASKBLEND
			glDisable( GL_BLEND )
			glEnable( GL_ALPHA_TEST )
			glAlphaFunc( GL_GEQUAL, 0.5 )
		?
		Case SOLIDBLEND
			glDisable( GL_BLEND )
			?Not opengles
			glDisable( GL_ALPHA_TEST )
			?
		Case ALPHABLEND
			glEnable( GL_BLEND )
			glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA )
			?Not opengles
			glDisable( GL_ALPHA_TEST )
			?
		Case LIGHTBLEND
			glEnable( GL_BLEND )
			glBlendFunc( GL_SRC_ALPHA, GL_ONE )
			?Not opengles
			glDisable( GL_ALPHA_TEST )
			?
		Case SHADEBLEND
			glEnable( GL_BLEND )
			glBlendFunc( GL_DST_COLOR, GL_ZERO )
			?Not opengles
			glDisable( GL_ALPHA_TEST )
			?
		Default
			glDisable( GL_BLEND )
			?Not opengles
			glDisable( GL_ALPHA_TEST )
			?
		End Select

	End Method

	Method SetAlpha( alpha# ) Override

		If alpha > 1.0 Then alpha = 1.0
		If alpha < 0.0 Then alpha = 0.0
		color4f[3] = alpha

	End Method

	Method SetLineWidth( width# ) Override

		glLineWidth( width )

	End Method

	Method SetColor( red, green, blue ) Override

		color4f[0] = Min( Max( red, 0 ), 255 ) / 255.0
		color4f[1] = Min( Max( green, 0 ), 255 ) / 255.0
		color4f[2] = Min( Max( blue, 0 ), 255 ) / 255.0

	End Method

	Method SetColor( color:SColor8 ) Override
		color4f[0]=color.r / 255.0
		color4f[1]=color.g / 255.0
		color4f[2]=color.b / 255.0
	End Method

	Method SetClsColor( red, green, blue ) Override

		red = Min( Max( red, 0 ), 255 )
		green = Min( Max( green, 0 ), 255 )
		blue = Min( Max( blue, 0 ), 255 )
		glClearColor( red / 255.0, green / 255.0, blue / 255.0, 1.0 )

	End Method

	Method SetClsColor( color:SColor8 ) Override
		glClearColor( color.r / 255.0, color.g / 255.0, color.b / 255.0, 1.0 )
	End Method
	
	Method SetViewport( x, y, w, h ) Override
		'render what has been batched till now
		FlushTest( PRIMITIVE_VIEWPORT )

		If x = 0 And y = 0 And w = GraphicsWidth() And h = GraphicsHeight()
			glDisable( GL_SCISSOR_TEST )
		Else
			glEnable( GL_SCISSOR_TEST )
			glScissor( x, GraphicsHeight() - y - h, w, h )
		EndIf

	End Method

	Method SetTransform( xx#, xy#, yx#, yy# ) Override

		ix = xx
		iy = xy
		jx = yx
		jy = yy

	End Method

	Method Cls() Override
		'render what has been batched till now - maybe this happens
		'with an restricted viewport
		FlushTest( PRIMITIVE_CLS )

		glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT )

	End Method

	Method Plot( px#, py# ) Override

		FlushTest( PRIMITIVE_DOT )

		Local in:Int = vert_index * 2

		vert_array[in + 0] = px
		vert_array[in + 1] = py

		in = vert_index * 4

		col_array[in + 0] = color4f[0] 'red
		col_array[in + 1] = color4f[1] 'green
		col_array[in + 2] = color4f[2] 'blue
		col_array[in + 3] = color4f[3] 'alpha

		vert_index :+ 1

	End Method

	Method DrawLine( x0#, y0#, x1#, y1#, tx#, ty# ) Override

		FlushTest( PRIMITIVE_LINE )

		Local in:Int = vert_index * 2

		vert_array[in + 0] = x0 * ix + y0 * iy + tx + 0.5
		vert_array[in + 1] = x0 * jx + y0 * jy + ty + 0.5

		vert_array[in + 2] = x1 * ix + y1 * iy + tx + 0.5
		vert_array[in + 3] = x1 * jx + y1 * jy + ty + 0.5

		in = vert_index * 4

		col_array[in + 0] = color4f[0] 'red
		col_array[in + 1] = color4f[1] 'green
		col_array[in + 2] = color4f[2] 'blue
		col_array[in + 3] = color4f[3] 'alpha

		col_array[in + 4] = color4f[0] 'red
		col_array[in + 5] = color4f[1] 'green
		col_array[in + 6] = color4f[2] 'blue
		col_array[in + 7] = color4f[3] 'alpha

		vert_index :+ 2

	End Method

	Method DrawRect( x0#, y0#, x1#, y1#, tx#, ty# ) Override

		FlushTest( PRIMITIVE_PLAIN_TRIANGLE )

		Local in:Int = vert_index * 2

		vert_array[in    ] = x0 * ix + y0 * iy + tx		'topleft x
		vert_array[in + 1] = x0 * jx + y0 * jy + ty		'topleft y
		vert_array[in + 2] = x1 * ix + y0 * iy + tx		'topright x
		vert_array[in + 3] = x1 * jx + y0 * jy + ty		'topright y
		vert_array[in + 4] = x1 * ix + y1 * iy + tx		'bottomright x
		vert_array[in + 5] = x1 * jx + y1 * jy + ty		'bottomright x
		vert_array[in + 6] = x0 * ix + y1 * iy + tx		'bottomleft x
		vert_array[in + 7] = x0 * jx + y1 * jy + ty		'bottomleft y

		in = vert_index * 4

		col_array[in + 00] = color4f[0] 'red
		col_array[in + 01] = color4f[1] 'green
		col_array[in + 02] = color4f[2] 'blue
		col_array[in + 03] = color4f[3] 'alpha

		col_array[in + 04] = color4f[0] 'red
		col_array[in + 05] = color4f[1] 'green
		col_array[in + 06] = color4f[2] 'blue
		col_array[in + 07] = color4f[3] 'alpha

		col_array[in + 08] = color4f[0] 'red
		col_array[in + 09] = color4f[1] 'green
		col_array[in + 10] = color4f[2] 'blue
		col_array[in + 11] = color4f[3] 'alpha

		col_array[in + 12] = color4f[0] 'red
		col_array[in + 13] = color4f[1] 'green
		col_array[in + 14] = color4f[2] 'blue
		col_array[in + 15] = color4f[3] 'alpha

		vert_index :+ 4
		quad_index :+ 1

	End Method

	Method DrawOval( x0#, y0#, x1#, y1#, tx#, ty# ) Override

		' TRIANGLE_FAN (no batching)
		FlushTest( PRIMITIVE_TRIANGLE_FAN )

		Local xr# = ( x1 - x0 ) * 0.5
		Local yr# = ( y1 - y0 ) * 0.5
		Local segs = Abs( xr ) + Abs( yr )

		segs = Max( segs, 12 ) &~ 3

		x0 :+ xr
		y0 :+ yr

		Local in:Int = vert_index * 2

		vert_array[in    ] = x0 * ix + y0 * iy + tx
		vert_array[in + 1] = x0 * jx + y0 * jy + ty

		Local off:Int = 2

		For Local i = 0 To segs
			Local th# = i * 360# / segs
			Local x# = x0 + Cos( th ) * xr
			Local y# = y0 - Sin( th ) * yr
			vert_array[in + off    ] = x * ix + y * iy + tx
			vert_array[in + off + 1] = x * jx + y * jy + ty
			off :+ 2
		Next

		in = vert_index * 4

		col_array[in + 0] = color4f[0] 'red
		col_array[in + 1] = color4f[1] 'green
		col_array[in + 2] = color4f[2] 'blue
		col_array[in + 3] = color4f[3] 'alpha

		off = 4

		For Local i = 0 To segs
			col_array[in + off + 0] = color4f[0] 'red
			col_array[in + off + 1] = color4f[1] 'green
			col_array[in + off + 2] = color4f[2] 'blue
			col_array[in + off + 3] = color4f[3] 'alpha
			off :+ 4
		Next

		vert_index :+ segs + 2

	End Method

	Method DrawPoly( xy#[], handle_x#, handle_y#, origin_x#, origin_y# ) Override

		If xy.length < 6 Or ( xy.length & 1 ) Then Return

		' TRIANGLE_FAN (no batching)
		FlushTest( PRIMITIVE_TRIANGLE_FAN )

		Local in:Int = vert_index * 2

		For Local i = 0 Until xy.length Step 2
			Local x# = handle_x + xy[i]
			Local y# = handle_y + xy[i + 1]
			vert_array[in + i    ] = x * ix + y * iy + origin_x
			vert_array[in + i + 1] = x * jx + y * jy + origin_y
		Next

		in = vert_index * 4

		For Local i = 0 Until xy.length / 2
			col_array[in + i * 4    ] = color4f[0] 'red
			col_array[in + i * 4 + 1] = color4f[1] 'green
			col_array[in + i * 4 + 2] = color4f[2] 'blue
			col_array[in + i * 4 + 3] = color4f[3] 'alpha
		Next

		vert_index :+ xy.length / 2

	End Method

	Method DrawPixmap( p:TPixmap, x, y ) Override

		Local blend = state_blend
		SetBlend( SOLIDBLEND )

		Local t:TPixmap = p
		If t.format <> PF_RGBA8888 Then t = ConvertPixmap( t, PF_RGBA8888 )

		Local img:TImage = LoadImage(t)
		DrawImage img, x, y

		SetBlend( blend )

	End Method

	Method DrawTexture( name, u0#, v0#, u1#, v1#, x0#, y0#, x1#, y1#, tx#, ty#, img:TImageFrame = Null )

		FlushTest( PRIMITIVE_TEXTURED_TRIANGLE, name )

		Local in:Int = vert_index * 2

		uv_array[in    ] = u0		'topleft x
		uv_array[in + 1] = v0		'topleft y
		uv_array[in + 2] = u1		'topright x
		uv_array[in + 3] = v0		'topright y
		uv_array[in + 4] = u1		'bottomright x
		uv_array[in + 5] = v1		'bottomright y
		uv_array[in + 6] = u0		'bottomleft x
		uv_array[in + 7] = v1		'bottomleft y

		vert_array[in    ] = x0 * ix + y0 * iy + tx		'topleft x
		vert_array[in + 1] = x0 * jx + y0 * jy + ty		'topleft y
		vert_array[in + 2] = x1 * ix + y0 * iy + tx		'topright x
		vert_array[in + 3] = x1 * jx + y0 * jy + ty		'topright y
		vert_array[in + 4] = x1 * ix + y1 * iy + tx		'bottomright x
		vert_array[in + 5] = x1 * jx + y1 * jy + ty		'bottomright x
		vert_array[in + 6] = x0 * ix + y1 * iy + tx		'bottomleft x
		vert_array[in + 7] = x0 * jx + y1 * jy + ty		'bottomleft y

		in = vert_index * 4

		col_array[in + 00] = color4f[0] 'red
		col_array[in + 01] = color4f[1] 'green
		col_array[in + 02] = color4f[2] 'blue
		col_array[in + 03] = color4f[3] 'alpha

		col_array[in + 04] = color4f[0] 'red
		col_array[in + 05] = color4f[1] 'green
		col_array[in + 06] = color4f[2] 'blue
		col_array[in + 07] = color4f[3] 'alpha

		col_array[in + 08] = color4f[0] 'red
		col_array[in + 09] = color4f[1] 'green
		col_array[in + 10] = color4f[2] 'blue
		col_array[in + 11] = color4f[3] 'alpha

		col_array[in + 12] = color4f[0] 'red
		col_array[in + 13] = color4f[1] 'green
		col_array[in + 14] = color4f[2] 'blue
		col_array[in + 15] = color4f[3] 'alpha

		vert_index :+ 4
		quad_index :+ 1
		
		If img Then
			imgCache.AddLast(img)
		End If

	End Method

	Method GrabPixmap:TPixmap( x, y, w, h ) Override

		Local blend = state_blend
		SetBlend( SOLIDBLEND )
		Local p:TPixmap = CreatePixmap( w, h, PF_RGBA8888 )
		' flush everything to ensure there's something to read
		Flush()
		glReadPixels( x, GraphicsHeight() - h - y, w, h, GL_RGBA, GL_UNSIGNED_BYTE, p.pixels )
		p = YFlipPixmap( p )
		SetBlend( blend )
		Return p

	End Method

	Method SetResolution( width#, height# ) Override

		u_pmatrix.SetOrthographic( 0, width, 0, height, -1, 1 )
		'glMatrixMode( GL_PROJECTION )
		'glLoadIdentity()
		'glOrtho( 0, width, height, 0, -1, 1 )
		'glMatrixMode( GL_MODELVIEW )

	End Method

	Method Init()

		?Not opengles
		glewinit()
		?

		color4f[0] = 1.0
		color4f[1] = 1.0
		color4f[2] = 1.0
		color4f[3] = 1.0

		For Local i = 0 Until BATCHSIZE
			Local in = i * 3
			TRI_INDS[in    ] = in
			TRI_INDS[in + 1] = in + 1
			TRI_INDS[in + 2] = in + 2
		Next
		For Local i:Int = 0 Until BATCHSIZE
			Local i4 = i * 4
			Local i6 = i * 6
			QUAD_INDS[i6    ] = i4
			QUAD_INDS[i6 + 1] = i4 + 1
			QUAD_INDS[i6 + 2] = i4 + 2
			QUAD_INDS[i6 + 3] = i4 + 2
			QUAD_INDS[i6 + 4] = i4 + 3
			QUAD_INDS[i6 + 5] = i4
		Next

		' set up shaders
		defaultVShader = New TGLSLShader.Create( DefaultVShaderSource(), GL_VERTEX_SHADER )
		defaultFShader = New TGLSLShader.Create( DefaultFShaderSource(), GL_FRAGMENT_SHADER )
		defaultProgram = New TGLSLProgram.Create( defaultVShader, defaultFShader )

		defaultTextureVShader = New TGLSLShader.Create( DefaultTextureVShaderSource(), GL_VERTEX_SHADER )
		defaultTextureFShader = New TGLSLShader.Create( DefaultTextureFShaderSource(), GL_FRAGMENT_SHADER )
		defaultTextureProgram = New TGLSLProgram.Create( defaultTextureVShader, defaultTextureFShader )

		vert_index = 0
		quad_index = 0
		primitive_id = 0
		texture_id = -1
		blend_id = SOLIDBLEND

	End Method

	Method FlushTest( prim_id:Int, tex_id:Int = -1 )

		Select primitive_id
		Case PRIMITIVE_TRIANGLE_FAN, PRIMITIVE_TRIANGLE_STRIP	'Always flush...
			Flush()

		Default
			If prim_id <> primitive_id Or ..
			vert_index > BATCHSIZE - 256 Or ..
			state_blend <> blend_id Or ..
			tex_id <> texture_id Then
				Flush()
			EndIf

		End Select
		primitive_id = prim_id
		texture_id = tex_id
		blend_id = state_blend

	End Method
	
	Method Flush()

		Select primitive_id
		Case PRIMITIVE_PLAIN_TRIANGLE
			If quad_index = 0 Then Return
			If activeProgram <> defaultProgram Then
				activeProgram = defaultProgram
				activeProgram.Use()
			EndIf
		Case PRIMITIVE_TEXTURED_TRIANGLE
			If quad_index = 0 Then Return
			If activeProgram <> defaultTextureProgram
				activeProgram = defaultTextureProgram
				activeProgram.Use()
			EndIf
		Case PRIMITIVE_DOT, PRIMITIVE_LINE, PRIMITIVE_TRIANGLE_FAN, PRIMITIVE_TRIANGLE_STRIP
			If vert_index = 0 Then Return
			If activeProgram <> defaultProgram Then
				activeProgram = defaultProgram
				activeProgram.Use()
			EndIf
		Default
			Return
		End Select

		If activeProgram Then
			
			' additional tests. validate shaderprogram and buffer. shader program validation takes
			' context into consideration, so do it right before drawing
			
			' NOTE: This should probably happen, but not on every Flush().
			'activeProgram.Validate()
			
			' somewhat interesting? default framebuffer should not return any errors
			' NOTE: 36062 seems to be an erroneous error code (ie opengl returns something it shouldnt)
			'Local status:Int = glCheckFramebufferStatus( GL_FRAMEBUFFER )
			'Select status
			'Case GL_FRAMEBUFFER_COMPLETE
				'Print "valid framebuffer"
			'Default
				'Print "status: " + status
			'End Select

			activeProgram.EnableData( vert_array, uv_array, col_array, u_pmatrix.grid )

			Select blend_id
			?Not opengles
			Case MASKBLEND
				glDisable( GL_BLEND )
				glEnable( GL_ALPHA_TEST )
				glAlphaFunc( GL_GEQUAL, 0.5 )
			?
			Case SOLIDBLEND
				glDisable( GL_BLEND )
				?Not opengles
				glDisable( GL_ALPHA_TEST )
				?
			Case ALPHABLEND
				glEnable( GL_BLEND )
				glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA )
				?Not opengles
				glDisable( GL_ALPHA_TEST )
				?
			Case LIGHTBLEND
				glEnable( GL_BLEND )
				glBlendFunc( GL_SRC_ALPHA, GL_ONE )
				?Not opengles
				glDisable( GL_ALPHA_TEST )
				?
			Case SHADEBLEND
				glEnable( GL_BLEND )
				glBlendFunc( GL_DST_COLOR, GL_ZERO )
				?Not opengles
				glDisable( GL_ALPHA_TEST )
				?
			Default
				glDisable( GL_BLEND )
				?Not opengles
				glDisable( GL_ALPHA_TEST )
				?
			End Select

			Select primitive_id
			Case PRIMITIVE_PLAIN_TRIANGLE
				glDrawElements( GL_TRIANGLES, quad_index * 6, GL_UNSIGNED_SHORT, QUAD_INDS )
			Case PRIMITIVE_TEXTURED_TRIANGLE
				EnableTex( texture_id )
				glDrawElements( GL_TRIANGLES, quad_index * 6, GL_UNSIGNED_SHORT, QUAD_INDS )
				DisableTex()

				imgCache.Clear()
			Case PRIMITIVE_DOT
				glDrawArrays( GL_POINTS, 0, vert_index )
			Case PRIMITIVE_LINE
				glDrawArrays( GL_LINES, 0, vert_index )
			Case PRIMITIVE_TRIANGLE_FAN
				glDrawArrays( GL_TRIANGLE_FAN, 0, vert_index )
			Case PRIMITIVE_TRIANGLE_STRIP
				glDrawArrays( GL_TRIANGLE_STRIP, 0, vert_index )
			End Select
			
			activeProgram.DisableData()
			glUseProgram( 0 )
			activeProgram = Null
		End If

		vert_index = 0
		quad_index = 0

	End Method

	'NOTE: Unnecessary, for the time being.
'	Method UpdateBuffers()
'
'		If vert_buffer = 0 Then glGenBuffers( 1, Varptr vert_buffer )
'		If uv_buffer = 0 Then glGenBuffers( 1, Varptr uv_buffer )
'		If col_buffer = 0 Then glGenBuffers( 1, Varptr col_buffer )
'		If element_buffer = 0 Then glGenBuffers( 1, Varptr element_buffer )
'
'		glBindBuffer( GL_ARRAY_BUFFER, vert_buffer )
'		glBufferData( GL_ARRAY_BUFFER, vert_index * 12, vert_array, GL_DYNAMIC_DRAW )
'
'		glBindBuffer( GL_ARRAY_BUFFER, uv_buffer)
'		glBufferData( GL_ARRAY_BUFFER, vert_index * 8, uv_array, GL_DYNAMIC_DRAW )
'
'		glBindBuffer( GL_ARRAY_BUFFER, col_buffer )
'		glBufferData( GL_ARRAY_BUFFER, vert_index * 16, col_array, GL_DYNAMIC_DRAW )
'
'		glBindBuffer( GL_ELEMENT_ARRAY_BUFFER, element_buffer)
'		glBufferData( GL_ELEMENT_ARRAY_BUFFER, element_index * 12, element_array, GL_DYNAMIC_DRAW )
'
'	End Method

End Type

Rem
bbdoc: Get OpenGL Max2D Driver
about:
The returned driver can be used with #SetGraphicsDriver to enable OpenGL Max2D rendering.
End Rem
Function GL2Max2DDriver:TGL2Max2DDriver()
	Print "GL2 (with shaders) Active"
	Global _done
	If Not _done
		_driver = New TGL2Max2DDriver.Create()
		_done = True
	EndIf
	Return _driver
End Function

Local driver:TGL2Max2DDriver = GL2Max2DDriver()
If driver SetGraphicsDriver driver
