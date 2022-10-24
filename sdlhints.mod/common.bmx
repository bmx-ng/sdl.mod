' Copyright (c) 2022 Bruce A Henderson
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

Import SDL.SDL

Extern

	Function SDL_ResetHint:Int(name:Byte Ptr)
	Function SDL_ResetHints()
	Function SDL_GetHint:Byte Ptr(name:Byte Ptr)
	Function SDL_SetHint:Int(name:Byte Ptr, value:Byte Ptr)
	
End Extern


Rem
bbdoc: A hint that specifies whether the Android / iOS built-in accelerometer should be listed as a joystick device, rather than listing actual joysticks only.
about:
Values
```
0   list only real joysticks and accept input from them
1   list real joysticks along with the accelorometer as if it were a 3 axis joystick (the default)
```
End Rem
Const SDL_HINT_ACCELEROMETER_AS_JOYSTICK:String = "SDL_ACCELEROMETER_AS_JOYSTICK"

Rem
bbdoc: This hint specifies the behavior of Alt+Tab while the keyboard is grabbed.
about: By default, SDL emulates Alt+Tab functionality while the keyboard is grabbed and your window is full-screen.
This prevents the user from getting stuck in your application if you've enabled keyboard grab.

The variable can be set to the following values:
```
0    SDL will not handle Alt+Tab. Your application is responsible for handling Alt+Tab while the keyboard is grabbed.
1    SDL will minimize your window when Alt+Tab is pressed (default)
```
End Rem
Const SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED:String = "SDL_ALLOW_ALT_TAB_WHILE_GRABBED"

Rem
bbdoc: A hint to allow setting the topmost Window bit.
about: If set to 0 then never set the top most bit on a SDL Window, even if the video mode expects it.
This is a debugging aid for developers and not expected to be used by end users. The default is 1.

Values
```
0   don't allow topmost
1   allow topmost (default)
```
End Rem
Const SDL_HINT_ALLOW_TOPMOST:String = "SDL_ALLOW_TOPMOST"

Rem
bbdoc: A hint that specifies the Android APK expansion main file version.
about:
Values
```
X   the Android APK expansion main file version (should be a string number like "1", "2" etc.)
```
This hint must be set together with the hint #SDL_HINT_ANDROID_APK_EXPANSION_PATCH_FILE_VERSION.

If both hints were set then #SDLRWFromFile() will look into expansion files after a given relative path was not found in the internal storage and assets.

By default this hint is not set and the APK expansion files are not searched.
End Rem
Const SDL_HINT_ANDROID_APK_EXPANSION_MAIN_FILE_VERSION:String = "SDL_ANDROID_APK_EXPANSION_MAIN_FILE_VERSION"

Rem
bbdoc: A hint that specifies the Android APK expansion patch file version.
about: 
Values
```
X   the Android APK expansion patch file version (should be a string number like "1", "2" etc.)
```
This hint must be set together with the hint #SDL_HINT_ANDROID_APK_EXPANSION_MAIN_FILE_VERSION.

If both hints were set then #SDLRWFromFile() will look into expansion files after a given relative path was not found in the internal storage and assets.

By default this hint is not set and the APK expansion files are not searched.
End Rem
Const SDL_HINT_ANDROID_APK_EXPANSION_PATCH_FILE_VERSION:String = "SDL_ANDROID_APK_EXPANSION_PATCH_FILE_VERSION"

Rem
bbdoc: A variable to control whether the event loop will block itself when the app is paused.
about:
Values
```
0    Non blocking.
1    Blocking. (default)
```
The value should be set before SDL is initialized.
End Rem
Const SDL_HINT_ANDROID_BLOCK_ON_PAUSE:String = "SDL_ANDROID_BLOCK_ON_PAUSE"

Rem
bbdoc: A hint to control whether SDL will pause audio in background (Requires SDL_ANDROID_BLOCK_ON_PAUSE as "Non blocking")
about:
Values
```
0    Non paused.
1    Paused. (default)
```
The value should be set before SDL is initialized.
End Rem
Const SDL_HINT_ANDROID_BLOCK_ON_PAUSE_PAUSEAUDIO:String = "SDL_ANDROID_BLOCK_ON_PAUSE_PAUSEAUDIO"

Rem
bbdoc: A hint that specifies a variable to control whether mouse and touch events are to be treated together or separately.
about: 
Values
```
0   mouse events will be handled as touch events and touch will raise fake mouse events (default)
1   mouse events will be handled separately from pure touch events
```
By default mouse events will be handled as touch events and touch will raise fake mouse events.

The value of this hint is used at runtime, so it can be changed at any time.
End Rem
Const SDL_HINT_ANDROID_SEPARATE_MOUSE_AND_TOUCH:String = "SDL_ANDROID_SEPARATE_MOUSE_AND_TOUCH"

Rem
bbdoc: A hint to control whether we trap the Android back button to handle it manually.
about: This is necessary for the rightmouse button to work on some Android devices, or to be able to trap the back
button for use in your code reliably. If set to true, the back button will show up as an SDL_KEYDOWN / SDL_KEYUP pair with a
keycode of SDL_SCANCODE_AC_BACK.

Values
```
0    Back button will be handled as usual for system. (default)
1    Back button will be trapped, allowing you to handle the key press manually. (This will also let right mouse click 
     work on systems where the right mouse button functions as back.)
```
The value of this hint is used at runtime, so it can be changed at any time.
End Rem
Const SDL_HINT_ANDROID_TRAP_BACK_BUTTON:String = "SDL_ANDROID_TRAP_BACK_BUTTON"

Rem
bbdoc: A hint that specifies whether controllers used with the Apple TV generate UI events.
about: 
Values
```
0   controller input does not gnerate UI events (default)
1   controller input generates UI events
```
When UI events are generated by controller input, the app will be backgrounded when the Apple TV remote's menu button is pressed, and when the
pause or B buttons on gamepads are pressed.

More information about properly making use of controllers for the Apple TV can be found here: https://developer.apple.com/tvos/human-interface-guidelines/remote-and-controllers/
End Rem
Const SDL_HINT_APPLE_TV_CONTROLLER_UI_EVENTS:String = "SDL_APPLE_TV_CONTROLLER_UI_EVENTS"

Rem
bbdoc: A hint that specifies whether the Apple TV remote's joystick axes will automatically match the rotation of the remote.
about:
Values
```
0   remote orientation does not affect joystick axes (default)
1   joystick axes are based on the orientation of the remote
```
End Rem
Const SDL_HINT_APPLE_TV_REMOTE_ALLOW_ROTATION:String = "SDL_APPLE_TV_REMOTE_ALLOW_ROTATION"

Rem
bbdoc: A hint controlling the audio category on iOS and Mac OS X.
about:
Values
```
ambient    Use the AVAudioSessionCategoryAmbient audio category, will be muted by the phone mute switch (default)
playback   Use the AVAudioSessionCategoryPlayback category
```
For more information, see Apple's documentation: https://developer.apple.com/library/content/documentation/Audio/Conceptual/AudioSessionProgrammingGuide/AudioSessionCategoriesandModes/AudioSessionCategoriesandModes.html
End Rem
Const SDL_HINT_AUDIO_CATEGORY:String = "SDL_AUDIO_CATEGORY"

Rem
bbdoc: This hint specifies an application name for an audio device.
about: Some audio backends (such as PulseAudio) allow you to describe your audio stream. Among other things,
this description might show up in a system control panel that lets the user adjust the volume on specific audio
streams instead of using one giant master volume slider.

This hints lets you transmit that information to the OS. The contents of this hint are used while opening an audio
device. You should use a string that describes your program ("My Game 2: The Revenge")

Setting this to "" or leaving it unset will have SDL use a reasonable default: probably the application's name or
"SDL Application" if SDL doesn't have any better information.

On targets where this is not supported, this hint does nothing.
End Rem
Const SDL_HINT_AUDIO_DEVICE_APP_NAME:String = "SDL_AUDIO_DEVICE_APP_NAME"

Rem
bbdoc: This hint specifies an application name for an audio device.
about: Some audio backends (such as PulseAudio) allow you to describe your audio stream. Among other things,
this description might show up in a system control panel that lets the user adjust the volume on specific audio
streams instead of using one giant master volume slider.

This hints lets you transmit that information to the OS. The contents of this hint are used while opening an audio
device. You should use a string that describes your what your program is playing ("audio stream" is probably
sufficient in many cases, but this could be useful for something like "team chat" if you have a headset playing VoIP audio separately).

Setting this to "" or leaving it unset will have SDL use a reasonable default: "audio stream" or something similar.

On targets where this is not supported, this hint does nothing.
End Rem
Const SDL_HINT_AUDIO_DEVICE_STREAM_NAME:String = "SDL_AUDIO_DEVICE_STREAM_NAME"

Rem
bbdoc: This hint specifies an application role for an audio device.
about: Some audio backends (such as Pipewire) allow you to describe the role of your audio stream.
Among other things, this description might show up in a system control panel or software for displaying and manipulating media playback/capture graphs.

