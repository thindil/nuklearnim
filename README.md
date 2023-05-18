NuklearNim is Nim binding for [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear/)
GUI library. At the moment it is in the alpha stage and generally, it is
a WYSIWYG (or DIY) type of the project. ;)

I created the project because I needed a GUI library for my other projects in
Nim. It is more like backup than a real project. I will occasionally update the
binding as I will work more with it in other cases. For this reason I
don't accept any bug reports or requests for features. Not until first 3.0
version of the project (for roadmap, please look below).

If you want a mature Nim binding for Nuklear, use: https://github.com/zacharycarter/nuklear-nim

If you read this file on GitHub: **please don't send pull requests here**. All will
be automatically closed. Any code propositions should go to the
[Fossil](https://www.laeran.pl/repositories/nuklearnim) repository.

### Roadmap

* 1.0 - Basic, low level binding with Nuklear GUI library. Current focus of the
  development.
* 2.0 - High level binding with Nuklear GUI library.
* 3.0 - Rewrite everything in Nim.

### Usage

To use it in your project, you will need 4 files:

* `nuklear.h` - Nuklear library itself
* `nuklear.nim` - Nim binding to the Nuklear library
* nuklear_xxx.h - the selected backend for Nuklear library. For example,
  `nuklear_xlib.h`
* nuklear_xxx.nim - Nim binding for the selected backed. In the same example,
  it will be `nuklear_xlib.nim`.

You will need also to set the proper flags for C compiler, so it will be able to
find the library.

In your project, always import binding to the backed, not to the library
itself. For example, `import nuklear_xlib`.

### Demo

To build the demo, enter *demo* directory and run *build.nims* script. You will
need to set paths in *config.nims* file too. To see all available backends,
just run *build.nims* without any argument. For example, to build the demo with
Xlib backend, type `./build.nims xlib`.

### Documentation

At the moment only in form of the code, in *demo* directory plus comments in
*nuklear.h* file. Don't expect anything better soon(TM). ;)

### License

The project released under 3-Clause BSD license. The original Nuklear library
code is released under Public Domain/MIT license (at your option).

---

Bartek thindil Jasicki
