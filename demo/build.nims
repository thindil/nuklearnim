#!/usr/bin/env -S nim --hints:off

if paramCount() < 3:
  quit "Required parameter: xlib or sdl2"

case paramStr(3)
of "xlib":
  exec "nim c --define:xlib demo.nim"
of "sdl2":
  exec "nim c --define:sdl2 demo.nim"
else:
  quit "Unknown backend, supported options: xlib or sdl2"
