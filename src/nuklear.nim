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

# Constants
const
  nkWindowBorder*: cint = 1 shl 0
  nkWindowMoveable*: cint = 1 shl 1
  nkWindowScalable*: cint = 1 shl 2
  nkWindowCloseable*: cint = 1 shl 3
  nkWindowMinimizable*: cint = 1 shl 4
  nkWindowNoScrollbar*: cint = 1 shl 5
  nkWindowScaleLeft*: cint = 1 shl 9
  nkWindowTitle*: cint = 1 shl 6

# Simple types
type
  nk_flags* = cint
  nk_size* = clong
  nk_byte* = uint8
  nk_rune* = cuint

# Enumerations
type
  nk_style_header_align* = enum
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
  nk_popup_type* = enum
    NK_POPUP_STATIC, NK_POPUP_DYNAMIC
  nk_bool* = enum
    nk_false, nk_true
  nk_modify* = enum
    NK_FIXED, NK_MODIFIABLE
  nk_collapse_states* = enum
    NK_MINIMIZED, NK_MAXIMIZED
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
  nk_edit_flags* = enum
    NK_EDIT_DEFAULT = 0,
    NK_EDIT_READ_ONLY = 1 shl 0,
    NK_EDIT_AUTO_SELECT = 1 shl 1,
    NK_EDIT_SIG_ENTER = 1 shl 2,
    NK_EDIT_ALLOW_TAB = 1 shl 3,
    NK_EDIT_NO_CURSOR = 1 shl 4,
    NK_EDIT_SELECTABLE = 1 shl 5,
    NK_EDIT_CLIPBOARD = 1 shl 6,
    NK_EDIT_CTRL_ENTER_NEWLINE = 1 shl 7,
    NK_EDIT_NO_HORIZONTAL_SCROLL = 1 shl 8,
    NK_EDIT_ALWAYS_INSERT_MODE = 1 shl 9,
    NK_EDIT_MULTILINE = 1 shl 10,
    NK_EDIT_GOTO_END_ON_ACTIVATE = 1 shl 11
  nk_edit_types* = enum
    NK_EDIT_SIMPLE = NK_EDIT_ALWAYS_INSERT_MODE,
    NK_EDIT_FIELD = NK_EDIT_SIMPLE.int or NK_EDIT_SELECTABLE.int or
        NK_EDIT_CLIPBOARD.int,
    NK_EDIT_EDITOR = NK_EDIT_ALLOW_TAB.int or NK_EDIT_SELECTABLE.int or
        NK_EDIT_CLIPBOARD.int or NK_EDIT_MULTILINE.int,
    NK_EDIT_BOX = NK_EDIT_ALWAYS_INSERT_MODE.int or NK_EDIT_SELECTABLE.int or
        NK_EDIT_MULTILINE.int or NK_EDIT_ALLOW_TAB.int or NK_EDIT_CLIPBOARD.int
  nk_edit_events* = enum
    NK_EDIT_ACTIVE = 1 shl 0,
    NK_EDIT_INACTIVE = 1 shl 1,
    NK_EDIT_ACTIVATED = 1 shl 2,
    NK_EDIT_DEACTIVATED = 1 shl 3,
    NK_EDIT_COMMITED = 1 shl 4
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

# Objects
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
  nk_plugin_filter* = proc (box: ptr nk_text_edit;
      unicode: nk_rune): nk_bool {.cdecl.}
  nk_font* {.importc: "struct nk_font", nodecl.} = object
    handle*: nk_user_font
  nk_font_atlas* {.importc: "struct nk_font_atlas", nodecl.} = object
  nk_font_config* {.importc: "struct nk_font_config", nodecl.} = object
  PContext* = ptr nk_context

# Creating structures
proc new_nk_rect*(x, y, w, h: cfloat): nk_rect {.importc: "nk_rect", nodecl.}
proc new_nk_vec2*(x, y: cfloat): nk_vec2 {.importc: "nk_vec2", nodecl.}
proc new_nk_font_config*(pixel_height: cfloat): nk_font_config {.importc: "nk_font_config", nodecl.}

