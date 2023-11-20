# Copyright © 2023 Bartek Jasicki
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met*:
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
# DAMAGES *(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT *(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Provides code for Nuklear binding

# ---------
# Constants
# ---------
const
  nkWindowBorder*: cint = 1 shl 0
  nkWindowMoveable*: cint = 1 shl 1
  nkWindowScalable*: cint = 1 shl 2
  nkWindowCloseable*: cint = 1 shl 3
  nkWindowMinimizable*: cint = 1 shl 4
  nkWindowNoScrollbar*: cint = 1 shl 5
  nkWindowScaleLeft*: cint = 1 shl 9
  nkWindowTitle*: cint = 1 shl 6

# ------------
# Simple types
# ------------
type
  nk_flags* = cint
  nk_size* = clong
  nk_byte* = uint8
  nk_rune* = cuint

# ------------
# Enumerations
# ------------
type
  nk_style_header_align = enum
    NK_HEADER_LEFT, NK_HEADER_RIGHT
  nk_layout_format* = enum
    NK_DYNAMIC, NK_STATIC
  nk_text_align* = enum
    NK_TEXT_ALIGN_LEFT = 0x01,
    NK_TEXT_ALIGN_CENTERED = 0x02,
    NK_TEXT_ALIGN_RIGHT = 0x04,
    NK_TEXT_ALIGN_TOP = 0x08,
    NK_TEXT_ALIGN_MIDDLE = 0x10,
    NK_TEXT_ALIGN_BOTTOM = 0x20
  nk_text_alignment* = enum
    NK_TEXT_LEFT = NK_TEXT_ALIGN_MIDDLE.int or NK_TEXT_ALIGN_LEFT.int,
    NK_TEXT_CENTERED = NK_TEXT_ALIGN_MIDDLE.int or NK_TEXT_ALIGN_CENTERED.int,
    NK_TEXT_RIGHT = NK_TEXT_ALIGN_MIDDLE.int or NK_TEXT_ALIGN_RIGHT.int
  nk_tree_type* = enum
    NK_TREE_NODE, NK_TREE_TAB
  nk_chart_type* = enum
    NK_CHART_LINES, NK_CHART_COLUMN, NK_CHART_MAX
  nk_bool* = enum
    nk_false, nk_true
  nk_modify* = enum
    NK_FIXED, NK_MODIFIABLE
  nk_collapse_states* = enum
    minimized, maximized
  nk_button_behavior* = enum
    NK_BUTTON_DEFAULT, NK_BUTTON_REPEATER
  nk_symbol_type* = enum
    NK_SYMBOL_NONE, NK_SYMBOL_X, NK_SYMBOL_UNDERSCORE, NK_SYMBOL_CIRCLE_SOLID,
        NK_SYMBOL_CIRCLE_OUTLINE, NK_SYMBOL_RECT_SOLID, NK_SYMBOL_RECT_OUTLINE,
        NK_SYMBOL_TRIANGLE_UP, NK_SYMBOL_TRIANGLE_DOWN, NK_SYMBOL_TRIANGLE_LEFT,
        NK_SYMBOL_TRIANGLE_RIGHT, NK_SYMBOL_PLUS, NK_SYMBOL_MINUS, NK_SYMBOL_MAX
  nk_style_item_type* = enum
    NK_STYLE_ITEM_COLOR, NK_STYLE_ITEM_IMAGE
  nk_color_format* = enum
    NK_RGB, NK_RGBA
  nk_chart_event* = enum
    NK_CHART_HOVERING = 0x01,
    NK_CHART_CLICKED = 0x02
  nk_buttons* = enum
    NK_BUTTON_LEFT, NK_BUTTON_MIDDLE, NK_BUTTON_RIGHT, NK_BUTTON_DOUBLE, NK_BUTTON_MAX
  nk_style_colors* = enum
    NK_COLOR_TEXT, NK_COLOR_WINDOW, NK_COLOR_HEADER, NK_COLOR_BORDER,
    NK_COLOR_BUTTON, NK_COLOR_BUTTON_HOVER, NK_COLOR_BUTTON_ACTIVE,
    NK_COLOR_TOGGLE, NK_COLOR_TOGGLE_HOVER, NK_COLOR_TOGGLE_CURSOR,
    NK_COLOR_SELECT, NK_COLOR_SELECT_ACTIVE, NK_COLOR_SLIDER,
    NK_COLOR_SLIDER_CURSOR, NK_COLOR_SLIDER_CURSOR_HOVER,
    NK_COLOR_SLIDER_CURSOR_ACTIVE, NK_COLOR_PROPERTY, NK_COLOR_EDIT,
    NK_COLOR_EDIT_CURSOR, NK_COLOR_COMBO, NK_COLOR_CHART,
    NK_COLOR_CHART_COLOR, NK_COLOR_CHART_COLOR_HIGHLIGHT,
    NK_COLOR_SCROLLBAR, NK_COLOR_SCROLLBAR_CURSOR,
    NK_COLOR_SCROLLBAR_CURSOR_HOVER, NK_COLOR_SCROLLBAR_CURSOR_ACTIVE,
    NK_COLOR_TAB_HEADER, NK_COLOR_COUNT
  nk_anti_aliasing* = enum
    NK_ANTI_ALIASING_OFF, NK_ANTI_ALIASING_ON

