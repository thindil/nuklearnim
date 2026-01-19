# Copyright © 2023-2025 Bartek Jasicki
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

## Nuklear overview demo translated to Nim

import std/[colors, math, strformat, times]
import contracts, nimalyzer
when defined(xlib):
  import nuklear_xlib
else:
  import nuklear_sdl_renderer

type
  MenuState = enum
    menuNone, menuFile, menuEdit, menuView, menuChart
  Options = enum
    A, B, C
  ColorMode = enum
    rgb, hsv
const
  values: array[13, float] = [26.0, 13.0, 30.0, 15.0, 25.0, 10.0, 20.0, 40.0,
      12.0, 8.0, 22.0, 28.0, 5.0]
  ratio: array[2, cfloat] = [120.0.cfloat, 150.0]
  weapons: array[5, string] = ["Fist", "Pistol", "Shotgun", "Plasma", "BFG"]
  chartStep: float = ((2.0 * 3.141592654) / 32.0).float
  ratioTwo: array[3, cfloat] = [0.2.cfloat, 0.6, 0.2]
  widthTwo: array[3, cfloat] = [100.0.cfloat, 200.0, 50.0]
  names: array[3, string] = ["Lines", "Columns", "Mixed"]
{.push ruleOff: "varUplevel".}
var
  showMenu, titlebar, border, resize, movable, noScrollbar, scaleLeft,
    minimizable, check, mcheck, checkbox, inactive, groupBorder: bool = true
  windowFlags: set[PanelFlags] = {}
  showAppAbout, groupTitlebar, groupNoScrollbar: bool = false
  prog, progValue: int = 40
  slider, mslider: int = 10
  propertyInt, propertyNeg: int = 10
  mprog: int = 60
  menuState: Natural = menuNone.ord
  state: CollapseStates = minimized
  option: Options = A
  intSlider: int = 5
  floatSlider: float = 2.5
  propertyFloat: float = 2.0
  rangeFloatMin: float = 0
  rangeFloatMax: float = 100
  rangeFloatValue: float = 50
  rangeIntMin: int = 0
  rangeIntMax: int = 2048
  rangeIntValue: int = 4096
  selected: array[4, bool] = [false, false, true, false]
  selected2: array[16, bool] = [true, false, false, false,
    false, true, false, false, false, false, true,
    false, false, false, false, true]
  currentWeapon: int = 0
  comboColor: NkColor = NkColor(r: 130, g: 50, b: 50, a: 255)
  comboColor2: NkColorF = NkColorF(r: 0.509, g: 0.705, b: 0.2, a: 1.0)
  colMode: ColorMode = rgb
  progA: nk_size = 20
  progB: nk_size = 40
  progC: nk_size = 10
  progD: nk_size = 90
  checkValues: array[5, bool] = [false, false, false, false, false]
  position: array[3, float] = [0.0, 0.0, 0.0]
  chartSelection: cfloat = 8.0
  timeSelected, dateSelected, popupActive: bool = false
  selectedDate: DateTime = now()
  text: array[9, string] = ["", "", "", "", "", "", "", "", ""]
  textLen: array[9, cint] = [0.cint, 0, 0, 0, 0, 0, 0, 0, 0]
  boxLen: cint = 0
  fieldBuffer: string = ""
  boxBuffer: string = ""
  boxActive: EditEvent = none
  lineIndex, colIndex: int = -1
  popupColor: NkColor = NkColor(r: 255, g: 0, b: 0, a: 255)
  groupWidth: int = 320
  groupHeight: int = 200
  rootSelected: bool = false
  selected3: array[8, bool] = [false, false, false, false, false, false, false, false]
  currentTab: cint = 0
  selected4: array[32, bool] = [false, false, false, false, false, false, false,
      false, false, false, false, false, false, false, false, false, false,
      false, false, false, false, false, false, false, false, false, false,
      false, false, false, false, false]
  a, b, c: float = 100
{.push ruleOn: "varUplevel".}

