# Copyright © 2023 Bartek Jasicki
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

# Nuklear Xlib demo translated to Nim

import std/[os, times]
when defined(xlib):
  import nuklear_xlib
  const windowName = "X11"
else:
  import nuklear_sdl_renderer
  const windowName = "SDL2 Renderer"
import overview, style

const
  dtime: float = 20.0
  windowWidth: cint = 1200
  windowHeight: cint = 800

type
  difficulty = enum
    easy, hard

proc main() =

  let ctx = nuklearInit(windowWidth, windowHeight, windowName)

  var
    op: difficulty = easy
    property: int = 20

  while true:
    let started = cpuTime()
    # Input
    if nuklearInput():
      break

    # GUI
    window(name = "Demo", x = 50, y = 50, w = 200, h = 200, {windowBorder,
        windowMoveable, windowScalable, windowCloseable,
        windowMinimizable, windowTitle}):
      setLayoutRowStatic(30.0, 80, 1)
      labelButton("button"):
        echo "button pressed"
      setLayoutRowDynamic(30.0, 2)
      if option("easy", op == easy):
        op = easy
      if option("hard", op == hard):
        op = hard
      setLayoutRowDynamic(25.0, 1)
      propertyInt("Compression:", 0, property, 100, 10, 1.0)
    if windowIsHidden("Demo"):
      break
    overview(ctx)
    setStyle(themeDark)

    # Draw
    nuklearDraw()

    # Timing
    let dt = cpuTime() - started
    if (dt < dtime):
      sleep((dtime - dt).int)

  nuklearClose()

main()