# -------
# Objects
# -------
type
  nk_color* {.importc: "struct nk_color", nodecl.} = object
    r*, g*, b*, a*: nk_byte
  nk_colorf* {.importc: "struct nk_colorf", nodecl.} = object
    r*, g*, b*, a*: cfloat
  nk_vec2* {.importc: "struct nk_vec2", nodecl.} = object
    x*, y*: cfloat
  nk_style_item_data* {.importc, nodecl.} = object
  nk_style_item* {.importc: "struct nk_style_item", nodecl.} = object
  nk_style_window_header* {.importc, nodecl.} = object
    align*: nk_style_header_align
  nk_style_window* {.importc, nodecl.} = object
    header*: nk_style_window_header
    spacing*: nk_vec2
  nk_style_button* {.importc: "struct nk_style_button", nodecl.} = object
    normal*, hover*, active*: nk_style_item
    border_color*, text_background*, text_normal*, text_hover*,
      text_active*: nk_color
    rounding*: cfloat
    padding*: nk_vec2
  nk_handle* {.bycopy, union.} = object
    `ptr`*: pointer
    id*: cint
  nk_text_width_f* = proc (arg1: nk_handle; h: cfloat; arg3: cstring;
      len: cint): cfloat {.cdecl.}
  nk_user_font* {.importc: "struct nk_user_font", nodecl.} = object
    userdata*: nk_handle
    height*: cfloat
    width*: nk_text_width_f
  nk_style* {.importc, nodecl.} = object
    window*: nk_style_window
    button*: nk_style_button
    font*: ptr nk_user_font
  nk_mouse* {.importc, nodecl.} = object
    delta*: nk_vec2
  nk_input* {.importc, nodecl.} = object
    mouse*: nk_mouse
  nk_buffer* {.importc, nodecl.} = object
  nk_context* {.importc: "struct nk_context", nodecl.} = object
    style*: nk_style
    input*: nk_input
  nk_rect* {.importc: "struct nk_rect", nodecl.} = object
    x*, y*, w*, h*: cfloat
  nk_text_edit* = object
  nk_font* {.importc: "struct nk_font", nodecl.} = object
    handle*: nk_user_font
  nk_font_atlas* {.importc: "struct nk_font_atlas", nodecl.} = object
  nk_font_config* {.importc: "struct nk_font_config", nodecl.} = object
  PContext* = ptr nk_context

# ---------------------
# Procedures parameters
# ---------------------
using ctx: PContext

# -------------------
# Creating structures
# -------------------
proc new_nk_rect*(x, y, w, h: cfloat): nk_rect {.importc: "nk_rect", nodecl.}
proc new_nk_vec2*(x, y: cfloat): nk_vec2 {.importc: "nk_vec2", nodecl.}
proc new_nk_font_config*(pixel_height: cfloat): nk_font_config {.importc: "nk_font_config", nodecl.}

# -----
# Input
# -----
proc nk_input_begin*(ctx) {.importc, nodecl.}
proc nk_input_end*(ctx) {.importc, nodecl.}

# -------
# General
# -------
proc nk_end(ctx) {.importc, cdecl.}
proc nk_spacing*(ctx; cols: cint) {.importc, cdecl.}

# ----
# Text
# ----
proc nk_text*(ctx; str: cstring; len: cint;
    alignment: nk_flags) {.importc, cdecl.}
proc nk_label_wrap*(ctx; str: cstring) {.importc, cdecl.}
proc nk_labelf*(ctx; flags: nk_flags; fmt: cstring) {.importc,
    varargs, cdecl.}

# -------
# Layouts
# -------
proc nk_layout_row_end*(ctx) {.importc, cdecl.}
proc nk_layout_row_begin*(ctx; fmt: nk_layout_format;
    row_height: cfloat; cols: cint) {.importc, cdecl.}
proc nk_layout_row_push*(ctx; width: cfloat) {.importc, cdecl.}
proc nk_layout_row*(ctx; fmt: nk_layout_format; height: cfloat;
    cols: cint; ratio: pointer) {.importc, cdecl.}
proc nk_layout_space_begin*(ctx; fmt: nk_layout_format;
    height: cfloat; widget_count: cint) {.importc, cdecl.}
proc nk_layout_space_end*(ctx) {.importc, cdecl.}
proc nk_layout_row_template_begin*(ctx; height: cfloat) {.importc, cdecl.}
proc nk_layout_row_template_push_dynamic*(ctx) {.importc, cdecl.}
proc nk_layout_row_template_push_variable*(ctx;
    min_width: cfloat) {.importc, cdecl.}
proc nk_layout_row_template_push_static*(ctx;
    width: cfloat) {.importc, cdecl.}
proc nk_layout_row_template_end*(ctx) {.importc, cdecl.}

# -----
# Menus
# -----
proc nk_menubar_begin(ctx) {.importc, cdecl.}
proc nk_menubar_end(ctx) {.importc, cdecl.}
proc nk_menu_end*(ctx) {.importc, cdecl.}
proc nk_menu_item_label(ctx; text: cstring;
    aligmnent: nk_flags): nk_bool {.importc, cdecl.}

# ------
# Charts
# ------
proc nk_chart_begin*(ctx; ctype: nk_chart_type; num: cint; min,
    max: cfloat): nk_bool {.importc, cdecl.}
proc nk_chart_push*(ctx; value: cfloat): nk_flags {.importc, cdecl.}
proc nk_chart_end*(ctx) {.importc, cdecl.}
proc nk_chart_add_slot*(ctx; ctype: nk_chart_type; count: cint;
    min_value, max_value: cfloat) {.importc, cdecl.}
proc nk_chart_push_slot*(ctx; value: cfloat;
    slot: cint): nk_flags {.importc, cdecl.}

# ------
# Popups
# ------
proc nk_popup_end(ctx) {.importc, nodecl.}

# -----
# Trees
# -----
proc nk_tree_state_push*(ctx; ttype: nk_tree_type;
    title: cstring; state: var nk_collapse_states): nk_bool {.importc, cdecl.}
proc nk_tree_pop*(ctx) {.importc, cdecl.}
proc nk_tree_push_hashed*(ctx; ttype: nk_tree_type;
    title: cstring; state: nk_collapse_states; hash: cstring; len,
    id: cint): nk_bool {.importc, cdecl.}
proc nk_tree_element_push_hashed*(ctx; ttype: nk_tree_type;
    title: cstring; state: nk_collapse_states; selected: var nk_bool;
    hash: cstring; len, sed: cint): nk_bool {.importc, cdecl.}
proc nk_tree_element_pop*(ctx) {.importc, cdecl.}

# -------
# Buttons
# -------
proc nk_button_label(ctx; title: cstring): nk_bool {.importc, cdecl.}
proc nk_button_set_behavior*(ctx;
    behavior: nk_button_behavior) {.importc, cdecl.}
proc nk_button_symbol*(ctx; symbol: nk_symbol_type): nk_bool {.importc, cdecl.}
proc nk_button_symbol_label*(ctx; symbol: nk_symbol_type;
    label: cstring; align: nk_flags): nk_bool {.importc, cdecl.}

# -------
# Sliders
# -------
proc nk_slider_int*(ctx; min: cint; val: var cint; max,
    step: cint): nk_bool {.importc, cdecl.}
proc nk_slider_float*(ctx; min: cfloat; val: var cfloat; max,
    value_step: cfloat): nk_bool {.importc, cdecl.}