proc showLayouts() {.raises: [Exception], tags: [RootEffect], contractual.} =
  ## Show layouts example
  treeTab(title = "Layout", state = minimized, index = 14):
    treeNode(title = "Widget", state = minimized, index = 15):
      setLayoutRowDynamic(height = 30, cols = 1)
      label(str = "Dynamic fixed column layout with generated position and size:")
      setLayoutRowDynamic(height = 30, cols = 3)
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
      setLayoutRowDynamic(height = 30, cols = 1)
      label(str = "Static fixed column layout with generated position and size:")
      setLayoutRowStatic(height = 30, width = 100, cols = 3)
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
      setLayoutRowDynamic(height = 30, cols = 1)
      label(str = "Dynamic array-based custom column layout with generated position and custom size:")
      setLayoutRowDynamic(height = 30, cols = 3, ratio = ratioTwo)
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
      setLayoutRowDynamic(height = 30, cols = 1)
      label(str = "Static array-based custom column layout with generated position and custom size:")
      setLayoutRowStatic(height = 30, cols = 3, ratio = widthTwo)
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
      setLayoutRowDynamic(height = 30, cols = 1)
      label(str = "Dynamic immediate mode custom column layout with generated position and custom size:")
      layoutDynamic(height = 30, cols = 3):
        row(width = 0.2):
          labelButton(title = "button"):
            discard
        row(width = 0.6):
          labelButton(title = "button"):
            discard
        row(width = 0.2):
          labelButton(title = "button"):
            discard
      setLayoutRowDynamic(height = 30, cols = 1)
      label(str = "Static immediate mode custom column layout with generated position and custom size:")
      layoutStatic(height = 30, cols = 3):
        row(width = 100):
          labelButton(title = "button"):
            discard
        row(width = 200):
          labelButton(title = "button"):
            discard
        row(width = 50):
          labelButton(title = "button"):
            discard
      setLayoutRowDynamic(height = 30, cols = 1)
      label(str = "Static free space with custom position and custom size:")
      layoutSpaceStatic(height = 60, widgetsCount = 4):
        row(x = 100, y = 0, w = 100, h = 30):
          labelButton(title = "button"):
            discard
        row(x = 0, y = 15, w = 100, h = 30):
          labelButton(title = "button"):
            discard
        row(x = 200, y = 15, w = 100, h = 30):
          labelButton(title = "button"):
            discard
        row(x = 100, y = 30, w = 100, h = 30):
          labelButton(title = "button"):
            discard
      setLayoutRowDynamic(height = 30, cols = 1)
      label(str = "Row template:")
      setRowTemplate(height = 30):
        rowTemplateDynamic()
        rowTemplateVariable(minWidth = 80)
        rowTemplateStatic(width = 80)
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
      labelButton(title = "button"):
        discard
    treeNode(title = "Group", state = minimized, index = 16):
      var groupFlags: set[PanelFlags] = {}
      if groupBorder:
        groupFlags.incl(y = windowBorder)
      if groupNoScrollbar:
        groupFlags.incl(y = windowNoScrollbar)
      if groupTitlebar:
        groupFlags.incl(y = windowTitle)
      setLayoutRowDynamic(height = 30, cols = 3)
      checkbox(label = "Titlebar", checked = groupTitlebar)
      checkbox(label = "Border", checked = groupBorder)
      checkbox(label = "No Scrollbar", checked = groupNoScrollbar)
      layoutStatic(height = 22, cols = 3):
        row(width = 50):
          label(str = "size:")
        row(width = 130):
          property(name = "#Width:", min = 100, val = groupWidth, max = 500,
              step = 10, incPerPixel = 1)
        row(width = 130):
          property(name = "#Height:", min = 100, val = groupHeight, max = 500,
              step = 10, incPerPixel = 1)
      setLayoutRowStatic(height = groupHeight.cfloat, width = groupWidth, cols = 2)
      group(title = "Group", flags = groupFlags):
        setLayoutRowStatic(height = 18, width = 100, cols = 1)
        for i in 0 .. 15:
          selectableLabel(str = (if selected2[
              i]: "Selected" else: "Unselected"), value = selected2[i],
              align = centered)
    treeNode(title = "Tree", state = minimized, index = 17):
      var sel: bool = rootSelected
      treeElement(eType = node, title = "Root", state = minimized,
          selected = sel, index = 1):
        var nodeSelect: bool = selected3[0]
        if sel != rootSelected:
          rootSelected = sel
          for i in 0 .. 7:
            selected3[i] = sel
        treeElement(eType = node, title = "Node", state = minimized,
            selected = nodeSelect, index = 2):
          if nodeSelect != selected3[0]:
            selected3[0] = nodeSelect
            for i in 0 .. 3:
              selected[i] = nodeSelect
          setLayoutRowStatic(height = 18, width = 100, cols = 1)
          for j in 0 .. 3:
            selectableSymbolLabel(sym = circleSolid, title = (if selected[
                j]: "Selected" else: "Unselected"), value = selected[j], align = right)
        setLayoutRowStatic(height = 18, width = 100, cols = 1)
        for i in 0 .. 7:
          selectableSymbolLabel(sym = circleSolid, title = (if selected3[
              i]: "Selected" else: "Unselected"), value = selected3[i], align = right)
    treeNode(title = "Notebook", state = minimized, index = 18):
      changeStyle(field = spacing, x = 0, y = 0):
        changeStyle(field = buttonRounding, value = 0):
          layoutStatic(height = 20, cols = 3):
            for i in 0 .. 2:
              let
                textWidth: float = getTextWidth(text = names[i])
                widgetWidth: float = textWidth + 3 * getButtonStyle(
                    field = padding).x
              row(width = widgetWidth):
                if currentTab == i:
                  saveButtonStyle()
                  setButtonStyle2(source = active, destination = normal)
                  currentTab = current_tab
                  labelButton(title = names[i]):
                    currentTab = i.cint
                  restoreButtonStyle()
                else:
                  currentTab = current_tab
                  labelButton(title = names[i]):
                    currentTab = i.cint
      setLayoutRowDynamic(height = 140, cols = 1)
      group(title = "Notebook", flags = {windowBorder}):
        var id: cfloat = 0.0
        let step: cfloat = (2 * 3.141592654f) / 32
        case currentTab
        of 0:
          setLayoutRowDynamic(height = 100, cols = 1)
          colorChart(cType = lines, color = NkColor(r: 255, g: 0, b: 0,
              a: 255), highlight = NkColor(r: 150, g: 0, b: 0, a: 255),
              count = 32, minValue = 0.0, maxValue = 1.0):
            addColorChartSlot(cType = lines, color = NkColor(r: 0, g: 0,
                b: 255, a: 255), highlight = NkColor(r: 0, g: 0, b: 150,
                a: 255), count = 32, minValue = -1.0, maxValue = 1.0)
            id = 0.0
            for i in 0 .. 31:
              chartPushSlot(value = abs(x = sin(x = id)), slot = 0)
              chartPushSlot(value = cos(x = id), slot = 1)
              id += step
        of 1:
          setLayoutRowDynamic(height = 100, cols = 1)
          colorChart(cType = column, color = NkColor(r: 255, g: 0, b: 0,
              a: 255), highlight = NkColor(r: 150, g: 0, b: 0, a: 255),
              count = 32, minValue = 0.0, maxValue = 1.0):
            id = 0.0
            for i in 0 .. 31:
              chartPushSlot(value = abs(x = sin(x = id)), slot = 0)
              id += step
        of 2:
          setLayoutRowDynamic(height = 100, cols = 1)
          colorChart(cType = lines, color = NkColor(r: 255, g: 0, b: 0,
              a: 255), highlight = NkColor(r: 150, g: 0, b: 0, a: 255),
              count = 32, minValue = 0.0, maxValue = 1.0):
            addColorChartSlot(cType = lines, color = NkColor(r: 0, g: 0,
                b: 255, a: 255), highlight = NkColor(r: 0, g: 0, b: 150,
                a: 255), count = 32, minValue = -1.0, maxValue = 1.0)
            addColorChartSlot(cType = column, color = NkColor(r: 0, g: 255,
                b: 0), highlight = NkColor(r: 0, g: 150, b: 0), count = 32,
                minValue = 0.0, maxValue = 1.0)
            id = 0.0
            for i in 0 .. 31:
              chartPushSlot(value = abs(x = sin(x = id)), slot = 0)
              chartPushSlot(value = abs(x = cos(x = id)), slot = 1)
              chartPushSlot(value = abs(x = sin(x = id)), slot = 2)
              id += step
        else:
          discard
    treeNode(title = "Simple", state = minimized, index = 19):
      setLayoutRowDynamic(height = 300, cols = 2)
      group(title = "Group_Without_Border", flags = {windowNoFlags}):
        setLayoutRowStatic(height = 18, width = 150, cols = 1)
        for i in 0 .. 63:
          {.push ruleOff: "namedParams".}
          fmtLabel(left, "%s: scrollable region",
              fmt"{i:#X}".cstring)
          {.push ruleOn: "namedParams".}
      group(title = "Group_With_Border", flags = {windowBorder}):
        setLayoutRowDynamic(height = 25, cols = 2)
        for i in 0 .. 63:
          let number: int = (((i mod 7) * 10)) + (64 + (i mod 2) * 2)
          labelButton(title = fmt"{number:08}"):
            discard
    treeNode(title = "Complex", state = minimized, index = 20):
      layoutSpaceStatic(height = 500, widgetsCount = 64):
        row(x = 0, y = 0, w = 150, h = 500):
          group(title = "Group_left", flags = {windowBorder}):
            setLayoutRowStatic(height = 18, width = 100, cols = 1)
            for i in 0 .. 31:
              selectableLabel(str = (if selected4[
                  i]: "Selected" else: "Unselected"), value = selected4[i],
                  align = centered)
        row(x = 160, y = 0, w = 150, h = 240):
          group(title = "Group_top", flags = {windowBorder}):
            setLayoutRowDynamic(height = 25, cols = 1)
            labelButton(title = "#FFAA"):
              discard
            labelButton(title = "#FFBB"):
              discard
            labelButton(title = "#FFCC"):
              discard
            labelButton(title = "#FFDD"):
              discard
            labelButton(title = "#FFEE"):
              discard
            labelButton(title = "#FFFF"):
              discard
        row(x = 160, y = 250, w = 150, h = 250):
          group(title = "Group_buttom", flags = {windowBorder}):
            setLayoutRowDynamic(height = 25, cols = 1)
            labelButton(title = "#FFAA"):
              discard
            labelButton(title = "#FFBB"):
              discard
            labelButton(title = "#FFCC"):
              discard
            labelButton(title = "#FFDD"):
              discard
            labelButton(title = "#FFEE"):
              discard
            labelButton(title = "#FFFF"):
              discard
        row(x = 320, y = 0, w = 150, h = 150):
          group(title = "Group_right_top", flags = {windowBorder}):
            setLayoutRowStatic(height = 18, width = 100, cols = 1)
            for i in 0 .. 3:
              selectableLabel(str = (if selected[
                  i]: "Selected" else: "Unselected"), value = selected[i],
                  align = centered)
        row(x = 320, y = 160, w = 150, h = 150):
          group(title = "Group_right_center", flags = {windowBorder}):
            setLayoutRowStatic(height = 18, width = 100, cols = 1)
            for i in 0 .. 3:
              selectableLabel(str = (if selected[
                  i]: "Selected" else: "Unselected"), value = selected[i],
                  align = centered)
        row(x = 320, y = 320, w = 150, h = 150):
          group(title = "Group_right_bottom", flags = {windowBorder}):
            setLayoutRowStatic(height = 18, width = 100, cols = 1)
            for i in 0 .. 3:
              selectableLabel(str = (if selected[
                  i]: "Selected" else: "Unselected"), value = selected[i],
                  align = centered)
    treeNode(title = "Splitter", state = minimized, index = 21):
      setLayoutRowStatic(height = 20, width = 320, cols = 1)
      label(str = "Use slider and spinner to change tile size")
      label(str = "Drag the space between tiles to change tile ratio")
      treeNode(title = "Vertical", state = minimized, index = 22):
        let rowLayout: array[5, cfloat] = [a.cfloat, 8, b.cfloat, 8, c.cfloat]
        setLayoutRowStatic(height = 30, width = 100, cols = 2)
        label(str = "left:")
        slider(min = 10.0, val = a, max = 200.0, step = 10.0)
        label(str = "middle:")
        slider(min = 10.0, val = b, max = 200.0, step = 10.0)
        label(str = "right:")
        slider(min = 10.0, val = c, max = 200.0, step = 10.0)
        setLayoutRowStatic(height = 200, cols = 5, ratio = rowLayout)
        group(title = "left", flags = {windowNoScrollbar, windowBorder}):
          setLayoutRowDynamic(height = 25, cols = 1)
          labelButton(title = "#FFAA"):
            discard
          labelButton(title = "#FFBB"):
            discard
          labelButton(title = "#FFCC"):
            discard
          labelButton(title = "#FFDD"):
            discard
          labelButton(title = "#FFEE"):
            discard
          labelButton(title = "#FFFF"):
            discard
        var bounds: Rect = getWidgetBounds()
        addSpacing(cols = 1)
        if (isMouseHovering(rect = bounds) or isMousePrevHovering(
            rect = bounds)) and isMouseDown(id = left):
          a = rowLayout[0] + getMouseDelta().x
          b = rowLayout[2] - getMouseDelta().x
        group(title = "center", flags = {windowBorder, windowNoScrollbar}):
          setLayoutRowDynamic(height = 25, cols = 1)
          labelButton(title = "#FFAA"):
            discard
          labelButton(title = "#FFBB"):
            discard
          labelButton(title = "#FFCC"):
            discard
          labelButton(title = "#FFDD"):
            discard
          labelButton(title = "#FFEE"):
            discard
          labelButton(title = "#FFFF"):
            discard
        bounds = getWidgetBounds()
        addSpacing(cols = 1)
        if (isMouseHovering(rect = bounds) or isMousePrevHovering(
            rect = bounds)) and isMouseDown(id = left):
          b = rowLayout[2] + getMouseDelta().x
          c = rowLayout[4] - getMouseDelta().x
        group(title = "right", flags = {windowBorder, windowNoScrollbar}):
          setLayoutRowDynamic(height = 25, cols = 1)
          labelButton(title = "#FFAA"):
            discard
          labelButton(title = "#FFBB"):
            discard
          labelButton(title = "#FFCC"):
            discard
          labelButton(title = "#FFDD"):
            discard
          labelButton(title = "#FFEE"):
            discard
          labelButton(title = "#FFFF"):
            discard
      treeNode(title = "Horizontal", state = minimized, index = 23):
        setLayoutRowStatic(height = 30, width = 100, cols = 2)
        label(str = "top:")
        slider(min = 10.0, val = a, max = 200.0, step = 10.0)
        label(str = "middle:")
        slider(min = 10.0, val = b, max = 200.0, step = 10.0)
        label(str = "bottom:")
        slider(min = 10.0, val = c, max = 200.0, step = 10.0)
        setLayoutRowDynamic(height = a, cols = 1)
        group(title = "top", flags = {windowBorder, windowNoScrollbar}):
          setLayoutRowDynamic(height = 25, cols = 3)
          labelButton(title = "#FFAA"):
            discard
          labelButton(title = "#FFBB"):
            discard
          labelButton(title = "#FFCC"):
            discard
          labelButton(title = "#FFDD"):
            discard
          labelButton(title = "#FFEE"):
            discard
          labelButton(title = "#FFFF"):
            discard
        setLayoutRowDynamic(height = 8, cols = 1)
        var bounds: Rect = getWidgetBounds()
        addSpacing(cols = 1)
        if (isMouseHovering(rect = bounds) or isMousePrevHovering(
            rect = bounds)) and isMouseDown(id = left):
          a += getMouseDelta().y
          b -= getMouseDelta().y
        setLayoutRowDynamic(height = b, cols = 1)
        group(title = "middle", flags = {windowBorder, windowNoScrollbar}):
          setLayoutRowDynamic(height = 25, cols = 3)
          labelButton(title = "#FFAA"):
            discard
          labelButton(title = "#FFBB"):
            discard
          labelButton(title = "#FFCC"):
            discard
          labelButton(title = "#FFDD"):
            discard
          labelButton(title = "#FFEE"):
            discard
          labelButton(title = "#FFFF"):
            discard
        setLayoutRowDynamic(height = 8, cols = 1)
        bounds = getWidgetBounds()
        if (isMouseHovering(rect = bounds) or isMousePrevHovering(
            rect = bounds)) and isMouseDown(id = left):
          b += getMouseDelta().y
          c -= getMouseDelta().y
        setLayoutRowDynamic(height = c, cols = 1)
        group(title = "bottom", flags = {windowBorder, windowNoScrollbar}):
          setLayoutRowDynamic(height = 25, cols = 3)
          labelButton(title = "#FFAA"):
            discard
          labelButton(title = "#FFBB"):
            discard
          labelButton(title = "#FFCC"):
            discard
          labelButton(title = "#FFDD"):
            discard
          labelButton(title = "#FFEE"):
            discard
          labelButton(title = "#FFFF"):
            discard

