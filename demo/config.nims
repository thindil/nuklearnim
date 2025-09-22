if defined(freebsd):
  switch("passL", "-I/usr/local/include -I/usr/local/include/SDL2 -L/usr/local/lib -lX11 -lm -lSDL2 -lSDL2_image")
  switch("passC", "-I../src -Wno-error=incompatible-function-pointer-types -Wno-error=int-conversion")
else:
  switch("passL", "-I/usr/include -I/usr/include/SDL2 -L/usr/lib -lX11 -lm -lSDL2 -lSDL2_image")
  switch("passC", "-I../src -Wno-error=int-conversion")
switch("path", "../src")