proc nk_slide_int*(ctx; min, val, max, step: cint): cint {.importc, cdecl.}

# ----------
# Properties
# ----------
proc nk_property_float*(ctx; name: cstring; min: cfloat;
    val: var cfloat; max, step, inc_per_pixel: cfloat) {.importc, cdecl.}
proc nk_propertyf*(ctx; name: cstring; min, val, max, step,
    inc_per_pixel: cfloat): cfloat {.importc, cdecl.}
proc nk_propertyi*(ctx; name: cstring; min, val, max, step: cint;
    inc_per_pixel: cfloat): cint {.importc, cdecl.}

# -----
# Style
# -----
proc nk_style_item_color*(col: nk_color): nk_style_item {.importc, cdecl.}
proc nk_style_pop_float*(ctx) {.importc, cdecl.}
proc nk_style_pop_vec2*(ctx) {.importc, cdecl.}
proc nk_style_set_font*(ctx; font: ptr nk_user_font) {.importc, nodecl.}

# ------
# Combos
# ------
proc nk_combo_begin_color(ctx; color: nk_color;
    size: nk_vec2): nk_bool {.importc, nodecl.}
proc nk_combo_end*(ctx) {.importc, cdecl.}
proc nk_combo_close*(ctx) {.importc, cdecl.}

# ------
# Colors
# ------
proc nk_rgb*(r, g, b: cint): nk_color {.importc, nodecl.}
proc nk_rgb_cf*(c: nk_colorf): nk_color {.importc, nodecl.}
proc nk_rgba*(r, g, b, a: cint): nk_color {.importc, nodecl.}

# -------
# Filters
# -------
proc nk_filter_default*(box: ptr nk_text_edit;
    unicode: nk_rune): nk_bool {.importc, cdecl.}
proc nk_filter_decimal*(box: ptr nk_text_edit;
    unicode: nk_rune): nk_bool {.importc, cdecl.}
proc nk_filter_float*(box: ptr nk_text_edit;
    unicode: nk_rune): nk_bool {.importc, cdecl.}
proc nk_filter_hex*(box: ptr nk_text_edit;
    unicode: nk_rune): nk_bool {.importc, cdecl.}
proc nk_filter_oct*(box: ptr nk_text_edit;
    unicode: nk_rune): nk_bool {.importc, cdecl.}
proc nk_filter_binary*(box: ptr nk_text_edit;
    unicode: nk_rune): nk_bool {.importc, cdecl.}
proc nk_filter_ascii*(box: ptr nk_text_edit;
    unicode: nk_rune): nk_bool {.importc, cdecl.}

# ----------
# Contextual
# ----------
proc nk_contextual_end*(ctx) {.importc, cdecl.}
proc nk_contextual_item_label*(ctx; label: cstring;
    align: nk_flags): nk_bool {.importc, cdecl.}

# --------
# Tooltips
# --------
proc nk_tooltipf*(ctx; fmt: cstring) {.importc, nodecl, varargs.}
proc nk_tooltip*(ctx; text: cstring) {.importc, nodecl.}

# ------
# Groups
# ------
proc nk_group_begin*(ctx; title: cstring;
    flags: nk_flags): nk_bool {.importc, cdecl.}
proc nk_group_end*(ctx) {.importc, cdecl.}

# -----------
# Selectables
# -----------
proc nk_selectable_label*(ctx; str: cstring; align: nk_flags;
    value: var nk_bool): nk_bool {.importc, cdecl.}
proc nk_selectable_symbol_label*(ctx; sym: nk_symbol_type;
    title: cstring; align: nk_flags; value: var nk_bool): nk_bool {.importc, cdecl.}

# -------
# Widgets
# -------
proc nk_progress*(ctx; cur: var nk_size; max: nk_size;
    modifyable: nk_bool): nk_bool {.importc, cdecl.}

# -----
# Fonts
# -----
proc nk_font_atlas_add_default*(atlas: ptr nk_font_atlas; height: cfloat;
    config: ptr nk_font_config): ptr nk_font {.importc, nodecl.}

# ------------------------------------------------------------------
# High level bindings. The new version of the binding
# ------------------------------------------------------------------

# -----
# Types
# -----
type
  NimColor* = object
    ## Used to store information about the selected color. Usually later
    ## converted to Nuklear structure nk_color
    r*, g*, b*, a*: cint
  NimColorF* = object
    ## Also used to store information about the selected color, but as a float
    ## values.
    r*, g*, b*, a*: cfloat
  NimRect* = object
    ## Used to store information about UI rectangle. Usually later converted to
    ## Nuklear nk_rect
    x*, y*, w*, h*: cfloat
  NimVec2* = object
    ## Used to store information about UI vector. Usually later converted to
    ## Nuklear nk_vec2
    x*, y*: cfloat
  ButtonStyleTypes* = enum
    ## The types of fields in style's settings for UI buttons
    normal, hover, active, borderColor, textBackground, textNormal, textHover,
        textActive, rounding, padding
  WindowStyleTypes* = enum
    ## The types of fields in style's settings for windows
    spacing
  WindowFlags* {.size: sizeof(cint).} = enum
    ## The settings for windows
    windowNoFlags = 0,
    windowBorder = 1 shl 0,
    windowMoveable = 1 shl 1,
    windowScalable = 1 shl 2,
    windowCloseable = 1 shl 3
    windowMinimizable = 1 shl 4,
    windowNoScrollbar = 1 shl 5,
    windowTitle = 1 shl 6,
    windowScaleLeft = 1 shl 9
  NuklearException* = object of CatchableError
    ## An exception thrown when there is an issue with Nuklear library
  PopupType* = enum
    ## The types of popup windows
    staticPopup, dynamicPopup
  TextAlignment* {.size: sizeof(cint).} = enum
    ## The alignments of a text
    left = NK_TEXT_ALIGN_MIDDLE.int or NK_TEXT_ALIGN_LEFT.int,
    centered = NK_TEXT_ALIGN_MIDDLE.int or NK_TEXT_ALIGN_CENTERED.int,
    right = NK_TEXT_ALIGN_MIDDLE.int or NK_TEXT_ALIGN_RIGHT.int
  EditFlags* {.size: sizeof(cint).} = enum
    ## The edit fields' flags
    default = 0,
    readOnly = 1 shl 0,
    autoSelect = 1 shl 1,
    sigEnter = 1 shl 2,
    allowTab = 1 shl 3,
    noCursor = 1 shl 4,
    selectable = 1 shl 5,
    clipboard = 1 shl 6,
    ctrlEnterNewLine = 1 shl 7,
    noHorizontalScroll = 1 shl 8,
    alwaysInsertMode = 1 shl 9,
    multiline = 1 shl 10,
    gotoEndOnActivate = 1 shl 11
  EditEvent* {.size: sizeof(cint).} = enum
    ## The events which happen in a text field
    none = 0,
    active = 1 shl 0,
    inactive = 1 shl 1,
    activated = 1 shl 2,
    deactivated = 1 shl 3,
    commited = 1 shl 4
  EditTypes* {.size: sizeof(cint).} = enum
    ## The types of edit fields
    simple = alwaysInsertMode,
    field = simple.int or selectable.int or clipboard.int,
    editor = allowTab.int or selectable.int or clipboard.int or multiline.int,
    box = alwaysInsertMode.int or selectable.int or multiline.int or
        allowTab.int or clipboard.int
  PluginFilter* = proc (box: ptr nk_text_edit;
      unicode: nk_rune): nk_bool {.cdecl.}
    ## The procedure used to filter input in edit fields
  StyleColors* = enum
    ## Names of the colors for UI's elements which can be set. The last value
    ## is special, it defines the amount of available colors' settings.
    textColor, windowColor, headerColor, borderColor, buttonColor,
      buttonHoverColor, buttonActiveColor, toggleColor, toggleHoverColor,
      toggleCursorColor, selectColor, selectActiveColor, sliderColor,
      sliderCursorColor, sliderCursorHoverColor, sliderCursorActiveColor,
      propertyColor, editColor, editCursorColor, comboColor, chartColor,
      colorChartColor, colorChartHighlightColor, scrollbarColor,
      scrollbarCursorColor, scrollbarCursorHoverColor,
      scrollbarCursorActiveColor, tabHeaderColor, countColors
  StyleHeaderAlign* = enum
    ## The styles of the window's header
    headerLeft, headerRight