proc showPopups() {.raises: [], tags: [RootEffect], contractual.} =
  ## Show popup example
  treeTab(title = "Popup", state = minimized, index = 13):
    setLayoutRowStatic(height = 30, width = 160, cols = 1)
    var bounds: Rect = getWidgetBounds()
    label(str = "Right click me for menu")
    contextualMenu(flags = {windowNoFlags}, x = 100, y = 300,
        triggerBounds = bounds, button = right):
      setLayoutRowDynamic(height = 25, cols = 1)
      checkbox(label = "Menu", checked = showMenu)
      progressBar(value = prog, maxValue = 100)
      slider(min = 0, val = slider, max = 16, step = 1)
      contextualItemLabel(label = "About", align = centered):
        showAppAbout = true
      selectableLabel(str = (if selected[0]: "Uns" else: "S") & "elect",
          value = selected[0])
      selectableLabel(str = (if selected[1]: "Uns" else: "S") & "elect",
          value = selected[1])
      selectableLabel(str = (if selected[2]: "Uns" else: "S") & "elect",
          value = selected[2])
      selectableLabel(str = (if selected[3]: "Uns" else: "S") & "elect",
          value = selected[3])
    layoutStatic(height = 30, cols = 2):
      row(width = 120):
        label(str = "Right Click here:")
      row(width = 50):
        bounds = getWidgetBounds()
        colorButton(r = popupColor.r, g = popupColor.g, b = popupColor.b):
          discard
    contextualMenu(flags = {windowNoFlags}, x = 350, y = 60,
        triggerBounds = bounds, button = right):
      setLayoutRowDynamic(height = 30, cols = 4)
      popupColor.r = property2(name = "#r", min = 0, val = popupColor.r,
          max = 255, step = 1, incPerPixel = 1)
      popupColor.g = property2(name = "#g", min = 0, val = popupColor.g,
          max = 255, step = 1, incPerPixel = 1)
      popupColor.b = property2(name = "#b", min = 0, val = popupColor.b,
          max = 255, step = 1, incPerPixel = 1)
      popupColor.a = property2(name = "#a", min = 0, val = popupColor.a,
          max = 255, step = 1, incPerPixel = 1)
    layoutStatic(height = 30, cols = 2):
      row(width = 120):
        label(str = "Popup:")
      row(width = 50):
        labelButton(title = "Popup"):
          popup_active = true
    if popupActive:
      try:
        popup(pType = staticPopup, title = "Error", flags = {windowNoFlags},
            x = 20, y = 100, w = 220, h = 90):
          setLayoutRowDynamic(height = 25, cols = 1)
          label(str = "A terrible error as occurred")
          setLayoutRowDynamic(height = 25, cols = 2)
          labelButton(title = "OK"):
            popupActive = false
            closePopup()
          labelButton(title = "Cancel"):
            popupActive = false
            closePopup()
      except:
        popupActive = false
    setLayoutRowStatic(height = 30, width = 150, cols = 1)
    bounds = getWidgetBounds()
    label(str = "Hover me for tooltip")
    if isMouseHovering(rect = bounds):
      tooltip(text = "This is a tooltip")

