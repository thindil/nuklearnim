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

## Provides code for Nuklear backend for X11 Xlib

{.emit: """/*INCLUDESECTION*/
#define NK_INCLUDE_FIXED_TYPES
#define NK_INCLUDE_STANDARD_IO
#define NK_INCLUDE_STANDARD_VARARGS
#define NK_INCLUDE_DEFAULT_ALLOCATOR
#define NK_IMPLEMENTATION
#define NK_XLIB_IMPLEMENTATION
#include "nuklear.h"
#include "nuklear_xlib.h"
""".}

include nuklear

# Xlib bindings

const
  keyPressMask*: clong = 1 shl 0
  keyReleaseMask*: clong = 1 shl 1
  buttonPressMask*: clong = 1 shl 2
  buttonReleaseMask*: clong = 1 shl 3
  pointerMotionMask*: clong = 1 shl 6
  button1MotionMask*: clong = 1 shl 8
  button3MotionMask*: clong = 1 shl 10
  button4MotionMask*: clong = 1 shl 11
  button5MotionMask*: clong = 1 shl 12
  buttonMotionMask*: clong = 1 shl 13
  keymapStateMask*: clong = 1 shl 14
  exposureMask*: clong = 1 shl 15
  CWEventMask*: clong = 1 shl 11
  CWColorMask*: clong = 1 shl 13
  clientMessage*: cint = 33

type
  Display {.importc, nodecl.} = object
  Window = cint
  Visual {.importc, nodecl.} = object
  Colormap = cint
  XWindowAttributes {.importc, nodecl.} = object
    width: cint
    height: cint
  XSetWindowAttributes {.importc, nodecl.} = object
    colormap: Colormap
    event_mask: cint
  Atom = cint
  XFont {.importc, nodecl.} = object
  XEvent {.importc, nodecl.} = object
    `type`: cint
  Drawable = cint
  XWindow = object
    dpy: ptr Display
    root: Window
    vis: ptr Visual
    cmap: Colormap
    attr: XWindowAttributes
    swa: XSetWindowAttributes
    win: Window
    screen: cint
    font: ptr XFont
    width: cint
    height: cint
    wm_delete_window: Atom

proc XOpenDisplay(display_name: cstring): ptr Display {.importc, nodecl.}
proc DefaultRootWindow(display: ptr Display): Window {.importc, nodecl.}
proc XDefaultScreen(display: ptr Display): cint {.importc, nodecl.}
proc XDefaultVisual(display: ptr Display;
    screen_number: cint): ptr Visual {.importc, nodecl.}
proc XCreateColormap(display: ptr Display; w: Window; visual: ptr Visual;
    alloc: cint): Colormap {.importc, nodecl.}
proc XCreateWindow(display: ptr Display; parent: Window; x, y, width, height,
    border_width, depth, class: cint; visual: ptr Visual; valuemask: cint;
    attributes: ptr XSetWindowAttributes): Window {.importc, nodecl.}
proc XDefaultDepth(display: ptr Display; screen_number: cint): cint {.importc, nodecl.}
proc XStoreName(display: ptr Display; w: Window;
    window_name: cstring) {.importc, nodecl.}
proc XMapWindow(display: ptr Display; w: Window) {.importc, nodecl.}
proc XInternAtom(display: ptr Display; atom_name: cstring;
    only_if_exists: cint): Atom {.importc, nodecl.}
proc XSetWMProtocols(display: ptr Display; w: Window; protocols: ptr Atom;
    count: cint): cint {.importc, nodecl.}
proc XGetWindowAttributes(display: ptr Display; w: Window;
    window_attributes_return: ptr XWindowAttributes): cint {.importc, nodecl.}
proc XPending(display: ptr Display): cint {.importc, nodecl.}
proc XNextEvent(display: ptr Display; event_return: ptr XEvent) {.importc, nodecl.}
proc XFilterEvent(event: ptr XEvent; w: Window): cint {.importc, nodecl.}
proc XClearWindow(display: ptr Display; w: Window) {.importc, nodecl.}
proc XFlush(display: ptr Display) {.importc, nodecl.}
proc XUnmapWindow(display: ptr Display; w: Window) {.importc, nodecl.}
proc XFreeColormap(display: ptr Display; colormap: Colormap) {.importc, nodecl.}
proc XDestroyWindow(display: ptr Display; w: Window) {.importc, nodecl.}
proc XCloseDisplay(display: ptr Display) {.importc, nodecl.}

# Nuklear Xlib backend bindings