This hints lets you transmit that information to the OS. The contents of this hint are used while opening
an audio device. You should use a string that describes your what your program is playing (Game, Music, Movie, etc...).

Setting this to "" or leaving it unset will have SDL use a reasonable default: "Game" or something similar.

On targets where this is not supported, this hint does nothing.
End Rem
Const SDL_HINT_AUDIO_DEVICE_STREAM_ROLE:String = "SDL_AUDIO_DEVICE_STREAM_ROLE"

Rem
bbdoc: A hint controlling speed/quality tradeoff of audio resampling.
about: If available, SDL can use libsamplerate ( http://www.mega-nerd.com/SRC/ ) to handle audio resampling. There are
different resampling modes available that produce different levels of quality, using more CPU.

If this hint isn't specified to a valid setting, or libsamplerate isn't available, SDL will use the default, internal resampling algorithm.

Note that this is currently only applicable to resampling audio that is being written to a device for playback or
audio being read from a device for capture. SDL_AudioCVT always uses the default resampler (although this might change for SDL 2.1).

This hint is currently only checked at audio subsystem initialization.

This variable can be set to the following values:
```
0 or default   Use SDL's internal resampling (Default when not set - low quality, fast)
1 or fast      Use fast, slightly higher quality resampling, if available
2 or medium    Use medium quality resampling, if available
3 or best      Use high quality resampling, if available
```
End Rem
Const SDL_HINT_AUDIO_RESAMPLING_MODE:String = "SDL_AUDIO_RESAMPLING_MODE"

Rem
bbdoc: A hint controlling whether SDL updates joystick state when getting input events
about:
Values
```
0    You'll call SDL_JoystickUpdate( ) manually
1    SDL will automatically call SDL_JoystickUpdate( ) (default)
```
This hint can be toggled on and off at runtime.
End Rem
Const SDL_HINT_AUTO_UPDATE_JOYSTICKS:String = "SDL_AUTO_UPDATE_JOYSTICKS"

Rem
bbdoc: A hint controlling whether SDL updates sensor state when getting input events
about:
Values
```
0    You'll call SDL_SensorUpdate ( ) manually
1    SDL will automatically call SDL_SensorUpdate( ) (default)
```
This hint can be toggled on and off at runtime.
End Rem
Const SDL_HINT_AUTO_UPDATE_SENSORS:String = "SDL_AUTO_UPDATE_SENSORS"

Rem
bbdoc: A hint that specifies whether SDL should not use version 4 of the bitmap header when saving BMPs.
Values
```
0   version 4 of the bitmap header will be used when saving BMPs (default)
1   version 4 of the bitmap header will not be used when saving BMPs
```
The bitmap header version 4 is required for proper alpha channel support and SDL will use it when required.
Should this not be desired, this hint can force the use of the 40 byte header version which is supported everywhere.

If the hint is not set then surfaces with a colorkey or an alpha channel are saved to a 32-bit BMP file with an alpha mask.
SDL will use the bitmap header version 4 and set the alpha mask accordingly. This is the default behavior since SDL 2.0.5.

If the hint is set then surfaces with a colorkey or an alpha channel are saved to a 32-bit BMP file without an alpha mask.
The alpha channel data will be in the file, but applications are going to ignore it. This was the default behavior before SDL 2.0.5.
End Rem
Const SDL_HINT_BMP_SAVE_LEGACY_FORMAT:String = "SDL_BMP_SAVE_LEGACY_FORMAT"

Rem
bbdoc: This hint can be used as an override for SDL_GetDisplayUsableBounds( )
about: If set, this hint will override the expected results for SDL_GetDisplayUsableBounds( ) for display index 0.
Generally you don't want to do this, but this allows an embedded system to request that some of the screen be
reserved for other uses when paired with a well-behaved application.

The contents of this hint must be 4 comma-separated integers, the first is the bounds x, then y, width and height, in that order.
End Rem
Const SDL_HINT_DISPLAY_USABLE_BOUNDS:String = "SDL_DISPLAY_USABLE_BOUNDS"

Rem
bbdoc: A hint that specifies if SDL should give back control to the browser automatically when running with asyncify.
about: 
Values
```
0   disable emscripten_sleep calls (if you give back browser control manually or use asyncify for other purposes)
1   enable emscripten_sleep calls (default)
```
This hint only applies to the Emscripten platform.
End Rem
Const SDL_HINT_EMSCRIPTEN_ASYNCIFY:String = "SDL_EMSCRIPTEN_ASYNCIFY"

Rem
bbdoc: A hint that specifies a value to override the binding element for keyboard inputs for Emscripten builds.
about:
Values
```
#window     the JavaScript window object (default)
#document   the JavaScript document object
#screen     the JavaScript window.screen object
#canvas     the default WebGL canvas element
```
Any other string without a leading # sign applies to the element on the page with that ID.

This hint only applies to the Emscripten platform.
End Rem
Const SDL_HINT_EMSCRIPTEN_KEYBOARD_ELEMENT:String = "SDL_EMSCRIPTEN_KEYBOARD_ELEMENT"

Rem
bbdoc: A hint that controls whether Steam Controllers should be exposed using the SDL joystick and game controller APIs.
about:
Values
```
0    Do not scan for Steam Controllers
1    Scan for Steam Controllers (the default)
```
The default value is "1".  This hint must be set before initializing the joystick subsystem.
End Rem
Const SDL_HINT_ENABLE_STEAM_CONTROLLERS:String = "SDL_ENABLE_STEAM_CONTROLLERS"

Rem
bbdoc: A hint controlling whether SDL logs all events pushed onto its internal queue.
about:
Values
```
0    Don't log any events (default)
1    Log all events except mouse and finger motion, which are pretty spammy.
2    Log all events.
```
This is generally meant to be used to debug SDL itself, but can be useful for application developers that need
better visibility into what is going on in the event queue. Logged events are sent through SDL_Log( ), which
means by default they appear on stdout on most platforms or maybe OutputDebugString( ) on Windows, and can be
funneled by the app with SDL_LogSetOutputFunction( ), etc.

This hint can be toggled on and off at runtime, if you only need to log events for a small subset of program execution.
End Rem
Const SDL_HINT_EVENT_LOGGING:String = "SDL_EVENT_LOGGING"

Rem
bbdoc: A hint that specifies how 3D acceleration is used with #GetSurface().
about:
Values
```
0   disable 3D acceleration
1   enable 3D acceleration, using the default renderer
X   enable 3D acceleration, using X where X is one of the valid rendering drivers. (e.g. "direct3d", "opengl", etc.)
```
By default SDL tries to make a best guess whether to use acceleration or not on each platform.

SDL can try to accelerate the screen surface returned by TSDLWindow #GetSurface() by using streaming textures with a 3D rendering engine.
This variable controls whether and how this is done.
End Rem
Const SDL_HINT_FRAMEBUFFER_ACCELERATION:String = "SDL_FRAMEBUFFER_ACCELERATION"

Rem
bbdoc: A hint that lets you provide a file with extra gamecontroller db entries.
about:
This hint must be set before calling SDL_Init(SDL_INIT_GAMECONTROLLER).

You can update mappings after the system is initialized with SDL_GameControllerMappingForGUID( ) and SDL_GameControllerAddMapping( ).
End Rem
Const SDL_HINT_GAMECONTROLLERCONFIG:String = "SDL_GAMECONTROLLERCONFIG"

Rem
bbdoc: A hint that lets you provide a file with extra gamecontroller db entries.
about: The file should contain lines of gamecontroller config data, see SDL_gamecontroller.h

This hint must be set before calling SDL_Init(SDL_INIT_GAMECONTROLLER)

You can update mappings after the system is initialized with SDL_GameControllerMappingForGUID( ) and SDL_GameControllerAddMapping( ).
End Rem
Const SDL_HINT_GAMECONTROLLERCONFIG_FILE:String = "SDL_GAMECONTROLLERCONFIG_FILE"

Rem
bbdoc: A hint that overrides the automatic controller type detection
about: The hint should be comma separated entries, in the form: VID/PID=type

The VID and PID should be hexadecimal with exactly 4 digits, e.g. 0x00fd

The type should be one of:
```
Xbox360
XboxOne
PS3
PS4
PS5
SwitchPro
```
This hint affects what driver is used, and must be set before calling SDL_Init(SDL_INIT_GAMECONTROLLER).
End Rem
Const SDL_HINT_GAMECONTROLLERTYPE:String = "SDL_GAMECONTROLLERTYPE"

Rem
bbdoc: A hint containing a list of devices to skip when scanning for game controllers.
about: 
The format of the string is a comma separated list of USB VID/PID pairs in hexadecimal form, e.g.
```
0xAAAA/0xBBBB,0xCCCC/0xDDDD
```
The hint can also take the form of @file, in which case the named file will be loaded and interpreted as the value of the variable.
End Rem
Const SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES:String = "SDL_GAMECONTROLLER_IGNORE_DEVICES"

Rem
bbdoc: If set, all devices will be skipped when scanning for game controllers except for the ones listed in this variable.
about: The format of the string is a comma separated list of USB VID/PID pairs in hexadecimal form, e.g.
```
0xAAAA/0xBBBB,0xCCCC/0xDDDD
```
The variable can also take the form of @file, in which case the named file will be loaded and interpreted as the value of the variable.
End Rem
Const SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT:String = "SDL_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT"

Rem
bbdoc: If set, game controller face buttons report their values according to their labels instead of their positional layout.

For example, on Nintendo Switch controllers, normally you'd get:
```
    (Y)
(X)     (B)
    (A)
```
but if this hint is set, you'll get:
```
    (X)
(Y)     (A)
    (B)
```
The hint can be set to the following values:
```
0   Report the face buttons by position, as though they were on an Xbox controller.
1   Report the face buttons by label instead of position
```
The default value is 1. This hint may be set at any time.
End Rem
Const SDL_HINT_GAMECONTROLLER_USE_BUTTON_LABELS:String = "SDL_GAMECONTROLLER_USE_BUTTON_LABELS"

Rem
bbdoc: A hint setting the double click time, in milliseconds.
End Rem
Const SDL_HINT_GRAB_KEYBOARD:String = "SDL_GRAB_KEYBOARD"

Rem
bbdoc: A hint that specifies a variable controlling whether the idle timer is disabled on iOS.
about:
Values
```
0   enable idle timer (default)
1   disable idle timer
```
When an iOS application does not receive touches for some time, the screen is dimmed automatically.
For games where the accelerometer is the only input this is problematic. This functionality can be disabled by setting this hint.

As of SDL 2.0.4, #SDLEnableScreenSaver() and #SDLDisableScreenSaver() accomplish the same thing on iOS. They should be preferred over this hint.
End Rem
Const SDL_HINT_IDLE_TIMER_DISABLED:String = "SDL_IDLE_TIMER_DISABLED"

Rem
bbdoc: A hint to control whether we trap the Android back button to handle it manually.
about: This is necessary for the right mouse button to work on some Android devices, or to be able to trap the
back button for use in your code reliably. If set to true, the back button will show up as an SDL_KEYDOWN / SDL_KEYUP
pair with a keycode of SDL_SCANCODE_AC_BACK.

Values
```
0   Back button will be handled as usual for system. (default)
1   Back button will be trapped, allowing you to handle the key press
    manually. (This will also let right mouse click work on systems
    where the right mouse button functions as back.)
```
The value of this hint is used at runtime, so it can be changed at any time.
End Rem
Const SDL_HINT_IME_INTERNAL_EDITING:String = "SDL_IME_INTERNAL_EDITING"

Rem
bbdoc: A hint controlling whether the home indicator bar on iPhone X should be hidden.
about:
Values
```
0   The indicator bar is not hidden (default for windowed applications)
1   The indicator bar is hidden and is shown when the screen is touched (useful for movie playback applications)
2   The indicator bar is dim and the first swipe makes it visible and the second swipe performs the "home" action (default for fullscreen applications)
```
End Rem
Const SDL_HINT_IOS_HIDE_HOME_INDICATOR:String = "SDL_IOS_HIDE_HOME_INDICATOR"

Rem
bbdoc: A hint controlling whether the HIDAPI joystick drivers should be used.
about:
Values
```
0   HIDAPI drivers are not used
1   HIDAPI drivers are used (default)
```
This hint is the default for all drivers, but can be overridden by the hints for specific drivers below.
End Rem
Const SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS:String = "SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS"

Rem
bbdoc: A hint controlling whether the HIDAPI joystick drivers should be used.
about:
Values
```
0   HIDAPI drivers are not used
1   HIDAPI drivers are used (the default)
```
This hint is the default for all drivers, but can be overridden by the hints for specific drivers below.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI:String = "SDL_JOYSTICK_HIDAPI"

Rem
bbdoc: A hint controlling whether the HIDAPI driver for XBox controllers on Windows should pull correlated data from XInput.
about:
Values
```
0   HIDAPI Xbox driver will only use HIDAPI data
1   HIDAPI Xbox driver will also pull data from XInput, providing better trigger axes, guide button
    presses, and rumble support
```
The default is 1. This hint applies to any joysticks opened after setting the hint.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_CORRELATE_XINPUT:String = "SDL_JOYSTICK_HIDAPI_CORRELATE_XINPUT"

Rem
bbdoc: A hint that controls whether Steam Controllers should be exposed using the SDL joystick and game controller APIs
about:
Values
```
0   Do not scan for Steam Controllers
1   Scan for Steam Controllers (default)
```
The default value is 1. This hint must be set before initializing the joystick subsystem.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE:String = "SDL_JOYSTICK_HIDAPI_GAMECUBE"

Rem
bbdoc: A hint controlling whether Switch Joy-Cons should be treated the same as Switch Pro Controllers when using the HIDAPI driver.
about:
Values
```
0   basic Joy-Con support with no analog input (default)
1   Joy-Cons treated as half full Pro Controllers with analog inputs and sensors
```
This does not combine Joy-Cons into a single controller. That's up to the user.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_JOY_CONS:String = "SDL_JOYSTICK_HIDAPI_JOY_CONS"

Rem
bbdoc: A hint controlling whether the HIDAPI driver for PS4 controllers should be used.
about: 
Values
```
0   HIDAPI driver is not used
1   HIDAPI driver is used
```
The default is the value of SDL_HINT_JOYSTICK_HIDAPI
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_PS4:String = "SDL_JOYSTICK_HIDAPI_PS4"

Rem
bbdoc: A hint controlling whether extended input reports should be used for PS4 controllers when using the HIDAPI driver.
about: 
Values
```
0   extended reports are not enabled (default)
1   extended reports
```
Extended input reports allow rumble on Bluetooth PS4 controllers, but break DirectInput handling for applications that don't use SDL.

Once extended reports are enabled, they can not be disabled without power cycling the controller.

For compatibility with applications written for versions of SDL prior to the introduction of PS5 controller support, this
value will also control the state of extended reports on PS5 controllers when the #SDL_HINT_JOYSTICK_HIDAPI_PS5_RUMBLE hint is not explicitly set.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_PS4_RUMBLE:String = "SDL_JOYSTICK_HIDAPI_PS4_RUMBLE"

Rem
bbdoc: A hint controlling whether the HIDAPI driver for PS5 controllers should be used.
about:
Values
```
0   HIDAPI driver is not used
1   HIDAPI driver is used
```
The default is the value of #SDL_HINT_JOYSTICK_HIDAPI.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_PS5:String = "SDL_JOYSTICK_HIDAPI_PS5"

Rem
bbdoc: A hint controlling whether the player LEDs should be lit to indicate which player is associated with a PS5 controller.
about:
Values
```
0   player LEDs are not enabled
1   player LEDs are enabled (default)
```
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_PS5_PLAYER_LED:String = "SDL_JOYSTICK_HIDAPI_PS5_PLAYER_LED"

Rem
bbdoc: A hint controlling whether extended input reports should be used for PS5 controllers when using the HIDAPI driver.
about: 
Values
```
0   extended reports are not enabled (default)
1   extended reports
```
Extended input reports allow rumble on Bluetooth PS5 controllers, but break DirectInput handling for applications that don't use SDL.

Once extended reports are enabled, they can not be disabled without power cycling the controller.

For compatibility with applications written for versions of SDL prior to the introduction of PS5 controller support, this value
defaults to the value of #SDL_HINT_JOYSTICK_HIDAPI_PS4_RUMBLE.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_PS5_RUMBLE:String = "SDL_JOYSTICK_HIDAPI_PS5_RUMBLE"

Rem
bbdoc: A hint controlling whether the HIDAPI driver for Google Stadia controllers should be used.
about:
Values
```
0   HIDAPI driver is not used
1   HIDAPI driver is used
```
The default is the value of #SDL_HINT_JOYSTICK_HIDAPI.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_STADIA:String = "SDL_JOYSTICK_HIDAPI_STADIA"

Rem
bbdoc: A hint controlling whether the HIDAPI driver for Steam Controllers should be used.
about:
Values
```
0   HIDAPI driver is not used
1   HIDAPI driver is used
```
The default is the value of #SDL_HINT_JOYSTICK_HIDAPI.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_STEAM:String = "SDL_JOYSTICK_HIDAPI_STEAM"

Rem
bbdoc: A hint controlling whether the HIDAPI driver for Nintendo Switch controllers should be used.
about:
Values
```
0   HIDAPI driver is not used
1   HIDAPI driver is used
```
The default is the value of #SDL_HINT_JOYSTICK_HIDAPI.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_SWITCH:String = "SDL_JOYSTICK_HIDAPI_SWITCH"

Rem
bbdoc: A hint controlling whether the Home button LED should be turned on when a Nintendo Switch controller is opened
about:
Values
```
0   home button LED is left off
1   home button LED is turned on (default)
```
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_SWITCH_HOME_LED:String = "SDL_JOYSTICK_HIDAPI_SWITCH_HOME_LED"

Rem
bbdoc: A hint controlling whether the HIDAPI driver for XBox controllers should be used.
about:
Values
```
0   HIDAPI driver is not used
1   HIDAPI driver is used
```
The default is 0 on Windows, otherwise the value of #SDL_HINT_JOYSTICK_HIDAPI.
End Rem
Const SDL_HINT_JOYSTICK_HIDAPI_XBOX:String = "SDL_JOYSTICK_HIDAPI_XBOX"

Rem
bbdoc: A hint controlling whether the RAWINPUT joystick drivers should be used for better handling XInput-capable devices.
about:
Values
```
0   RAWINPUT drivers are not used
1   RAWINPUT drivers are used (default)
```
End Rem
Const SDL_HINT_JOYSTICK_RAWINPUT:String = "SDL_JOYSTICK_RAWINPUT"

Rem
bbdoc: A hint controlling whether a separate thread should be used for handling joystick detection and raw input messages on Windows
about:
Values
```
0   A separate thread is not used (default)
1   A separate thread is used for handling raw input messages
```
End Rem
Const SDL_HINT_JOYSTICK_THREAD:String = "SDL_JOYSTICK_THREAD"

Rem
bbdoc: A hint to determine whether SDL enforces that DRM master is required in order to initialize the KMSDRM video backend.
about: The DRM subsystem has a concept of a "DRM master" which is a DRM client that has the ability to set planes, set cursor,
etc. When SDL is DRM master, it can draw to the screen using the SDL rendering APIs. Without DRM master, SDL is still able to
process input and query attributes of attached displays, but it cannot change display state or draw to the screen directly.

In some cases, it can be useful to have the KMSDRM backend even if it cannot be used for rendering. An app may want to use SDL
for input processing while using another rendering API (such as an MMAL overlay on Raspberry Pi) or using its own code to
	render to DRM overlays that SDL doesn't support.

This hint must be set before initializing the video subsystem.

This variable can be set to the following values:
```
0    SDL will allow usage of the KMSDRM backend without DRM master
1    SDL Will require DRM master to use the KMSDRM backend (default)
```
End Rem
Const SDL_HINT_KMSDRM_REQUIRE_DRM_MASTER:String = "SDL_KMSDRM_REQUIRE_DRM_MASTER"

Rem
bbdoc: A hint controlling whether joysticks on Linux adhere to their HID-defined deadzones or return unfiltered values.
about:
Values
```
0   Return unfiltered joystick axis values (default)
1   Return axis values with deadzones taken into account
```
End Rem
Const SDL_HINT_LINUX_JOYSTICK_DEADZONES:String = "SDL_LINUX_JOYSTICK_DEADZONES"

Rem
bbdoc: A hint that specifies if the SDL app should not be forced to become a foreground process on Mac OS X.
about:
Values
```
0   force the SDL app to become a foreground process (default)
1   do not force the SDL app to become a foreground process
```
This hint only applies to Mac OSX.
End Rem
Const SDL_HINT_MAC_BACKGROUND_APP:String = "SDL_MAC_BACKGROUND_APP"

Rem
bbdoc: A hint that specifies whether ctrl+click should generate a right-click event on Mac.
about:
Values
```
0   disable emulating right click (default)
1   enable emulating right click
```
End Rem
Const SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK:String = "SDL_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK"

Rem
bbdoc: A hint setting the double click radius, in pixels.
End Rem
Const SDL_HINT_MOUSE_DOUBLE_CLICK_RADIUS:String = "SDL_MOUSE_DOUBLE_CLICK_RADIUS"

Rem
bbdoc: A hint setting the double click time, in milliseconds.
End Rem
Const SDL_HINT_MOUSE_DOUBLE_CLICK_TIME:String = "SDL_MOUSE_DOUBLE_CLICK_TIME"

Rem
bbdoc: A hint that specifies if mouse click events are sent when clicking to focus an SDL window.
about:
Values
```
0   no mouse click events are sent when clicking to focus (default)
1   mouse click events are sent when clicking to focus
```
End Rem
Const SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH:String = "SDL_MOUSE_FOCUS_CLICKTHROUGH"

Rem
bbdoc: A hint setting the speed scale for mouse motion, in floating point, when the mouse is not in relative mode.
End Rem
Const SDL_HINT_MOUSE_NORMAL_SPEED_SCALE:String = "SDL_MOUSE_NORMAL_SPEED_SCALE"

Rem
bbdoc: A hint that specifies whether relative mouse mode is implemented using mouse warping.
about:
Values
```
0   relative mouse mode uses the raw input (default)
1   relative mouse mode uses mouse warping
```
End Rem
Const SDL_HINT_MOUSE_RELATIVE_MODE_WARP:String = "SDL_MOUSE_RELATIVE_MODE_WARP"

Rem
bbdoc: A hint controlling whether relative mouse motion is affected by renderer scaling
about: 
Values
```
0   Relative motion is unaffected by DPI or renderer's logical size
1   Relative motion is scaled according to DPI scaling and logical size
```
By default relative mouse deltas are affected by DPI and renderer scaling.
End Rem
Const SDL_HINT_MOUSE_RELATIVE_SCALING:String = "SDL_MOUSE_RELATIVE_SCALING"

Rem
bbdoc: A hint setting the scale for mouse motion, in floating point, when the mouse is in relative mode.
End Rem
Const SDL_HINT_MOUSE_RELATIVE_SPEED_SCALE:String = "SDL_MOUSE_RELATIVE_SPEED_SCALE"

Rem
bbdoc: A hint controlling whether mouse events should generate synthetic touch events
about:
Values
```
0   Mouse events will not generate touch events (default for desktop platforms)
1   Mouse events will generate touch events (default for mobile platforms, such as Android and iOS)
```
End Rem
Const SDL_HINT_MOUSE_TOUCH_EVENTS:String = "SDL_MOUSE_TOUCH_EVENTS"

Rem
bbdoc: A hint that specifies not to catch the SIGINT or SIGTERM signals.
about:
Values
```
0   SDL will install a SIGINT and SIGTERM handler, and when it
    catches a signal, convert it into an SDL_QUIT event
1   SDL will not install a signal handler at all
```
End Rem
Const SDL_HINT_NO_SIGNAL_HANDLERS:String = "SDL_NO_SIGNAL_HANDLERS"

Rem
bbdoc: A hint controlling what driver to use for OpenGL ES contexts.
about: On some platforms, currently Windows and X11, OpenGL drivers may support creating contexts with
an OpenGL ES profile. By default SDL uses these profiles, when available, otherwise it attempts to load an
OpenGL ES library, e.g. that provided by the ANGLE project. This variable controls whether SDL follows this
default behaviour or will always load an OpenGL ES library.

Circumstances where this is useful include

Testing an app with a particular OpenGL ES implementation, e.g ANGLE, or emulator, e.g. those from ARM, Imagination or Qualcomm.
Resolving OpenGL ES function addresses at link time by linking with the OpenGL ES library instead of querying them at run time with SDL_GL_GetProcAddress( ).
Caution: for an application to work with the default behaviour across different OpenGL drivers it must query the OpenGL ES function addresses at run time using SDL_GL_GetProcAddress( ).

This variable is ignored on most platforms because OpenGL ES is native or not supported.

This variable can be set to the following values:
```
0    Use ES profile of OpenGL, if available. (Default when not set.)
1    Load OpenGL ES library using the default library names.
```
End Rem
Const SDL_HINT_OPENGL_ES_DRIVER:String = "SDL_OPENGL_ES_DRIVER"

Rem
bbdoc: A hint controlling which orientations are allowed on iOS/Android.
about:
In some circumstances it is necessary to be able to explicitly control which UI orientations are allowed.

Values
```
LandscapeLeft
LandscapeRight
Portrait
PortraitUpsideDown
```
End Rem
Const SDL_HINT_ORIENTATIONS:String = "SDL_ORIENTATIONS"

Rem
bbdoc: This hint sets an override for SDL_GetPreferredLocales( )
about: If set, this will be favored over anything the OS might report for the user's preferred locales. Changing this
hint at runtime will not generate a SDL_LOCALECHANGED event (but if you can change the hint, you can push your own event, if you want).

The format of this hint is a comma-separated list of language and locale, combined with an underscore, as is a
common format: "en_GB". Locale is optional: "en". So you might have a list like this: "en_GB,jp,es_PT"
End Rem
Const SDL_HINT_PREFERRED_LOCALES:String = "SDL_PREFERRED_LOCALES"

Rem
bbdoc: A hint describing the content orientation on QtWayland-based platforms.
about: 
On QtWayland platforms, windows are rotated client-side to allow for custom transitions. In order to correctly position overlays
(e.g. volume bar) and gestures (e.g. events view, close/minimize gestures), the system needs to know in which orientation the
application is currently drawing its contents.

This does not cause the window to be rotated or resized, the application needs to take care of drawing the content in the
right orientation (the framebuffer is always in portrait mode).

Values
```
primary (default)
portrait
landscape
inverted-portrait
inverted-landscape
```
End Rem
Const SDL_HINT_QTWAYLAND_CONTENT_ORIENTATION:String = "SDL_QTWAYLAND_CONTENT_ORIENTATION"

Rem
bbdoc: A hint to set flags on QtWayland windows to integrate with the native window manager.
about: On QtWayland platforms, this hint controls the flags to set on the windows. For example, on Sailfish OS,
OverridesSystemGestures disables swipe gestures.

This variable is a space-separated list of the following values (empty = no flags):
```
OverridesSystemGestures
StaysOnTop
BypassWindowManager
```
End Rem
Const SDL_HINT_QTWAYLAND_WINDOW_FLAGS:String = "SDL_QTWAYLAND_WINDOW_FLAGS"

Rem
bbdoc: A hint controlling whether the 2D render API is compatible or efficient.
about:
Values
```
0    Don't use batching to make rendering more efficient.
1    Use batching, but might cause problems if app makes its own direct OpenGL calls.
```
Up to SDL 2.0.9, the render API would draw immediately when requested. Now it batches up draw requests and sends
them all to the GPU only when forced to (during #SDLRenderPresent, when changing render targets, by updating a
texture that the batch needs, etc). This is significantly more efficient, but it can cause problems for apps that
expect to render on top of the render API's output. As such, SDL will disable batching if a specific render backend
is requested (since this might indicate that the app is planning to use the underlying graphics API directly). This
hint can be used to explicitly request batching in this instance. It is a contract that you will either never use
the underlying graphics API directly, or if you do, you will call SDL_RenderFlush( ) before you do so any current
batch goes to the GPU before your work begins. Not following this contract will result in undefined behavior.
End Rem
Const SDL_HINT_RENDER_BATCHING:String = "SDL_RENDER_BATCHING"

Rem
bbdoc: A hint controlling whether to enable Direct3D 11+'s Debug Layer.
about:
This hint does not have any effect on the Direct3D 9 based renderer.

Values
```
0   Disable Debug Layer use (default)
1   Enable Debug Layer use
```
End Rem
Const SDL_HINT_RENDER_DIRECT3D11_DEBUG:String = "SDL_RENDER_DIRECT3D11_DEBUG"

Rem
bbdoc: A variable controlling whether the Direct3D device is initialized for thread-safe operations.
about:
Values
```
0   Thread-safety is not enabled (faster; default)
1   Thread-safety is enabled
```
End Rem
Const SDL_HINT_RENDER_DIRECT3D_THREADSAFE:String = "SDL_RENDER_DIRECT3D_THREADSAFE"

Rem
bbdoc: A hint specifying which render driver to use.
about:
If the application doesn't pick a specific renderer to use, this variable specifies the name of the preferred renderer.
If the preferred renderer can't be initialized, the normal default renderer is used.

Values
```
direct3d
opengl
opengles2
opengles
metal
software
```
The default varies by platform, but it's the first one in the list that is available on the current platform.
End Rem
Const SDL_HINT_RENDER_DRIVER:String = "SDL_RENDER_DRIVER"

Rem
bbdoc: A hint controlling the scaling policy for SDL_RenderSetLogicalSize.
about:
Values
```
0 or letterbox    Uses letterbox/sidebars to fit the entire rendering on screen.
1 or overscan     Will zoom the rendering so it fills the entire screen, allowing edges to be drawn offscreen.
```
By default letterbox is used.
End Rem
Const SDL_HINT_RENDER_LOGICAL_SIZE_MODE:String = "SDL_RENDER_LOGICAL_SIZE_MODE"

Rem
bbdoc: A hint controlling whether the OpenGL render driver uses shaders if they are available.
about:
Values
```
0   Disable shaders
1   Enable shaders (default)
```
End Rem
Const SDL_HINT_RENDER_OPENGL_SHADERS:String = "SDL_RENDER_OPENGL_SHADERS"

Rem
bbdoc: A hint controlling the scaling quality
about: This variable can be set to the following values: 0 or nearest Nearest pixel sampling (default) 1 or linear
Linear filtering (supported by OpenGL and Direct3D) 2 or best Currently this is the same as linear
End Rem
Const SDL_HINT_RENDER_SCALE_QUALITY:String = "SDL_RENDER_SCALE_QUALITY"

Rem
bbdoc: A hint controlling whether updates to the SDL screen surface should be synchronized with the vertical refresh, to avoid tearing.
about:
Values
```
0   Disable vsync
1   Enable vsync
```
By default SDL does not sync screen surface updates with vertical refresh.
End Rem
Const SDL_HINT_RENDER_VSYNC:String = "SDL_RENDER_VSYNC"

Rem
bbdoc: A hint to control whether the return key on the soft keyboard should hide the soft keyboard on Android and iOS.
about:
Values
```
0    The return key will be handled as a key event. This is the behaviour of SDL <= 2.0.3. (default)
1    The return key will hide the keyboard.
```
The value of this hint is used at runtime, so it can be changed at any time.
End Rem
Const SDL_HINT_RETURN_KEY_HIDES_IME:String = "SDL_RETURN_KEY_HIDES_IME"

Rem
bbdoc: A hint to tell SDL which Dispmanx layer to use on a Raspberry PI.
about: Also known as Z-order. The variable can take a negative or positive value.

The default is 10000.
End Rem
Const SDL_HINT_RPI_VIDEO_LAYER:String = "SDL_RPI_VIDEO_LAYER"

Rem
bbdoc: Specifies whether #SDL_THREAD_PRIORITY_TIME_CRITICAL should be treated as realtime.
about: On some platforms, like Linux, a realtime priority thread may be subject to restrictions that require special handling by
the application. This hint exists to let SDL know that the app is prepared to handle said restrictions.

On Linux, SDL will apply the following configuration to any thread that becomes realtime:

The SCHED_RESET_ON_FORK bit will be set on the scheduling policy,

An RLIMIT_RTTIME budget will be configured to the rtkit specified limit.

Exceeding this limit will result in the kernel sending SIGKILL to the app,

Refer to the man pages for more information.

This hint can be set to the following values:
```
0   default platform specific behaviour
1   Force SDL_THREAD_PRIORITY_TIME_CRITICAL to a realtime scheduling policy
```
End Rem
Const SDL_HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL:String = "SDL_THREAD_FORCE_REALTIME_TIME_CRITICAL"

Rem
bbdoc: A hint specifying additional information to use with SDL_SetThreadPriority.
about: By default #SDLSetThreadPriority will make appropriate system changes in order to apply a thread priority.
For example on systems using pthreads the scheduler policy is changed automatically to a policy that works well with
a given priority. Code which has specific requirements can override SDL's default behavior with this hint.

pthread hint values are current, other, fifo and rr. Currently no other platform hint values are defined but may be in the future.

Note:
On Linux, the kernel may send SIGKILL to realtime tasks which exceed the distro configured execution budget for rtkit.
This budget can be queried through RLIMIT_RTTIME after calling #SDLSetThreadPriority( ).
End Rem
Const SDL_HINT_THREAD_PRIORITY_POLICY:String = "SDL_THREAD_PRIORITY_POLICY"

Rem
bbdoc: A hint specifying SDL's threads stack size in bytes or 0 for the backend's default size.
about: Use this hint in case you need to set SDL's threads stack size to other than the default.
This is specially useful if you build SDL against a non glibc libc library (such as musl) which provides a relatively
small default thread stack size (a few kilobytes versus the default 8MB glibc uses). Support for this hint is currently available
only in the pthread, Windows, and PSP backend.

Instead of this hint, in 2.0.9 and later, you can use #SDLCreateThreadWithStackSize(). This hint only works with the classic #SDLCreateThread( ).
End Rem
Const SDL_HINT_THREAD_STACK_SIZE:String = "SDL_THREAD_STACK_SIZE"

Rem
bbdoc: A hint that controls the timer resolution, in milliseconds.
about: The higher resolution the timer, the more frequently the CPU services timer interrupts, and the more precise delays are,
but this takes up power and CPU time. This hint is only used on Windows.

See this blog post for more information: http://randomascii.wordpress.com/2013/07/08/windows-timer-resolution-megawatts-wasted/

If this variable is set to 0, the system timer resolution is not set.

The default value is 1. This hint may be set at any time.
End Rem
Const SDL_HINT_TIMER_RESOLUTION:String = "SDL_TIMER_RESOLUTION"

Rem
bbdoc: A hint controlling whether touch events should generate synthetic mouse events
about:
Values
```
0   Touch events will not generate mouse events
1   Touch events will generate mouse events
```
By default SDL will generate mouse events for touch events.
End Rem
Const SDL_HINT_TOUCH_MOUSE_EVENTS:String = "SDL_TOUCH_MOUSE_EVENTS"

Rem
bbdoc: A hint controlling whether the Android / tvOS remotes should be listed as joystick devices, instead of sending keyboard events.
about:
Values
```
0   Remotes send enter/escape/arrow key events
1   Remotes are available as 2 axis, 2 button joysticks (the default).
```
End Rem
Const SDL_HINT_TV_REMOTE_AS_JOYSTICK:String = "SDL_TV_REMOTE_AS_JOYSTICK"

Rem
bbdoc: A hint controlling whether the screensaver is enabled.
about: 
Values
```
0   Disable screensaver
1   Enable screensaver
```
By default SDL will disable the screensaver.
End Rem
Const SDL_HINT_VIDEO_ALLOW_SCREENSAVER:String = "SDL_VIDEO_ALLOW_SCREENSAVER"

Rem
bbdoc: A hint to tell the video driver that we only want a double buffer.
about: By default, most lowlevel 2D APIs will use a triple buffer scheme that wastes no CPU time on waiting for vsync
after issuing a flip, but introduces a frame of latency. On the other hand, using a double buffer scheme instead is
recommended for cases where low latency is an important factor because we save a whole frame of latency. We do so by
	waiting for vsync immediately after issuing a flip, usually just after eglSwapBuffers call in the backend's *_SwapWindow function.

Since it's driver-specific, it's only supported where possible and implemented. Currently supported the following drivers:
```
KMSDRM (kmsdrm)
Raspberry Pi (raspberrypi)
```
End Rem
Const SDL_HINT_VIDEO_DOUBLE_BUFFER:String = "SDL_VIDEO_DOUBLE_BUFFER"

Rem
bbdoc: A hint controlling whether the graphics context is externally managed.
about:
Values
```
0   SDL will manage graphics contexts that are attached to windows.
1   Disable graphics context management on windows.
```
By default SDL will manage OpenGL contexts in certain situations. For example, on Android the context will
be automatically saved and restored when pausing the application. Additionally, some platforms will assume
usage of OpenGL if Vulkan isn't used. Setting this to 1 will prevent this behavior, which is desirable when the
application manages the graphics context, such as an externally managed OpenGL context or attaching a Vulkan surface to the window.
End Rem
Const SDL_HINT_VIDEO_EXTERNAL_CONTEXT:String = "SDL_VIDEO_EXTERNAL_CONTEXT"

Rem
bbdoc: If set to 1, then do not allow high-DPI windows. ("Retina" on Mac and iOS)
End Rem
Const SDL_HINT_VIDEO_HIGHDPI_DISABLED:String = "SDL_VIDEO_HIGHDPI_DISABLED"

Rem
bbdoc: A hint that dictates policy for fullscreen Spaces on Mac OS X.
about: This hint only applies to Mac OS X.

Values
```
0   Disable Spaces support (FULLSCREEN_DESKTOP won't use them and
    SDL_WINDOW_RESIZABLE windows won't offer the "fullscreen"
    button on their titlebars).
1   Enable Spaces support (FULLSCREEN_DESKTOP will use them and
    SDL_WINDOW_RESIZABLE windows will offer the "fullscreen"
    button on their titlebars).
```
The default value is 1. Spaces are disabled regardless of this hint if the OS isn't at least Mac OS X Lion (10.7).
This hint must be set before any windows are created.
End Rem
Const SDL_HINT_VIDEO_MAC_FULLSCREEN_SPACES:String = "SDL_VIDEO_MAC_FULLSCREEN_SPACES"

Rem
bbdoc: A hint that inimizes your SDL2::Window if it loses key focus when in fullscreen mode.
about: Defaults to #False.

Warning: Before SDL 2.0.14, this defaulted to true! In 2.0.14, we're seeing if "true" causes more problems than it solves in modern times.
End Rem
Const SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS:String = "SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS"

Rem
bbdoc: A hint that is the address of another SDL Window* (as a hex string formatted with %p).
about: If this hint is set before CreateWindowFrom( ) and the SDL Window* it is set to has SDL_WINDOW_OPENGL set (and running on WGL only, currently),
then two things will occur on the newly created SDL2::Window:

1. Its pixel format will be set to the same pixel format as this SDL2::Window. This is needed for example when sharing an OpenGL context across multiple windows.
2. The flag SDL_WINDOW_OPENGL will be set on the new window so it can be used for OpenGL rendering.

This hint can be set to the address (as a string %p) of the SDL_Window* that new windows created with SDL_CreateWindowFrom( ... )
should share a pixel format with.
End Rem
Const SDL_HINT_VIDEO_WINDOW_SHARE_PIXEL_FORMAT:String = "SDL_VIDEO_WINDOW_SHARE_PIXEL_FORMAT"

Rem
bbdoc: A hint specifying which shader compiler to preload when using the Chrome ANGLE binaries
about: SDL has EGL and OpenGL ES2 support on Windows via the ANGLE project. It can use two different sets of binaries, those
compiled by the user from source or those provided by the Chrome browser. In the later case, these binaries require that SDL loads
a DLL providing the shader compiler.

Values
```
d3dcompiler_46.dll    default, best for Vista or later.
d3dcompiler_43.dll    for XP support.
none                  do not load any library, useful if you compiled ANGLE from source and included the compiler in your binaries.
```
End Rem
Const SDL_HINT_VIDEO_WIN_D3DCOMPILE:String = "SDL_VIDEO_WIN_D3DCOMPILE"

Rem
bbdoc: 
End Rem
Const SDL_HINT_VIDEO_WIN_D3DCOMPILER:String = "SDL_VIDEO_WIN_D3DCOMPILER"

Rem
bbdoc: A hint controlling whether X11 should use GLX or EGL by default
about:
Values
```
0   Use GLX
1   Use EGL
```
By default SDL will use GLX when both are present.
End Rem
Const SDL_HINT_VIDEO_X11_FORCE_EGL:String = "SDL_VIDEO_X11_FORCE_EGL"

Rem
bbdoc: A hint controlling whether the X11 _NET_WM_BYPASS_COMPOSITOR hint should be used.
about:
Values
```
0   Disable _NET_WM_BYPASS_COMPOSITOR
1   Enable _NET_WM_BYPASS_COMPOSITOR
```	
By default SDL will use _NET_WM_BYPASS_COMPOSITOR.
End Rem
Const SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR:String = "SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR"

Rem
bbdoc: A hint controlling whether the X11 _NET_WM_PING protocol should be supported.
about:
Values
```
0   Disable _NET_WM_PING
1   Enable _NET_WM_PING
```
By default SDL will use _NET_WM_PING, but for applications that know they will not always be able to respond to ping
requests in a timely manner they can turn it off to avoid the window manager thinking the app is hung. The hint is checked in CreateWindow.
End Rem
Const SDL_HINT_VIDEO_X11_NET_WM_PING:String = "SDL_VIDEO_X11_NET_WM_PING"

Rem
bbdoc: A hint forcing the visual ID chosen for new X11 windows.
End Rem
Const SDL_HINT_VIDEO_X11_WINDOW_VISUALID:String = "SDL_VIDEO_X11_WINDOW_VISUALID"

Rem
bbdoc: A hint controlling whether the X11 Xinerama extension should be used.
about:
Values
```
0   Disable Xinerama
1   Enable Xinerama
```
By default SDL will use Xinerama if it is available.
End Rem
Const SDL_HINT_VIDEO_X11_XINERAMA:String = "SDL_VIDEO_X11_XINERAMA"

Rem
bbdoc: A hint controlling whether the X11 XRandR extension should be used.
about:
Values
```
0   Disable XRandR
1   Enable XRandR
```
By default SDL will not use XRandR because of window manager issues.
End Rem
Const SDL_HINT_VIDEO_X11_XRANDR:String = "SDL_VIDEO_X11_XRANDR"

Rem
bbdoc: A hint controlling whether the X11 VidMode extension should be used.
about:
Values
```
0   Disable XVidMode
1   Enable XVidMode
```
By default SDL will use XVidMode if it is available.
End Rem
Const SDL_HINT_VIDEO_X11_XVIDMODE:String = "SDL_VIDEO_X11_XVIDMODE"

Rem
bbdoc: This hint controls how the fact chunk affects the loading of a WAVE file.
about: The fact chunk stores information about the number of samples of a WAVE file. The Standards Update
from Microsoft notes that this value can be used to 'determine the length of the data in seconds'. This
is especially useful for compressed formats (for which this is a mandatory chunk) if they produce multiple
sample frames per block and truncating the block is not allowed. The fact chunk can exactly specify how many
sample frames there should be in this case.

Unfortunately, most application seem to ignore the fact chunk and so SDL ignores it by default as well.

This variable can be set to the following values:
```
truncate    Use the number of samples to truncate the wave data if the fact chunk is present and valid
strict      Like "truncate", but raise an error if the fact chunk is invalid, not present for non-PCM formats,
            or if the data chunk doesn't have that many samples
ignorezero  Like "truncate", but ignore fact chunk if the number of samples is zero
ignore      Ignore fact chunk entirely (default)
```
End Rem
Const SDL_HINT_WAVE_FACT_CHUNK:String = "SDL_WAVE_FACT_CHUNK"

Rem
bbdoc: This hint controls how the size of the RIFF chunk affects the loading of a WAVE file.
about: The size of the RIFF chunk (which includes all the sub-chunks of the WAVE file) is not always reliable.
In case the size is wrong, it's possible to just ignore it and step through the chunks until a fixed limit is reached.

Note that files that have trailing data unrelated to the WAVE file or corrupt files may slow down the loading
process without a reliable boundary. By default, SDL stops after 10000 chunks to prevent wasting time. Use the
environment variable SDL_WAVE_CHUNK_LIMIT to adjust this value.

This variable can be set to the following values:
```
force        Always use the RIFF chunk size as a boundary for the chunk search
ignorezero   Like "force", but a zero size searches up to 4 GiB (default)
ignore       Ignore the RIFF chunk size and always search up to 4 GiB
maximum      Search for chunks until the end of file (not recommended)
```
End Rem
Const SDL_HINT_WAVE_RIFF_CHUNK_SIZE:String = "SDL_WAVE_RIFF_CHUNK_SIZE"

Rem
bbdoc: This hint controls how a truncated WAVE file is handled.
about: A WAVE file is considered truncated if any of the chunks are incomplete or the data chunk size
is not a multiple of the block size. By default, SDL decodes until the first incomplete block, as most applications seem to do.

This variable can be set to the following values:
```
verystrict   Raise an error if the file is truncated
strict       Like "verystrict", but the size of the RIFF chunk is ignored
dropframe    Decode until the first incomplete sample frame
dropblock    Decode until the first incomplete block (default)
```
End Rem
Const SDL_HINT_WAVE_TRUNCATION:String = "SDL_WAVE_TRUNCATION"

Rem
bbdoc: A hint to tell SDL not to name threads on Windows with the 0x406D1388 Exception.
about: The 0x406D1388 Exception is a trick used to inform Visual Studio of a thread's name, but it tends to cause problems
with other debuggers, and the .NET runtime. Note that SDL 2.0.6 and later will still use the (safer) SetThreadDescription API,
introduced in the Windows 10 Creators Update, if available.

Values
```
0   SDL will raise the 0x406D1388 Exception to name threads.
    This is the default behavior of SDL <= 2.0.4.
1   SDL will not raise this exception, and threads will be unnamed. (default)
    This is necessary with .NET languages or debuggers that aren't Visual Studio.
```
End Rem
Const SDL_HINT_WINDOWS_DISABLE_THREAD_NAMING:String = "SDL_WINDOWS_DISABLE_THREAD_NAMING"

Rem
bbdoc: A hint controlling whether the windows message loop is processed by SDL.
about:
Values
```
0   The window message loop is not run
1   The window message loop is processed in SDL_PumpEvents( )
```
By default SDL will process the windows message loop.
End Rem
Const SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP:String = "SDL_WINDOWS_ENABLE_MESSAGELOOP"

Rem
bbdoc: A hint to force SDL to use Critical Sections for mutexes on Windows.
about: On Windows 7 and newer, Slim Reader/Writer Locks are available. They offer better performance, allocate no kernel
resources and use less memory. SDL will fall back to Critical Sections on older OS versions or if forced to by this hint.

This also affects Condition Variables. When SRW mutexes are used, SDL will use Windows Condition Variables as well.
Else, a generic SDL_cond implementation will be used that works with all mutexes.

This variable can be set to the following values:
```
0    Use SRW Locks when available. If not, fall back to Critical Sections. (default)
1    Force the use of Critical Sections in all cases.
```
End Rem
Const SDL_HINT_WINDOWS_FORCE_MUTEX_CRITICAL_SECTIONS:String = "SDL_WINDOWS_FORCE_MUTEX_CRITICAL_SECTIONS"

Rem
bbdoc: A hint to force SDL to use Kernel Semaphores on Windows.
about: Kernel Semaphores are inter-process and require a context switch on every interaction. On Windows 8 and newer,
the WaitOnAddress API is available. Using that and atomics to implement semaphores increases performance. SDL will fall
back to Kernel Objects on older OS versions or if forced to by this hint.

This variable can be set to the following values:
```
0    Use Atomics and WaitOnAddress API when available. If not, fall back to Kernel Objects. (default)
1    Force the use of Kernel Objects in all cases.
```
End Rem
Const SDL_HINT_WINDOWS_FORCE_SEMAPHORE_KERNEL:String = "SDL_WINDOWS_FORCE_SEMAPHORE_KERNEL"

Rem
bbdoc: A hint to specify custom icon resource id from RC file on Windows platform.
End Rem
Const SDL_HINT_WINDOWS_INTRESOURCE_ICON:String = "SDL_WINDOWS_INTRESOURCE_ICON"

Rem
bbdoc: A hint to specify custom icon resource id from RC file on Windows platform.
End Rem
Const SDL_HINT_WINDOWS_INTRESOURCE_ICON_SMALL:String = "SDL_WINDOWS_INTRESOURCE_ICON_SMALL"

Rem
bbdoc: A hint to tell SDL not to generate window-close events for Alt+F4 on Windows.

Values
```
0   SDL will generate a window-close event when it sees Alt+F4.
1   SDL will only do normal key handling for Alt+F4.
```
End Rem
Const SDL_HINT_WINDOWS_NO_CLOSE_ON_ALT_F4:String = "SDL_WINDOWS_NO_CLOSE_ON_ALT_F4"

Rem
bbdoc: A hint to use the D3D9Ex API introduced in Windows Vista, instead of normal D3D9.
about: Direct3D 9Ex contains changes to state management that can eliminate device loss errors during scenarios
like Alt+Tab or UAC prompts. D3D9Ex may require some changes to your application to cope with the new behavior, so this is disabled by default.

This hint must be set before initializing the video subsystem.

For more information on Direct3D 9Ex, see:

https://docs.microsoft.com/en-us/windows/win32/direct3darticles/graphics-apis-in-windows-vista#direct3d-9ex
https://docs.microsoft.com/en-us/windows/win32/direct3darticles/direct3d-9ex-improvements

This variable can be set to the following values:
```
0    Use the original Direct3D 9 API (default)
1    Use the Direct3D 9Ex API on Vista and later (and fall back if D3D9Ex is unavailable)
```
End Rem
Const SDL_HINT_WINDOWS_USE_D3D9EX:String = "SDL_WINDOWS_USE_D3D9EX"

Rem
bbdoc: A hint controlling whether the window frame and title bar are interactive when the cursor is hidden.
about:
Values
```
0   The window frame is not interactive when the cursor is hidden (no move, resize, etc)
1   The window frame is interactive when the cursor is hidden
```
By default SDL will allow interaction with the window frame when the cursor is hidden.
End Rem
Const SDL_HINT_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN:String = "SDL_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN"

Rem
bbdoc: A hint that allows back-button-press events on Windows Phone to be marked as handled.
about: Windows Phone devices typically feature a Back button. When pressed, the OS will emit back-button-press events,
which apps are expected to handle in an appropriate manner. If apps do not explicitly mark these events as 'Handled', then the OS
will invoke its default behavior for unhandled back-button-press events, which on Windows Phone 8 and 8.1 is to terminate the app (and
attempt to switch to the previous app, or to the device's home screen).

Setting the SDL_HINT_WINRT_HANDLE_BACK_BUTTON hint to "1" will cause SDL to mark back-button-press events as Handled, if and when one is sent to the app.

Internally, Windows Phone sends back button events as parameters to special back-button-press callback functions. Apps that need
to respond to back-button-press events are expected to register one or more callback functions for such, shortly after being launched
(during the app's initialization phase). After the back button is pressed, the OS will invoke these callbacks. If the app's callback(s)
do not explicitly mark the event as handled by the time they return, or if the app never registers one of these callback, the OS will
consider the event un-handled, and it will apply its default back button behavior (terminate the app).

SDL registers its own back-button-press callback with the Windows Phone OS. This callback will emit a pair of SDL key-press events
(SDL_KEYDOWN and SDL_KEYUP), each with a scancode of SDL_SCANCODE_AC_BACK, after which it will check the contents of the hint,
SDL_HINT_WINRT_HANDLE_BACK_BUTTON. If the hint's value is set to 1, the back button event's Handled property will get set to a true value.
If the hint's value is set to something else, or if it is unset, SDL will leave the event's Handled property alone. (By default, the OS sets
this property to 'false', to note.)

SDL apps can either set SDL_HINT_WINRT_HANDLE_BACK_BUTTON well before a back button is pressed, or can set it in direct-response to a
back button being pressed.

In order to get notified when a back button is pressed, SDL apps should register a callback function with SDL_AddEventWatch( ), and have
it listen for SDL_KEYDOWN events that have a scancode of SDL_SCANCODE_AC_BACK. (Alternatively, SDL_KEYUP events can be listened-for. Listening
for either event type is suitable.) Any value of SDL_HINT_WINRT_HANDLE_BACK_BUTTON set by such a callback, will be applied to the OS'
	current back-button-press event.

More details on back button behavior in Windows Phone apps can be found at the following page, on Microsoft's developer
site: http://msdn.microsoft.com/en-us/library/windowsphone/develop/jj247550(v=vs.105).aspx
End Rem
Const SDL_HINT_WINRT_HANDLE_BACK_BUTTON:String = "SDL_WINRT_HANDLE_BACK_BUTTON"

Rem
bbdoc: A hint to set the label text for a WinRT app's privacy policy link.
about: Network-enabled WinRT apps must include a privacy policy. On Windows 8, 8.1, and RT, Microsoft mandates that this policy be
available via the Windows Settings charm. SDL provides code to add a link there, with its label text being set via the optional
hint, #SDL_HINT_WINRT_PRIVACY_POLICY_LABEL.

Please note that a privacy policy's contents are not set via this hint. A separate hint, #SDL_HINT_WINRT_PRIVACY_POLICY_URL,
is used to link to the actual text of the policy.

The contents of this hint should be encoded as a UTF8 string.

The default value is "Privacy Policy". This hint should only be set during app initialization, preferably before any calls to SDL_Init( ... ).

For additional information on linking to a privacy policy, see the documentation for #SDL_HINT_WINRT_PRIVACY_POLICY_URL.

End Rem
Const SDL_HINT_WINRT_PRIVACY_POLICY_LABEL:String = "SDL_WINRT_PRIVACY_POLICY_LABEL"

Rem
bbdoc: A hint to specify a URL to a WinRT app's privacy policy.
about: All network-enabled WinRT apps must make a privacy policy available to its users. On Windows 8, 8.1, and RT, Microsoft mandates
that this policy be be available in the Windows Settings charm, as accessed from within the app. SDL provides code to add a URL-based
link there, which can point to the app's privacy policy.

To setup a URL to an app's privacy policy, set #SDL_HINT_WINRT_PRIVACY_POLICY_URL before calling any SDL_Init( ... ) functions. The
contents of the hint should be a valid URL. For example, http://www.example.com.

The default value is an empty string (), which will prevent SDL from adding a privacy policy link to the Settings charm. This hint
should only be set during app init.

The label text of an app's "Privacy Policy" link may be customized via another hint, #SDL_HINT_WINRT_PRIVACY_POLICY_LABEL.

Please note that on Windows Phone, Microsoft does not provide standard UI for displaying a privacy policy link, and as such,
#SDL_HINT_WINRT_PRIVACY_POLICY_URL will not get used on that platform. Network-enabled phone apps should display their privacy policy
through some other, in-app means.
End Rem
Const SDL_HINT_WINRT_PRIVACY_POLICY_URL:String = "SDL_WINRT_PRIVACY_POLICY_URL"

Rem
bbdoc: A hint that lets you disable the detection and use of Xinput gamepad devices
about: 
Values
```
0   Disable XInput detection (only uses direct input)
1   Enable XInput detection (default)
```
End Rem
Const SDL_HINT_XINPUT_ENABLED:String = "SDL_XINPUT_ENABLED"

Rem
bbdoc: A hint that causes SDL to use the old axis and button mapping for XInput devices.
about: This hint is for backwards compatibility only and will be removed in SDL 2.1

The default value is 0. This hint must be set before SDL_Init( ... )
End Rem
Const SDL_HINT_XINPUT_USE_OLD_JOYSTICK_MAPPING:String = "SDL_XINPUT_USE_OLD_JOYSTICK_MAPPING"

Rem
bbdoc: A hint that lets you disable the detection and use of DirectInput gamepad devices.
about:
Values
```
0    Disable DirectInput detection (only uses XInput)
1    Enable DirectInput detection (the default)
```
End Rem
Const SDL_HINT_DIRECTINPUT_ENABLED:String = "SDL_DIRECTINPUT_ENABLED"

Rem
bbdoc: A hint that causes SDL to not ignore audio "monitors"
about: This is currently only used for PulseAudio and ignored elsewhere.
By default, SDL ignores audio devices that aren't associated with physical
hardware. Changing this hint to "1" will expose anything SDL sees that
appears to be an audio source or sink. This will add "devices" to the list
that the user probably doesn't want or need, but it can be useful in
scenarios where you want to hook up SDL to some sort of virtual device,
etc.

The default value is "0".  This hint must be set before SDL_Init().

This hint is available since SDL 2.0.16. Before then, virtual devices are
always ignored.

End Rem
Const SDL_HINT_AUDIO_INCLUDE_MONITORS:String = "SDL_AUDIO_INCLUDE_MONITORS"

Rem
bbdoc: A hint that forces X11 windows to create as a custom type.
about: This is currently only used for X11 and ignored elsewhere.

During SDL_CreateWindow, SDL uses the _NET_WM_WINDOW_TYPE X11 property
to report to the window manager the type of window it wants to create.
This might be set to various things if SDL_WINDOW_TOOLTIP or
SDL_WINDOW_POPUP_MENU, etc, were specified. For "normal" windows that
haven't set a specific type, this hint can be used to specify a custom
type. For example, a dock window might set this to
"_NET_WM_WINDOW_TYPE_DOCK".

If not set or set to "", this hint is ignored. This hint must be set
before the SDL_CreateWindow() call that it is intended to affect.

This hint is available since SDL 2.0.22.
End Rem
Const SDL_HINT_X11_WINDOW_TYPE:String = "SDL_X11_WINDOW_TYPE"

Rem
bbdoc: A hint that decides whether to send SDL_QUIT when closing the final window.
about: By default, SDL sends an SDL_QUIT event when there is only one window
and it receives an SDL_WINDOWEVENT_CLOSE event, under the assumption most
apps would also take the loss of this window as a signal to terminate the
program.

However, it's not unreasonable in some cases to have the program continue
to live on, perhaps to create new windows later.

Changing this hint to "0" will cause SDL to not send an SDL_QUIT event
when the final window is requesting to close. Note that in this case,
there are still other legitimate reasons one might get an SDL_QUIT
event: choosing "Quit" from the macOS menu bar, sending a SIGINT (ctrl-c)
on Unix, etc.

The default value is "1".  This hint can be changed at any time.

This hint is available since SDL 2.0.22. Before then, you always get
an SDL_QUIT event when closing the final window.
End Rem
Const SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE:String = "SDL_QUIT_ON_LAST_WINDOW_CLOSE"

Rem
bbdoc: A hint that decides what video backend to use.
about: By default, SDL will try all available video backends in a reasonable
order until it finds one that can work, but this hint allows the app
or user to force a specific target, such as "x11" if, say, you are
on Wayland but want to try talking to the X server instead.

This functionality has existed since SDL 2.0.0 (indeed, before that)
but before 2.0.22 this was an environment variable only. In 2.0.22,
it was upgraded to a full SDL hint, so you can set the environment
variable as usual or programatically set the hint with SDL_SetHint,
which won't propagate to child processes.

The default value is unset, in which case SDL will try to figure out
the best video backend on your behalf. This hint needs to be set
before SDL_Init() is called to be useful.

This hint is available since SDL 2.0.22. Before then, you could set
the environment variable to get the same effect.
End Rem
Const SDL_HINT_VIDEODRIVER:String = "SDL_VIDEODRIVER"

Rem
bbdoc:  A hint that decides what audio backend to use.
about: By default, SDL will try all available audio backends in a reasonable
order until it finds one that can work, but this hint allows the app
or user to force a specific target, such as "alsa" if, say, you are
on PulseAudio but want to try talking to the lower level instead.

This functionality has existed since SDL 2.0.0 (indeed, before that)
but before 2.0.22 this was an environment variable only. In 2.0.22,
it was upgraded to a full SDL hint, so you can set the environment
variable as usual or programatically set the hint with SDL_SetHint,
which won't propagate to child processes.

The default value is unset, in which case SDL will try to figure out
the best audio backend on your behalf. This hint needs to be set
before SDL_Init() is called to be useful.

This hint is available since SDL 2.0.22. Before then, you could set
the environment variable to get the same effect.
End Rem
Const SDL_HINT_AUDIODRIVER:String = "SDL_AUDIODRIVER"

Rem
bbdoc: A hint that decides what KMSDRM device to use.
about: Internally, SDL might open something like "/dev/dri/cardNN" to
access KMSDRM functionality, where "NN" is a device index number.

SDL makes a guess at the best index to use (usually zero), but the
app or user can set this hint to a number between 0 and 99 to
force selection.

This hint is available since SDL 2.24.0.
End Rem
Const SDL_HINT_KMSDRM_DEVICE_INDEX:String = "SDL_KMSDRM_DEVICE_INDEX"

Rem
bbdoc: A hint that treats trackpads as touch devices.
about: On macOS (and possibly other platforms in the future), SDL will report
touches on a trackpad as mouse input, which is generally what users
expect from this device; however, these are often actually full
multitouch-capable touch devices, so it might be preferable to some apps
to treat them as such.

Setting this hint to true will make the trackpad input report as a
multitouch device instead of a mouse. The default is false.

Note that most platforms don't support this hint. As of 2.24.0, it
only supports MacBooks' trackpads on macOS. Others may follow later.

This hint is checked during SDL_Init and can not be changed after.

This hint is available since SDL 2.24.0.
End Rem
Const SDL_HINT_TRACKPAD_IS_TOUCH_ONLY:String = "SDL_TRACKPAD_IS_TOUCH_ONLY"
