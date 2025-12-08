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

# Nuklear overview demo translated to Nim (for Xlib binding)

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
  values = [26.0, 13.0, 30.0, 15.0, 25.0, 10.0, 20.0, 40.0, 12.0, 8.0, 22.0,
      28.0, 5.0]
  ratio = [120.0.cfloat, 150.0]
  weapons = ["Fist", "Pistol", "Shotgun", "Plasma", "BFG"]
  chartStep = ((2.0 * 3.141592654) / 32.0).float
  ratioTwo = [0.2.cfloat, 0.6, 0.2]
  widthTwo = [100.0.cfloat, 200.0, 50.0]
  names = ["Lines", "Columns", "Mixed"]
var
  showMenu, titlebar, border, resize, movable, noScrollbar, scaleLeft,
    minimizable, check, mcheck, checkbox, inactive, groupBorder: bool = true
  windowFlags: set[PanelFlags]
  showAppAbout, groupTitlebar, groupNoScrollbar: bool = false
  prog, progValue = 40
  slider, mslider: int = 10
  propertyInt, propertyNeg: int = 10
  mprog = 60
  menuState: Natural = menuNone.ord
  state = minimized
  option = A
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
  colMode: ColorMode
  progA: nk_size = 20
  progB: nk_size = 40
  progC: nk_size = 10
  progD: nk_size = 90
  checkValues: array[5, bool]
  position: array[3, float]
  chartSelection: cfloat = 8.0
  timeSelected, dateSelected, popupActive: bool = false
  selectedDate: DateTime
  text: array[9, string]
  textLen: array[9, cint] = [0.cint, 0, 0, 0, 0, 0, 0, 0, 0]
  boxLen: cint
  fieldBuffer: string
  boxBuffer: string
  boxActive: EditEvent
  lineIndex, colIndex = -1
  popupColor: NkColor = NkColor(r: 255, g: 0, b: 0, a: 255)
  groupWidth: int = 320
  groupHeight: int = 200
  rootSelected: bool
  selected3: array[8, bool]
  currentTab: cint = 0
  selected4: array[32, bool]
  a, b, c: float = 100

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
        slider(min = 0, val = float_slider, max = 5.0, step = 0.5)
        fmtLabel(left, "Progressbar: %u", progValue)
        {.push ruleOn: "namedParams".}
        progressBar(prog_value, 100)
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
      treeNode("Inactive", minimized, 6):
        setLayoutRowDynamic(30, 1)
        checkbox("Inactive", inactive)
        setLayoutRowStatic(30, 80, 1)
        if inactive == 1:
          disabled:
            labelButton("button"):
              discard
        else:
          labelButton("button"):
            echo "button pressed"
      treeNode("Selectable", minimized, 7):
        treeNode("List", minimized, 8):
          setLayoutRowStatic(18, 100, 1)
          selectableLabel("Selectable", selected[0])
          selectableLabel("Selectable", selected[1])
          label("Not Selectable")
          selectableLabel("Selectable", selected[2])
          selectableLabel("Selectable", selected[3])
        treeNode("Grid", minimized, 9):
          setLayoutRowStatic(50, 50, 4)
          for index, value in selected2.mpairs:
            if selectableLabel("Z", value, centered):
              let
                x = index mod 4
                y = (index / 4).int
              if x > 0: selected2[index - 1] = (selected2[index -
                  1].cint xor 1).nk_bool
              if x < 3: selected2[index + 1] = (selected2[index +
                  1].cint xor 1).nk_bool
              if y > 0: selected2[index - 4] = (selected2[index -
                  4].cint xor 1).nk_bool
              if y < 3: selected2[index + 4] = (selected2[index +
                  4].cint xor 1).nk_bool
      treeNode("Combo", minimized, 10):
        setLayoutRowStatic(25, 200, 1);
        currentWeapon = comboList(weapons, currentWeapon, 25, 200, 200)
        colorCombo(comboColor, 200, 200):
          let ratios: array[2, cfloat] = [0.15.cfloat, 0.85]
          setLayoutRowDynamic(30, 2, ratios)
          label("R:")
          comboColor.r = slide(0, comboColor.r, 255, 5)
          label("G:")
          comboColor.g = slide(0, comboColor.g, 255, 5)
          label("B:")
          comboColor.b = slide(0, comboColor.b, 255, 5)
          label("A:")
          comboColor.a = slide(0, comboColor.a, 255, 5)
        colorCombo(comboColor2, 200, 400):
          setLayoutRowDynamic(120, 1)
          comboColor2 = colorPicker(comboColor2, rgba)
          setLayoutRowDynamic(25, 2)
          if option("RGB", colMode == rgb):
            colMode = rgb
          if option("HSV", colMode == hsv):
            colMode = hsv
          setLayoutRowDynamic(25, 1)
          if colMode == rgb:
            comboColor2.r = property2("#R:", 0, comboColor2.r, 1.0,
                0.01, 0.005)
            comboColor2.g = property2("#G:", 0, comboColor2.g, 1.0,
                0.01, 0.005)
            comboColor2.b = property2("#B:", 0, comboColor2.b, 1.0,
                0.01, 0.005)
            comboColor2.a = property2("#A:", 0, comboColor2.a, 1.0,
                0.01, 0.005)
          else:
            var hsva: array[4, float]
            colorfToHsva(hsva, comboColor2)
            hsva[0] = property2("#H:", 0, hsva[0], 1.0, 0.01, 0.05)
            hsva[1] = property2("#S:", 0, hsva[1], 1.0, 0.01, 0.05)
            hsva[2] = property2("#V:", 0, hsva[2], 1.0, 0.01, 0.05)
            hsva[3] = property2("#A:", 0, hsva[3], 1.0, 0.01, 0.05)
            comboColor2 = hsvaToColorf(hsva)
        var sum = $(progA + progB + progC + progD)
        labelCombo(sum, 200, 200):
          setLayoutRowDynamic(30, 1)
          progressBar(progA, 100)
          progressBar(progB, 100)
          progressBar(progC, 100)
          progressBar(progD, 100)
        sum = $(checkValues[0] + checkValues[1] + checkValues[2] + checkValues[
            3] + checkValues[4])
        labelCombo(sum, 200, 200):
          setLayoutRowDynamic(30, 1)
          checkBox(weapons[0], checkValues[0])
          checkBox(weapons[1], checkValues[1])
          checkBox(weapons[2], checkValues[2])
          checkBox(weapons[3], checkValues[3])
          checkBox(weapons[4], checkValues[4])
        sum = $position[0] & " " & $position[1] & " " & $position[2]
        labelCombo(sum, 200, 200):
          setLayoutRowDynamic(25, 1)
          property("#X:", -1024.0, position[0], 1024.0, 1, 0.5)
          property("#Y:", -1024.0, position[1], 1024.0, 1, 0.5)
          property("#Z:", -1024.0, position[2], 1024.0, 1, 0.5)
        sum = $chartSelection
        labelCombo(sum, 200, 250):
          setLayoutRowDynamic(150, 1)
          chart(column, values.len, 0, 50):
            for value in values:
              if chartPush(value) == clicked:
                chartSelection = value
                comboClose()
        if not timeSelected and not dateSelected:
          selectedDate = now()
        sum = $selectedDate.hour & ":" & $selectedDate.minute & ":" &
            $selectedDate.second
        labelCombo(sum, 200, 250):
          timeSelected = true
          setLayoutRowDynamic(25, 1)
          {.warning[Deprecated]: off.}
          selectedDate.second = property2("#S:", 0, selectedDate.second,
              60, 1, 1)
          selectedDate.minute = property2("#M:", 0, selectedDate.minute,
              60, 1, 1)
          selectedDate.hour = property2("#H:", 0, selectedDate.hour, 23,
              1, 1)
        sum = $selectedDate.monthday & "-" & $selectedDate.month & "-" &
            $selectedDate.year
        labelCombo(sum, 350, 400):
          dateSelected = true
          layoutDynamic(20, 3):
            row(0.05):
              symbolButton(triangleLeft):
                if selectedDate.month == mJan:
                  selectedDate.monthZero = 12
                  selectedDate.year = selectedDate.year - 1
                else:
                  selectedDate.monthZero = selectedDate.month.ord - 1
            row(0.9):
              sum = $selectedDate.month & " " & $selectedDate.year
              label(sum, centered)
            row(0.05):
              symbolButton(triangleRight):
                if selectedDate.month == mDec:
                  selectedDate.monthZero = 1
                  selectedDate.year = selectedDate.year + 1
                else:
                  selectedDate.monthZero = selectedDate.month.ord + 1
          setLayoutRowDynamic(35, 7)
          for day in WeekDay:
            sum = $day
            label(sum, centered)
          var spacing = getDayOfWeek(1, selectedDate.month,
              selectedDate.year).ord - dMon.ord
          if spacing > 0:
            addSpacing(spacing)
          for i in 1 .. getDaysInMonth(selectedDate.month, selectedDate.year):
            sum = $i
            labelButton(sum):
              selectedDate.monthdayZero = i
              comboClose()
          {.warning[Deprecated]: on.}
      treeNode("Input", minimized, 11):
        setLayoutRowStatic(25, 2, ratio)
        label("Default:")
        editString(text[0], 64)
        label("Int:")
        editString(text[1], 64, filter = nk_filter_decimal)
        label("Float:")
        editString(text[2], 64, filter = nk_filter_float)
        label("Hex:")
        editString(text[4], 64, filter = nk_filter_hex)
        label("Octal:")
        editString(text[5], 64, filter = nk_filter_oct)
        label("Binary:")
        editString(text[6], 64, filter = nk_filter_binary)
        label("Password:")
        var buffer = text[8]
        for ch in buffer.mitems:
          ch = '*'
        editString(buffer, 64, field)
        text[8] = buffer
        label("Field:")
        editString(fieldBuffer, 64, field)
        label("Box:")
        setLayoutRowStatic(180, 278, 1)
        editString(boxBuffer, 512, box)
        setLayoutRowStatic(25, 2, ratio)
        boxActive = editString(text[7], 64, field, nk_filter_ascii, {sigEnter})
        labelButton("Submit"):
          text_len[7].inc
          boxBuffer.add(text[7] & "\n")
          boxLen = boxLen + textLen[7] + 1
          text[7] = ""
          textLen[7] = 0
        if boxActive == commited:
          text_len[7].inc
          boxBuffer.add(text[7] & "\n")
          boxLen = boxLen + textLen[7] + 1
          text[7] = ""
          textLen[7] = 0
    treeTab("Charts", minimized, 12):
      var
        chartId: cfloat = 0
        chartIndex = -1
      setLayoutRowDynamic(100, 1)
      chart(lines, 32, -1.0, 1.0):
        for i in 0 .. 31:
          let res = chartPush(cos(chartId))
          if res == hovering:
            chartIndex = i
          if res == clicked:
            lineIndex = i
          chartId = chartId + chartStep
      if chartIndex != -1:
        fmtTooltip("Value: %.2f", cos(chartIndex.cfloat *
            chartStep).cfloat)
      if lineIndex != 1:
        setLayoutRowDynamic(20, 1)
        fmtLabel(left, "Selected value: %.2f", cos(
            chartIndex.cfloat * chartStep).cfloat)
      setLayoutRowDynamic(100, 1)
      chart(column, 32, 0.0, 1.0):
        for i in 0 .. 31:
          let res = chartPush(abs(sin(chartId)))
          if res == hovering:
            chartIndex = i
          if res == clicked:
            colIndex = i
          chartId = chartId + chartStep
      if chartIndex != -1:
        fmtTooltip("Value: %.2f", abs(sin(chartStep *
            chartIndex.cfloat).cfloat))
      if col_index != -1:
        setLayoutRowDynamic(20, 1)
        fmtLabel(left, "Selected value: %.2f", abs(sin(
            chartStep * colIndex.cfloat).cfloat))
      setLayoutRowDynamic(100, 1)
      chart(column, 32, 0.0, 1.0):
        addChartSlot(lines, 32, -1.0, 1.0)
        addChartSlot(lines, 32, -1.0, 1.0)
        chartId = 0
        for i in 0 .. 31:
          chartPushSlot(abs(sin(chartId)), 0)
          chartPushSlot(cos(chartId), 1)
          chartPushSlot(sin(chartId), 2)
          chartId = chartId + chartStep
      setLayoutRowDynamic(100, 1)
      colorChart(lines, NkColor(r: 255, g: 0, b: 0),
          NkColor(r: 150, g: 0, b: 0), 32, 0.0, 1.0):
        addColorChartSlot(lines, NkColor(r: 0, g: 0, b: 255),
            NkColor(r: 0, g: 0, b: 150), 32, -1.0, 1.0)
        addColorChartSlot(lines, NkColor(r: 0, g: 255, b: 0),
            NkColor(r: 0, g: 150, b: 0), 32, -1.0, 1.0)
        chartId = 0
        for i in 0 .. 31:
          chartPushSlot(abs(sin(chartId)), 0)
          chartPushSlot(cos(chartId), 1)
          chartPushSlot(sin(chartId), 2)
          chartId = chartId + chartStep
    treeTab("Popup", minimized, 13):
      setLayoutRowStatic(30, 160, 1)
      var bounds = getWidgetBounds()
      label("Right click me for menu")
      contextualMenu({windowNoFlags}, 100, 300, bounds, right):
        setLayoutRowDynamic(25, 1);
        checkbox("Menu", showMenu)
        progressBar(prog, 100)
        slider(0, slider, 16, 1)
        contextualItemLabel("About", centered):
          showAppAbout = true
        selectableLabel((if selected[0]: "Uns" else: "S") & "elect", selected[0])
        selectableLabel((if selected[1]: "Uns" else: "S") & "elect", selected[1])
        selectableLabel((if selected[2]: "Uns" else: "S") & "elect", selected[2])
        selectableLabel((if selected[3]: "Uns" else: "S") & "elect", selected[3])
      layoutStatic(30, 2):
        row(120):
          label("Right Click here:")
        row(50):
          bounds = getWidgetBounds()
          colorButton(popupColor.r, popupColor.g, popupColor.b):
            discard
      contextualMenu({windowNoFlags}, 350, 60, bounds, right):
        setLayoutRowDynamic(30, 4);
        popupColor.r = property2("#r", 0, popupColor.r, 255, 1, 1)
        popupColor.g = property2("#g", 0, popupColor.g, 255, 1, 1)
        popupColor.b = property2("#b", 0, popupColor.b, 255, 1, 1)
        popupColor.a = property2("#a", 0, popupColor.a, 255, 1, 1)
      layoutStatic(30, 2):
        row(120):
          label("Popup:")
        row(50):
          labelButton("Popup"):
            popup_active = true
      if popupActive:
        try:
          popup(staticPopup, "Error", {windowNoFlags}, 20, 100, 220, 90):
            setLayoutRowDynamic(25, 1)
            label("A terrible error as occurred")
            setLayoutRowDynamic(25, 2)
            labelButton("OK"):
              popupActive = false
              closePopup()
            labelButton("Cancel"):
              popupActive = false
              closePopup()
        except:
          popupActive = false
      setLayoutRowStatic(30, 150, 1)
      bounds = getWidgetBounds()
      label("Hover me for tooltip")
      if isMouseHovering(bounds):
        tooltip("This is a tooltip")
    treeTab("Layout", minimized, 14):
      treeNode("Widget", minimized, 15):
        setLayoutRowDynamic(30, 1)
        label("Dynamic fixed column layout with generated position and size:")
        setLayoutRowDynamic(30, 3)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        setLayoutRowDynamic(30, 1)
        label("Static fixed column layout with generated position and size:")
        setLayoutRowStatic(30, 100, 3)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        setLayoutRowDynamic(30, 1)
        label("Dynamic array-based custom column layout with generated position and custom size:")
        setLayoutRowDynamic(30, 3, ratioTwo)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        setLayoutRowDynamic(30, 1)
        label("Static array-based custom column layout with generated position and custom size:")
        setLayoutRowStatic(30, 3, widthTwo)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        setLayoutRowDynamic(30, 1)
        label("Dynamic immediate mode custom column layout with generated position and custom size:")
        layoutDynamic(30, 3):
          row(0.2):
            labelButton("button"):
              discard
          row(0.6):
            labelButton("button"):
              discard
          row(0.2):
            labelButton("button"):
              discard
        setLayoutRowDynamic(30, 1)
        label("Static immediate mode custom column layout with generated position and custom size:")
        layoutStatic(30, 3):
          row(100):
            labelButton("button"):
              discard
          row(200):
            labelButton("button"):
              discard
          row(50):
            labelButton("button"):
              discard
        setLayoutRowDynamic(30, 1)
        label("Static free space with custom position and custom size:")
        layoutSpaceStatic(60, 4):
          row(100, 0, 100, 30):
            labelButton("button"):
              discard
          row(0, 15, 100, 30):
            labelButton("button"):
              discard
          row(200, 15, 100, 30):
            labelButton("button"):
              discard
          row(100, 30, 100, 30):
            labelButton("button"):
              discard
        setLayoutRowDynamic(30, 1)
        label("Row template:")
        setRowTemplate(30):
          rowTemplateDynamic()
          rowTemplateVariable(80)
          rowTemplateStatic(80)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
      treeNode("Group", minimized, 16):
        var groupFlags: set[PanelFlags]
        if groupBorder:
          groupFlags.incl(windowBorder)
        if groupNoScrollbar:
          groupFlags.incl(windowNoScrollbar)
        if groupTitlebar:
          groupFlags.incl(windowTitle)
        setLayoutRowDynamic(30, 3)
        checkbox("Titlebar", groupTitlebar)
        checkbox("Border", groupBorder)
        checkbox("No Scrollbar", groupNoScrollbar)
        layoutStatic(22, 3):
          row(50):
            label("size:")
          row(130):
            property("#Width:", 100, groupWidth, 500, 10, 1)
          row(130):
            property("#Height:", 100, groupHeight, 500, 10, 1)
        setLayoutRowStatic(groupHeight.cfloat, groupWidth, 2)
        group("Group", groupFlags):
          setLayoutRowStatic(18, 100, 1)
          for i in 0 .. 15:
            selectableLabel((if selected2[i]: "Selected" else: "Unselected"),
                selected2[i], centered)
      treeNode("Tree", minimized, 17):
        var sel = rootSelected
        treeElement(node, "Root", minimized, sel, 1):
          var nodeSelect = selected3[0]
          if sel != rootSelected:
            rootSelected = sel
            for i in 0 .. 7:
              selected3[i] = sel
          treeElement(node, "Node", minimized, nodeSelect, 2):
            if nodeSelect != selected3[0]:
              selected3[0] = nodeSelect
              for i in 0 .. 3:
                selected[i] = nodeSelect
            setLayoutRowStatic(18, 100, 1)
            for j in 0 .. 3:
              selectableSymbolLabel(circleSolid, (
                  if selected[j]: "Selected" else: "Unselected"),
                  selected[j], right)
          setLayoutRowStatic(18, 100, 1)
          for i in 0 .. 7:
            selectableSymbolLabel(circleSolid, (
                if selected3[i]: "Selected" else: "Unselected"),
                selected3[i], right)
      treeNode("Notebook", minimized, 18):
        changeStyle(field = spacing, x = 0, y = 0):
          changeStyle(field = buttonRounding, value = 0):
            layoutStatic(20, 3):
              for i in 0 .. 2:
                let
                  textWidth = getTextWidth(names[i])
                  widgetWidth = textWidth + 3 * getButtonStyle(padding).x;
                row(widgetWidth):
                  if currentTab == i:
                    saveButtonStyle()
                    setButtonStyle2(active, normal)
                    currentTab = current_tab
                    labelButton(names[i]):
                      currentTab = i.cint
                    restoreButtonStyle()
                  else:
                    currentTab = current_tab
                    labelButton(names[i]):
                      currentTab = i.cint
        setLayoutRowDynamic(140, 1)
        group("Notebook", {windowBorder}):
          var id: cfloat
          let step: cfloat = (2 * 3.141592654f) / 32
          case currentTab
          of 0:
            setLayoutRowDynamic(100, 1)
            colorChart(lines, NkColor(r: 255, g: 0, b: 0, a: 255), NkColor(
                r: 150, g: 0, b: 0, a: 255), 32, 0.0, 1.0):
              addColorChartSlot(lines, NkColor(r: 0, g: 0, b: 255, a: 255),
                  NkColor(r: 0, g: 0, b: 150, a: 255), 32, -1.0, 1.0)
              id = 0.0
              for i in 0 .. 31:
                chartPushSlot(abs(sin(id)), 0)
                chartPushSlot(cos(id), 1)
                id = id + step
          of 1:
            setLayoutRowDynamic(100, 1)
            colorChart(column, NkColor(r: 255, g: 0, b: 0, a: 255), NkColor(
                r: 150, g: 0, b: 0, a: 255), 32, 0.0, 1.0):
              id = 0.0
              for i in 0 .. 31:
                chartPushSlot(abs(sin(id)), 0)
                id = id + step
          of 2:
            setLayoutRowDynamic(100, 1)
            colorChart(lines, NkColor(r: 255, g: 0, b: 0, a: 255), NkColor(
                r: 150, g: 0, b: 0, a: 255), 32, 0.0, 1.0):
              addColorChartSlot(lines, NkColor(r: 0, g: 0, b: 255, a: 255),
                  NkColor(r: 0, g: 0, b: 150, a: 255), 32, -1.0, 1.0)
              addColorChartSlot(column, NkColor(r: 0, g: 255, b: 0), NkColor(
                  r: 0, g: 150, b: 0), 32, 0.0, 1.0)
              id = 0.0
              for i in 0 .. 31:
                chartPushSlot(abs(sin(id)), 0)
                chartPushSlot(abs(cos(id)), 1)
                chartPushSlot(abs(sin(id)), 2)
                id = id + step
          else:
            discard
      treeNode("Simple", minimized, 19):
        setLayoutRowDynamic(300, 2)
        group("Group_Without_Border", {windowNoFlags}):
          setLayoutRowStatic(18, 150, 1)
          for i in 0 .. 63:
            fmtLabel(left, "%s: scrollable region",
                fmt"{i:#X}".cstring)
        group("Group_With_Border", {windowBorder}):
          setLayoutRowDynamic(25, 2)
          for i in 0 .. 63:
            let number = (((i mod 7) * 10)) + (64 + (i mod 2) * 2)
            labelButton(fmt"{number:08}"):
              discard
      treeNode("Complex", minimized, 20):
        layoutSpaceStatic(500, 64):
          row(0, 0, 150, 500):
            group("Group_left", {windowBorder}):
              setLayoutRowStatic(18, 100, 1)
              for i in 0 .. 31:
                selectableLabel((if selected4[
                    i]: "Selected" else: "Unselected"), selected4[i], centered)
          row(160, 0, 150, 240):
            group("Group_top", {windowBorder}):
              setLayoutRowDynamic(25, 1)
              labelButton("#FFAA"):
                discard
              labelButton("#FFBB"):
                discard
              labelButton("#FFCC"):
                discard
              labelButton("#FFDD"):
                discard
              labelButton("#FFEE"):
                discard
              labelButton("#FFFF"):
                discard
          row(160, 250, 150, 250):
            group("Group_buttom", {windowBorder}):
              setLayoutRowDynamic(25, 1)
              labelButton("#FFAA"):
                discard
              labelButton("#FFBB"):
                discard
              labelButton("#FFCC"):
                discard
              labelButton("#FFDD"):
                discard
              labelButton("#FFEE"):
                discard
              labelButton("#FFFF"):
                discard
          row(320, 0, 150, 150):
            group("Group_right_top", {windowBorder}):
              setLayoutRowStatic(18, 100, 1)
              for i in 0 .. 3:
                selectableLabel((if selected[i]: "Selected" else: "Unselected"),
                    selected[i], centered)
          row(320, 160, 150, 150):
            group("Group_right_center", {windowBorder}):
              setLayoutRowStatic(18, 100, 1)
              for i in 0 .. 3:
                selectableLabel((if selected[i]: "Selected" else: "Unselected"),
                    selected[i], centered)
          row(320, 320, 150, 150):
            group("Group_right_bottom", {windowBorder}):
              setLayoutRowStatic(18, 100, 1)
              for i in 0 .. 3:
                selectableLabel((if selected[i]: "Selected" else: "Unselected"),
                    selected[i], centered)
      treeNode("Splitter", minimized, 21):
        setLayoutRowStatic(20, 320, 1)
        label("Use slider and spinner to change tile size")
        label("Drag the space between tiles to change tile ratio")
        treeNode("Vertical", minimized, 21):
          let rowLayout: array[5, cfloat] = [a.cfloat, 8, b.cfloat, 8, c.cfloat]
          setLayoutRowStatic(30, 100, 2)
          label("left:")
          slider(10.0, a, 200.0, 10.0)
          label("middle:")
          slider(10.0, b, 200.0, 10.0)
          label("right:")
          slider(10.0, c, 200.0, 10.0)
          setLayoutRowStatic(200, 5, rowLayout)
          group("left", {windowNoScrollbar, windowBorder}):
            setLayoutRowDynamic(25, 1)
            labelButton("#FFAA"):
              discard
            labelButton("#FFBB"):
              discard
            labelButton("#FFCC"):
              discard
            labelButton("#FFDD"):
              discard
            labelButton("#FFEE"):
              discard
            labelButton("#FFFF"):
              discard
          var bounds = getWidgetBounds()
          addSpacing(1)
          if (isMouseHovering(bounds) or
              isMousePrevHovering(bounds)) and isMouseDown(left):
            a = rowLayout[0] + getMouseDelta().x
            b = rowLayout[2] - getMouseDelta().x
          group("center", {windowBorder, windowNoScrollbar}):
            setLayoutRowDynamic(25, 1)
            labelButton("#FFAA"):
              discard
            labelButton("#FFBB"):
              discard
            labelButton("#FFCC"):
              discard
            labelButton("#FFDD"):
              discard
            labelButton("#FFEE"):
              discard
            labelButton("#FFFF"):
              discard
          bounds = getWidgetBounds()
          addSpacing(1)
          if (isMouseHovering(bounds) or
              isMousePrevHovering(bounds)) and isMouseDown(left):
            b = rowLayout[2] + getMouseDelta().x
            c = rowLayout[4] - getMouseDelta().x
          group("right", {windowBorder, windowNoScrollbar}):
            setLayoutRowDynamic(25, 1)
            labelButton("#FFAA"):
              discard
            labelButton("#FFBB"):
              discard
            labelButton("#FFCC"):
              discard
            labelButton("#FFDD"):
              discard
            labelButton("#FFEE"):
              discard
            labelButton("#FFFF"):
              discard
        treeNode("Horizontal", minimized, 22):
          setLayoutRowStatic(30, 100, 2)
          label("top:")
          slider(10.0, a, 200.0, 10.0)
          label("middle:")
          slider(10.0, b, 200.0, 10.0)
          label("bottom:")
          slider(10.0, c, 200.0, 10.0)
          setLayoutRowDynamic(a, 1)
          group("top", {windowBorder, windowNoScrollbar}):
            setLayoutRowDynamic(25, 3)
            labelButton("#FFAA"):
              discard
            labelButton("#FFBB"):
              discard
            labelButton("#FFCC"):
              discard
            labelButton("#FFDD"):
              discard
            labelButton("#FFEE"):
              discard
            labelButton("#FFFF"):
              discard
          setLayoutRowDynamic(8, 1)
          var bounds = getWidgetBounds()
          addSpacing(1)
          if (isMouseHovering(bounds) or
              isMousePrevHovering(bounds)) and isMouseDown(left):
            a = a + getMouseDelta().y
            b = b - getMouseDelta().y
          setLayoutRowDynamic(b, 1)
          group("middle", {windowBorder, windowNoScrollbar}):
            setLayoutRowDynamic(25, 3)
            labelButton("#FFAA"):
              discard
            labelButton("#FFBB"):
              discard
            labelButton("#FFCC"):
              discard
            labelButton("#FFDD"):
              discard
            labelButton("#FFEE"):
              discard
            labelButton("#FFFF"):
              discard
          setLayoutRowDynamic(8, 1)
          bounds = getWidgetBounds()
          if (isMouseHovering(bounds) or
              isMousePrevHovering(bounds)) and isMouseDown(left):
            b = b + getMouseDelta().y
            c = c - getMouseDelta().y
          setLayoutRowDynamic(c, 1)
          group("bottom", {windowBorder, windowNoScrollbar}):
            setLayoutRowDynamic(25, 3)
            labelButton("#FFAA"):
              discard
            labelButton("#FFBB"):
              discard
            labelButton("#FFCC"):
              discard
            labelButton("#FFDD"):
              discard
            labelButton("#FFEE"):
              discard
            labelButton("#FFFF"):
              discard