# ----------
# Converters
# ----------
converter toBool*(x: nk_bool): bool =
  ## Converts Nuklear nk_bool enum to Nim bool
  x == nk_true
converter toNkFlags*(x: nk_text_alignment): nk_flags =
  ## Converts Nuklear nk_text_alignment enum to Nuklear nk_flags type
  x.ord.cint
converter toNkFlags*(x: EditTypes): nk_flags =
  ## Converts EditTypes enum to Nuklear nk_flags type
  x.ord.cint
converter toCint*(x: bool): cint =
  ## Converts Nim bool type to Nim cint type
  if x: 1 else: 0

# ---------
# Variables
# ---------
var ctx: PContext ## Pointer to the Nuklear context

# -------
# General
# -------
proc setContext*(context: PContext) =
  ## Set the Nuklear lib context
  ##
  ## * context - the pointer to the Nuklear context
  ctx = context

proc getContext*(): PContext =
  ## Get the Nuklear lib context, temporary code
  ##
  ## Returns the pointer to the Nuklear context
  return ctx

proc charArrayToString(charArray: openArray[char]; length: int): string =
  ## Convert a characters' array to Nim string, internal use only, temporary
  ## code
  ##
  ## * charArray - the array of characters to convert
  ##
  ## Returns a string with text converted from the chars' array
  result = ""
  for i in 0 .. length - 1:
    result.add(charArray[i])

proc stringToCharArray(str: string; length: int): tuple[charArray: seq[char];
    length: cint] =
  ## Convert a Nim string to a characters array, internal use only, temporary
  ## code
  ##
  ## * str - the string to convert
  ##
  ## Returns a tuple with two fields, charArray with the converted text from
  ## the string and lenght with the amount of the characters.
  for ch in str:
    result.charArray.add(ch)
  if str.len < length:
    for i in str.len .. length:
      result.charArray.add('\0')
  result.length = str.len.cint

proc createWin(name: cstring; x, y, w, h: cfloat; flags: nk_flags): bool =
  ## Create a new Nuklear window/widget, internal use only, temporary code
  ##
  ## Returns true if window was succesfully created otherwise false.
  proc nk_begin(ctx; title: cstring; bounds: nk_rect;
      flags: nk_flags): nk_bool {.importc, nodecl.}
  return nk_begin(ctx, name, new_nk_rect(x, y, w, h), flags)

proc winSetToInt(flags: set[WindowFlags]): cint =
  result = 0
  {.warning[HoleEnumConv]: off.}
  for flag in flags:
    result = result or flag.cint
  {.warning[HoleEnumConv]: on.}

template window*(name: string; x, y, w, h: float; flags: set[WindowFlags];
    content: untyped) =
  ## Create a new Nuklear window/widget with the content
  ##
  ## * name    - the window title
  ## * x       - the X position of the top left corner of the window
  ## * y       - the Y position of the top left corner of the window
  ## * w       - the width of the window
  ## * h       - the height of the window
  ## * flags   - the flags for the window
  ## * content - the content of the window
  if createWin(name.cstring, x, y, w, h, winSetToInt(flags)):
    content
  nk_end(ctx)

proc getWidgetBounds*(ctx): NimRect =
  ## Get the rectable with the current Nuklear widget coordinates
  ##
  ## * ctx - the Nuklear context
  ##
  ## Returns a rectangle with the current Nuklear widget coordinates
  ## converted to NimRect
  proc nk_widget_bounds(ctx): nk_rect {.importc, nodecl.}
  let rect = nk_widget_bounds(ctx)
  return NimRect(x: rect.x, y: rect.y, w: rect.w, h: rect.h)

proc getTextWidth*(text: string): float =
  ## Get the width in pixels of the selected text in the current font
  ##
  ## * text - the text which width will be count
  ##
  ## Returns width in pixels of the text paramter
  return ctx.style.font.width(ctx.style.font.userdata, ctx.style.font.height,
      text, text.len.cint)

proc windowIsHidden*(name: string): bool =
  ## Check if the window with the selected name is hidden
  ##
  ## * name - the name of the window to check
  ##
  ## Returns true if the window is hidden, otherwise false
  proc nk_window_is_hidden(ctx; name: cstring): cint {.importc, nodecl.}
  return nk_window_is_hidden(ctx, name.cstring) > 0

