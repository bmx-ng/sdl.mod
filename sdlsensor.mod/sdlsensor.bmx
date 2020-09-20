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
bbdoc: SDL Sensor
End Rem
Module SDL.SDLSensor

Import SDL.SDL


Import "common.bmx"

Rem
bbdoc: A Sensor
End Rem
Type TSDLSensor

	Field sensorPtr:Byte Ptr
	
	Function _create:TSDLSensor(sensorPtr:Byte Ptr)
		If sensorPtr Then
			Local this:TSDLSensor = New TSDLSensor
			this.sensorPtr = sensorPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Counts the number of sensors attached to the system right now.
	End Rem
	Function NumSensors:Int()
		Return SDL_NumSensors()
	End Function
	
	Rem
	bbdoc: Gets the implementation dependent name of a sensor.
	about: This can be called before any sensors are opened.
	End Rem
	Function GetDeviceName:String(deviceIndex:Int)
		Return String.FromCString(SDL_SensorGetDeviceName(deviceIndex))
	End Function
	
	Rem
	bbdoc: Gets the type of a sensor.
	about: This can be called before any sensors are opened.
	End Rem
	Function GetDeviceType:Int(deviceIndex:Int)
		Return SDL_SensorGetDeviceType(deviceIndex)
	End Function
	
	Rem
	bbdoc: Gets the platform dependent type of a sensor.
	about: This can be called before any sensors are opened.
	End Rem
	Function GetDeviceNonPortableType:Int(deviceIndex:Int)
		Return SDL_SensorGetDeviceNonPortableType(deviceIndex)
	End Function
	
	Rem
	bbdoc: Gets the instance ID of a sensor.
	about: This can be called before any sensors are opened.
	End Rem
	Function GetDeviceInstanceID:Int(deviceIndex:Int)
		Return SDL_SensorGetDeviceInstanceID(deviceIndex)
	End Function
	
	Rem
	bbdoc: Returns the TSDLSensor associated with an instance id.
	End Rem
	Function FromInstanceID:TSDLSensor(instanceID:Int)
		Return _create(SDL_SensorFromInstanceID(instanceID))
	End Function

	Rem
	bbdoc: Opens a sensor for use.
	about: The index passed as an argument refers to the N'th sensor on the system.
	End Rem
	Function Open:TSDLSensor(deviceIndex:Int)
		Return _create(SDL_SensorOpen(deviceIndex))
	End Function

	Rem
	bbdoc: Gets the implementation dependent name of a sensor.
	End Rem
	Method GetName:String()
		Return String.FromCString(SDL_SensorGetName(sensorPtr))
	End Method
	
	Rem
	bbdoc: Gets the type of a sensor.
	about: This can be called before any sensors are opened.
	End Rem
	Method GetType:Int()
		Return SDL_SensorGetType(sensorPtr)
	End Method
	
	Rem
	bbdoc: Gets the platform dependent type of a sensor.
	about: This can be called before any sensors are opened.
	End Rem
	Method GetNonPortableType:Int()
		Return SDL_SensorGetNonPortableType(sensorPtr)
	End Method
	
	Rem
	bbdoc: Gets the instance ID of a sensor.
	about: This can be called before any sensors are opened.
	End Rem
	Method GetInstanceID:Int()
		Return SDL_SensorGetInstanceID(sensorPtr)
	End Method
	
	Rem
	bbdoc: Gets the current state of an opened sensor.
	about: The number of values and interpretation of the data is sensor dependent.
	End Rem
	Method GetData:Int(data:Float Ptr, numValues:Int)
		Return SDL_SensorGetData(sensorPtr, data, numValues)
	End Method
	
	Rem
	bbdoc: Closes the sensor.
	End Rem
	Method Close()
		SDL_SensorClose(sensorPtr)
	End Method
	
	Rem
	bbdoc: Updates the current state of the open sensors.
	about: This is called automatically by the event loop if sensor events are enabled.
	This needs to be called from the thread that initialized the sensor subsystem.
	End Rem
	Function Update()
		SDL_SensorUpdate()
	End Function

End Type

SDL_InitSubSystem(SDL_INIT_SENSOR)