proc showCharts() {.raises: [], tags: [RootEffect], contractual.} =
  ## Show popup example
  treeTab(title = "Charts", state = minimized, index = 12):
    var
      chartId: cfloat = 0
      chartIndex: int = -1
    setLayoutRowDynamic(height = 100, cols = 1)
    chart(cType = lines, num = 32, min = -1.0, max = 1.0):
      for i in 0 .. 31:
        let res: ChartEvent = chartPush(value = cos(x = chartId))
        if res == hovering:
          chartIndex = i
        if res == clicked:
          lineIndex = i
        chartId += chartStep
    if chartIndex != -1:
      {.push ruleOff: "namedParams".}
      fmtTooltip("Value: %.2f", cos(x = chartIndex.cfloat * chartStep).cfloat)
      {.push ruleOn: "namedParams".}
    if lineIndex != 1:
      setLayoutRowDynamic(height = 20, cols = 1)
      {.push ruleOff: "namedParams".}
      fmtLabel(left, "Selected value: %.2f", cos(x = chartIndex.cfloat *
          chartStep).cfloat)
      {.push ruleOn: "namedParams".}
    setLayoutRowDynamic(height = 100, cols = 1)
    chart(cType = column, num = 32, min = 0.0, max = 1.0):
      for i in 0 .. 31:
        let res: ChartEvent = chartPush(value = abs(x = sin(x = chartId)))
        if res == hovering:
          chartIndex = i
        if res == clicked:
          colIndex = i
        chartId += chartStep
    if chartIndex != -1:
      {.push ruleOff: "namedParams".}
      fmtTooltip("Value: %.2f", abs(x = sin(x = chartStep *
          chartIndex.cfloat).cfloat))
      {.push ruleOn: "namedParams".}
    if col_index != -1:
      setLayoutRowDynamic(height = 20, cols = 1)
      {.push ruleOff: "namedParams".}
      fmtLabel(left, "Selected value: %.2f", abs(x = sin(x = chartStep *
          colIndex.cfloat).cfloat))
      {.push ruleOn: "namedParams".}
    setLayoutRowDynamic(height = 100, cols = 1)
    chart(cType = column, num = 32, min = 0.0, max = 1.0):
      addChartSlot(cType = lines, count = 32, minValue = -1.0, maxValue = 1.0)
      addChartSlot(cType = lines, count = 32, minValue = -1.0, maxValue = 1.0)
      chartId = 0
      for i in 0 .. 31:
        chartPushSlot(value = abs(x = sin(x = chartId)), slot = 0)
        chartPushSlot(value = cos(x = chartId), slot = 1)
        chartPushSlot(value = sin(x = chartId), slot = 2)
        chartId += chartStep
    setLayoutRowDynamic(height = 100, cols = 1)
    colorChart(cType = lines, color = NkColor(r: 255, g: 0, b: 0),
        highlight = NkColor(r: 150, g: 0, b: 0), count = 32, minValue = 0.0,
        maxValue = 1.0):
      addColorChartSlot(ctype = lines, color = NkColor(r: 0, g: 0, b: 255),
          highlight = NkColor(r: 0, g: 0, b: 150), count = 32,
          minValue = -1.0, maxValue = 1.0)
      addColorChartSlot(ctype = lines, color = NkColor(r: 0, g: 255, b: 0),
          highlight = NkColor(r: 0, g: 150, b: 0), count = 32,
          minValue = -1.0, maxValue = 1.0)
      chartId = 0
      for i in 0 .. 31:
        chartPushSlot(value = abs(x = sin(x = chartId)), slot = 0)
        chartPushSlot(value = cos(x = chartId), slot = 1)
        chartPushSlot(value = sin(x = chartId), slot = 2)
        chartId += chartStep