# Input
proc nk_input_begin*(ctx: PContext) {.importc, nodecl.}
proc nk_input_end*(ctx: PContext) {.importc, nodecl.}
proc nk_input_is_mouse_hovering_rect*(i: ptr nk_input;
    rect: nk_rect): nk_bool {.importc, nodecl.}
proc nk_input_is_mouse_prev_hovering_rect*(i: ptr nk_input;
    rect: nk_rect): nk_bool {.importc, nodecl.}
proc nk_input_is_mouse_down*(i: ptr nk_input;
    id: nk_buttons): nk_bool {.importc, nodecl.}

# General
proc nk_begin*(ctx: PContext; title: cstring; bounds: nk_rect;
    flags: nk_flags): nk_bool {.importc, nodecl.}
proc nk_end*(ctx: PContext) {.importc, cdecl.}
proc nk_window_is_hidden*(ctx: PContext; name: cstring): cint {.importc, cdecl.}
proc nk_spacing*(ctx: PContext; cols: cint) {.importc, cdecl.}
proc nk_widget_bounds*(ctx: PContext): nk_rect {.importc, nodecl.}

# Text
proc nk_label*(ctx: PContext; str: cstring;
    alignment: nk_flags) {.importc, cdecl.}
proc nk_label_colored*(ctx: PContext; str: cstring; align: nk_flags;
    color: nk_color) {.importc, nodecl.}
proc nk_text*(ctx: PContext; str: cstring; len: cint;
    alignment: nk_flags) {.importc, cdecl.}
proc nk_label_wrap*(ctx: PContext; str: cstring) {.importc, cdecl.}
proc nk_labelf*(ctx: PContext; flags: nk_flags; fmt: cstring) {.importc,
    varargs, cdecl.}

# Layouts
proc nk_layout_row_static*(ctx: PContext; height: cfloat; item_width,
    cols: cint) {.importc, cdecl.}
proc nk_layout_row_dynamic*(ctx: PContext; height: cfloat;
    cols: cint) {.importc, cdecl.}
proc nk_layout_row_end*(ctx: PContext) {.importc, cdecl.}
proc nk_layout_row_begin*(ctx: PContext; fmt: nk_layout_format;
    row_height: cfloat; cols: cint) {.importc, cdecl.}
proc nk_layout_row_push*(ctx: PContext; width: cfloat) {.importc, cdecl.}
proc nk_layout_row*(ctx: PContext; fmt: nk_layout_format; height: cfloat;
    cols: cint; ratio: pointer) {.importc, cdecl.}
proc nk_layout_space_begin*(ctx: PContext; fmt: nk_layout_format;
    height: cfloat; widget_count: cint) {.importc, cdecl.}
proc nk_layout_space_end*(ctx: PContext) {.importc, cdecl.}
proc nk_layout_space_push*(ctx: PContext; rect: nk_rect) {.importc, nodecl.}
proc nk_layout_row_template_begin*(ctx: PContext; height: cfloat) {.importc, cdecl.}
proc nk_layout_row_template_push_dynamic*(ctx: PContext) {.importc, cdecl.}
proc nk_layout_row_template_push_variable*(ctx: PContext;
    min_width: cfloat) {.importc, cdecl.}
proc nk_layout_row_template_push_static*(ctx: PContext;
    width: cfloat) {.importc, cdecl.}
proc nk_layout_row_template_end*(ctx: PContext) {.importc, cdecl.}

# Menus
proc nk_menubar_begin*(ctx: PContext) {.importc, cdecl.}
proc nk_menubar_end*(ctx: PContext) {.importc, cdecl.}
proc nk_menu_begin_label*(ctx: PContext; text: cstring; align: nk_flags;
     size: nk_vec2): nk_bool {.importc, nodecl.}
proc nk_menu_end*(ctx: PContext) {.importc, cdecl.}
proc nk_menu_item_label*(ctx: PContext; text: cstring;
    aligmnent: nk_flags): nk_bool {.importc, cdecl.}