proc nk_xfont_create(dpy: ptr Display; name: cstring): ptr XFont {.importc, nodecl.}
proc nk_xlib_init(xfont: ptr XFont; dpy: ptr Display; screen: cint;
    root: Window; w, h: cint): PContext {.importc, nodecl.}
proc nk_xlib_handle_event(display: ptr Display; scrn: cint; w: Window;
    evt: ptr XEvent): cint {.importc, nodecl.}
proc nk_xlib_render(screen: Drawable; clear: nk_color) {.importc, nodecl.}
proc nk_xfont_del(dpy: ptr Display; font: ptr XFont) {.importc, nodecl.}
proc nk_xlib_shutdown() {.importc, nodecl.}

# High level bindings

import std/bitops

var xw: XWindow ## The main X window of the program

proc nuklearInit*(windowWidth, windowHeight: cint; name,
    font: cstring = "fixed"): PContext =
  ## Initialize Nuklear library, create the main program's window with the
  ## selected parameters.
  ##
  ## * windowWidth  - the default main window width
  ## * windowHeight - the default main window height
  ## * name         - the title of the main window
  ## * font         - the name of the font used in UI. Default value is "fixed".
  ##
  ## Returns pointer to the Nuklear context.
  xw.dpy = XOpenDisplay("")
  if xw.dpy == nil:
    quit "Could not open a display; perhaps $DISPLAY is not set?"
  xw.root = DefaultRootWindow(xw.dpy)
  xw.screen = XDefaultScreen(xw.dpy)
  xw.vis = XDefaultVisual(xw.dpy, xw.screen)
  xw.cmap = XCreateColormap(xw.dpy, xw.root, xw.vis, 0)
  xw.swa.colormap = xw.cmap
  xw.swa.event_mask = bitor(exposureMask, keyPressMask, keyReleaseMask,
      buttonPressMask, buttonReleaseMask, buttonMotionMask, button1MotionMask,
      button3MotionMask, button4MotionMask, button5MotionMask,
      pointerMotionMask, keymapStateMask)
  xw.win = XCreateWindow(xw.dpy, xw.root, 0.cint, 0.cint, windowWidth,
      windowHeight, 0.cint, XDefaultDepth(xw.dpy, xw.screen), 1.cint, xw.vis,
      bitor(CWEventMask, CWColorMask), xw.swa.addr)
  XStoreName(xw.dpy, xw.win, name)
  XMapWindow(xw.dpy, xw.win)
  xw.wm_delete_window = XInternAtom(xw.dpy, "WM_DELETE_WINDOW", 0)
  discard XSetWMProtocols(xw.dpy, xw.win, xw.wm_delete_window.addr, 1)
  discard XGetWindowAttributes(xw.dpy, xw.win, xw.attr.addr)
  xw.width = xw.attr.width
  xw.height = xw.attr.height
  xw.font = nk_xfont_create(xw.dpy, font)
  return nk_xlib_init(xw.font, xw.dpy, xw.screen, xw.win, xw.width, xw.height)

proc nuklearInput*(ctx: PContext): bool =
  ## Handle the user input
  ##
  ## * ctx - the pointer to the Nuklear context
  ##
  ## Returns true if user requested to close the window, otherwise false
  nk_input_begin(ctx)
  while XPending(xw.dpy) > 0:
    var evt: XEvent
    XNextEvent(xw.dpy, evt.addr)
    if evt.type == clientMessage:
      return true
    if XFilterEvent(evt.addr, xw.win) == 1:
      continue
    discard nk_xlib_handle_event(xw.dpy, xw.screen, xw.win, evt.addr)
  nk_input_end(ctx)

proc nuklearDraw*() =
  ## Draw the main window content
  XClearWindow(xw.dpy, xw.win)
  nk_xlib_render(xw.win, nk_rgb(30, 30, 30))
  XFlush(xw.dpy)

proc nuklearClose*() =
  ## Release all resources related to Xlib and Nuklear
  nk_xfont_del(xw.dpy, xw.font)
  nk_xlib_shutdown()
  XUnmapWindow(xw.dpy, xw.win)
  XFreeColormap(xw.dpy, xw.cmap)
  XDestroyWindow(xw.dpy, xw.win)
  XCloseDisplay(xw.dpy)

proc getWindowWidth*(): cfloat =
  ## Get the current width of the main window
  discard XGetWindowAttributes(xw.dpy, xw.win, xw.attr.addr)
  xw.width = xw.attr.width
  return xw.width.cfloat

proc getWindowHeight*(): cfloat =
  ## Get the current height of the main window
  discard XGetWindowAttributes(xw.dpy, xw.win, xw.attr.addr)
  xw.height = xw.attr.height
  return xw.height.cfloat
