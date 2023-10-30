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
    MENU_NONE, MENU_FILE, MENU_EDIT, MENU_VIEW, MENU_CHART
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
  widthTwo = [100.cfloat, 200, 50]
  names = ["Lines".cstring, "Columns", "Mixed"]
var
  showMenu, titlebar, border, resize, movable, noScrollbar, scaleLeft, minimizable, check, mcheck, checkbox, inactive: bool = true
  windowFlags: set[WindowFlags]
  showAppAbout, groupTitlebar: bool = false
  headerAlign: nk_style_header_align = NK_HEADER_RIGHT
  prog, progValue = 40
  slider, mslider, propertyInt, propertyNeg: cint = 10
  mprog = 60
  menuState = MENU_NONE
  state = NK_MINIMIZED
  option = A
  intSlider: cint = 5
  floatSlider: cfloat = 2.5
  propertyFloat: cfloat = 2.0
  rangeFloatMin: cfloat = 0
  rangeFloatMax: cfloat = 100
  rangeFloatValue: cfloat = 50
  rangeIntMin: cint = 0
  rangeIntMax: cint = 2048
  rangeIntValue: cint = 4096
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
  groupBorder: cint = nk_true.cint
  groupNoScrollbar: cint = nk_false.cint
  groupWidth: cint = 320
  groupHeight: cint = 200
  rootSelected: nk_bool
  selected3: array[8, nk_bool]
  currentTab: cint = 0
  selected4: array[32, nk_bool]
  a, b, c: cfloat = 100