# Charts
proc nk_chart_begin*(ctx: PContext; ctype: nk_chart_type; num: cint; min,
    max: cfloat): nk_bool {.importc, cdecl.}
proc nk_chart_push*(ctx: PContext; value: cfloat): nk_flags {.importc, cdecl.}
proc nk_chart_end*(ctx: PContext) {.importc, cdecl.}
proc nk_chart_add_slot*(ctx: PContext; ctype: nk_chart_type; count: cint;
    min_value, max_value: cfloat) {.importc, cdecl.}
proc nk_chart_push_slot*(ctx: PContext; value: cfloat;
    slot: cint): nk_flags {.importc, cdecl.}
proc nk_chart_begin_colored*(ctx: PContext; ctype: nk_chart_type; color,
    higlight: nk_color; count: cint; min_value,
    max_value: cfloat): nk_bool {.importc, nodecl.}
proc nk_chart_add_slot_colored*(ctx: PContext; ctype: nk_chart_type; color,
    higlight: nk_color; count: cint; min_value, max_value: cfloat) {.importc, nodecl.}

# Popups
proc nk_popup_begin*(ctx: PContext; pType: nk_popup_type; title: cstring;
    flags: nk_flags; rect: nk_rect): nk_bool {.importc, nodecl.}
proc nk_popup_end*(ctx: PContext) {.importc, nodecl.}
proc nk_popup_close*(ctx: PContext) {.importc, nodecl.}

# Trees
proc nk_tree_state_push*(ctx: PContext; ttype: nk_tree_type;
    title: cstring; state: var nk_collapse_states): nk_bool {.importc, cdecl.}
proc nk_tree_pop*(ctx: PContext) {.importc, cdecl.}
proc nk_tree_push_hashed*(ctx: PContext; ttype: nk_tree_type;
    title: cstring; state: nk_collapse_states; hash: cstring; len,
    id: cint): nk_bool {.importc, cdecl.}
proc nk_tree_element_push_hashed*(ctx: PContext; ttype: nk_tree_type;
    title: cstring; state: nk_collapse_states; selected: var nk_bool;
    hash: cstring; len, sed: cint): nk_bool {.importc, cdecl.}
proc nk_tree_element_pop*(ctx: PContext) {.importc, cdecl.}

# Buttons
proc nk_button_label*(ctx: PContext; title: cstring): nk_bool {.importc, cdecl.}
proc nk_button_set_behavior*(ctx: PContext;
    behavior: nk_button_behavior) {.importc, cdecl.}
proc nk_button_color*(ctx: PContext; color: nk_color): nk_bool {.importc, nodecl.}
proc nk_button_symbol*(ctx: PContext; symbol: nk_symbol_type): nk_bool {.importc, cdecl.}
proc nk_button_symbol_label*(ctx: PContext; symbol: nk_symbol_type;
    label: cstring; align: nk_flags): nk_bool {.importc, cdecl.}

# Sliders
proc nk_slider_int*(ctx: PContext; min: cint; val: var cint; max,
    step: cint): nk_bool {.importc, cdecl.}
proc nk_slider_float*(ctx: PContext; min: cfloat; val: var cfloat; max,
    value_step: cfloat): nk_bool {.importc, cdecl.}
proc nk_slide_int*(ctx: PContext; min, val, max, step: cint): cint {.importc, cdecl.}

# Properties
proc nk_property_int*(ctx: PContext; name: cstring; min: cint;
    val: var cint; max, step: cint; inc_per_pixel: cfloat) {.importc, cdecl.}
proc nk_property_float*(ctx: PContext; name: cstring; min: cfloat;
    val: var cfloat; max, step, inc_per_pixel: cfloat) {.importc, cdecl.}
proc nk_propertyf*(ctx: PContext; name: cstring; min, val, max, step,
    inc_per_pixel: cfloat): cfloat {.importc, cdecl.}
proc nk_propertyi*(ctx: PContext; name: cstring; min, val, max, step: cint;
    inc_per_pixel: cfloat): cint {.importc, cdecl.}

