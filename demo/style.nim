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

# Nuklear style demo translated to Nim (for Xlib binding)

when defined(xlib):
  import nuklear_xlib
else:
  import nuklear_sdl_renderer

type
  Theme* = enum
    themeBlack, themeWhite, themeRed, themeBlue, themeDark

proc setStyle*(ctx: PContext, theme: Theme) =
  var table: array[NK_COLOR_COUNT, NimColor]
  case theme
  of themeWhite:
    table[NK_COLOR_TEXT] = NimColor(r: 70, g: 70, b: 70, a: 255)
    table[NK_COLOR_WINDOW] = NimColor(r: 175, g: 175, b: 175, a: 255)
    table[NK_COLOR_HEADER] = NimColor(r: 175, g: 175, b: 175, a: 255)
    table[NK_COLOR_BORDER] = NimColor(r: 0, g: 0, b: 0, a: 255)
    table[NK_COLOR_BUTTON] = NimColor(r: 185, g: 185, b: 185, a: 255)
    table[NK_COLOR_BUTTON_HOVER] = NimColor(r: 170, g: 170, b: 170, a: 255)
    table[NK_COLOR_BUTTON_ACTIVE] = NimColor(r: 160, g: 160, b: 160, a: 255)
    table[NK_COLOR_TOGGLE] = NimColor(r: 150, g: 150, b: 150, a: 255)
    table[NK_COLOR_TOGGLE_HOVER] = NimColor(r: 120, g: 120, b: 120, a: 255)
    table[NK_COLOR_TOGGLE_CURSOR] = NimColor(r: 175, g: 175, b: 175, a: 255)
    table[NK_COLOR_SELECT] = NimColor(r: 190, g: 190, b: 190, a: 255)
    table[NK_COLOR_SELECT_ACTIVE] = NimColor(r: 175, g: 175, b: 175, a: 255)
    table[NK_COLOR_SLIDER] = NimColor(r: 190, g: 190, b: 190, a: 255)
    table[NK_COLOR_SLIDER_CURSOR] = NimColor(r: 80, g: 80, b: 80, a: 255)
    table[NK_COLOR_SLIDER_CURSOR_HOVER] = NimColor(r: 70, g: 70, b: 70, a: 255)
    table[NK_COLOR_SLIDER_CURSOR_ACTIVE] = NimColor(r: 60, g: 60, b: 60, a: 255)
    table[NK_COLOR_PROPERTY] = NimColor(r: 175, g: 175, b: 175, a: 255)
    table[NK_COLOR_EDIT] = NimColor(r: 150, g: 150, b: 150, a: 255)
    table[NK_COLOR_EDIT_CURSOR] = NimColor(r: 0, g: 0, b: 0, a: 255)
    table[NK_COLOR_COMBO] = NimColor(r: 175, g: 175, b: 175, a: 255)
    table[NK_COLOR_CHART] = NimColor(r: 160, g: 160, b: 160, a: 255)
    table[NK_COLOR_CHART_COLOR] = NimColor(r: 45, g: 45, b: 45, a: 255)
    table[NK_COLOR_CHART_COLOR_HIGHLIGHT] = NimColor(r: 255, g: 0, b: 0, a: 255)
    table[NK_COLOR_SCROLLBAR] = NimColor(r: 180, g: 180, b: 180, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR] = NimColor(r: 140, g: 140, b: 140, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR_HOVER] = NimColor(r: 150, g: 150, b: 150, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] = NimColor(r: 160, g: 160, b: 160, a: 255)
    table[NK_COLOR_TAB_HEADER] = NimColor(r: 180, g: 180, b: 180, a: 255)
    styleFromTable(ctx, table)
  of themeRed:
    table[NK_COLOR_TEXT] = NimColor(r: 190, g: 190, b: 190, a: 255)
    table[NK_COLOR_WINDOW] = NimColor(r: 30, g: 33, b: 40, a: 215)
    table[NK_COLOR_HEADER] = NimColor(r: 181, g: 45, b: 69, a: 220)
    table[NK_COLOR_BORDER] = NimColor(r: 51, g: 55, b: 67, a: 255)
    table[NK_COLOR_BUTTON] = NimColor(r: 181, g: 45, b: 69, a: 255)
    table[NK_COLOR_BUTTON_HOVER] = NimColor(r: 190, g: 50, b: 70, a: 255)
    table[NK_COLOR_BUTTON_ACTIVE] = NimColor(r: 195, g: 55, b: 75, a: 255)
    table[NK_COLOR_TOGGLE] = NimColor(r: 51, g: 55, b: 67, a: 255)
    table[NK_COLOR_TOGGLE_HOVER] = NimColor(r: 45, g: 60, b: 60, a: 255)
    table[NK_COLOR_TOGGLE_CURSOR] = NimColor(r: 181, g: 45, b: 69, a: 255)
    table[NK_COLOR_SELECT] = NimColor(r: 51, g: 55, b: 67, a: 255)
    table[NK_COLOR_SELECT_ACTIVE] = NimColor(r: 181, g: 45, b: 69, a: 255)
    table[NK_COLOR_SLIDER] = NimColor(r: 51, g: 55, b: 67, a: 255)
    table[NK_COLOR_SLIDER_CURSOR] = NimColor(r: 181, g: 45, b: 69, a: 255)
    table[NK_COLOR_SLIDER_CURSOR_HOVER] = NimColor(r: 186, g: 50, b: 74, a: 255)
    table[NK_COLOR_SLIDER_CURSOR_ACTIVE] = NimColor(r: 191, g: 55, b: 79, a: 255)
    table[NK_COLOR_PROPERTY] = NimColor(r: 51, g: 55, b: 67, a: 255)
    table[NK_COLOR_EDIT] = NimColor(r: 51, g: 55, b: 67, a: 225)
    table[NK_COLOR_EDIT_CURSOR] = NimColor(r: 190, g: 190, b: 190, a: 255)
    table[NK_COLOR_COMBO] = NimColor(r: 51, g: 55, b: 67, a: 255)
    table[NK_COLOR_CHART] = NimColor(r: 51, g: 55, b: 67, a: 255)
    table[NK_COLOR_CHART_COLOR] = NimColor(r: 170, g: 40, b: 60, a: 255)
    table[NK_COLOR_CHART_COLOR_HIGHLIGHT] = NimColor(r: 255, g: 0, b: 0, a: 255)
    table[NK_COLOR_SCROLLBAR] = NimColor(r: 30, g: 33, b: 40, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR] = NimColor(r: 64, g: 84, b: 95, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR_HOVER] = NimColor(r: 70, g: 90, b: 100, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] = NimColor(r: 75, g: 95, b: 105, a: 255)
    table[NK_COLOR_TAB_HEADER] = NimColor(r: 181, g: 45, b: 69, a: 220)
    styleFromTable(ctx, table)
  of themeBlue:
    table[NK_COLOR_TEXT] = NimColor(r: 20, g: 20, b: 20, a: 255)
    table[NK_COLOR_WINDOW] = NimColor(r: 202, g: 212, b: 214, a: 215)
    table[NK_COLOR_HEADER] = NimColor(r: 137, g: 182, b: 224, a: 220)
    table[NK_COLOR_BORDER] = NimColor(r: 140, g: 159, b: 173, a: 255)
    table[NK_COLOR_BUTTON] = NimColor(r: 137, g: 182, b: 224, a: 255)
    table[NK_COLOR_BUTTON_HOVER] = NimColor(r: 142, g: 187, b: 229, a: 255)
    table[NK_COLOR_BUTTON_ACTIVE] = NimColor(r: 147, g: 192, b: 234, a: 255)
    table[NK_COLOR_TOGGLE] = NimColor(r: 177, g: 210, b: 210, a: 255)
    table[NK_COLOR_TOGGLE_HOVER] = NimColor(r: 182, g: 215, b: 215, a: 255)
    table[NK_COLOR_TOGGLE_CURSOR] = NimColor(r: 137, g: 182, b: 224, a: 255)
    table[NK_COLOR_SELECT] = NimColor(r: 177, g: 210, b: 210, a: 255)
    table[NK_COLOR_SELECT_ACTIVE] = NimColor(r: 137, g: 182, b: 224, a: 255)
    table[NK_COLOR_SLIDER] = NimColor(r: 177, g: 210, b: 210, a: 255)
    table[NK_COLOR_SLIDER_CURSOR] = NimColor(r: 137, g: 182, b: 224, a: 245)
    table[NK_COLOR_SLIDER_CURSOR_HOVER] = NimColor(r: 142, g: 188, b: 229, a: 255)
    table[NK_COLOR_SLIDER_CURSOR_ACTIVE] = NimColor(r: 147, g: 193, b: 234, a: 255)
    table[NK_COLOR_PROPERTY] = NimColor(r: 210, g: 210, b: 210, a: 255)
    table[NK_COLOR_EDIT] = NimColor(r: 210, g: 210, b: 210, a: 225)
    table[NK_COLOR_EDIT_CURSOR] = NimColor(r: 20, g: 20, b: 20, a: 255)
    table[NK_COLOR_COMBO] = NimColor(r: 210, g: 210, b: 210, a: 255)
    table[NK_COLOR_CHART] = NimColor(r: 210, g: 210, b: 210, a: 255)
    table[NK_COLOR_CHART_COLOR] = NimColor(r: 137, g: 182, b: 224, a: 255)
    table[NK_COLOR_CHART_COLOR_HIGHLIGHT] = NimColor(r: 255, g: 0, b: 0, a: 255)
    table[NK_COLOR_SCROLLBAR] = NimColor(r: 190, g: 200, b: 200, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR] = NimColor(r: 64, g: 84, b: 95, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR_HOVER] = NimColor(r: 70, g: 90, b: 100, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] = NimColor(r: 75, g: 95, b: 105, a: 255)
    table[NK_COLOR_TAB_HEADER] = NimColor(r: 156, g: 193, b: 220, a: 255)
    styleFromTable(ctx, table)
  of themeDark:
    table[NK_COLOR_TEXT] = NimColor(r: 210, g: 210, b: 210, a: 255)
    table[NK_COLOR_WINDOW] = NimColor(r: 57, g: 67, b: 71, a: 215)
    table[NK_COLOR_HEADER] = NimColor(r: 51, g: 51, b: 56, a: 220)
    table[NK_COLOR_BORDER] = NimColor(r: 46, g: 46, b: 46, a: 255)
    table[NK_COLOR_BUTTON] = NimColor(r: 48, g: 83, b: 111, a: 255)
    table[NK_COLOR_BUTTON_HOVER] = NimColor(r: 58, g: 93, b: 121, a: 255)
    table[NK_COLOR_BUTTON_ACTIVE] = NimColor(r: 63, g: 98, b: 126, a: 255)
    table[NK_COLOR_TOGGLE] = NimColor(r: 50, g: 58, b: 61, a: 255)
    table[NK_COLOR_TOGGLE_HOVER] = NimColor(r: 45, g: 53, b: 56, a: 255)
    table[NK_COLOR_TOGGLE_CURSOR] = NimColor(r: 48, g: 83, b: 111, a: 255)
    table[NK_COLOR_SELECT] = NimColor(r: 57, g: 67, b: 61, a: 255)
    table[NK_COLOR_SELECT_ACTIVE] = NimColor(r: 48, g: 83, b: 111, a: 255)
    table[NK_COLOR_SLIDER] = NimColor(r: 50, g: 58, b: 61, a: 255)
    table[NK_COLOR_SLIDER_CURSOR] = NimColor(r: 48, g: 83, b: 111, a: 245)
    table[NK_COLOR_SLIDER_CURSOR_HOVER] = NimColor(r: 53, g: 88, b: 116, a: 255)
    table[NK_COLOR_SLIDER_CURSOR_ACTIVE] = NimColor(r: 58, g: 93, b: 121, a: 255)
    table[NK_COLOR_PROPERTY] = NimColor(r: 50, g: 58, b: 61, a: 255)
    table[NK_COLOR_EDIT] = NimColor(r: 50, g: 58, b: 61, a: 225)
    table[NK_COLOR_EDIT_CURSOR] = NimColor(r: 210, g: 210, b: 210, a: 255)
    table[NK_COLOR_COMBO] = NimColor(r: 50, g: 58, b: 61, a: 255)
    table[NK_COLOR_CHART] = NimColor(r: 50, g: 58, b: 61, a: 255)
    table[NK_COLOR_CHART_COLOR] = NimColor(r: 48, g: 83, b: 111, a: 255)
    table[NK_COLOR_CHART_COLOR_HIGHLIGHT] = NimColor(r: 255, g: 0, b: 0, a: 255)
    table[NK_COLOR_SCROLLBAR] = NimColor(r: 50, g: 58, b: 61, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR] = NimColor(r: 48, g: 83, b: 111, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR_HOVER] = NimColor(r: 53, g: 88, b: 116, a: 255)
    table[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] = NimColor(r: 58, g: 93, b: 121, a: 255)
    table[NK_COLOR_TAB_HEADER] = NimColor(r: 48, g: 83, b: 111, a: 255)
    styleFromTable(ctx, table)
  of themeBlack:
    nk_style_default(ctx)
