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

# Nuklear overview demo translated to Nim (for Xlib binding)

import std/[math, strformat, times]
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
    COL_RGB, COL_HSV
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
  windowFlags: set[WindowFlags]
  showAppAbout, groupTitlebar, groupNoScrollbar: bool = false
  prog, progValue = 40
  slider, mslider: int = 10
  propertyInt, propertyNeg: int = 10
  mprog = 60
  menuState = menuNone.ord
  state = minimized
  option = A
  intSlider: int = 5
  floatSlider: cfloat = 2.5
  propertyFloat: cfloat = 2.0
  rangeFloatMin: cfloat = 0
  rangeFloatMax: cfloat = 100
  rangeFloatValue: cfloat = 50
  rangeIntMin: int = 0
  rangeIntMax: int = 2048
  rangeIntValue: int = 4096
  selected: array[4, nk_bool] = [nk_false, nk_false, nk_true, nk_false]
  selected2: array[16, nk_bool] = [nk_true, nk_false, nk_false, nk_false,
    nk_false, nk_true, nk_false, nk_false, nk_false, nk_false, nk_true,
    nk_false, nk_false, nk_false, nk_false, nk_true]
  currentWeapon: int = 0
  comboColor: NimColor = NimColor(r: 130, g: 50, b: 50, a: 255)
  comboColor2: NimColorF = NimColorF(r: 0.509, g: 0.705, b: 0.2, a: 1.0)
  colMode: ColorMode
  progA: nk_size = 20
  progB: nk_size = 40
  progC: nk_size = 10
  progD: nk_size = 90
  checkValues: array[5, bool]
  position: array[3, cfloat]
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
  popupColor: NimColor = NimColor(r: 255, g: 0, b: 0, a: 255)
  groupWidth: int = 320
  groupHeight: int = 200
  rootSelected: nk_bool
  selected3: array[8, nk_bool]
  currentTab: cint = 0
  selected4: array[32, nk_bool]
  a, b, c: cfloat = 100

