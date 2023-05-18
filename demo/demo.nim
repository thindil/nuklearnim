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

import std/[bitops, os, times]
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

  var ctx = nuklearInit(windowWidth, windowHeight, windowName)

  var
    op: difficulty = easy
    property: cint = 20

  while true:
    let started = cpuTime()
    # Input
    if nuklearInput(ctx):
      break

    # GUI
    if createWin(ctx, "Demo", 50.0, 50.0, 200.0, 200.0, bitor(
        nkWindowBorder, nkWindowMoveable, nkWindowScalable, nkWindowCloseable,
        nkWindowMinimizable, nkWindowTitle)):
      nk_layout_row_static(ctx, 30.0, 80, 1)
      if nk_button_label(ctx, "button") == nk_true:
        echo "button pressed"
      nk_layout_row_dynamic(ctx, 30.0, 2)
      if nk_option_label(ctx, "easy", (if op == easy: 1 else: 0)) == nk_true:
        op = easy
      if nk_option_label(ctx, "hard", (if op == hard: 1 else: 0)) == nk_true:
        op = hard
      nk_layout_row_dynamic(ctx, 25.0, 1)
      nk_property_int(ctx, "Compression:", 0, property, 100, 10, 1.0)
    nk_end(ctx)
    if nk_window_is_hidden(ctx, "Demo") > 0:
      break
    overview(ctx)
    setStyle(ctx, themeDark)

    # Draw
    nuklearDraw()

    # Timing
    let dt = cpuTime() - started
    if (dt < dtime):
      sleep((dtime - dt).int)

  nuklearClose()

main()