# Style
proc nk_style_item_color*(col: nk_color): nk_style_item {.importc, cdecl.}
proc nk_style_push_vec2*(ctx: PContext; dest: var nk_vec2;
    source: nk_vec2): nk_bool {.importc, nodecl.}
proc nk_style_push_float*(ctx: PContext; dest: var cfloat;
    source: cfloat): nk_bool {.importc, nodecl.}
proc nk_style_pop_float*(ctx: PContext) {.importc, cdecl.}
proc nk_style_pop_vec2*(ctx: PContext) {.importc, cdecl.}
proc nk_style_from_table*(ctx: PContext; table: pointer) {.importc, nodecl.}
proc nk_style_default*(ctx: PContext) {.importc, cdecl.}
proc nk_style_set_font*(ctx: PContext; font: ptr nk_user_font) {.importc, nodecl.}

# Combos
proc nk_combo*(ctx: PContext; items: pointer; count,
    selected, item_height: cint; size: nk_vec2): cint {.importc, nodecl.}
proc nk_combo_begin_color*(ctx: PContext; color: nk_color;
    size: nk_vec2): nk_bool {.importc, nodecl.}
proc nk_combo_end*(ctx: PContext) {.importc, cdecl.}
proc nk_combo_begin_label*(ctx: PContext; selected: cstring;
    size: nk_vec2): nk_bool {.importc, nodecl.}
proc nk_combo_close*(ctx: PContext) {.importc, cdecl.}

# Colors
proc nk_colorf_hsva_fv*(hsva: pointer; color: nk_colorf) {.importc, nodecl.}
proc nk_hsva_colorf*(h, s, v, a: cfloat): nk_colorf {.importc, nodecl.}
proc nk_rgb*(r, g, b: cint): nk_color {.importc, nodecl.}
proc nk_rgb_cf*(c: nk_colorf): nk_color {.importc, nodecl.}
proc nk_rgba*(r, g, b, a: cint): nk_color {.importc, nodecl.}

# Filters
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

# Contextual
proc nk_contextual_begin*(ctx: PContext; flags: nk_flags; size: nk_vec2;
    trigger_bounds: nk_rect): nk_bool {.importc, nodecl.}
proc nk_contextual_end*(ctx: PContext) {.importc, cdecl.}
proc nk_contextual_item_label*(ctx: PContext; label: cstring;
    align: nk_flags): nk_bool {.importc, cdecl.}

# Tooltips
proc nk_tooltipf*(ctx: PContext; fmt: cstring) {.importc, nodecl, varargs.}
proc nk_tooltip*(ctx: PContext; text: cstring) {.importc, nodecl.}

# Groups
proc nk_group_begin*(ctx: PContext; title: cstring;
    flags: nk_flags): nk_bool {.importc, cdecl.}
proc nk_group_end*(ctx: PContext) {.importc, cdecl.}

# Selectables
proc nk_selectable_label*(ctx: PContext; str: cstring; align: nk_flags;
    value: var nk_bool): nk_bool {.importc, cdecl.}
proc nk_selectable_symbol_label*(ctx: PContext; sym: nk_symbol_type;
    title: cstring; align: nk_flags; value: var nk_bool): nk_bool {.importc, cdecl.}

# Widgets
proc nk_option_label*(ctx: PContext; name: cstring;
    active: cint): nk_bool {.importc, cdecl.}
proc nk_checkbox_label*(ctx: PContext; text: cstring;
    active: var cint): nk_bool {.importc, cdecl.}
proc nk_progress*(ctx: PContext; cur: var nk_size; max: nk_size;
    modifyable: nk_bool): nk_bool {.importc, cdecl.}
proc nk_color_picker*(ctx: PContext; color: nk_colorf;
    fmt: nk_color_format): nk_colorf {.importc, nodecl.}
proc nk_edit_string*(ctx: PContext; flags: nk_flags; memory: pointer;
    len: var cint; max: cint; filter: nk_plugin_filter): nk_flags {.importc, cdecl.}

