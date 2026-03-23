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

## Nuklear style demo translated to Nim

import contracts, nimalyzer

when defined(xlib):
  import nuklear_xlib
else:
  import nuklear_sdl_renderer

type
  Theme* = enum
    ## The list of available UI themes
    themeBlack, themeWhite, themeRed, themeBlue, themeDark

proc setStyle*(theme: Theme) {.raises: [], tags: [], contractual.} =
  ## Set the style for the demo application
  ##
  ## * theme - the UI theme to set
  {.ruleOff: "varDeclared".}
  var table: array[StyleColors, NkColor]
  {.ruleOn: "varDeclared".}
  case theme
  of themeWhite:
    table[textColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[windowColor] = NkColor(r: 175, g: 175, b: 175, a: 255)
    table[headerColor] = NkColor(r: 175, g: 175, b: 175, a: 255)
    table[headerTextColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[StyleColors.borderColor] = NkColor(r: 0, g: 0, b: 0, a: 255)
    table[buttonColor] = NkColor(r: 185, g: 185, b: 185, a: 255)
    table[buttonHoverColor] = NkColor(r: 170, g: 170, b: 170, a: 255)
    table[buttonActiveColor] = NkColor(r: 160, g: 160, b: 160, a: 255)
    table[buttonTextColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[buttonHoverTextColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[buttonActiveTextColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[toggleColor] = NkColor(r: 150, g: 150, b: 150, a: 255)
    table[toggleHoverColor] = NkColor(r: 120, g: 120, b: 120, a: 255)
    table[toggleCursorColor] = NkColor(r: 175, g: 175, b: 175, a: 255)
    table[selectColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[selectActiveColor] = NkColor(r: 175, g: 175, b: 175, a: 255)
    table[selectActiveTextColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[sliderColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[sliderCursorColor] = NkColor(r: 80, g: 80, b: 80, a: 255)
    table[sliderCursorHoverColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[sliderCursorActiveColor] = NkColor(r: 60, g: 60, b: 60, a: 255)
    table[propertyColor] = NkColor(r: 175, g: 175, b: 175, a: 255)
    table[propertyTextColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[editColor] = NkColor(r: 150, g: 150, b: 150, a: 255)
    table[editTextColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[editCursorColor] = NkColor(r: 0, g: 0, b: 0, a: 255)
    table[comboColor] = NkColor(r: 175, g: 175, b: 175, a: 255)
    table[comboTextColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[chartColor] = NkColor(r: 160, g: 160, b: 160, a: 255)
    table[colorChartColor] = NkColor(r: 45, g: 45, b: 45, a: 255)
    table[colorChartHighlightColor] = NkColor(r: 255, g: 0, b: 0, a: 255)
    table[scrollbarColor] = NkColor(r: 180, g: 180, b: 180, a: 255)
    table[scrollbarCursorColor] = NkColor(r: 140, g: 140, b: 140, a: 255)
    table[scrollbarCursorHoverColor] = NkColor(r: 150, g: 150, b: 150, a: 255)
    table[scrollbarCursorActiveColor] = NkColor(r: 160, g: 160, b: 160, a: 255)
    table[tabHeaderColor] = NkColor(r: 180, g: 180, b: 180, a: 255)
    table[tooltipColor] = NkColor(r: 175, g: 175, b: 175, a: 255)
    table[tooltipBorderColor] = NkColor(r: 0, g: 0, b: 0, a: 255)
    table[groupBorderColor] = NkColor(r: 0, g: 0, b: 0, a: 255)
    table[groupTextColor] = NkColor(r: 70, g: 70, b: 70, a: 255)
    table[progressbarColor] = NkColor(r: 80, g: 80, b: 80, a: 255)
    styleFromTable(table = table)
  of themeRed:
    table[textColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[windowColor] = NkColor(r: 30, g: 33, b: 40, a: 215)
    table[headerColor] = NkColor(r: 181, g: 45, b: 69, a: 220)
    table[headerTextColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[StyleColors.borderColor] = NkColor(r: 51, g: 55, b: 67, a: 255)
    table[buttonColor] = NkColor(r: 181, g: 45, b: 69, a: 255)
    table[buttonHoverColor] = NkColor(r: 190, g: 50, b: 70, a: 255)
    table[buttonActiveColor] = NkColor(r: 195, g: 55, b: 75, a: 255)
    table[buttonTextColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[buttonHoverTextColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[buttonActiveTextColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[toggleColor] = NkColor(r: 51, g: 55, b: 67, a: 255)
    table[toggleHoverColor] = NkColor(r: 45, g: 60, b: 60, a: 255)
    table[toggleCursorColor] = NkColor(r: 181, g: 45, b: 69, a: 255)
    table[selectColor] = NkColor(r: 51, g: 55, b: 67, a: 255)
    table[selectActiveColor] = NkColor(r: 181, g: 45, b: 69, a: 255)
    table[selectActiveTextColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[sliderColor] = NkColor(r: 51, g: 55, b: 67, a: 255)
    table[sliderCursorColor] = NkColor(r: 181, g: 45, b: 69, a: 255)
    table[sliderCursorHoverColor] = NkColor(r: 186, g: 50, b: 74, a: 255)
    table[sliderCursorActiveColor] = NkColor(r: 191, g: 55, b: 79, a: 255)
    table[propertyColor] = NkColor(r: 51, g: 55, b: 67, a: 255)
    table[propertyTextColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[editColor] = NkColor(r: 51, g: 55, b: 67, a: 225)
    table[editTextColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[editCursorColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[comboColor] = NkColor(r: 51, g: 55, b: 67, a: 255)
    table[comboTextColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[chartColor] = NkColor(r: 51, g: 55, b: 67, a: 255)
    table[colorChartColor] = NkColor(r: 170, g: 40, b: 60, a: 255)
    table[colorChartHighlightColor] = NkColor(r: 255, g: 0, b: 0, a: 255)
    table[scrollbarColor] = NkColor(r: 30, g: 33, b: 40, a: 255)
    table[scrollbarCursorColor] = NkColor(r: 64, g: 84, b: 95, a: 255)
    table[scrollbarCursorHoverColor] = NkColor(r: 70, g: 90, b: 100, a: 255)
    table[scrollbarCursorActiveColor] = NkColor(r: 75, g: 95, b: 105, a: 255)
    table[tabHeaderColor] = NkColor(r: 181, g: 45, b: 69, a: 220)
    table[tooltipColor] = NkColor(r: 30, g: 33, b: 40, a: 215)
    table[tooltipBorderColor] = NkColor(r: 51, g: 55, b: 67, a: 255)
    table[groupBorderColor] = NkColor(r: 51, g: 55, b: 67, a: 255)
    table[groupTextColor] = NkColor(r: 190, g: 190, b: 190, a: 255)
    table[progressbarColor] = NkColor(r: 181, g: 45, b: 69, a: 255)
    styleFromTable(table = table)
  of themeBlue:
    table[textColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[windowColor] = NkColor(r: 202, g: 212, b: 214, a: 215)
    table[headerColor] = NkColor(r: 137, g: 182, b: 224, a: 220)
    table[headerTextColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[StyleColors.borderColor] = NkColor(r: 140, g: 159, b: 173, a: 255)
    table[buttonColor] = NkColor(r: 137, g: 182, b: 224, a: 255)
    table[buttonHoverColor] = NkColor(r: 142, g: 187, b: 229, a: 255)
    table[buttonActiveColor] = NkColor(r: 147, g: 192, b: 234, a: 255)
    table[buttonTextColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[buttonHoverTextColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[buttonActiveTextColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[toggleColor] = NkColor(r: 177, g: 210, b: 210, a: 255)
    table[toggleHoverColor] = NkColor(r: 182, g: 215, b: 215, a: 255)
    table[toggleCursorColor] = NkColor(r: 137, g: 182, b: 224, a: 255)
    table[selectColor] = NkColor(r: 177, g: 210, b: 210, a: 255)
    table[selectActiveColor] = NkColor(r: 137, g: 182, b: 224, a: 255)
    table[selectActiveTextColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[sliderColor] = NkColor(r: 177, g: 210, b: 210, a: 255)
    table[sliderCursorColor] = NkColor(r: 137, g: 182, b: 224, a: 245)
    table[sliderCursorHoverColor] = NkColor(r: 142, g: 188, b: 229, a: 255)
    table[sliderCursorActiveColor] = NkColor(r: 147, g: 193, b: 234, a: 255)
    table[propertyColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[propertyTextColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[editColor] = NkColor(r: 210, g: 210, b: 210, a: 225)
    table[editTextColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[editCursorColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[comboColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[comboTextColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[chartColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[colorChartColor] = NkColor(r: 137, g: 182, b: 224, a: 255)
    table[colorChartHighlightColor] = NkColor(r: 255, g: 0, b: 0, a: 255)
    table[scrollbarColor] = NkColor(r: 190, g: 200, b: 200, a: 255)
    table[scrollbarCursorColor] = NkColor(r: 64, g: 84, b: 95, a: 255)
    table[scrollbarCursorHoverColor] = NkColor(r: 70, g: 90, b: 100, a: 255)
    table[scrollbarCursorActiveColor] = NkColor(r: 75, g: 95, b: 105, a: 255)
    table[tabHeaderColor] = NkColor(r: 156, g: 193, b: 220, a: 255)
    table[tooltipColor] = NkColor(r: 202, g: 212, b: 214, a: 215)
    table[tooltipBorderColor] = NkColor(r: 140, g: 159, b: 173, a: 255)
    table[groupBorderColor] = NkColor(r: 140, g: 159, b: 173, a: 255)
    table[groupTextColor] = NkColor(r: 20, g: 20, b: 20, a: 255)
    table[progressbarColor] = NkColor(r: 137, g: 182, b: 224, a: 245)
    styleFromTable(table = table)
  of themeDark:
    table[textColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[windowColor] = NkColor(r: 57, g: 67, b: 71, a: 215)
    table[headerColor] = NkColor(r: 51, g: 51, b: 56, a: 220)
    table[headerTextColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[StyleColors.borderColor] = NkColor(r: 46, g: 46, b: 46, a: 255)
    table[buttonColor] = NkColor(r: 48, g: 83, b: 111, a: 255)
    table[buttonHoverColor] = NkColor(r: 58, g: 93, b: 121, a: 255)
    table[buttonActiveColor] = NkColor(r: 63, g: 98, b: 126, a: 255)
    table[buttonTextColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[buttonHoverTextColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[buttonHoverTextColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[toggleColor] = NkColor(r: 50, g: 58, b: 61, a: 255)
    table[toggleHoverColor] = NkColor(r: 45, g: 53, b: 56, a: 255)
    table[toggleCursorColor] = NkColor(r: 48, g: 83, b: 111, a: 255)
    table[selectColor] = NkColor(r: 57, g: 67, b: 61, a: 255)
    table[selectActiveColor] = NkColor(r: 48, g: 83, b: 111, a: 255)
    table[selectActiveTextColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[sliderColor] = NkColor(r: 50, g: 58, b: 61, a: 255)
    table[sliderCursorColor] = NkColor(r: 48, g: 83, b: 111, a: 245)
    table[sliderCursorHoverColor] = NkColor(r: 53, g: 88, b: 116, a: 255)
    table[sliderCursorActiveColor] = NkColor(r: 58, g: 93, b: 121, a: 255)
    table[propertyColor] = NkColor(r: 50, g: 58, b: 61, a: 255)
    table[propertyTextColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[editColor] = NkColor(r: 50, g: 58, b: 61, a: 225)
    table[editTextColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[editCursorColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[comboColor] = NkColor(r: 50, g: 58, b: 61, a: 255)
    table[comboTextColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[chartColor] = NkColor(r: 50, g: 58, b: 61, a: 255)
    table[colorChartColor] = NkColor(r: 48, g: 83, b: 111, a: 255)
    table[colorChartHighlightColor] = NkColor(r: 255, g: 0, b: 0, a: 255)
    table[scrollbarColor] = NkColor(r: 50, g: 58, b: 61, a: 255)
    table[scrollbarCursorColor] = NkColor(r: 48, g: 83, b: 111, a: 255)
    table[scrollbarCursorHoverColor] = NkColor(r: 53, g: 88, b: 116, a: 255)
    table[scrollbarCursorActiveColor] = NkColor(r: 58, g: 93, b: 121, a: 255)
    table[tabHeaderColor] = NkColor(r: 48, g: 83, b: 111, a: 255)
    table[tooltipColor] = NkColor(r: 57, g: 67, b: 71, a: 215)
    table[tooltipBorderColor] = NkColor(r: 46, g: 46, b: 46, a: 255)
    table[groupBorderColor] = NkColor(r: 46, g: 46, b: 46, a: 255)
    table[groupTextColor] = NkColor(r: 210, g: 210, b: 210, a: 255)
    table[progressbarColor] = NkColor(r: 48, g: 83, b: 111, a: 245)
    styleFromTable(table = table)
  of themeBlack:
    defaultStyle()