# ------
# Popups
# ------
proc createPopup(pType: PopupType; title: cstring;
    flags: nk_flags; x, y, w, h: cfloat): bool =
  ## Create a new Nuklear popup window, internal use only, temporary code
  ##
  ## Returns true if the popup was successfully created, otherwise false.
  type nk_popup_type = enum
    NK_POPUP_STATIC, NK_POPUP_DYNAMIC
  proc nk_popup_begin(ctx; pType: nk_popup_type; title: cstring;
      flags: nk_flags; rect: nk_rect): nk_bool {.importc, nodecl.}
  return nk_popup_begin(ctx, pType.ord.nk_popup_type, title, flags, new_nk_rect(
      x, y, w, h))

template popup*(pType: PopupType; title: string; flags: set[WindowFlags]; x,
    y, w, h: float; content: untyped) =
  ## Create a new Nuklear popup window with the selected content
  ##
  ## * pType   - the type of the popup
  ## * title   - the title of the popup
  ## * flags   - the flags for the popup
  ## * x       - the X position of the top left corner of the popup
  ## * y       - the Y position of the top left corner of the popup
  ## * w       - the width of the popup
  ## * h       - the height of the popup
  ## * content - the code executed when the button is pressed
  if not createPopup(pType, title.cstring, winSetToInt(flags), x.cfloat, y, w, h):
    raise newException(NuklearException,
        "Can't create the popup window with title: '" & title & "'.")
  content
  ctx.nk_popup_end

proc closePopup*() =
  ## Close the last popup window
  proc nk_popup_close(ctx) {.importc, nodecl.}
  ctx.nk_popup_close()

# ------
# Labels
# ------
proc colorLabel*(ctx; str: cstring; align: nk_flags; r, g, b: cint) =
  ## Draw a text with the selected color
  ##
  ## * ctx   - the Nuklear context
  ## * str   - the text to display
  ## * align - the text aligmnent flags
  ## * r     - the red value for the text color in RGB
  ## * g     - the green value for the text color in RGB
  ## * b     - the blue value for the text color in RGB
  proc nk_label_colored(ctx; str: cstring; align: nk_flags;
      color: nk_color) {.importc, nodecl.}
  nk_label_colored(ctx, str, align, nk_rgb(r, g, b))
proc label*(str: string; alignment: TextAlignment = left) =
  ## Draw the text with the selected alignment
  ##
  ## * str       - the text to draw
  ## * alignment - the alignment of the text. Default is alignment to the left
  proc nk_label(ctx; str: cstring; alignment: nk_flags) {.importc, nodecl.}
  nk_label(ctx, str.cstring, alignment.nk_flags)

# -------
# Buttons
# -------
proc colorButton*(ctx; r, g, b: cint): bool =
  ## Draw a button with the selected color background
  ##
  ## * ctx - the Nuklear context
  ## * r   - the red value for the button color in RGB
  ## * g   - the green value for the button color in RGB
  ## * b   - the blue value for the button color in RGB
  ##
  ## Returns true if button was pressed
  proc nk_button_color(ctx; color: nk_color): nk_bool {.importc, nodecl.}
  return nk_button_color(ctx, nk_rgb(r, g, b))
template labelButton*(title: string; onPressCode: untyped) =
  ## Draw the button with the selected text on it. Execute the selected code
  ## on pressing it.
  ##
  ## * title       - the text to shown on the button
  ## * onPressCode - the Nim code to execute when the button was pressed
  if nk_button_label(ctx, title.cstring):
    onPressCode

# -------
# Layouts
# -------
proc layoutSpacePush*(ctx; x, y, w, h: cfloat) =
  ## Push the next widget's position and size
  ##
  ## * ctx - the Nuklear context
  ## * x   - the amount of pixels or ratio to push the position in X axis
  ## * y   - the amount of pixels or ratio to push the position in Y axis
  ## * w   - the amount of pixels or ratio to push the width
  ## * h   - the amount of pixels or ratio to push the height
  proc nk_layout_space_push(ctx; rect: nk_rect) {.importc, nodecl.}
  nk_layout_space_push(ctx, new_nk_rect(x, y, w, h))

proc setLayoutRowDynamic*(height: float; cols: int) =
  ## Set the current widgets layout to divide it into selected amount of
  ## columns with the selected height in rows and grows in width when the
  ## parent window resizes
  ##
  ## * height - the height in pixels of each row
  ## * cols   - the amount of columns in each row
  proc nk_layout_row_dynamic(ctx; height: cfloat; cols: cint) {.importc, cdecl.}
  nk_layout_row_dynamic(ctx, height.cfloat, cols.cint)

proc setLayoutRowStatic*(height: float; width, cols: int) =
  ## Set the current widgets layout to divide it into selected amount of
  ## columns with the selected height in rows but it will not grow in width
  ## when the parent window resizes
  ##
  ## * height    - the height in pixels of each row
  ## * width     - the width in pixels of each column
  ## * cols      - the amount of columns in each row
  proc nk_layout_row_static(ctx; height: cfloat; item_width,
      cols: cint) {.importc, cdecl.}
  nk_layout_row_static(ctx, height.cfloat, width.cint, cols.cint)

# -----
# Menus
# -----
template menuBar*(content: untyped) =
  # Create a menu bar with the selected content
  #
  # * content - the content of the menu bar
  nk_menubar_begin(ctx)
  content
  nk_menubar_end(ctx)

proc createMenu(ctx; text: cstring; align: nk_flags; x, y: cfloat): bool =
  ## Create a Nuklear menu, internal use only, temporary code
  ##
  ## Returns true if the popup was successfully created, otherwise false.
  ##
  ## * ctx   - the Nuklear context
  ## * text  - the label for the menu
  ## * align - the menu alignment
  ## * x     - the X position of the top left corner of the menu
  ## * y     - the Y position of the top left corner of the menu
  ##
  ## Returns true if menu were created, otherwise false
  proc nk_menu_begin_label(ctx; text: cstring; align: nk_flags;
       size: nk_vec2): nk_bool {.importc, nodecl.}
  return nk_menu_begin_label(ctx, text, align, new_nk_vec2(x, y))

