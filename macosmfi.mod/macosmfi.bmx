SuperStrict

Module SDL.macosmfi

?osx
ModuleInfo "CC_OPTS: -mmmx -msse -msse2 -DTARGET_API_MAC_CARBON -DTARGET_API_MAC_OSX"
ModuleInfo "CC_OPTS: -fobjc-arc"

Import "../sdl.mod/include/macos/*.h"

' this file must be compiled with ARC enabled ( -fobjc-arc )
' unfortunately, we don't support CC_OPTS on a per-file basis.
Import "../sdl.mod/SDL/src/joystick/iphoneos/SDL_mfijoystick.m"
?