proc overview*(ctx: PContext) =
  windowFlags = {}
  headerAlign(headerRight)
  if border:
    windowFlags.incl(windowBorder)
  if resize:
    windowFlags.incl(windowScalable)
  if movable:
    windowFlags.incl(windowMoveable)
  if noScrollbar:
    windowFlags.incl(windowNoScrollbar)
  if scaleLeft:
    windowFlags.incl(windowScaleLeft)
  if minimizable:
    windowFlags.incl(windowMinimizable)
  window("Overview", 275, 10, 400, 600, windowFlags):
    if showMenu:
      # menubar
      menuBar:
        layoutStatic(25, 5):
          # menu #1
          row(45):
            menu("MENU", left, 120, 200):
              setLayoutRowDynamic(25, 1)
              menuItem("Hide", left):
                showMenu = false
              menuItem("About", left):
                showAppAbout = true
              progressBar(prog, 100)
              slider(0, slider, 16, 1)
              checkbox("check", check)
          # menu 2
          row(60):
            menu("ADVANCED", left, 200, 600):
              treeTab("FILE", state, menuState, menuFile.ord):
                menuItem("New", left):
                  discard
                menuItem("Open", left):
                  discard
                menuItem("Save", left):
                  discard
                menuItem("Close", left):
                  discard
                menuItem("Exit", left):
                  discard
              treeTab("EDIT", state, menuState, menuEdit.ord):
                menuItem("Copy", left):
                  discard
                menuItem("Delete", left):
                  discard
                menuItem("Cut", left):
                  discard
                menuItem("Paste", left):
                  discard
              treeTab("VIEW", state, menuState, menuView.ord):
                menuItem("About", left):
                  discard
                menuItem("Options", left):
                  discard
                menuItem("Customize", left):
                  discard
              treeTab("CHART", state, menuState, menuChart.ord):
                setLayoutRowDynamic(150, 1)
                chart(column, values.len, 0, 50):
                  for value in values:
                    chartPush(value)
          # menu widgets
          row(70):
            progressBar(mprog, 100)
            slider(0, mslider, 16, 1)
            checkbox("check", mcheck)
    if showAppAbout:
      try:
        popup(staticPopup, "About", {windowCloseable}, 20, 100,
            300, 190):
          setLayoutRowDynamic(20, 1)
          label("Nuklear")
          label("By Micha Mettke")
          label("nuklear is licensed under the public domain License.")
      except:
        showAppAbout = false
    treeTab("Window", minimized, 1):
      setLayoutRowDynamic(30, 2)
      checkbox("Titlebar", titlebar)
      checkbox("Menu", showMenu)
      checkbox("Border", border)
      checkbox("Resizable", resize)
      checkbox("Movable", movable)
      checkbox("No Scrollbar", noScrollbar)
      checkbox("Minimizable", minimizable)
      checkbox("Scale Left", scaleLeft)
    treeTab("Widgets", minimized, 2):
      treeNode("Text", minimized, 3):
        setLayoutRowDynamic(20, 1)
        label("Label aligned left")
        label("Label aligned centered", centered)
        label("Label aligned right", right)
        colorLabel("Blue text", 0, 0, 255)
        colorLabel("Yellow text", 255, 255, 0)
        text("Text without /0", alignment = right)
        setLayoutRowStatic(100, 200, 1)
        wrapLabel("This is a very long line to hopefully get this text to be wrapped into multiple lines to show line wrapping")
        setLayoutRowDynamic(100, 1)
        wrapLabel("This is another long text to show dynamic window changes on multiline text")
      treeNode("Button", minimized, 4):
        setLayoutRowStatic(30, 100, 3)
        labelButton("Button"):
          echo "Button pressed!"
        setButtonBehavior(repeater)
        labelButton("Repeater"):
          echo "Repeater is being pressed!"
        setButtonBehavior(default)
        colorButton(0, 0, 255):
          discard
        setLayoutRowStatic(25, 25, 8)
        symbolButton(circleSolid):
          discard
        symbolButton(circleOutline):
          discard
        symbolButton(rectSolid):
          discard
        symbolButton(rectOutline):
          discard
        symbolButton(triangleUp):
          discard
        symbolButton(triangleDown):
          discard
        symbolButton(triangleLeft):
          discard
        symbolButton(triangleRight):
          discard
        setLayoutRowStatic(30, 100, 2)
        symbolLabelButton(triangleLeft, "prev", right):
          discard
        symbolLabelButton(triangleRight, "next", left):
          discard
      treeNode("Basic", minimized, 5):
        setLayoutRowStatic(30, 100, 1)
        checkbox("Checkbox", checkbox)
        setLayoutRowStatic(30, 80, 3)
        if option("optionA", option == A):
          option = A
        if option("optionB", option == B):
          option = B
        if option("optionC", option == C):
          option = C
        setLayoutRowStatic(30, 2, ratio.addr)
        nk_labelf(ctx, NK_TEXT_LEFT, "Slider int")
        slider(0, intSlider, 10, 1)
        label("Slider float")
        discard nk_slider_float(ctx, 0, float_slider, 5.0, 0.5f)
        nk_labelf(ctx, NK_TEXT_LEFT, "Progressbar: %u", progValue)
        progressBar(prog_value, 100)
        setLayoutRowStatic(25, 2, ratio.addr)
        label("Property float:")
        nk_property_float(ctx, "Float:", 0, propertyFloat, 64.0, 0.1, 0.2)
        label("Property int:")
        property("Int:", 0, propertyInt, 100, 1, 1)
        label("Property neg:")
        property("Neg:", -10, propertyNeg, 10, 1, 1)
        setLayoutRowDynamic(25, 1)
        label("Range:")
        setLayoutRowDynamic(25, 3)
        nk_property_float(ctx, "#min:", 0, rangeFloatMin, rangeFloatMax, 1.0, 0.2)
        nk_property_float(ctx, "#float:", rangeFloatMin, rangeFloatValue,
            rangeFloatMax, 1.0, 0.2)
        nk_property_float(ctx, "#max:", rangeFloatMin, rangeFloatMax, 100, 1.0, 0.2)
        property("#min:", cint.low, rangeIntMin, rangeIntMax, 1, 10)
        property("#neg:", rangeIntMin, rangeIntValue, rangeIntMax,
            1, 10)
        property("#max:", rangeIntMin, rangeIntMax, cint.high, 1, 10)
      treeNode("Inactive", minimized, 6):
        setLayoutRowDynamic(30, 1)
        checkbox("Inactive", inactive)
        setLayoutRowStatic(30, 80, 1)
        if inactive == 1:
          saveButtonStyle(ctx)
          setButtonStyle(ctx, normal, 40, 40, 40)
          setButtonStyle(ctx, hover, 40, 40, 40)
          setButtonStyle(ctx, active, 40, 40, 40)
          setButtonStyle(ctx, borderColor, 60, 60, 60)
          setButtonStyle(ctx, textBackground, 60, 60, 60)
          setButtonStyle(ctx, textNormal, 60, 60, 60)
          setButtonStyle(ctx, textHover, 60, 60, 60)
          setButtonStyle(ctx, textActive, 60, 60, 60)
          labelButton("button"):
            discard
          restoreButtonStyle(ctx)
        else:
          labelButton("button"):
            echo "button pressed"
      treeNode("Selectable", minimized, 7):
        treeNode("List", minimized, 8):
          setLayoutRowStatic(18, 100, 1)
          discard nk_selectable_label(ctx, "Selectable", NK_TEXT_LEFT,
              selected[0])
          discard nk_selectable_label(ctx, "Selectable", NK_TEXT_LEFT,
              selected[1])
          label("Not Selectable")
          discard nk_selectable_label(ctx, "Selectable", NK_TEXT_LEFT,
              selected[2])
          discard nk_selectable_label(ctx, "Selectable", NK_TEXT_LEFT,
              selected[3])
        treeNode("Grid", minimized, 9):
          setLayoutRowStatic(50, 50, 4)
          for index, value in selected2.mpairs:
            if nk_selectable_label(ctx, "Z", NK_TEXT_CENTERED, value):
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
        if createColorCombo(ctx, comboColor, 200, 200):
          let ratios: array[2, cfloat] = [0.15.cfloat, 0.85]
          setLayoutRowDynamic(30, 2, ratios.addr)
          label("R:")
          comboColor.r = nk_slide_int(ctx, 0, comboColor.r, 255, 5)
          label("G:")
          comboColor.g = nk_slide_int(ctx, 0, comboColor.g, 255, 5)
          label("B:")
          comboColor.b = nk_slide_int(ctx, 0, comboColor.b, 255, 5)
          label("A:")
          comboColor.a = nk_slide_int(ctx, 0, comboColor.a, 255, 5)
          nk_combo_end(ctx)
        if createColorCombo(ctx, comboColor2, 200, 400):
          setLayoutRowDynamic(120, 1)
          comboColor2 = colorPicker(ctx, comboColor2, NK_RGBA)
          setLayoutRowDynamic(25, 2)
          if option("RGB", colMode == COL_RGB):
            colMode = COL_RGB
          if option("HSV", colMode == COL_HSV):
            colMode = COL_HSV
          setLayoutRowDynamic(25, 1)
          if colMode == COL_RGB:
            comboColor2.r = nk_propertyf(ctx, "#R:", 0, comboColor2.r, 1.0,
                0.01, 0.005)
            comboColor2.g = nk_propertyf(ctx, "#G:", 0, comboColor2.g, 1.0,
                0.01, 0.005)
            comboColor2.b = nk_propertyf(ctx, "#B:", 0, comboColor2.b, 1.0,
                0.01, 0.005)
            comboColor2.a = nk_propertyf(ctx, "#A:", 0, comboColor2.a, 1.0,
                0.01, 0.005)
          else:
            var hsva: array[4, cfloat]
            colorfToHsva(hsva, comboColor2)
            hsva[0] = nk_propertyf(ctx, "#H:", 0, hsva[0], 1.0, 0.01, 0.05)
            hsva[1] = nk_propertyf(ctx, "#S:", 0, hsva[1], 1.0, 0.01, 0.05)
            hsva[2] = nk_propertyf(ctx, "#V:", 0, hsva[2], 1.0, 0.01, 0.05)
            hsva[3] = nk_propertyf(ctx, "#A:", 0, hsva[3], 1.0, 0.01, 0.05)
            comboColor2 = hsvaToColorf(hsva)
          nk_combo_end(ctx)
        var sum = $(progA + progB + progC + progD)
        if createLabelCombo(ctx, sum.cstring, 200, 200):
          setLayoutRowDynamic(30, 1)
          progressBar(progA, 100)
          progressBar(progB, 100)
          progressBar(progC, 100)
          progressBar(progD, 100)
          nk_combo_end(ctx)
        sum = $(checkValues[0] + checkValues[1] + checkValues[2] + checkValues[
            3] + checkValues[4])
        if createLabelCombo(ctx, sum.cstring, 200, 200):
          setLayoutRowDynamic(30, 1)
          checkBox(weapons[0], checkValues[0])
          checkBox(weapons[1], checkValues[1])
          checkBox(weapons[2], checkValues[2])
          checkBox(weapons[3], checkValues[3])
          checkBox(weapons[4], checkValues[4])
          nk_combo_end(ctx)
        sum = $position[0] & " " & $position[1] & " " & $position[2]
        if createLabelCombo(ctx, sum.cstring, 200, 200):
          setLayoutRowDynamic(25, 1)
          nk_property_float(ctx, "#X:", -1024.0, position[0], 1024.0, 1, 0.5)
          nk_property_float(ctx, "#Y:", -1024.0, position[1], 1024.0, 1, 0.5)
          nk_property_float(ctx, "#Z:", -1024.0, position[2], 1024.0, 1, 0.5)
          nk_combo_end(ctx)
        sum = $chartSelection
        if createLabelCombo(ctx, sum.cstring, 200, 250):
          setLayoutRowDynamic(150, 1)
          chart(column, values.len, 0, 50):
            for value in values:
              if chartPush(value) == clicked:
                chartSelection = value
                nk_combo_close(ctx)
          nk_combo_end(ctx)
        if not timeSelected and not dateSelected:
          selectedDate = now()
        sum = $selectedDate.hour & ":" & $selectedDate.minute & ":" &
            $selectedDate.second
        if createLabelCombo(ctx, sum.cstring, 200, 250):
          timeSelected = true
          setLayoutRowDynamic(25, 1)
          {.warning[Deprecated]: off.}
          selectedDate.second = nk_propertyi(ctx, "#S:", 0, selectedDate.second,
              60, 1, 1)
          selectedDate.minute = nk_propertyi(ctx, "#M:", 0, selectedDate.minute,
              60, 1, 1)
          selectedDate.hour = nk_propertyi(ctx, "#H:", 0, selectedDate.hour, 23,
              1, 1)
          nk_combo_end(ctx);
        sum = $selectedDate.monthday & "-" & $selectedDate.month & "-" &
            $selectedDate.year
        if createLabelCombo(ctx, sum.cstring, 350, 400):
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
            nk_spacing(ctx, spacing.cint)
          for i in 1 .. getDaysInMonth(selectedDate.month, selectedDate.year):
            sum = $i
            labelButton(sum):
              selectedDate.monthdayZero = i
              nk_combo_close(ctx)
          {.warning[Deprecated]: on.}
          nk_combo_end(ctx)
      treeNode("Input", minimized, 11):
        setLayoutRowStatic(25, 2, ratio.addr)
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
        setLayoutRowStatic(25, 2, ratio.addr)
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
        nk_tooltipf(ctx, "Value: %.2f", cos(chartIndex.cfloat *
            chartStep).cfloat)
      if lineIndex != 1:
        setLayoutRowDynamic(20, 1)
        nk_labelf(ctx, NK_TEXT_LEFT, "Selected value: %.2f", cos(
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
        nk_tooltipf(ctx, "Value: %.2f", abs(sin(chartStep *
            chartIndex.cfloat).cfloat));
      if col_index != -1:
        setLayoutRowDynamic(20, 1)
        nk_labelf(ctx, NK_TEXT_LEFT, "Selected value: %.2f", abs(sin(
            chartStep * colIndex.cfloat).cfloat))
      setLayoutRowDynamic(100, 1)
      chart(column, 32, 0.0, 1.0):
        nk_chart_add_slot(ctx, lines, 32, -1.0, 1.0)
        nk_chart_add_slot(ctx, lines, 32, -1.0, 1.0)
        chartId = 0
        for i in 0 .. 31:
          discard nk_chart_push_slot(ctx, abs(sin(chartId)), 0)
          discard nk_chart_push_slot(ctx, cos(chartId), 1)
          discard nk_chart_push_slot(ctx, sin(chartId), 2)
          chartId = chartId + chartStep
      setLayoutRowDynamic(100, 1)
      if createColorChart(ctx, lines, NimColor(r: 255, g: 0, b: 0),
          NimColor(r: 150, g: 0, b: 0), 32, 0.0, 1.0):
        addColorChartSlot(ctx, lines, NimColor(r: 0, g: 0, b: 255),
            NimColor(r: 0, g: 0, b: 150), 32, -1.0, 1.0)
        addColorChartSlot(ctx, lines, NimColor(r: 0, g: 255, b: 0),
            NimColor(r: 0, g: 150, b: 0), 32, -1.0, 1.0)
        chartId = 0
        for i in 0 .. 31:
          discard nk_chart_push_slot(ctx, abs(sin(chartId)), 0)
          discard nk_chart_push_slot(ctx, cos(chartId), 1)
          discard nk_chart_push_slot(ctx, sin(chartId), 2)
          chartId = chartId + chartStep
        nk_chart_end(ctx)
    treeTab("Popup", minimized, 13):
      setLayoutRowStatic(30, 160, 1)
      var bounds = getWidgetBounds(ctx)
      label("Right click me for menu")
      if createContextual(ctx, 0, 100, 300, bounds):
        setLayoutRowDynamic(25, 1);
        checkbox("Menu", showMenu)
        progressBar(prog, 100)
        slider(0, slider, 16, 1)
        if nk_contextual_item_label(ctx, "About", NK_TEXT_CENTERED):
          showAppAbout = true
        discard nk_selectable_label(ctx, ((if selected[0] ==
            nk_true: "Uns" else: "S") & "elect").cstring, NK_TEXT_LEFT,
            selected[0])
        discard nk_selectable_label(ctx, ((if selected[1] ==
            nk_true: "Uns" else: "S") & "elect").cstring, NK_TEXT_LEFT,
            selected[1])
        discard nk_selectable_label(ctx, ((if selected[2] ==
            nk_true: "Uns" else: "S") & "elect").cstring, NK_TEXT_LEFT,
            selected[2])
        discard nk_selectable_label(ctx, ((if selected[3] ==
            nk_true: "Uns" else: "S") & "elect").cstring, NK_TEXT_LEFT,
            selected[3])
        nk_contextual_end(ctx)
      layoutStatic(30, 2):
        row(120):
          label("Right Click here:")
        row(50):
          bounds = getWidgetBounds(ctx)
          colorButton(popupColor.r, popupColor.g, popupColor.b):
            discard
      if createContextual(ctx, 0, 350, 60, bounds):
        setLayoutRowDynamic(30, 4);
        popupColor.r = nk_propertyi(ctx, "#r", 0, popupColor.r, 255, 1, 1)
        popupColor.g = nk_propertyi(ctx, "#g", 0, popupColor.g, 255, 1, 1)
        popupColor.b = nk_propertyi(ctx, "#b", 0, popupColor.b, 255, 1, 1)
        popupColor.a = nk_propertyi(ctx, "#a", 0, popupColor.a, 255, 1, 1)
        nk_contextual_end(ctx)
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
      bounds = getWidgetBounds(ctx)
      label("Hover me for tooltip")
      if isMouseHovering(ctx, bounds.x, bounds.y, bounds.w, bounds.h):
        nk_tooltip(ctx, "This is a tooltip")
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
        setLayoutRowDynamic(30, 3, ratioTwo.addr)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        setLayoutRowDynamic(30, 1)
        label("Static array-based custom column layout with generated position and custom size:")
        setLayoutRowStatic(30, 3, widthTwo.addr)
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
        nk_layout_space_begin(ctx, NK_STATIC, 60, 4)
        layoutSpacePush(ctx, 100, 0, 100, 30)
        labelButton("button"):
          discard
        layoutSpacePush(ctx, 0, 15, 100, 30)
        labelButton("button"):
          discard
        layoutSpacePush(ctx, 200, 15, 100, 30)
        labelButton("button"):
          discard
        layoutSpacePush(ctx, 100, 30, 100, 30)
        labelButton("button"):
          discard
        nk_layout_space_end(ctx)
        setLayoutRowDynamic(30, 1)
        label("Row template:")
        nk_layout_row_template_begin(ctx, 30)
        nk_layout_row_template_push_dynamic(ctx)
        nk_layout_row_template_push_variable(ctx, 80)
        nk_layout_row_template_push_static(ctx, 80)
        nk_layout_row_template_end(ctx)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
      treeNode("Group", minimized, 16):
        var groupFlags: nk_flags = 0
        if groupBorder == nk_true.cint:
          groupFlags = groupFlags or nkWindowBorder
        if groupNoScrollbar == nk_true.cint:
          groupFlags = groupFlags or nkWindowNoScrollbar
        if groupTitlebar == nk_true.cint:
          groupFlags = groupFlags or nkWindowTitle
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
        if nk_group_begin(ctx, "Group", groupFlags):
          setLayoutRowStatic(18, 100, 1)
          for i in 0 .. 15:
            discard nk_selectable_label(ctx, (if selected2[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected2[i])
          nk_group_end(ctx)
      treeNode("Tree", minimized, 17):
        var sel = rootSelected
        if nk_tree_element_push_hashed(ctx, NK_TREE_NODE, "Root", minimized,
            sel, "overview771", 12, 771):
          var nodeSelect = selected3[0]
          if sel != rootSelected:
            rootSelected = sel
            for i in 0 .. 7:
              selected3[i] = sel
          if nk_tree_element_push_hashed(ctx, NK_TREE_NODE, "Node",
              minimized, node_select, "overview778", 12, 778):
            if nodeSelect != selected3[0]:
              selected3[0] = nodeSelect
              for i in 0 .. 3:
                selected[i] = nodeSelect
            setLayoutRowStatic(18, 100, 1)
            for j in 0 .. 3:
              discard nk_selectable_symbol_label(ctx, circleSolid, (
                  if selected[j] ==
                  nk_true: "Selected" else: "Unselected").cstring,
                  NK_TEXT_RIGHT, selected[j])
            nk_tree_element_pop(ctx)
          setLayoutRowStatic(18, 100, 1)
          for i in 0 .. 7:
            discard nk_selectable_symbol_label(ctx, circleSolid, (
                if selected3[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_RIGHT, selected3[i])
          nk_tree_element_pop(ctx)
      treeNode("Notebook", minimized, 18):
        discard stylePushVec2(ctx, spacing, 0, 0)
        discard stylePushFloat(ctx, rounding, 0)
        layoutStatic(20, 3):
          for i in 0 .. 2:
            let
              textWidth = getTextWidth(names[i])
              widgetWidth = textWidth + 3 * getButtonStyle(ctx, padding).x;
            row(widgetWidth):
              if currentTab == i:
                saveButtonStyle(ctx)
                setButtonStyle2(ctx, active, normal)
                currentTab = current_tab
                labelButton(names[i]):
                  currentTab = i.cint
                restoreButtonStyle(ctx)
              else:
                currentTab = current_tab
                labelButton(names[i]):
                  currentTab = i.cint
        nk_style_pop_float(ctx)
        nk_style_pop_vec2(ctx)
        setLayoutRowDynamic(140, 1)
        if nk_group_begin(ctx, "Notebook", nkWindowBorder):
          var id: cfloat
          let step: cfloat = (2 * 3.141592654f) / 32
          case currentTab
          of 0:
            setLayoutRowDynamic(100, 1)
            if createColorChart(ctx, lines, NimColor(r: 255, g: 0,
                b: 0, a: 255), NimColor(r: 150, g: 0, b: 0, a: 255), 32, 0.0, 1.0):
              addColorChartSlot(ctx, lines, NimColor(r: 0, g: 0,
                  b: 255, a: 255), NimColor(r: 0, g: 0, b: 150, a: 255), 32,
                  -1.0, 1.0)
              id = 0.0
              for i in 0 .. 31:
                discard nk_chart_push_slot(ctx, abs(sin(id)), 0)
                discard nk_chart_push_slot(ctx, cos(id), 1)
                id = id + step
              nk_chart_end(ctx)
          of 1:
            setLayoutRowDynamic(100, 1)
            if createColorChart(ctx, column, NimColor(r: 255, g: 0,
                b: 0, a: 255), NimColor(r: 150, g: 0, b: 0, a: 255), 32, 0.0, 1.0):
              id = 0.0
              for i in 0 .. 31:
                discard nk_chart_push_slot(ctx, abs(sin(id)), 0)
                id = id + step
              nk_chart_end(ctx)
          of 2:
            setLayoutRowDynamic(100, 1)
            if createColorChart(ctx, lines, NimColor(r: 255, g: 0,
                b: 0, a: 255), NimColor(r: 150, g: 0, b: 0, a: 255), 32, 0.0, 1.0):
              addColorChartSlot(ctx, lines, NimColor(r: 0, g: 0,
                  b: 255, a: 255), NimColor(r: 0, g: 0, b: 150, a: 255), 32,
                  -1.0, 1.0)
              addColorChartSlot(ctx, column, NimColor(r: 0, g: 255,
                  b: 0), NimColor(r: 0, g: 150, b: 0), 32, 0.0, 1.0)
              id = 0.0
              for i in 0 .. 31:
                discard nk_chart_push_slot(ctx, abs(sin(id)), 0)
                discard nk_chart_push_slot(ctx, abs(cos(id)), 1)
                discard nk_chart_push_slot(ctx, abs(sin(id)), 2)
                id = id + step
              nk_chart_end(ctx)
          else:
            discard
          nk_group_end(ctx)
      treeNode("Simple", minimized, 19):
        setLayoutRowDynamic(300, 2)
        if nk_group_begin(ctx, "Group_Without_Border", 0):
          setLayoutRowStatic(18, 150, 1)
          for i in 0 .. 63:
            nk_labelf(ctx, NK_TEXT_LEFT, "%s: scrollable region",
                fmt"{i:#X}".cstring)
          nk_group_end(ctx)
        if nk_group_begin(ctx, "Group_With_Border", nkWindowBorder):
          setLayoutRowDynamic(25, 2)
          for i in 0 .. 63:
            let number = (((i mod 7) * 10)) + (64 + (i mod 2) * 2)
            labelButton(fmt"{number:08}"):
              discard
          nk_group_end(ctx)
      treeNode("Complex", minimized, 20):
        nk_layout_space_begin(ctx, NK_STATIC, 500, 64)
        layoutSpacePush(ctx, 0, 0, 150, 500)
        if nk_group_begin(ctx, "Group_left", nkWindowBorder):
          setLayoutRowStatic(18, 100, 1)
          for i in 0 .. 31:
            discard nk_selectable_label(ctx, (if selected4[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected4[i])
          nk_group_end(ctx);
        layoutSpacePush(ctx, 160, 0, 150, 240)
        if nk_group_begin(ctx, "Group_top", nkWindowBorder):
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
          nk_group_end(ctx)
        layoutSpacePush(ctx, 160, 250, 150, 250)
        if nk_group_begin(ctx, "Group_buttom", nkWindowBorder):
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
          nk_group_end(ctx);
        layoutSpacePush(ctx, 320, 0, 150, 150)
        if nk_group_begin(ctx, "Group_right_top", nkWindowBorder):
          setLayoutRowStatic(18, 100, 1)
          for i in 0 .. 3:
            discard nk_selectable_label(ctx, (if selected[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected[i])
          nk_group_end(ctx)
        layoutSpacePush(ctx, 320, 160, 150, 150)
        if nk_group_begin(ctx, "Group_right_center", nkWindowBorder):
          setLayoutRowStatic(18, 100, 1)
          for i in 0 .. 3:
            discard nk_selectable_label(ctx, (if selected[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected[i])
          nk_group_end(ctx);
        layoutSpacePush(ctx, 320, 320, 150, 150)
        if nk_group_begin(ctx, "Group_right_bottom", nkWindowBorder):
          setLayoutRowStatic(18, 100, 1)
          for i in 0 .. 3:
            discard nk_selectable_label(ctx, (if selected[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected[i])
          nk_group_end(ctx);
        nk_layout_space_end(ctx)
      treeNode("Splitter", minimized, 21):
        setLayoutRowStatic(20, 320, 1)
        label("Use slider and spinner to change tile size")
        label("Drag the space between tiles to change tile ratio")
        treeNode("Vertical", minimized, 21):
          var rowLayout: array[5, cfloat] = [a, 8, b, 8, c]
          setLayoutRowStatic(30, 100, 2)
          label("left:")
          discard nk_slider_float(ctx, 10.0, a, 200.0, 10.0)
          label("middle:")
          discard nk_slider_float(ctx, 10.0, b, 200.0, 10.0)
          label("right:")
          discard nk_slider_float(ctx, 10.0, c, 200.0, 10.0)
          setLayoutRowStatic(200, 5, rowLayout.addr)
          if nk_group_begin(ctx, "left", nkWindowNoScrollbar or
              nkWindowBorder or nkWindowNoScrollbar):
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
            nk_group_end(ctx)
          var bounds = getWidgetBounds(ctx)
          nk_spacing(ctx, 1)
          if (isMouseHovering(ctx, bounds.x, bounds.y, bounds.w, bounds.h) or
              isMousePrevHovering(ctx, bounds.x, bounds.y, bounds.w,
              bounds.h)) and isMouseDown(ctx, NK_BUTTON_LEFT):
            a = rowLayout[0] + getMouseDelta(ctx).x
            b = rowLayout[2] - getMouseDelta(ctx).x
          if nk_group_begin(ctx, "center", nkWindowBorder or
              nkWindowNoScrollbar):
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
            nk_group_end(ctx)
          bounds = getWidgetBounds(ctx)
          nk_spacing(ctx, 1)
          if (isMouseHovering(ctx, bounds.x, bounds.y, bounds.w, bounds.h) or
              isMousePrevHovering(ctx, bounds.x, bounds.y, bounds.w,
              bounds.h)) and isMouseDown(ctx, NK_BUTTON_LEFT):
            b = rowLayout[2] + getMouseDelta(ctx).x
            c = rowLayout[4] - getMouseDelta(ctx).x
          if nk_group_begin(ctx, "right", nkWindowBorder or
              nkWindowNoScrollbar):
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
            nk_group_end(ctx)
        treeNode("Horizontal", minimized, 22):
          setLayoutRowStatic(30, 100, 2)
          label("top:")
          discard nk_slider_float(ctx, 10.0, a, 200.0, 10.0)
          label("middle:")
          discard nk_slider_float(ctx, 10.0, b, 200.0, 10.0)
          label("bottom:")
          discard nk_slider_float(ctx, 10.0, c, 200.0, 10.0)
          setLayoutRowDynamic(a, 1)
          if nk_group_begin(ctx, "top", nkWindowBorder or
              nkWindowNoScrollbar):
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
            nk_group_end(ctx)
          setLayoutRowDynamic(8, 1)
          var bounds = getWidgetBounds(ctx)
          nk_spacing(ctx, 1)
          if (isMouseHovering(ctx, bounds.x, bounds.y, bounds.w, bounds.h) or
              isMousePrevHovering(ctx, bounds.x, bounds.y, bounds.w,
              bounds.h)) and isMouseDown(ctx, NK_BUTTON_LEFT):
            a = a + getMouseDelta(ctx).y
            b = b - getMouseDelta(ctx).y
          setLayoutRowDynamic(b, 1)
          if nk_group_begin(ctx, "middle", nkWindowBorder or
              nkWindowNoScrollbar):
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
            nk_group_end(ctx)
          setLayoutRowDynamic(8, 1)
          bounds = getWidgetBounds(ctx)
          if (isMouseHovering(ctx, bounds.x, bounds.y, bounds.w, bounds.h) or
              isMousePrevHovering(ctx, bounds.x, bounds.y, bounds.w,
              bounds.h)) and isMouseDown(ctx, NK_BUTTON_LEFT):
            b = b + getMouseDelta(ctx).y
            c = c - getMouseDelta(ctx).y
          setLayoutRowDynamic(c, 1)
          if nk_group_begin(ctx, "bottom", nkWindowBorder or
              nkWindowNoScrollbar):
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
            nk_group_end(ctx)