proc overview*(ctx: PContext) =
  windowFlags = {}
  headerAlign(ctx, header_align)
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
      nk_menubar_begin(ctx)
      # menu #1
      nk_layout_row_begin(ctx, NK_STATIC, 25, 5)
      nk_layout_row_push(ctx, 45)
      if createMenu(ctx, "MENU", NK_TEXT_LEFT, 120, 200):
        setLayoutRowDynamic(25, 1)
        if nk_menu_item_label(ctx, "Hide", NK_TEXT_LEFT):
          showMenu = true
        if nk_menu_item_label(ctx, "About", NK_TEXT_LEFT):
          showAppAbout = true
        discard nk_progress(ctx, prog, 100, nk_true)
        discard nk_slider_int(ctx, 0, slider, 16, 1)
        checkbox("check", check)
        nk_menu_end(ctx)
      # menu 2
      nk_layout_row_push(ctx, 60)
      if createMenu(ctx, "ADVANCED", NK_TEXT_LEFT, 200, 600):
        state = (if menuState == MENU_FILE: NK_MAXIMIZED else: NK_MINIMIZED)
        if nk_tree_state_push(ctx, NK_TREE_TAB, "FILE", state):
          menuState = MENU_FILE
          discard nk_menu_item_label(ctx, "New", NK_TEXT_LEFT)
          discard nk_menu_item_label(ctx, "Open", NK_TEXT_LEFT)
          discard nk_menu_item_label(ctx, "Save", NK_TEXT_LEFT)
          discard nk_menu_item_label(ctx, "Close", NK_TEXT_LEFT)
          discard nk_menu_item_label(ctx, "Exit", NK_TEXT_LEFT)
          nk_tree_pop(ctx)
        else:
          menuState = (if menuState == MENU_FILE: MENU_NONE else: menuState)
        state = (if menuState == MENU_EDIT: NK_MAXIMIZED else: NK_MINIMIZED)
        if nk_tree_state_push(ctx, NK_TREE_TAB, "EDIT", state):
          menuState = MENU_EDIT
          discard nk_menu_item_label(ctx, "Copy", NK_TEXT_LEFT)
          discard nk_menu_item_label(ctx, "Delete", NK_TEXT_LEFT)
          discard nk_menu_item_label(ctx, "Cut", NK_TEXT_LEFT)
          discard nk_menu_item_label(ctx, "Paste", NK_TEXT_LEFT)
          nk_tree_pop(ctx)
        else:
          menuState = (if menuState == MENU_EDIT: MENU_NONE else: menuState)
        state = (if menu_state == MENU_VIEW: NK_MAXIMIZED else: NK_MINIMIZED)
        if nk_tree_state_push(ctx, NK_TREE_TAB, "VIEW", state):
          menuState = MENU_VIEW
          discard nk_menu_item_label(ctx, "About", NK_TEXT_LEFT)
          discard nk_menu_item_label(ctx, "Options", NK_TEXT_LEFT)
          discard nk_menu_item_label(ctx, "Customize", NK_TEXT_LEFT)
          nk_tree_pop(ctx)
        else:
          menuState = (if menuState == MENU_VIEW: MENU_NONE else: menuState)
        state = (if menuState == MENU_CHART: NK_MAXIMIZED else: NK_MINIMIZED)
        if nk_tree_state_push(ctx, NK_TREE_TAB, "CHART", state):
          menuState = MENU_CHART
          setLayoutRowDynamic(150, 1)
          discard nk_chart_begin(ctx, NK_CHART_COLUMN, values.len, 0, 50)
          for value in values:
            discard nk_chart_push(ctx, value)
          nk_chart_end(ctx)
          nk_tree_pop(ctx)
        else:
          menuState = (if menuState == MENU_CHART: MENU_NONE else: menuState)
        nk_menu_end(ctx)
      # menu widgets
      nk_layout_row_push(ctx, 70)
      discard nk_progress(ctx, mprog, 100, nk_true)
      discard nk_slider_int(ctx, 0, mslider, 16, 1);
      checkbox("check", mcheck)
      nk_menubar_end(ctx)
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
    if nk_tree_push_hashed(ctx, NK_TREE_TAB, "Window", NK_MINIMIZED,
        "overview151", 12, 151):
      setLayoutRowDynamic(30, 2)
      checkbox("Titlebar", titlebar)
      checkbox("Menu", showMenu)
      checkbox("Border", border)
      checkbox("Resizable", resize)
      checkbox("Movable", movable)
      checkbox("No Scrollbar", noScrollbar)
      checkbox("Minimizable", minimizable)
      checkbox("Scale Left", scaleLeft)
      nk_tree_pop(ctx)
    if nk_tree_push_hashed(ctx, NK_TREE_TAB, "Widgets", NK_MINIMIZED,
        "overview163", 12, 163):
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Text", NK_MINIMIZED,
          "overview165", 12, 165):
        setLayoutRowDynamic(20, 1)
        label("Label aligned left")
        label("Label aligned centered", centered)
        label("Label aligned right", right)
        colorLabel(ctx, "Blue text", NK_TEXT_LEFT, 0, 0, 255)
        colorLabel(ctx, "Yellow text", NK_TEXT_LEFT, 255, 255, 0)
        nk_text(ctx, "Text without /0", 15, NK_TEXT_RIGHT)
        nk_layout_row_static(ctx, 100, 200, 1)
        nk_label_wrap(ctx, "This is a very long line to hopefully get this text to be wrapped into multiple lines to show line wrapping")
        setLayoutRowDynamic(100, 1)
        nk_label_wrap(ctx, "This is another long text to show dynamic window changes on multiline text")
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Button", NK_MINIMIZED,
          "overview180", 12, 180):
        nk_layout_row_static(ctx, 30, 100, 3)
        labelButton("Button"):
          echo "Button pressed!"
        nk_button_set_behavior(ctx, NK_BUTTON_REPEATER)
        labelButton("Repeater"):
          echo "Repeater is being pressed!"
        nk_button_set_behavior(ctx, NK_BUTTON_DEFAULT)
        discard colorButton(ctx, 0, 0, 255)
        nk_layout_row_static(ctx, 25, 25, 8)
        discard nk_button_symbol(ctx, NK_SYMBOL_CIRCLE_SOLID)
        discard nk_button_symbol(ctx, NK_SYMBOL_CIRCLE_OUTLINE)
        discard nk_button_symbol(ctx, NK_SYMBOL_RECT_SOLID)
        discard nk_button_symbol(ctx, NK_SYMBOL_RECT_OUTLINE)
        discard nk_button_symbol(ctx, NK_SYMBOL_TRIANGLE_UP)
        discard nk_button_symbol(ctx, NK_SYMBOL_TRIANGLE_DOWN)
        discard nk_button_symbol(ctx, NK_SYMBOL_TRIANGLE_LEFT)
        discard nk_button_symbol(ctx, NK_SYMBOL_TRIANGLE_RIGHT)
        nk_layout_row_static(ctx, 30, 100, 2)
        discard nk_button_symbol_label(ctx, NK_SYMBOL_TRIANGLE_LEFT, "prev",
            NK_TEXT_RIGHT)
        discard nk_button_symbol_label(ctx, NK_SYMBOL_TRIANGLE_RIGHT, "next",
            NK_TEXT_LEFT)
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Basic", NK_MINIMIZED,
          "overview204", 12, 204):
        nk_layout_row_static(ctx, 30, 100, 1)
        checkbox("Checkbox", checkbox)
        nk_layout_row_static(ctx, 30, 80, 3)
        if nk_option_label(ctx, "optionA", (if option == A: 1 else: 0)):
          option = A
        if nk_option_label(ctx, "optionB", (if option == B: 1 else: 0)):
          option = B
        if nk_option_label(ctx, "optionC", (if option == C: 1 else: 0)):
          option = C
        nk_layout_row(ctx, NK_STATIC, 30, 2, ratio.unsafeAddr)
        nk_labelf(ctx, NK_TEXT_LEFT, "Slider int")
        discard nk_slider_int(ctx, 0, intSlider, 10, 1)
        label("Slider float")
        discard nk_slider_float(ctx, 0, float_slider, 5.0, 0.5f)
        nk_labelf(ctx, NK_TEXT_LEFT, "Progressbar: %u", progValue)
        discard nk_progress(ctx, prog_value, 100, nk_true)
        nk_layout_row(ctx, NK_STATIC, 25, 2, ratio.unsafeAddr)
        label("Property float:")
        nk_property_float(ctx, "Float:", 0, propertyFloat, 64.0, 0.1, 0.2)
        label("Property int:")
        nk_property_int(ctx, "Int:", 0, propertyInt, 100, 1, 1)
        label("Property neg:")
        nk_property_int(ctx, "Neg:", -10, propertyNeg, 10, 1, 1)
        setLayoutRowDynamic(25, 1)
        label("Range:")
        setLayoutRowDynamic(25, 3)
        nk_property_float(ctx, "#min:", 0, rangeFloatMin, rangeFloatMax, 1.0, 0.2)
        nk_property_float(ctx, "#float:", rangeFloatMin, rangeFloatValue,
            rangeFloatMax, 1.0, 0.2)
        nk_property_float(ctx, "#max:", rangeFloatMin, rangeFloatMax, 100, 1.0, 0.2)
        nk_property_int(ctx, "#min:", cint.low, rangeIntMin, rangeIntMax, 1, 10)
        nk_property_int(ctx, "#neg:", rangeIntMin, rangeIntValue, rangeIntMax,
            1, 10)
        nk_property_int(ctx, "#max:", rangeIntMin, rangeIntMax, cint.high, 1, 10)
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Inactive", NK_MINIMIZED,
          "overview257", 12, 257):
        setLayoutRowDynamic(30, 1)
        checkbox("Inactive", inactive)
        nk_layout_row_static(ctx, 30, 80, 1)
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
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Selectable", NK_MINIMIZED,
          "overview275", 12, 275):
        if nk_tree_push_hashed(ctx, NK_TREE_NODE, "List", NK_MINIMIZED,
            "overview277", 12, 277):
          nk_layout_row_static(ctx, 18, 100, 1)
          discard nk_selectable_label(ctx, "Selectable", NK_TEXT_LEFT,
              selected[0])
          discard nk_selectable_label(ctx, "Selectable", NK_TEXT_LEFT,
              selected[1])
          label("Not Selectable")
          discard nk_selectable_label(ctx, "Selectable", NK_TEXT_LEFT,
              selected[2])
          discard nk_selectable_label(ctx, "Selectable", NK_TEXT_LEFT,
              selected[3])
          nk_tree_pop(ctx);
        if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Grid", NK_MINIMIZED,
            "overview287", 12, 287):
          nk_layout_row_static(ctx, 50, 50, 4)
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
          nk_tree_pop(ctx)
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Combo", NK_MINIMIZED,
          "overview312", 12, 312):
        nk_layout_row_static(ctx, 25, 200, 1);
        currentWeapon = comboList(weapons, currentWeapon, 25, 200, 200)
        if createColorCombo(ctx, comboColor, 200, 200):
          let ratios: array[2, cfloat] = [0.15.cfloat, 0.85]
          nk_layout_row(ctx, NK_DYNAMIC, 30, 2, ratios.unsafeAddr)
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
          if nk_option_label(ctx, "RGB", (if colMode == COL_RGB: 1 else: 0)):
            colMode = COL_RGB
          if nk_option_label(ctx, "HSV", (if colMode == COL_HSV: 1 else: 0)):
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
          discard nk_progress(ctx, progA, 100, nk_true)
          discard nk_progress(ctx, progB, 100, nk_true)
          discard nk_progress(ctx, progC, 100, nk_true)
          discard nk_progress(ctx, progD, 100, nk_true)
          nk_combo_end(ctx)
        sum = $(checkValues[0] + checkValues[1] + checkValues[2] + checkValues[3] + checkValues[4])
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
          discard nk_chart_begin(ctx, NK_CHART_COLUMN, values.len, 0, 50)
          for value in values:
            var res = nk_chart_push(ctx, value)
            if (res and NK_CHART_CLICKED.nk_flags) == NK_CHART_CLICKED.nk_flags:
              chartSelection = value
              nk_combo_close(ctx)
          nk_chart_end(ctx)
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
          nk_layout_row_begin(ctx, NK_DYNAMIC, 20, 3);
          nk_layout_row_push(ctx, 0.05)
          if nk_button_symbol(ctx, NK_SYMBOL_TRIANGLE_LEFT):
            if selectedDate.month == mJan:
              selectedDate.monthZero = 12
              selectedDate.year = selectedDate.year - 1
            else:
              selectedDate.monthZero = selectedDate.month.ord - 1
          nk_layout_row_push(ctx, 0.9)
          sum = $selectedDate.month & " " & $selectedDate.year
          label(sum, centered)
          nk_layout_row_push(ctx, 0.05)
          if nk_button_symbol(ctx, NK_SYMBOL_TRIANGLE_RIGHT):
            if selectedDate.month == mDec:
              selectedDate.monthZero = 1
              selectedDate.year = selectedDate.year + 1
            else:
              selectedDate.monthZero = selectedDate.month.ord + 1
          nk_layout_row_end(ctx)
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
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Input", NK_MINIMIZED,
          "overview461", 12, 461):
        nk_layout_row(ctx, NK_STATIC, 25, 2, ratio.unsafeAddr)
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
        nk_layout_row_static(ctx, 180, 278, 1)
        editString(boxBuffer, 512, box)
        nk_layout_row(ctx, NK_STATIC, 25, 2, ratio.unsafeAddr)
        boxActive = editString(text[7], 64, field, nk_filter_ascii, {sigEnter})
        labelButton("Submit"):
          text[7][text_len[7]] = '\n'
          text_len[7].inc
          for i in 0 .. text_len[7]:
            boxBuffer[i + boxLen] = text[7][i]
          boxLen = boxLen + textLen[7]
          textLen[7] = 0
        if boxActive == commited:
          text[7][text_len[7]] = '\n'
          text_len[7].inc
          for i in 0 .. text_len[7]:
            boxBuffer[i + boxLen] = text[7][i]
          boxLen = boxLen + textLen[7]
          textLen[7] = 0
        nk_tree_pop(ctx)
      nk_tree_pop(ctx)
    if nk_tree_push_hashed(ctx, NK_TREE_TAB, "Charts", NK_MINIMIZED,
        "overview517", 12, 517):
      var
        chartId: cfloat = 0
        chartIndex = -1
      setLayoutRowDynamic(100, 1)
      if nk_chart_begin(ctx, NK_CHART_LINES, 32, -1.0, 1.0):
        for i in 0 .. 31:
          var res = nk_chart_push(ctx, cos(chartId).cfloat)
          if (res and NK_CHART_HOVERING.cint) == NK_CHART_HOVERING.cint:
            chartIndex = i
          if (res and NK_CHART_CLICKED.cint) == NK_CHART_CLICKED.cint:
            lineIndex = i
          chartId = chartId + chartStep
        nk_chart_end(ctx)
      if chartIndex != -1:
        nk_tooltipf(ctx, "Value: %.2f", cos(chartIndex.cfloat *
            chartStep).cfloat)
      if lineIndex != 1:
        setLayoutRowDynamic(20, 1)
        nk_labelf(ctx, NK_TEXT_LEFT, "Selected value: %.2f", cos(
            chartIndex.cfloat * chartStep).cfloat)
      setLayoutRowDynamic(100, 1)
      if nk_chart_begin(ctx, NK_CHART_COLUMN, 32, 0.0, 1.0):
        for i in 0 .. 31:
          var res = nk_chart_push(ctx, abs(sin(chartId)))
          if (res and NK_CHART_HOVERING.cint) == NK_CHART_HOVERING.cint:
            chartIndex = i
          if (res and NK_CHART_CLICKED.cint) == NK_CHART_CLICKED.cint:
            colIndex = i
          chartId = chartId + chartStep
        nk_chart_end(ctx)
      if chartIndex != -1:
        nk_tooltipf(ctx, "Value: %.2f", abs(sin(chartStep *
            chartIndex.cfloat).cfloat));
      if col_index != -1:
        setLayoutRowDynamic(20, 1)
        nk_labelf(ctx, NK_TEXT_LEFT, "Selected value: %.2f", abs(sin(
            chartStep * colIndex.cfloat).cfloat))
      setLayoutRowDynamic(100, 1)
      if nk_chart_begin(ctx, NK_CHART_COLUMN, 32, 0.0, 1.0):
        nk_chart_add_slot(ctx, NK_CHART_LINES, 32, -1.0, 1.0)
        nk_chart_add_slot(ctx, NK_CHART_LINES, 32, -1.0, 1.0)
        chartId = 0
        for i in 0 .. 31:
          discard nk_chart_push_slot(ctx, abs(sin(chartId)), 0)
          discard nk_chart_push_slot(ctx, cos(chartId), 1)
          discard nk_chart_push_slot(ctx, sin(chartId), 2)
          chartId = chartId + chartStep
        nk_chart_end(ctx)
      setLayoutRowDynamic(100, 1)
      if createColorChart(ctx, NK_CHART_LINES, NimColor(r: 255, g: 0, b: 0),
          NimColor(r: 150, g: 0, b: 0), 32, 0.0, 1.0):
        addColorChartSlot(ctx, NK_CHART_LINES, NimColor(r: 0, g: 0, b: 255),
            NimColor(r: 0, g: 0, b: 150), 32, -1.0, 1.0)
        addColorChartSlot(ctx, NK_CHART_LINES, NimColor(r: 0, g: 255, b: 0),
            NimColor(r: 0, g: 150, b: 0), 32, -1.0, 1.0)
        chartId = 0
        for i in 0 .. 31:
          discard nk_chart_push_slot(ctx, abs(sin(chartId)), 0)
          discard nk_chart_push_slot(ctx, cos(chartId), 1)
          discard nk_chart_push_slot(ctx, sin(chartId), 2)
          chartId = chartId + chartStep
        nk_chart_end(ctx)
      nk_tree_pop(ctx)
    if nk_tree_push_hashed(ctx, NK_TREE_TAB, "Popup", NK_MINIMIZED,
        "overview584", 12, 584):
      nk_layout_row_static(ctx, 30, 160, 1)
      var bounds = getWidgetBounds(ctx)
      label("Right click me for menu")
      if createContextual(ctx, 0, 100, 300, bounds):
        setLayoutRowDynamic(25, 1);
        checkbox("Menu", showMenu)
        discard nk_progress(ctx, prog, 100, nk_true)
        discard nk_slider_int(ctx, 0, slider, 16, 1)
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
      nk_layout_row_begin(ctx, NK_STATIC, 30, 2)
      nk_layout_row_push(ctx, 120)
      label("Right Click here:")
      nk_layout_row_push(ctx, 50)
      bounds = getWidgetBounds(ctx)
      discard colorButton(ctx, popupColor.r, popupColor.g, popupColor.b)
      nk_layout_row_end(ctx)
      if createContextual(ctx, 0, 350, 60, bounds):
        setLayoutRowDynamic(30, 4);
        popupColor.r = nk_propertyi(ctx, "#r", 0, popupColor.r, 255, 1, 1)
        popupColor.g = nk_propertyi(ctx, "#g", 0, popupColor.g, 255, 1, 1)
        popupColor.b = nk_propertyi(ctx, "#b", 0, popupColor.b, 255, 1, 1)
        popupColor.a = nk_propertyi(ctx, "#a", 0, popupColor.a, 255, 1, 1)
        nk_contextual_end(ctx)
      nk_layout_row_begin(ctx, NK_STATIC, 30, 2)
      nk_layout_row_push(ctx, 120)
      label("Popup:")
      nk_layout_row_push(ctx, 50)
      labelButton("Popup"):
        popup_active = true
      nk_layout_row_end(ctx)
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
      nk_layout_row_static(ctx, 30, 150, 1)
      bounds = getWidgetBounds(ctx)
      label("Hover me for tooltip")
      if isMouseHovering(ctx, bounds.x, bounds.y, bounds.w, bounds.h):
        nk_tooltip(ctx, "This is a tooltip")
      nk_tree_pop(ctx)
    if nk_tree_push_hashed(ctx, NK_TREE_TAB, "Layout", NK_MINIMIZED,
        "overview651", 12, 651):
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Widget", NK_MINIMIZED,
          "overview653", 12, 653):
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
        nk_layout_row_static(ctx, 30, 100, 3)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        setLayoutRowDynamic(30, 1)
        label("Dynamic array-based custom column layout with generated position and custom size:")
        nk_layout_row(ctx, NK_DYNAMIC, 30, 3, ratioTwo.unsafeAddr)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        setLayoutRowDynamic(30, 1)
        label("Static array-based custom column layout with generated position and custom size:")
        nk_layout_row(ctx, NK_STATIC, 30, 3, widthTwo.unsafeAddr)
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        labelButton("button"):
          discard
        setLayoutRowDynamic(30, 1)
        label("Dynamic immediate mode custom column layout with generated position and custom size:")
        nk_layout_row_begin(ctx, NK_DYNAMIC, 30, 3)
        nk_layout_row_push(ctx, 0.2)
        labelButton("button"):
          discard
        nk_layout_row_push(ctx, 0.6)
        labelButton("button"):
          discard
        nk_layout_row_push(ctx, 0.2)
        labelButton("button"):
          discard
        nk_layout_row_end(ctx)
        setLayoutRowDynamic(30, 1)
        label("Static immediate mode custom column layout with generated position and custom size:")
        nk_layout_row_begin(ctx, NK_STATIC, 30, 3)
        nk_layout_row_push(ctx, 100)
        labelButton("button"):
          discard
        nk_layout_row_push(ctx, 200)
        labelButton("button"):
          discard
        nk_layout_row_push(ctx, 50)
        labelButton("button"):
          discard
        nk_layout_row_end(ctx)
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
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Group", NK_MINIMIZED,
          "overview731", 12, 731):
        var groupFlags: nk_flags = 0
        if groupBorder == nk_true.cint:
          groupFlags = groupFlags or nkWindowBorder
        if groupNoScrollbar == nk_true.cint:
          groupFlags = groupFlags or nkWindowNoScrollbar
        if groupTitlebar == nk_true.cint:
          groupFlags = groupFlags or nkWindowTitle
        setLayoutRowDynamic(30, 3)
        checkbox("Titlebar", groupTitlebar)
        discard nk_checkbox_label(ctx, "Border", groupBorder)
        discard nk_checkbox_label(ctx, "No Scrollbar", groupNoScrollbar)
        nk_layout_row_begin(ctx, NK_STATIC, 22, 3)
        nk_layout_row_push(ctx, 50)
        nk_label(ctx, "size:", NK_TEXT_LEFT)
        nk_layout_row_push(ctx, 130)
        nk_property_int(ctx, "#Width:", 100, groupWidth, 500, 10, 1)
        nk_layout_row_push(ctx, 130)
        nk_property_int(ctx, "#Height:", 100, groupHeight, 500, 10, 1)
        nk_layout_row_end(ctx)
        nk_layout_row_static(ctx, groupHeight.cfloat, groupWidth, 2)
        if nk_group_begin(ctx, "Group", groupFlags):
          nk_layout_row_static(ctx, 18, 100, 1)
          for i in 0 .. 15:
            discard nk_selectable_label(ctx, (if selected2[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected2[i])
          nk_group_end(ctx)
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Tree", NK_MINIMIZED,
          "overview766", 12, 766):
        var sel = rootSelected
        if nk_tree_element_push_hashed(ctx, NK_TREE_NODE, "Root", NK_MINIMIZED,
            sel, "overview771", 12, 771):
          var nodeSelect = selected3[0]
          if sel != rootSelected:
            rootSelected = sel
            for i in 0 .. 7:
              selected3[i] = sel
          if nk_tree_element_push_hashed(ctx, NK_TREE_NODE, "Node",
              NK_MINIMIZED, node_select, "overview778", 12, 778):
            if nodeSelect != selected3[0]:
              selected3[0] = nodeSelect
              for i in 0 .. 3:
                selected[i] = nodeSelect
            nk_layout_row_static(ctx, 18, 100, 1)
            for j in 0 .. 3:
              discard nk_selectable_symbol_label(ctx, NK_SYMBOL_CIRCLE_SOLID, (
                  if selected[j] ==
                  nk_true: "Selected" else: "Unselected").cstring,
                  NK_TEXT_RIGHT, selected[j])
            nk_tree_element_pop(ctx)
          nk_layout_row_static(ctx, 18, 100, 1)
          for i in 0 .. 7:
            discard nk_selectable_symbol_label(ctx, NK_SYMBOL_CIRCLE_SOLID, (
                if selected3[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_RIGHT, selected3[i])
          nk_tree_element_pop(ctx)
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Notebook", NK_MINIMIZED,
          "overview799", 12, 799):
        discard stylePushVec2(ctx, spacing, 0, 0)
        discard stylePushFloat(ctx, rounding, 0)
        nk_layout_row_begin(ctx, NK_STATIC, 20, 3);
        for i in 0 .. 2:
          let
            textWidth = getTextWidth(ctx, names[i])
            widgetWidth = textWidth + 3 * getButtonStyle(ctx, padding).x;
          nk_layout_row_push(ctx, widgetWidth)
          if currentTab == i:
            saveButtonStyle(ctx)
            setButtonStyle2(ctx, active, normal)
            currentTab = (if nk_button_label(ctx, names[i]) ==
                nk_true: i.cint else: current_tab)
            restoreButtonStyle(ctx)
          else:
            currentTab = (if nk_button_label(ctx, names[i]) ==
                nk_true: i.cint else: current_tab)
        nk_style_pop_float(ctx)
        nk_style_pop_vec2(ctx)
        nk_layout_row_dynamic(ctx, 140, 1)
        if nk_group_begin(ctx, "Notebook", nkWindowBorder):
          var id: cfloat
          let step: cfloat = (2 * 3.141592654f) / 32
          case currentTab
          of 0:
            nk_layout_row_dynamic(ctx, 100, 1)
            if createColorChart(ctx, NK_CHART_LINES, NimColor(r: 255, g: 0,
                b: 0, a: 255), NimColor(r: 150, g: 0, b: 0, a: 255), 32, 0.0, 1.0):
              addColorChartSlot(ctx, NK_CHART_LINES, NimColor(r: 0, g: 0,
                  b: 255, a: 255), NimColor(r: 0, g: 0, b: 150, a: 255), 32,
                  -1.0, 1.0)
              id = 0.0
              for i in 0 .. 31:
                discard nk_chart_push_slot(ctx, abs(sin(id)), 0)
                discard nk_chart_push_slot(ctx, cos(id), 1)
                id = id + step
              nk_chart_end(ctx)
          of 1:
            nk_layout_row_dynamic(ctx, 100, 1)
            if createColorChart(ctx, NK_CHART_COLUMN, NimColor(r: 255, g: 0,
                b: 0, a: 255), NimColor(r: 150, g: 0, b: 0, a: 255), 32, 0.0, 1.0):
              id = 0.0
              for i in 0 .. 31:
                discard nk_chart_push_slot(ctx, abs(sin(id)), 0)
                id = id + step
              nk_chart_end(ctx)
          of 2:
            nk_layout_row_dynamic(ctx, 100, 1)
            if createColorChart(ctx, NK_CHART_LINES, NimColor(r: 255, g: 0,
                b: 0, a: 255), NimColor(r: 150, g: 0, b: 0, a: 255), 32, 0.0, 1.0):
              addColorChartSlot(ctx, NK_CHART_LINES, NimColor(r: 0, g: 0,
                  b: 255, a: 255), NimColor(r: 0, g: 0, b: 150, a: 255), 32,
                  -1.0, 1.0)
              addColorChartSlot(ctx, NK_CHART_COLUMN, NimColor(r: 0, g: 255,
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
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Simple", NK_MINIMIZED,
          "overview868", 12, 868):
        nk_layout_row_dynamic(ctx, 300, 2)
        if nk_group_begin(ctx, "Group_Without_Border", 0):
          nk_layout_row_static(ctx, 18, 150, 1)
          for i in 0 .. 63:
            nk_labelf(ctx, NK_TEXT_LEFT, "%s: scrollable region",
                fmt"{i:#X}".cstring)
          nk_group_end(ctx)
        if nk_group_begin(ctx, "Group_With_Border", nkWindowBorder):
          nk_layout_row_dynamic(ctx, 25, 2)
          for i in 0 .. 63:
            let number = (((i mod 7) * 10)) + (64 + (i mod 2) * 2)
            discard nk_button_label(ctx, fmt"{number:08}".cstring)
          nk_group_end(ctx)
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Complex", NK_MINIMIZED,
          "overview884", 12, 884):
        nk_layout_space_begin(ctx, NK_STATIC, 500, 64)
        layoutSpacePush(ctx, 0, 0, 150, 500)
        if nk_group_begin(ctx, "Group_left", nkWindowBorder):
          nk_layout_row_static(ctx, 18, 100, 1)
          for i in 0 .. 31:
            discard nk_selectable_label(ctx, (if selected4[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected4[i])
          nk_group_end(ctx);
        layoutSpacePush(ctx, 160, 0, 150, 240)
        if nk_group_begin(ctx, "Group_top", nkWindowBorder):
          nk_layout_row_dynamic(ctx, 25, 1)
          discard nk_button_label(ctx, "#FFAA")
          discard nk_button_label(ctx, "#FFBB")
          discard nk_button_label(ctx, "#FFCC")
          discard nk_button_label(ctx, "#FFDD")
          discard nk_button_label(ctx, "#FFEE")
          discard nk_button_label(ctx, "#FFFF")
          nk_group_end(ctx)
        layoutSpacePush(ctx, 160, 250, 150, 250)
        if nk_group_begin(ctx, "Group_buttom", nkWindowBorder):
          nk_layout_row_dynamic(ctx, 25, 1)
          discard nk_button_label(ctx, "#FFAA")
          discard nk_button_label(ctx, "#FFBB")
          discard nk_button_label(ctx, "#FFCC")
          discard nk_button_label(ctx, "#FFDD")
          discard nk_button_label(ctx, "#FFEE")
          discard nk_button_label(ctx, "#FFFF")
          nk_group_end(ctx);
        layoutSpacePush(ctx, 320, 0, 150, 150)
        if nk_group_begin(ctx, "Group_right_top", nkWindowBorder):
          nk_layout_row_static(ctx, 18, 100, 1)
          for i in 0 .. 3:
            discard nk_selectable_label(ctx, (if selected[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected[i])
          nk_group_end(ctx)
        layoutSpacePush(ctx, 320, 160, 150, 150)
        if nk_group_begin(ctx, "Group_right_center", nkWindowBorder):
          nk_layout_row_static(ctx, 18, 100, 1)
          for i in 0 .. 3:
            discard nk_selectable_label(ctx, (if selected[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected[i])
          nk_group_end(ctx);
        layoutSpacePush(ctx, 320, 320, 150, 150)
        if nk_group_begin(ctx, "Group_right_bottom", nkWindowBorder):
          nk_layout_row_static(ctx, 18, 100, 1)
          for i in 0 .. 3:
            discard nk_selectable_label(ctx, (if selected[i] ==
                nk_true: "Selected" else: "Unselected").cstring,
                NK_TEXT_CENTERED, selected[i])
          nk_group_end(ctx);
        nk_layout_space_end(ctx)
        nk_tree_pop(ctx)
      if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Splitter", NK_MINIMIZED,
          "overview942", 12, 942):
        nk_layout_row_static(ctx, 20, 320, 1)
        nk_label(ctx, "Use slider and spinner to change tile size",
            NK_TEXT_LEFT)
        nk_label(ctx, "Drag the space between tiles to change tile ratio",
            NK_TEXT_LEFT)
        if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Vertical", NK_MINIMIZED,
            "overview948", 12, 948):
          var rowLayout: array[5, cfloat] = [a, 8, b, 8, c]
          nk_layout_row_static(ctx, 30, 100, 2)
          nk_label(ctx, "left:", NK_TEXT_LEFT)
          discard nk_slider_float(ctx, 10.0, a, 200.0, 10.0)
          nk_label(ctx, "middle:", NK_TEXT_LEFT)
          discard nk_slider_float(ctx, 10.0, b, 200.0, 10.0)
          nk_label(ctx, "right:", NK_TEXT_LEFT)
          discard nk_slider_float(ctx, 10.0, c, 200.0, 10.0)
          nk_layout_row(ctx, NK_STATIC, 200, 5, rowLayout.unsafeAddr)
          if nk_group_begin(ctx, "left", nkWindowNoScrollbar or
              nkWindowBorder or nkWindowNoScrollbar):
            nk_layout_row_dynamic(ctx, 25, 1)
            discard nk_button_label(ctx, "#FFAA")
            discard nk_button_label(ctx, "#FFBB")
            discard nk_button_label(ctx, "#FFCC")
            discard nk_button_label(ctx, "#FFDD")
            discard nk_button_label(ctx, "#FFEE")
            discard nk_button_label(ctx, "#FFFF")
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
            nk_layout_row_dynamic(ctx, 25, 1)
            discard nk_button_label(ctx, "#FFAA")
            discard nk_button_label(ctx, "#FFBB")
            discard nk_button_label(ctx, "#FFCC")
            discard nk_button_label(ctx, "#FFDD")
            discard nk_button_label(ctx, "#FFEE")
            discard nk_button_label(ctx, "#FFFF")
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
            nk_layout_row_dynamic(ctx, 25, 1)
            discard nk_button_label(ctx, "#FFAA")
            discard nk_button_label(ctx, "#FFBB")
            discard nk_button_label(ctx, "#FFCC")
            discard nk_button_label(ctx, "#FFDD")
            discard nk_button_label(ctx, "#FFEE")
            discard nk_button_label(ctx, "#FFFF")
            nk_group_end(ctx)
          nk_tree_pop(ctx)
        if nk_tree_push_hashed(ctx, NK_TREE_NODE, "Horizontal", NK_MINIMIZED,
            "overview1006", 13, 106):
          nk_layout_row_static(ctx, 30, 100, 2)
          nk_label(ctx, "top:", NK_TEXT_LEFT)
          discard nk_slider_float(ctx, 10.0, a, 200.0, 10.0)
          nk_label(ctx, "middle:", NK_TEXT_LEFT)
          discard nk_slider_float(ctx, 10.0, b, 200.0, 10.0)
          nk_label(ctx, "bottom:", NK_TEXT_LEFT)
          discard nk_slider_float(ctx, 10.0, c, 200.0, 10.0)
          nk_layout_row_dynamic(ctx, a, 1)
          if nk_group_begin(ctx, "top", nkWindowBorder or
              nkWindowNoScrollbar):
            nk_layout_row_dynamic(ctx, 25, 3)
            discard nk_button_label(ctx, "#FFAA")
            discard nk_button_label(ctx, "#FFBB")
            discard nk_button_label(ctx, "#FFCC")
            discard nk_button_label(ctx, "#FFDD")
            discard nk_button_label(ctx, "#FFEE")
            discard nk_button_label(ctx, "#FFFF")
            nk_group_end(ctx)
          nk_layout_row_dynamic(ctx, 8, 1)
          var bounds = getWidgetBounds(ctx)
          nk_spacing(ctx, 1)
          if (isMouseHovering(ctx, bounds.x, bounds.y, bounds.w, bounds.h) or
              isMousePrevHovering(ctx, bounds.x, bounds.y, bounds.w,
              bounds.h)) and isMouseDown(ctx, NK_BUTTON_LEFT):
            a = a + getMouseDelta(ctx).y
            b = b - getMouseDelta(ctx).y
          nk_layout_row_dynamic(ctx, b, 1)
          if nk_group_begin(ctx, "middle", nkWindowBorder or
              nkWindowNoScrollbar):
            nk_layout_row_dynamic(ctx, 25, 3)
            discard nk_button_label(ctx, "#FFAA")
            discard nk_button_label(ctx, "#FFBB")
            discard nk_button_label(ctx, "#FFCC")
            discard nk_button_label(ctx, "#FFDD")
            discard nk_button_label(ctx, "#FFEE")
            discard nk_button_label(ctx, "#FFFF")
            nk_group_end(ctx)
          nk_layout_row_dynamic(ctx, 8, 1)
          bounds = getWidgetBounds(ctx)
          if (isMouseHovering(ctx, bounds.x, bounds.y, bounds.w, bounds.h) or
              isMousePrevHovering(ctx, bounds.x, bounds.y, bounds.w,
              bounds.h)) and isMouseDown(ctx, NK_BUTTON_LEFT):
            b = b + getMouseDelta(ctx).y
            c = c - getMouseDelta(ctx).y
          nk_layout_row_dynamic(ctx, c, 1)
          if nk_group_begin(ctx, "bottom", nkWindowBorder or
              nkWindowNoScrollbar):
            nk_layout_row_dynamic(ctx, 25, 3)
            discard nk_button_label(ctx, "#FFAA")
            discard nk_button_label(ctx, "#FFBB")
            discard nk_button_label(ctx, "#FFCC")
            discard nk_button_label(ctx, "#FFDD")
            discard nk_button_label(ctx, "#FFEE")
            discard nk_button_label(ctx, "#FFFF")
            nk_group_end(ctx)
          nk_tree_pop(ctx)
        nk_tree_pop(ctx)
      nk_tree_pop(ctx)
  nk_end(ctx)
