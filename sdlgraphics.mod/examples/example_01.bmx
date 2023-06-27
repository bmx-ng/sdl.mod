SuperStrict

Framework sdl.sdlgraphics
Import pub.opengl
Import brl.math
Import brl.standardio

Graphics 800, 600, 0, 60, GRAPHICS_BACKBUFFER|GRAPHICS_DEPTHBUFFER

Global ax:Float, ay:Float,tim:Float

While Not AppTerminate()
	Local wid:Int = GraphicsWidth()
	Local hgt:Int = GraphicsHeight()
	Local asp:Float = Float(wid)/Float(hgt)
	
	glViewport 0,0,wid,hgt
	glMatrixMode GL_PROJECTION
	glLoadIdentity
	gluPerspective 45, asp, 1, 100
	gltranslatef 0,0,-50+tim
	tim=20*Cos(MilliSecs()/10.0)
	
	glMatrixMode GL_MODELVIEW
	glLoadIdentity
	
	Local global_ambient:Float[]=[0.6:Float, 0.5:Float,  0.3:Float, 1.0:Float]
	Local light0pos:Float[]=     [0.0:Float, 5.0:Float, 10.0:Float, 1.0:Float]
	Local light0ambient:Float[]= [0.5:Float, 0.5:Float,  0.5:Float, 1.0:Float]
	Local light0diffuse:Float[]= [0.3:Float, 0.3:Float,  0.3:Float, 1.0:Float]
	Local light0specular:Float[]=[0.8:Float, 0.8:Float,  0.8:Float, 1.0:Float]
	
	Local lmodel_ambient:Float[]=[ 0.2:Float,0.2:Float,0.2:Float,1.0:Float]
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT,lmodel_ambient)
	
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, global_ambient)
	glLightfv(GL_LIGHT0, GL_POSITION, light0pos)
	glLightfv(GL_LIGHT0, GL_AMBIENT, light0ambient)
	glLightfv(GL_LIGHT0, GL_DIFFUSE, light0diffuse)
	glLightfv(GL_LIGHT0, GL_SPECULAR, light0specular)
	glEnable(GL_LIGHTING)
	glEnable(GL_LIGHT0)
	glShadeModel(GL_SMOOTH)
	glMateriali(GL_FRONT, GL_SHININESS, 128)
	
	                                
	glClearColor 0,0,0.5,1
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	
	glEnable(GL_DEPTH_TEST)
	
	glRotatef ax,1,0,0
	glRotatef ay,0,1,0
	ax:+1
	ay:+5
	DrawSizeCube(7)
	
	Flip 1
Wend




Function DrawSizeCube(size:Float)
	size=-size
	'Front Face
	glBegin(GL_TRIANGLE_STRIP)
	        glNormal3f( 0.0, 0.0, 1.0)
	        glVertex3f( size, size,-size)
	        glNormal3f( 0.0, 0.0, 1.0)
	        glVertex3f(-size, size,-size)
	        glNormal3f( 0.0, 0.0, 1.0)
	        glVertex3f( size,-size,-size)
	        glNormal3f( 0.0, 0.0, 1.0)
	        glVertex3f(-size,-size,-size)
	glEnd
	'Back Face
	glNormal3f( 0.0, 0.0, -1.0)
	glBegin(GL_TRIANGLE_STRIP)
	        glVertex3f(-size, size, size)
	        glVertex3f( size, size, size)
	        glVertex3f(-size,-size, size)
	        glVertex3f( size,-size, size)
	glEnd
	'Right Face
	glNormal3f( 1.0, 0.0, 0.0)
	glBegin(GL_TRIANGLE_STRIP)
	        glVertex3f(-size, size,-size)
	        glVertex3f(-size, size, size)
	        glVertex3f(-size,-size,-size)
	        glVertex3f(-size,-size, size)
	glEnd
	'Left Face
	glNormal3f( -1.0, 0.0, 0.0)
	glBegin(GL_TRIANGLE_STRIP)
	        glVertex3f( size, size, size)
	        glVertex3f( size, size,-size)
	        glVertex3f( size,-size, size)
	        glVertex3f( size,-size,-size)
	glEnd
	'Bottom Face
	glNormal3f( 0.0, -1.0, 0.0)
	glBegin(GL_TRIANGLE_STRIP)
	        glVertex3f( size, size,-size)
	        glVertex3f( size, size, size)
	        glVertex3f(-size, size,-size)
	        glVertex3f(-size, size, size)
	glEnd
	'Top Face
	glNormal3f( 0.0, 1.0, 0.0)
	glBegin(GL_TRIANGLE_STRIP)
	        glVertex3f( size,-size,-size)
	        glVertex3f(-size,-size,-size)
	        glVertex3f( size,-size, size)
	        glVertex3f(-size,-size, size)
	glEnd
End Function

