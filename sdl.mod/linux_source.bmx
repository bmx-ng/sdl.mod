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

?linux
Import "SDL/src/loadso/dlopen/SDL_sysloadso.c"
Import "SDL/src/audio/SDL_audiodev.c"
Import "SDL/src/audio/alsa/SDL_alsa_audio.c"
Import "SDL/src/audio/dsp/SDL_dspaudio.c"
Import "SDL/src/audio/nas/SDL_nasaudio.c"
Import "SDL/src/core/linux/SDL_dbus.c"
Import "SDL/src/core/linux/SDL_evdev.c"
Import "SDL/src/core/linux/SDL_ime.c"
Import "SDL/src/core/linux/SDL_udev.c"
Import "SDL/src/core/linux/SDL_threadprio.c"
Import "SDL/src/core/unix/SDL_poll.c"
Import "SDL/src/filesystem/unix/SDL_sysfilesystem.c"
Import "SDL/src/haptic/linux/SDL_syshaptic.c"
Import "SDL/src/joystick/linux/SDL_sysjoystick.c"
Import "SDL/src/joystick/steam/SDL_steamcontroller.c"
Import "SDL/src/locale/unix/SDL_syslocale.c"
Import "SDL/src/power/linux/SDL_syspower.c"
Import "SDL/src/render/opengl/SDL_render_gl.c"
Import "SDL/src/render/opengl/SDL_shaders_gl.c"
Import "SDL/src/render/opengles2/SDL_render_gles2.c"
Import "SDL/src/sensor/dummy/SDL_dummysensor.c"
Import "SDL/src/thread/pthread/SDL_systhread.c"
Import "SDL/src/thread/pthread/SDL_syssem.c"
Import "SDL/src/thread/pthread/SDL_sysmutex.c"
Import "SDL/src/thread/pthread/SDL_syscond.c"
Import "SDL/src/thread/pthread/SDL_systls.c"
Import "SDL/src/timer/unix/SDL_systimer.c"
Import "SDL/src/video/SDL_egl.c"
Import "SDL/src/video/x11/SDL_x11clipboard.c"
Import "SDL/src/video/x11/SDL_x11dyn.c"
Import "SDL/src/video/x11/SDL_x11events.c"
Import "SDL/src/video/x11/SDL_x11framebuffer.c"
Import "SDL/src/video/x11/SDL_x11keyboard.c"
Import "SDL/src/video/x11/SDL_x11messagebox.c"
Import "SDL/src/video/x11/SDL_x11modes.c"
Import "SDL/src/video/x11/SDL_x11mouse.c"
Import "SDL/src/video/x11/SDL_x11opengl.c"
Import "SDL/src/video/x11/SDL_x11opengles.c"
Import "SDL/src/video/x11/SDL_x11shape.c"
Import "SDL/src/video/x11/SDL_x11touch.c"
Import "SDL/src/video/x11/SDL_x11video.c"
Import "SDL/src/video/x11/SDL_x11window.c"
Import "SDL/src/video/x11/SDL_x11xinput2.c"
Import "SDL/src/video/x11/edid-parse.c"
Import "SDL/src/video/x11/imKStoUCS.c"
Import "SDL/src/audio/esd/SDL_esdaudio.c"
Import "SDL/src/audio/pulseaudio/SDL_pulseaudio.c"
?raspberrypi
Import "SDL/src/core/linux/SDL_fcitx.c"
Import "SDL/src/core/linux/SDL_evdev_kbd.c"
Import "SDL/src/render/opengles/SDL_render_gles.c"
Import "SDL/src/render/opengles2/SDL_render_gles2.c"
Import "SDL/src/render/opengles2/SDL_shaders_gles2.c"
Import "SDL/src/video/kmsdrm/SDL_kmsdrmdyn.c"
Import "SDL/src/video/kmsdrm/SDL_kmsdrmevents.c"
Import "SDL/src/video/kmsdrm/SDL_kmsdrmmouse.c"
Import "SDL/src/video/kmsdrm/SDL_kmsdrmopengles.c"
Import "SDL/src/video/kmsdrm/SDL_kmsdrmvideo.c"
Import "SDL/src/video/raspberry/SDL_rpievents.c"
Import "SDL/src/video/raspberry/SDL_rpimouse.c"
Import "SDL/src/video/raspberry/SDL_rpiopengles.c"
Import "SDL/src/video/raspberry/SDL_rpivideo.c"
?