# Fonts
proc nk_font_atlas_add_default*(atlas: ptr nk_font_atlas; height: cfloat;
    config: ptr nk_font_config): ptr nk_font {.importc, nodecl.}

# High level bindings. Necessary to workaround some limitations/bugs

type
  NimColor* = object
    r*, g*, b*, a*: cint
  NimColorF* = object
    r*, g*, b*, a*: cfloat
  NimRect* = object
    x*, y*, w*, h*: cfloat
  NimVec2* = object
    x*, y*: cfloat
  ButtonStyleTypes* = enum
    normal, hover, active, borderColor, textBackground, textNormal, textHover,
        textActive, rounding, padding
  WindowStyleTypes* = enum
    spacing

# Converters
converter toBool*(x: nk_bool): bool =
  x == nk_true
converter toNkFlags*(x: nk_text_alignment): nk_flags =
  x.ord.cint
converter toNkFlags*(x: nk_edit_types): nk_flags =
  x.ord.cint

# General
proc createWin*(ctx: PContext; name: cstring; x, y, w, h: cfloat;
    flags: nk_flags): bool =
  return nk_begin(ctx, name, new_nk_rect(x, y, w, h), flags)
proc createPopup*(ctx: PContext; pType: nk_popup_type; title: cstring;
    flags: nk_flags; x, y, w, h: cfloat): bool =
  return nk_popup_begin(ctx, pType, title, flags, new_nk_rect(x, y, w, h))
proc getWidgetBounds*(ctx: PContext): NimRect =
  let rect = nk_widget_bounds(ctx)
  return NimRect(x: rect.x, y: rect.y, w: rect.w, h: rect.h)
proc getTextWidth*(ctx: PContext; text: cstring): cfloat =
  return ctx.style.font.width(ctx.style.font.userdata, ctx.style.font.height,
      text, text.len.cint)

# Labels
proc colorLabel*(ctx: PContext; str: cstring; align: nk_flags; r, g, b: cint) =
  nk_label_colored(ctx, str, align, nk_rgb(r, g, b))

# Buttons
proc colorButton*(ctx: PContext; r, g, b: cint): bool =
  return nk_button_color(ctx, nk_rgb(r, g, b))

# Layouts
proc layoutSpacePush*(ctx: PContext; x, y, w, h: cfloat) =
  nk_layout_space_push(ctx, new_nk_rect(x, y, w, h))

# Menu
proc createMenu*(ctx: PContext; text: cstring; align: nk_flags; x,
    y: cfloat): bool =
  return nk_menu_begin_label(ctx, text, align, new_nk_vec2(x, y))

# Style
proc headerAlign*(ctx: PContext; value: nk_style_header_align) =
  ctx.style.window.header.align = value
var buttonStyle: nk_style_button
proc saveButtonStyle*(ctx: PContext) =
  buttonStyle = ctx.style.button
proc restoreButtonStyle*(ctx: PContext) =
  ctx.style.button = buttonStyle
proc setButtonStyle*(ctx: PContext; field: ButtonStyleTypes; r, g, b: cint) =
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
proc setButtonStyle2*(ctx: PContext; source, destination: ButtonStyleTypes) =
  if source == active:
    if destination == normal:
      ctx.style.button.normal = ctx.style.button.active
proc getButtonStyle*(ctx: PContext; field: ButtonStyleTypes): NimVec2 =
  if field == padding:
    return NimVec2(x: ctx.style.button.padding.x, y: ctx.style.button.padding.y)
proc stylePushVec2*(ctx: PContext; field: WindowStyleTypes; x,
    y: cfloat): bool =
  if field == spacing:
    return nk_style_push_vec2(ctx, ctx.style.window.spacing, new_nk_vec2(x,
        y))
proc stylePushFloat*(ctx: PContext; field: ButtonStyleTypes;
    value: cfloat): bool =
  case field
  of rounding:
    return nk_style_push_float(ctx, ctx.style.button.rounding, value)
  else:
    return false