template menu*(text: string; align: TextAlignment; x, y: float;
    content: untyped) =
  ## Create a Nuklear menu
  ##
  ## * text    - the label for the menu
  ## * align   - the menu alignment
  ## * x       - the X position of the top left corner of the menu
  ## * y       - the Y position of the top left corner of the menu
  ## * content - the content of the menu
  if createMenu(ctx, text.cstring, align.nk_flags, x, y):
    content
    nk_menu_end(ctx)

template menuItem*(label: string; align: TextAlignment; onPressCode: untyped) =
  ## Create a Nuklear menu's item. Execute the selected code when the user
  ## select the item from a menu.
  ##
  ## * label       - the label of the item
  ## * align       - the alignment of the item's label
  ## * onPressCode - the code executed when the menu was selected by the user
  if nk_menu_item_label(ctx, label.cstring, align.nk_flags):
    onPressCode

# ----------
# Properties
# ----------

proc propertyInt*(name: string; min: int; val: var int; max, step: int;
    incPerPixel: float) =
  ## Create a Nuklear property widget with integer values
  ##
  ## * name        - the name of the property and its label to show on it.
  ##                 Using symbol # will generate random string in its place,
  ##                 but it will not show in the property's text
  ## * min         - the minimal value of the property
  ## * val         - the current value of the property
  ## * max         - the maximum value of the property
  ## * step        - the amount which increase or decrease the property value
  ##                 when the user press arrows buttons
  ## * incPerPixel - the amount which increase or decrease the property value
  ##                 when the user drag in it
  ##
  ## Returns the modified parameter val
  proc nk_property_int(ctx; name: cstring; min: cint; val: var cint; max,
      step: cint; inc_per_pixel: cfloat) {.importc, nodecl.}
  var newVal = val.cint
  nk_property_int(ctx, name.cstring, min.cint, newVal, max.cint, step.cint,
      incPerPixel.cfloat)
  val = newVal.int

# -----
# Style
# -----
proc headerAlign*(value: StyleHeaderAlign) =
  ## Set the Nuklear windows header alignment
  ##
  ## * value - the new value for the alignment
  ctx.style.window.header.align = value.ord.nk_style_header_align
var buttonStyle: nk_style_button ## Used to store the Nuklear buttons style
proc saveButtonStyle*(ctx) =
  ## Save the Nuklear buttons style to variable, so it can be restored later
  ##
  ## * ctx - the Nuklear context
  buttonStyle = ctx.style.button
proc restoreButtonStyle*(ctx) =
  ## Restore previously save to the variable Nuklear buttons style
  ##
  ## * ctx - the Nuklear context
  ctx.style.button = buttonStyle
proc setButtonStyle*(ctx; field: ButtonStyleTypes; r, g, b: cint) =
  ## Set the color for the selcted field of the Nuklear buttons style
  ##
  ## * ctx   - the Nuklear context
  ## * field - the style's field which value will be changed
  ## * r     - the red value for the style color in RGB
  ## * g     - the green value for the style color in RGB
  ## * b     - the blue value for the style color in RGB
  case field
  of normal:
    ctx.style.button.normal = nk_style_item_color(nk_rgb(r, g, b))
  of hover:
    ctx.style.button.hover = nk_style_item_color(nk_rgb(r, g, b))
  of active:
    ctx.style.button.active = nk_style_item_color(nk_rgb(r, g, b))
  of borderColor:
    ctx.style.button.border_color = nk_rgb(r, g, b)
  of textBackground:
    ctx.style.button.text_background = nk_rgb(r, g, b)
  of textNormal:
    ctx.style.button.text_normal = nk_rgb(r, g, b)
  of textHover:
    ctx.style.button.text_hover = nk_rgb(r, g, b)
  of textActive:
    ctx.style.button.text_active = nk_rgb(r, g, b)
  else:
    discard
proc setButtonStyle2*(ctx; source, destination: ButtonStyleTypes) =
  ## Copy one field of Nuklear buttons style to another
  ##
  ## * ctx         - the Nuklear context
  ## * source      - the field which value will be copied
  ## * destination - the field to which the source value will be copied
  if source == active:
    if destination == normal:
      ctx.style.button.normal = ctx.style.button.active
proc getButtonStyle*(ctx; field: ButtonStyleTypes): NimVec2 =
  ## Get the value of the selected field of Nuklear buttons style
  ##
  ## * ctx   - the Nuklear context
  ## * field - the field which value will be taken
  ##
  ## Returns vector with the value of the selected field
  if field == padding:
    return NimVec2(x: ctx.style.button.padding.x, y: ctx.style.button.padding.y)
proc stylePushVec2*(ctx; field: WindowStyleTypes; x,
    y: cfloat): bool =
  ## Push the vector value for the selected Nuklear window style on a
  ## temporary stack
  ##
  ## * ctx   - the Nuklear context
  ## * field - the Nuklear windows style field which will be modified
  ## * x     - the X value of the vector to push
  ## * y     - the Y value of the vector to push
  ##
  ## Returns true if value was succesfully pushed, otherwise false
  proc nk_style_push_vec2(ctx; dest: var nk_vec2;
      source: nk_vec2): nk_bool {.importc, nodecl.}
  if field == spacing:
    return nk_style_push_vec2(ctx, ctx.style.window.spacing, new_nk_vec2(x,
        y))
proc stylePushFloat*(ctx; field: ButtonStyleTypes;
    value: cfloat): bool =
  ## Push the float value for the selected Nuklear buttons style on a
  ## temporary stack
  ##
  ## * ctx   - the Nuklear context
  ## * field - the Nuklear buttons style field which will be modified
  ## * value - the float value to push
  ##
  ## Returns true if value was succesfully pushed, otherwise false
  proc nk_style_push_float(ctx; dest: var cfloat;
      source: cfloat): nk_bool {.importc, nodecl.}
  case field
  of rounding:
    return nk_style_push_float(ctx, ctx.style.button.rounding, value)
  else:
    return false
proc styleFromTable*(table: openArray[NimColor]) =
  ## Set the Nuklear style colors from the table
  ##
  ## * table - the colors table which will be set
  proc nk_style_from_table(ctx; table: pointer) {.importc, nodecl.}
  var newTable: array[countColors.ord, nk_color]
  for index, color in table.pairs:
    newTable[index] = nk_rgba(color.r, color.g, color.b, color.a)
  nk_style_from_table(ctx, newTable.unsafeAddr)