proc overview*() {.raises: [Exception], tags: [RootEffect], contractual.} =
  ## Show the most features of the library
  windowFlags = {}
  headerAlign(value = headerRight)
  if border:
    windowFlags.incl(y = windowBorder)
  if resize:
    windowFlags.incl(y = windowScalable)
  if movable:
    windowFlags.incl(y = windowMovable)
  if noScrollbar:
    windowFlags.incl(y = windowNoScrollbar)
  if scaleLeft:
    windowFlags.incl(y = windowScaleLeft)
  if minimizable:
    windowFlags.incl(y = windowMinimizable)
  window(name = "Overview", x = 275, y = 10, w = 400, h = 600,
      flags = windowFlags):
    if showMenu:
      # menubar
      menuBar:
        layoutStatic(height = 25, cols = 5):
          # menu #1
          row(width = 45):
            menu(text = "MENU", align = left, x = 120, y = 200):
              setLayoutRowDynamic(height = 25, cols = 1)
              menuItem(label = "Hide", align = left):
                showMenu = false
              menuItem(label = "About", align = left):
                showAppAbout = true
              progressBar(value = prog, maxValue = 100)
              slider(min = 0, val = slider, max = 16, step = 1)
              checkbox(label = "check", checked = check)
          # menu 2
          row(width = 60):
            menu(text = "ADVANCED", align = left, x = 200, y = 600):
              treeTab(title = "FILE", state = state, current = menuState,
                  index = menuFile.ord):
                menuItem(label = "New", align = left):
                  discard
                menuItem(label = "Open", align = left):
                  discard
                menuItem(label = "Save", align = left):
                  discard
                menuItem(label = "Close", align = left):
                  discard
                menuItem(label = "Exit", align = left):
                  discard
              treeTab(title = "EDIT", state = state, current = menuState,
                  index = menuEdit.ord):
                menuItem(label = "Copy", align = left):
                  discard
                menuItem(label = "Delete", align = left):
                  discard
                menuItem(label = "Cut", align = left):
                  discard
                menuItem(label = "Paste", align = left):
                  discard
              treeTab(title = "VIEW", state = state, current = menuState,
                  index = menuView.ord):
                menuItem(label = "About", align = left):
                  discard
                menuItem(label = "Options", align = left):
                  discard
                menuItem(label = "Customize", align = left):
                  discard
              treeTab(title = "CHART", state = state, current = menuState,
                  index = menuChart.ord):
                setLayoutRowDynamic(height = 150, cols = 1)
                chart(cType = column, num = values.len, min = 0, max = 50):
                  for value in values:
                    chartPush(value = value)
          # menu widgets
          row(width = 70):
            progressBar(value = mprog, maxValue = 100)
            slider(min = 0, val = mslider, max = 16, step = 1)
            checkbox(label = "check", checked = mcheck)
    if showAppAbout:
      try:
        popup(pType = staticPopup, title = "About", flags = {windowClosable},
            x = 20, y = 100, w = 300, h = 190):
          setLayoutRowDynamic(height = 20, cols = 1)
          label(str = "Nuklear")
          label(str = "By Micha Mettke")
          label(str = "nuklear is licensed under the public domain License.")
      except:
        showAppAbout = false
    treeTab(title = "Window", state = minimized, index = 1):
      setLayoutRowDynamic(height = 30, cols = 2)
      checkbox(label = "Titlebar", checked = titlebar)
      checkbox(label = "Menu", checked = showMenu)
      checkbox(label = "Border", checked = border)
      checkbox(label = "Resizable", checked = resize)
      checkbox(label = "Movable", checked = movable)
      checkbox(label = "No Scrollbar", checked = noScrollbar)
      checkbox(label = "Minimizable", checked = minimizable)
      checkbox(label = "Scale Left", checked = scaleLeft)
    treeTab(title = "Widgets", state = minimized, index = 2):
      treeNode(title = "Text", state = minimized, index = 3):
        setLayoutRowDynamic(height = 20, cols = 1)
        label(str = "Label aligned left")
        label(str = "Label aligned centered", alignment = centered)
        label(str = "Label aligned right", alignment = right)
        colorLabel(str = "Blue text", color = colBlue)
        colorLabel(str = "Yellow text", color = colYellow)
        text(str = "Text without /0", alignment = right)
        setLayoutRowStatic(height = 100, width = 200, cols = 1)
        wrapLabel(str = "This is a very long line to hopefully get this text to be wrapped into multiple lines to show line wrapping")
        setLayoutRowDynamic(height = 100, cols = 1)
        wrapLabel(str = "This is another long text to show dynamic window changes on multiline text")
      treeNode(title = "Button", state = minimized, index = 4):
        setLayoutRowStatic(height = 30, width = 100, cols = 3)
        labelButton(title = "Button"):
          echo "Button pressed!"
        setButtonBehavior(behavior = repeater)
        labelButton(title = "Repeater"):
          echo "Repeater is being pressed!"
        setButtonBehavior(behavior = default)
        colorButton(r = 0, g = 0, b = 255):
          discard
        setLayoutRowStatic(height = 25, width = 25, cols = 8)
        symbolButton(symbol = circleSolid):
          discard
        symbolButton(symbol = circleOutline):
          discard
        symbolButton(symbol = rectSolid):
          discard
        symbolButton(symbol = rectOutline):
          discard
        symbolButton(symbol = triangleUp):
          discard
        symbolButton(symbol = triangleDown):
          discard
        symbolButton(symbol = triangleLeft):
          discard
        symbolButton(symbol = triangleRight):
          discard
        setLayoutRowStatic(height = 30, width = 100, cols = 2)
        symbolLabelButton(symbol = triangleLeft, label = "prev", align = right):
          discard
        symbolLabelButton(symbol = triangleRight, label = "next", align = left):
          discard
      treeNode(title = "Basic", state = minimized, index = 5):
        setLayoutRowStatic(height = 30, width = 100, cols = 1)
        checkbox(label = "Checkbox", checked = checkbox)
        setLayoutRowStatic(height = 30, width = 80, cols = 3)
        if option(label = "optionA", selected = option == A):
          option = A
        if option(label = "optionB", selected = option == B):
          option = B
        if option(label = "optionC", selected = option == C):
          option = C
        setLayoutRowStatic(height = 30, cols = 2, ratio = ratio)
        {.push ruleOff: "namedParams".}
        fmtLabel(left, "Slider int")
        slider(min = 0, val = intSlider, max = 10, step = 1)
        label(str = "Slider float")
        slider(min = 0, val = floatSlider, max = 5.0, step = 0.5)
        fmtLabel(left, "Progressbar: %u", progValue)
        {.push ruleOn: "namedParams".}
        progressBar(value = prog_value, maxValue = 100)
        setLayoutRowStatic(height = 25, cols = 2, ratio = ratio)
        label(str = "Property float:")
        property(name = "Float:", min = 0, val = propertyFloat, max = 64.0,
            step = 0.1, incPerPixel = 0.2)
        label(str = "Property int:")
        property(name = "Int:", min = 0, val = propertyInt, max = 100, step = 1,
            incPerPixel = 1)
        label(str = "Property neg:")
        property(name = "Neg:", min = -10, val = propertyNeg, max = 10,
            step = 1, incPerPixel = 1)
        setLayoutRowDynamic(height = 25, cols = 1)
        label(str = "Range:")
        setLayoutRowDynamic(height = 25, cols = 3)
        property(name = "#min:", min = 0, val = rangeFloatMin,
            max = rangeFloatMax, step = 1.0, incPerPixel = 0.2)
        property(name = "#float:", min = rangeFloatMin, val = rangeFloatValue,
            max = rangeFloatMax, step = 1.0, incPerPixel = 0.2)
        property(name = "#max:", min = rangeFloatMin, val = rangeFloatMax,
            max = 100, step = 1.0, incPerPixel = 0.2)
        property(name = "#min:", min = cint.low, val = rangeIntMin,
            max = rangeIntMax, step = 1, incPerPixel = 10)
        property(name = "#neg:", min = rangeIntMin, val = rangeIntValue,
            max = rangeIntMax, step = 1, incPerPixel = 10)
        property(name = "#max:", min = rangeIntMin, val = rangeIntMax,
            max = cint.high, step = 1, incPerPixel = 10)
      treeNode(title = "Inactive", state = minimized, index = 6):
        setLayoutRowDynamic(height = 30, cols = 1)
        checkbox(label = "Inactive", checked = inactive)
        setLayoutRowStatic(height = 30, width = 80, cols = 1)
        if inactive == 1:
          disabled:
            labelButton(title = "button"):
              discard
        else:
          labelButton(title = "button"):
            echo "button pressed"
      treeNode(title = "Selectable", state = minimized, index = 7):
        treeNode(title = "List", state = minimized, index = 8):
          setLayoutRowStatic(height = 18, width = 100, cols = 1)
          selectableLabel(str = "Selectable", value = selected[0])
          selectableLabel(str = "Selectable", value = selected[1])
          label(str = "Not Selectable")
          selectableLabel(str = "Selectable", value = selected[2])
          selectableLabel(str = "Selectable", value = selected[3])
        treeNode(title = "Grid", state = minimized, index = 9):
          setLayoutRowStatic(height = 50, width = 50, cols = 4)
          for index, value in selected2.mpairs:
            if selectableLabel(str = "Z", value = value, align = centered):
              let
                x: int = index mod 4
                y: int = (index / 4).int
              if x > 0: selected2[index - 1] = (selected2[index -
                  1].cint xor 1).nk_bool
              if x < 3: selected2[index + 1] = (selected2[index +
                  1].cint xor 1).nk_bool
              if y > 0: selected2[index - 4] = (selected2[index -
                  4].cint xor 1).nk_bool
              if y < 3: selected2[index + 4] = (selected2[index +
                  4].cint xor 1).nk_bool
      treeNode(title = "Combo", state = minimized, index = 10):
        setLayoutRowStatic(height = 25, width = 200, cols = 1);
        currentWeapon = comboList(items = weapons, selected = currentWeapon,
            itemHeight = 25, x = 200, y = 200)
        colorCombo(color = comboColor, x = 200, y = 200):
          let ratios: array[2, cfloat] = [0.15.cfloat, 0.85]
          setLayoutRowDynamic(height = 30, cols = 2, ratio = ratios)
          label(str = "R:")
          comboColor.r = slide(min = 0, val = comboColor.r, max = 255, step = 5)
          label(str = "G:")
          comboColor.g = slide(min = 0, val = comboColor.g, max = 255, step = 5)
          label(str = "B:")
          comboColor.b = slide(min = 0, val = comboColor.b, max = 255, step = 5)
          label(str = "A:")
          comboColor.a = slide(min = 0, val = comboColor.a, max = 255, step = 5)
        colorCombo(color = comboColor2, x = 200, y = 400):
          setLayoutRowDynamic(height = 120, cols = 1)
          comboColor2 = colorPicker(color = comboColor2, format = rgba)
          setLayoutRowDynamic(height = 25, cols = 2)
          if option(label = "RGB", selected = colMode == rgb):
            colMode = rgb
          if option(label = "HSV", selected = colMode == hsv):
            colMode = hsv
          setLayoutRowDynamic(height = 25, cols = 1)
          if colMode == rgb:
            comboColor2.r = property2(name = "#R:", min = 0,
                val = comboColor2.r, max = 1.0, step = 0.01,
                incPerPixel = 0.005)
            comboColor2.g = property2(name = "#G:", min = 0,
                val = comboColor2.g, max = 1.0, step = 0.01,
                incPerPixel = 0.005)
            comboColor2.b = property2(name = "#B:", min = 0,
                val = comboColor2.b, max = 1.0, step = 0.01,
                incPerPixel = 0.005)
            comboColor2.a = property2(name = "#A:", min = 0,
                val = comboColor2.a, max = 1.0, step = 0.01,
                incPerPixel = 0.005)
          else:
            var hsva: array[4, float] = [0.0, 0.0, 0.0, 0.0]
            colorfToHsva(hsva = hsva, color = comboColor2)
            hsva[0] = property2(name = "#H:", min = 0, val = hsva[0], max = 1.0,
                step = 0.01, incPerPixel = 0.05)
            hsva[1] = property2(name = "#S:", min = 0, val = hsva[1], max = 1.0,
                step = 0.01, incPerPixel = 0.05)
            hsva[2] = property2(name = "#V:", min = 0, val = hsva[2], max = 1.0,
                step = 0.01, incPerPixel = 0.05)
            hsva[3] = property2(name = "#A:", min = 0, val = hsva[3], max = 1.0,
                step = 0.01, incPerPixel = 0.05)
            comboColor2 = hsvaToColorf(hsva = hsva)
        var sum: string = $(progA + progB + progC + progD)
        labelCombo(selected = sum, x = 200, y = 200):
          setLayoutRowDynamic(height = 30, cols = 1)
          progressBar(value = progA, maxValue = 100)
          progressBar(value = progB, maxValue = 100)
          progressBar(value = progC, maxValue = 100)
          progressBar(value = progD, maxValue = 100)
        sum = $(checkValues[0] + checkValues[1] + checkValues[2] + checkValues[
            3] + checkValues[4])
        labelCombo(selected = sum, x = 200, y = 200):
          setLayoutRowDynamic(height = 30, cols = 1)
          checkBox(label = weapons[0], checked = checkValues[0])
          checkBox(label = weapons[1], checked = checkValues[1])
          checkBox(label = weapons[2], checked = checkValues[2])
          checkBox(label = weapons[3], checked = checkValues[3])
          checkBox(label = weapons[4], checked = checkValues[4])
        sum = $position[0] & " " & $position[1] & " " & $position[2]
        labelCombo(selected = sum, x = 200, y = 200):
          setLayoutRowDynamic(height = 25, cols = 1)
          property(name = "#X:", min = -1024.0, val = position[0], max = 1024.0,
              step = 1, incPerPixel = 0.5)
          property(name = "#Y:", min = -1024.0, val = position[1], max = 1024.0,
              step = 1, incPerPixel = 0.5)
          property(name = "#Z:", min = -1024.0, val = position[2], max = 1024.0,
              step = 1, incPerPixel = 0.5)
        sum = $chartSelection
        labelCombo(selected = sum, x = 200, y = 250):
          setLayoutRowDynamic(height = 150, cols = 1)
          chart(cType = column, num = values.len, min = 0, max = 50):
            for value in values:
              if chartPush(value = value) == clicked:
                chartSelection = value
                comboClose()
        if not timeSelected and not dateSelected:
          selectedDate = now()
        sum = $selectedDate.hour & ":" & $selectedDate.minute & ":" &
            $selectedDate.second
        labelCombo(selected = sum, x = 200, y = 250):
          timeSelected = true
          setLayoutRowDynamic(height = 25, cols = 1)
          {.warning[Deprecated]: off.}
          selectedDate.second = property2(name = "#S:", min = 0,
              val = selectedDate.second, max = 60, step = 1, incPerPixel = 1)
          selectedDate.minute = property2(name = "#M:", min = 0,
              val = selectedDate.minute, max = 60, step = 1, incPerPixel = 1)
          selectedDate.hour = property2(name = "#H:", min = 0,
              val = selectedDate.hour, max = 23, step = 1, incPerPixel = 1)
        sum = $selectedDate.monthday & "-" & $selectedDate.month & "-" &
            $selectedDate.year
        labelCombo(selected = sum, x = 350, y = 400):
          dateSelected = true
          layoutDynamic(height = 20, cols = 3):
            row(width = 0.05):
              symbolButton(symbol = triangleLeft):
                if selectedDate.month == mJan:
                  selectedDate.monthZero = 12
                  {.ruleOff: "assignments".}
                  selectedDate.year = selectedDate.year - 1
                  {.ruleOn: "assignments".}
                else:
                  selectedDate.monthZero = selectedDate.month.ord - 1
            row(width = 0.9):
              sum = $selectedDate.month & " " & $selectedDate.year
              label(str = sum, alignment = centered)
            row(width = 0.05):
              symbolButton(symbol = triangleRight):
                if selectedDate.month == mDec:
                  selectedDate.monthZero = 1
                  {.ruleOff: "assignments".}
                  selectedDate.year = selectedDate.year + 1
                  {.ruleOn: "assignments".}
                else:
                  selectedDate.monthZero = selectedDate.month.ord + 1
          setLayoutRowDynamic(height = 35, cols = 7)
          for day in WeekDay:
            sum = $day
            label(str = sum, alignment = centered)
          var spacing: int = getDayOfWeek(monthday = 1,
              month = selectedDate.month, year = selectedDate.year).ord - dMon.ord
          if spacing > 0:
            addSpacing(cols = spacing)
          for i in 1 .. getDaysInMonth(month = selectedDate.month,
              year = selectedDate.year):
            sum = $i
            labelButton(title = sum):
              selectedDate.monthdayZero = i
              comboClose()
          {.warning[Deprecated]: on.}
      treeNode(title = "Input", state = minimized, index = 11):
        setLayoutRowStatic(height = 25, cols = 2, ratio = ratio)
        label(str = "Default:")
        editString(text = text[0], maxLen = 64)
        label(str = "Int:")
        editString(text = text[1], maxLen = 64, filter = nk_filter_decimal)
        label(str = "Float:")
        editString(text = text[2], maxLen = 64, filter = nk_filter_float)
        label(str = "Hex:")
        editString(text = text[4], maxLen = 64, filter = nk_filter_hex)
        label(str = "Octal:")
        editString(text = text[5], maxLen = 64, filter = nk_filter_oct)
        label(str = "Binary:")
        editString(text = text[6], maxLen = 64, filter = nk_filter_binary)
        label(str = "Password:")
        var buffer: string = text[8]
        for ch in buffer.mitems:
          ch = '*'
        editString(text = buffer, maxLen = 64, editType = field)
        text[8] = buffer
        label(str = "Field:")
        editString(text = fieldBuffer, maxLen = 64, editType = field)
        label(str = "Box:")
        setLayoutRowStatic(height = 180, width = 278, cols = 1)
        editString(text = boxBuffer, maxLen = 512, editType = box)
        setLayoutRowStatic(height = 25, cols = 2, ratio = ratio)
        boxActive = editString(text = text[7], maxLen = 64, editType = field,
            filter = nk_filter_ascii, flags = {sigEnter})
        labelButton(title = "Submit"):
          text_len[7].inc
          boxBuffer.add(y = text[7] & "\n")
          boxLen = boxLen + textLen[7] + 1
          text[7] = ""
          textLen[7] = 0
        if boxActive == commited:
          text_len[7].inc
          boxBuffer.add(y = text[7] & "\n")
          boxLen = boxLen + textLen[7] + 1
          text[7] = ""
          textLen[7] = 0
    showCharts()
    showPopups()
    showLayouts()