proc styleFromTable*(ctx: PContext; table: openArray[NimColor]) =
  var newTable: array[NK_COLOR_COUNT.ord, nk_color]
  for index, color in table.pairs:
    newTable[index] = nk_rgba(color.r, color.g, color.b, color.a)
  nk_style_from_table(ctx, newTable.unsafeAddr)

# Combos
proc createCombo*(ctx: PContext; items: openArray[cstring]; selected,
    item_height: cint; x, y: cfloat): cint =
  return nk_combo(ctx, items.unsafeAddr, items.len.cint, selected, item_height,
      new_nk_vec2(x, y))
proc createColorCombo*(ctx: PContext; color: NimColor; x, y: cfloat): bool =
  return nk_combo_begin_color(ctx, nk_rgb(color.r, color.g, color.b),
      new_nk_vec2(x, y))
proc createColorCombo*(ctx: PContext; color: NimColorF; x, y: cfloat): bool =
  return nk_combo_begin_color(ctx, nk_rgb_cf(nk_colorf(r: color.r, g: color.g,
      b: color.b, a: color.a)), new_nk_vec2(x, y))
proc createLabelCombo*(ctx: PContext; selected: cstring; x, y: cfloat): bool =
  return nk_combo_begin_label(ctx, selected, new_nk_vec2(x, y))

# Colors
proc colorfToHsva*(hsva: var array[4, cfloat]; color: NimColorF) =
  nk_colorf_hsva_fv(hsva.unsafeAddr, nk_colorf(r: color.r, g: color.g,
      b: color.b, a: color.a))
proc hsvaToColorf*(hsva: array[4, cfloat]): NimColorF =
  let newColor = nk_hsva_colorf(hsva[0], hsva[1], hsva[2], hsva[3])
  result = NimColorF(r: newColor.r, g: newColor.g, b: newColor.b, a: newColor.a)

# Charts
proc createColorChart*(ctx: PContext; ctype: nk_chart_type; color,
    higlight: NimColor; count: cint; min_value, max_value: cfloat): bool =
  return nk_chart_begin_colored(ctx, ctype, nk_rgb(color.r, color.g, color.b),
      nk_rgb(higlight.r, higlight.g, higlight.b), count, min_value,
    max_value)
proc addColorChartSlot*(ctx: PContext; ctype: nk_chart_type; color,
    higlight: NimColor; count: cint; min_value, max_value: cfloat) =
  nk_chart_add_slot_colored(ctx, ctype, nk_rgb(color.r, color.g, color.b),
      nk_rgb(higlight.r, higlight.g, higlight.b), count, min_value, max_value)

# Contextual
proc createContextual*(ctx: PContext; flags: nk_flags; x, y: cfloat;
    trigger_bounds: NimRect): bool =
  return nk_contextual_begin(ctx, flags, new_nk_vec2(x, y), new_nk_rect(
      trigger_bounds.x, trigger_bounds.y, trigger_bounds.w,
      trigger_bounds.h))

# Input
proc isMouseHovering*(ctx: PContext; x, y, w, h: cfloat): bool =
  return nk_input_is_mouse_hovering_rect(ctx.input.unsafeAddr, new_nk_rect(x, y,
      w, h))
proc isMousePrevHovering*(ctx: PContext; x, y, w, h: cfloat): bool =
  return nk_input_is_mouse_prev_hovering_rect(ctx.input.unsafeAddr, new_nk_rect(
      x, y, w, h))
proc isMouseDown*(ctx: PContext; id: nk_buttons): bool =
  return nk_input_is_mouse_down(ctx.input.unsafeAddr, id)
proc getMouseDelta*(ctx: PContext): NimVec2 =
  return NimVec2(x: ctx.input.mouse.delta.x, y: ctx.input.mouse.delta.y)

# Widgets
proc colorPicker*(ctx: PContext; color: NimColorF;
    format: nk_color_format): NimColorF =
  let newColor = nk_color_picker(ctx, nk_colorf(r: color.r, g: color.g,
      b: color.b, a: color.a), format)
  result = NimColorF(r: newColor.r, g: newColor.g, b: newColor.b, a: newColor.a)