proc defaultStyle*() =
  ## reset the UI colors to the default Nuklear setting
  proc nk_style_default(ctx) {.importc, nodecl.}
  nk_style_default(ctx)

# ------
# Combos
# ------
proc comboList*(items: openArray[string]; selected, itemHeight: int; x,
    y: float; amount: int = items.len - 1): int =
  ## Create a Nuklear combo widget
  ##
  ## * items       - the list of values for the combo
  ## * selected    - the index of the selected value on the combo's list
  ## * item_height - the height in pixels for the values in the combo's list
  ## * x           - the width of the combo
  ## * y           - the height of the combo's values list
  ## * amount      - the amount of items in the items list. Default to the length
  ##                 of the list
  ##
  ## Returns the index of the currently selected valu on the combo's list
  proc nk_combo(ctx; items: pointer; count,
      selected, item_height: cint; size: nk_vec2): cint {.importc, nodecl.}
  var optionsList: seq[cstring]
  for i in 0 .. amount:
    optionsList.add(items[i].cstring)
  return nk_combo(ctx, optionsList[0].unsafeAddr, amount.cint + 1,
      selected.cint, itemHeight.cint, new_nk_vec2(x.cfloat, y.cfloat)).int
proc createColorCombo*(ctx; color: NimColor; x, y: cfloat): bool =
  ## Create a Nuklear combo widget which display color as the value
  ##
  ## * ctx   - the Nuklear context
  ## * color - the color displayed as the value of the combo
  ## * x     - the width of the combo
  ## * y     - the height of the combo's values list
  ##
  ## Returns true if combo was successfully created, otherwise false
  return nk_combo_begin_color(ctx, nk_rgb(color.r, color.g, color.b),
      new_nk_vec2(x, y))
proc createColorCombo*(ctx; color: NimColorF; x, y: cfloat): bool =
  ## Create a Nuklear combo widget which display color with float values as
  ## the value
  ##
  ## * ctx   - the Nuklear context
  ## * color - the color with float values displayed as the value of the combo
  ## * x     - the width of the combo
  ## * y     - the height of the combo's values list
  ##
  ## Returns true if combo was successfully created, otherwise false
  return nk_combo_begin_color(ctx, nk_rgb_cf(nk_colorf(r: color.r, g: color.g,
      b: color.b, a: color.a)), new_nk_vec2(x, y))
proc createLabelCombo*(ctx; selected: cstring; x, y: cfloat): bool =
  ## Create a Nuklear combo widget which display the custom text as the value
  ##
  ## * ctx      - the Nuklear context
  ## * selected - the text to display as the value of the combo
  ## * x        - the width of the combo
  ## * y        - the height of the combo's values list
  ##
  ## Returns true if combo was successfully created, otherwise false
  proc nk_combo_begin_label(ctx; selected: cstring;
      size: nk_vec2): nk_bool {.importc, nodecl.}
  return nk_combo_begin_label(ctx, selected, new_nk_vec2(x, y))

# ------
# Colors
# ------
proc colorfToHsva*(hsva: var array[4, cfloat]; color: NimColorF) =
  ## Convert Nim float color object to HSVA values
  ##
  ## * hsva  - the array of 4 values for HSVA color
  ## * color - the Nim color to convert
  ##
  ## Returns converted color as hsva argument
  proc nk_colorf_hsva_fv(hsva: pointer; color: nk_colorf) {.importc, nodecl.}
  nk_colorf_hsva_fv(hsva.unsafeAddr, nk_colorf(r: color.r, g: color.g,
      b: color.b, a: color.a))
proc hsvaToColorf*(hsva: array[4, cfloat]): NimColorF =
  ## Convert HSVA values to Nim color with float values
  ##
  ## * hsva - the array with HSVA values to convert
  ##
  ## Returns converted hsva parameter to Nim color with float values
  proc nk_hsva_colorf(h, s, v, a: cfloat): nk_colorf {.importc, nodecl.}
  let newColor = nk_hsva_colorf(hsva[0], hsva[1], hsva[2], hsva[3])
  result = NimColorF(r: newColor.r, g: newColor.g, b: newColor.b, a: newColor.a)

# ------
# Charts
# ------
proc createColorChart*(ctx; ctype: nk_chart_type; color,
    higlight: NimColor; count: cint; min_value, max_value: cfloat): bool =
  ## Create a colored chart
  ##
  ## * ctx       - the Nuklear context
  ## * ctype     - the type of the chart
  ## * color     - the color used for drawing the chart
  ## * highligh  - the color used for highlighting point when mouse hovering
  ##               over it
  ## * count     - the amount of values on the chart
  ## * min_value - the minimal value of the chart
  ## * max_value - the maximum value of the chart
  ##
  ## Returns true if the chart was succesfully created otherwise false
  proc nk_chart_begin_colored(ctx; ctype: nk_chart_type; color,
      higlight: nk_color; count: cint; min_value,
      max_value: cfloat): nk_bool {.importc, nodecl.}
  return nk_chart_begin_colored(ctx, ctype, nk_rgb(color.r, color.g, color.b),
      nk_rgb(higlight.r, higlight.g, higlight.b), count, min_value,
    max_value)
proc addColorChartSlot*(ctx; ctype: nk_chart_type; color,
    higlight: NimColor; count: cint; min_value, max_value: cfloat) =
  ## Add another chart to the existing one
  ##
  ## * ctx       - the Nuklear context
  ## * ctype     - the type of the chart
  ## * color     - the color used for drawing the chart
  ## * highligh  - the color used for highlighting point when mouse hovering
  ##               over it
  ## * count     - the amount of values on the chart
  ## * min_value - the minimal value of the chart
  ## * max_value - the maximum value of the chart
  proc nk_chart_add_slot_colored(ctx; ctype: nk_chart_type; color,
      higlight: nk_color; count: cint; min_value, max_value: cfloat) {.importc, nodecl.}
  nk_chart_add_slot_colored(ctx, ctype, nk_rgb(color.r, color.g, color.b),
      nk_rgb(higlight.r, higlight.g, higlight.b), count, min_value, max_value)

