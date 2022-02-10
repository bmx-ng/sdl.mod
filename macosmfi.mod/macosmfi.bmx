SuperStrict

Module SDL.macosmfi

?macos
ModuleInfo "CC_OPTS: -mmmx -msse -msse2 -DTARGET_API_MAC_CARBON -DTARGET_API_MAC_OSX"
ModuleInfo "CC_OPTS: -fobjc-arc"
ModuleInfo "CC_OPTS: -DSDL_dynapi_h_ -DSDL_DYNAMIC_API=0"

Import "../sdl.mod/include/macos/*.h"
Import "../sdl.mod/SDL/include/*.h"

' this file must be compiled with ARC enabled ( -fobjc-arc )
' unfortunately, we don't support CC_OPTS on a per-file basis.
Import "../sdl.mod/SDL/src/joystick/iphoneos/SDL_mfijoystick.m"
?

