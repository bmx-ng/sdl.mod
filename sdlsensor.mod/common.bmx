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

Extern

	Function SDL_NumSensors:Int()
	Function SDL_SensorGetDeviceType:Int(deviceIndex:Int)
	Function SDL_SensorGetDeviceName:Byte Ptr(deviceIndex:Int)
	Function SDL_SensorGetDeviceNonPortableType:Int(deviceIndex:Int)
	Function SDL_SensorGetDeviceInstanceID:Int(deviceIndex:Int)
	Function SDL_SensorOpen:Byte Ptr(deviceIndex:Int)
	Function SDL_SensorFromInstanceID:Byte Ptr(instanceId:Int)
	Function SDL_SensorGetName:Byte Ptr(handle:Byte Ptr)
	Function SDL_SensorGetType:Int(handle:Byte Ptr)
	Function SDL_SensorGetNonPortableType:Int(handle:Byte Ptr)
	Function SDL_SensorGetInstanceID:Int(handle:Byte Ptr)
	Function SDL_SensorGetData:Int(handle:Byte Ptr, data:Float Ptr, numValues:Int)
	Function SDL_SensorClose(handle:Byte Ptr)
	Function SDL_SensorUpdate()

End Extern

Const SDL_SENSOR_INVALID:Int = -1   ' Returned For an invalid sensor
Const SDL_SENSOR_UNKNOWN:Int = 0    ' Unknown sensor Type
Const SDL_SENSOR_ACCEL:Int = 1      ' Accelerometer
Const SDL_SENSOR_GYRO:Int = 2       ' Gyroscope


Const SDL_STANDARD_GRAVITY:Float = 9.80665