# ----------
# Contextual
# ----------
proc createContextual*(ctx; flags: nk_flags; x, y: cfloat;
    trigger_bounds: NimRect): bool =
  ## Create a contextual menu
  ##
  ## * ctx            - the Nuklear context
  ## * flags          - the flags for the menu
  ## * x              - the width of the menu
  ## * y              - the height of the menu
  ## * trigger_bounds - the rectange of coordinates in the window where clicking
  ##                    cause the menu to appear
  ##
  ## Return true if the contextual menu was created successfully, otherwise
  ## false
  proc nk_contextual_begin(ctx; flags: nk_flags; size: nk_vec2;
      trigger_bounds: nk_rect): nk_bool {.importc, nodecl.}
  return nk_contextual_begin(ctx, flags, new_nk_vec2(x, y), new_nk_rect(
      trigger_bounds.x, trigger_bounds.y, trigger_bounds.w,
      trigger_bounds.h))

# -----
# Input
# -----
proc isMouseHovering*(ctx; x, y, w, h: cfloat): bool =
  ## Check if mouse is hovering over the selected rectangle
  ##
  ## * ctx - the Nuklear context
  ## * x   - the X coordinate of top left corner of the rectangle
  ## * y   - the Y coordinate of top left corner of the rectangle
  ## * w   - the width of the rectangle in pixels
  ## * h   - the height of the rectangle in pixels
  ##
  ## Returns true if the mouse is hovering over the rectangle, otherwise false
  proc nk_input_is_mouse_hovering_rect(i: ptr nk_input;
      rect: nk_rect): nk_bool {.importc, nodecl.}
  return nk_input_is_mouse_hovering_rect(ctx.input.unsafeAddr, new_nk_rect(x, y,
      w, h))
proc isMousePrevHovering*(ctx; x, y, w, h: cfloat): bool =
  ## Check if the mouse was previously hovering over the selected rectangle
  ##
  ## * ctx - the Nuklear context
  ## * x   - the X coordinate of top left corner of the rectangle
  ## * y   - the Y coordinate of top left corner of the rectangle
  ## * w   - the width of the rectangle in pixels
  ## * h   - the height of the rectangle in pixels
  ##
  ## Returns true if the mouse was hovering over the rectangle, otherwise false
  proc nk_input_is_mouse_prev_hovering_rect(i: ptr nk_input;
      rect: nk_rect): nk_bool {.importc, nodecl.}
  return nk_input_is_mouse_prev_hovering_rect(ctx.input.unsafeAddr, new_nk_rect(
      x, y, w, h))
proc isMouseDown*(ctx; id: nk_buttons): bool =
  ## Check if mouse is pressed
  ##
  ## * ctx - the Nuklear context
  ## * id  - the mouse button which is pressed
  ##
  ## Returns true if the selected mouse button is pressed, otherwise false
  proc nk_input_is_mouse_down(i: ptr nk_input;
      id: nk_buttons): nk_bool {.importc, nodecl.}
  return nk_input_is_mouse_down(ctx.input.unsafeAddr, id)
proc getMouseDelta*(ctx): NimVec2 =
  ## Get the mouse vector between last check and current position of the mouse
  ##
  ## * ctx - the Nuklear context
  ##
  ## Returns vector with information about the mouse movement delta
  return NimVec2(x: ctx.input.mouse.delta.x, y: ctx.input.mouse.delta.y)

# ---------
# Edit text
# ---------
proc editString*(text: var string; maxLen: int; editType: EditTypes = simple;
    filter: PluginFilter = nk_filter_default; flags: set[EditFlags] = {}): EditEvent {.discardable.} =
  ## Draw the field of hte selected type and with the selected filter to edit a
  ## text
  ##
  ##  * text     - the text which will be edited in the field
  ##  * maxLen   - the maximum length of the text to edit
  ##  * editType - the type of the edit field. By default it is a simple, one
  ##               line field
  ##  * filter   - the procedure used to filter the user's input in the edit
  ##               field. By default there is no filtering.
  ##  * flags    - the additional flags for the edit field. By default no
  ##               additional flags
  ##
  ## Returns the current state of the edit field and the modified text
  ## parameter.

  proc nk_edit_string(ctx; flags: nk_flags; memory: pointer;
      len: var cint; max: cint; filter: PluginFilter): nk_flags {.importc, nodecl.}

  var
    (cText, length) = stringToCharArray(text, maxLen)
    cFlags: cint = editType.ord.cint
  {.warning[HoleEnumConv]: off.}
  for flag in flags:
    cFlags = cFlags or flag.cint
  result = nk_edit_string(ctx = ctx, flags = cFlags,
      memory = cText[0].unsafeAddr, len = length.cint, max = maxLen.cint,
      filter = filter).EditEvent
  text = charArrayToString(cText, length)

# -------
# Widgets
# -------
proc colorPicker*(ctx; color: NimColorF;
    format: nk_color_format): NimColorF =
  ## Create the color picker widget
  ##
  ## * ctx    - the Nuklear context
  ## * color  - the starting color for the widget
  ## * format - the color format for the widget
  ##
  ## Returns Nim color selected by the user in the widget
  proc nk_color_picker(ctx; color: nk_colorf;
      fmt: nk_color_format): nk_colorf {.importc, nodecl.}
  let newColor = nk_color_picker(ctx, nk_colorf(r: color.r, g: color.g,
      b: color.b, a: color.a), format)
  result = NimColorF(r: newColor.r, g: newColor.g, b: newColor.b, a: newColor.a)

proc checkBox*(label: string; checked: var bool): bool {.discardable.} =
  ## Create a Nuklear checkbox widget
  ##
  ## * label   - the text to show with the checkbox
  ## * checked - the state of the checkbox, if true, the checkbox is checked
  ##
  ## Returns true if the state of the checkbox was changed, otherwise false.
  proc nk_checkbox_label(ctx; text: cstring;
      active: var cint): nk_bool {.importc, nodecl.}
  var active: cint = (if checked: 1 else: 0)
  result = nk_checkbox_label(ctx = ctx, text = label.cstring,
      active = active) == nk_true
  checked = active == 1

proc option*(label: string; selected: bool): bool =
  ## Create a Nuklear option (radio) widget
  ##
  ## * label    - the text show with the option
  ## * selected - the state of the option, if true the option is selected
  ##
  ## Returns true if the option is selected, otherwise false
  proc nk_option_label(ctx; name: cstring; active: cint): nk_bool {.importc, nodecl.}
  var active: cint = (if selected: 1 else: 0)
  return nk_option_label(ctx = ctx, name = label.cstring, active = active) == nk_true
