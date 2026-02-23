# Copyright © 2023-2026 Bartek Jasicki
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the
# names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY COPYRIGHT HOLDERS AND CONTRIBUTORS ''AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Nuklear Xlib demo translated to Nim

import std/[os, times]
when defined(xlib):
  import nuklear_xlib
  const windowName = "X11"
else:
  import nuklear_sdl_renderer
  const windowName = "SDL2 Renderer"
import contracts
import overview, style

const
  dtime: float = 20.0
  windowWidth: cint = 1200
  windowHeight: cint = 800

type
  difficulty = enum
    easy, hard

proc main() {.raises: [Exception], tags: [TimeEffect, RootEffect],
    contractual.} =
  ## The main procedure of the demo. Starts the demo

  nuklearInit(windowWidth = windowWidth, windowHeight = windowHeight,
      name = windowName)
  when defined(sdl2):
    nuklearSetDefaultFont()

  var
    op: difficulty = easy
    property: int = 20

  while true:
    let started: float = cpuTime()
    # Input
    when defined(xlib):
      if nuklearInput():
        break
    else:
      case nuklearInput()
      of quitEvent:
        break
      else:
        discard

    # GUI
    window(name = "Demo", x = 50, y = 50, w = 200, h = 200, flags = {
        windowBorder, windowMovable, windowScalable, windowClosable,
        windowMinimizable, windowTitle}):
      setLayoutRowStatic(height = 30.0, width = 80, cols = 1)
      labelButton(title = "button"):
        echo "button pressed"
      setLayoutRowDynamic(height = 30.0, cols = 2)
      if option(label = "easy", selected = op == easy):
        op = easy
      if option(label = "hard", selected = op == hard):
        op = hard
      setLayoutRowDynamic(height = 25.0, cols = 1)
      property(name = "Compression:", min = 0, val = property, max = 100,
          step = 10, incPerPixel = 1.0)
    if windowIsHidden(name = "Demo"):
      break
    overview()
    setStyle(theme = themeDark)

    # Draw
    nuklearDraw()

    # Timing
    let dt: float = cpuTime() - started
    if (dt < dtime):
      sleep(milsecs = (dtime - dt).int)

  nuklearClose()

main()
