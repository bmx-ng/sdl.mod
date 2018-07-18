# A libSDL backend for BlitzMax

SDL.mod leverages [libSDL](https://www.libsdl.org/) as a replacement for some of the core BlitzMax modules that drive the events and graphics subsystems.

The SDL modules allow for improved graphics window management, more consistent cross-platform events, and extra functionality such as touch and haptic support, as well as acting as a base for taking BlitzMax to new platforms such as Android and iOS.



## How Does it Work?

SDL.mod 

## Installation

Clone or download the repository source, and extract into your BlitzMax/mod folder. The main folder will be called ```sdl.mod``` and will contain each of the SDL modules.

You can then optionally build the modules, or have them automatically compiled when your application builds (bmk understands whenever dependent modules require compilation, and will add them to the build).

## Requirements

Depending on which platform you are targeting, you may be required to install extra libraries as part of the compilation process. 

### Linux

As well as the usual packages required to build BlitzMax, the following developer packages are required for building the libSDL sources with SDL.mod :

```libasound2-dev libpulse-dev libaudio-dev libx11-dev libxext-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev libxxf86vm-dev libxss-dev libgl1-mesa-dev libesd0-dev libdbus-1-dev libudev-dev```

Although these are required for compilation, the runtime requirements for specific audio libraries are optional.

### Windows

Doesn't require anything extra to build or run.

### macOS

Doesn't require anything extra to build or run.