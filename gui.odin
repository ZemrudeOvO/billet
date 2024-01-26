package billet

import rl "vendor:raylib"
import "vendor:sdl2"

sdl2_render :: proc() {
	assert(sdl2.Init({.AUDIO, .VIDEO}) >= 0, string(sdl2.GetError()))
	defer sdl2.Quit()

	win_ptr := sdl2.CreateWindow(
		"billet",
		sdl2.WINDOWPOS_CENTERED,
		sdl2.WINDOWPOS_CENTERED,
		640,
		360,
		{.SHOWN, .RESIZABLE},
	)
	assert(win_ptr != nil, string(sdl2.GetError()))
	defer sdl2.DestroyWindow(win_ptr)

	surf := sdl2.GetWindowSurface(win_ptr)
	assert(surf != nil, string(sdl2.GetError()))
	defer sdl2.FreeSurface(surf)

	sdl2.FillRect(surf, &sdl2.Rect{50, 50, 100, 100}, 0xff0000)
	sdl2.FillRect(surf, &sdl2.Rect{150, 50, 100, 100}, sdl2.MapRGB(surf.format, 0, 255, 255))
	sdl2.UpdateWindowSurface(win_ptr)

	rect := sdl2.Rect{0, 200, 50, 50}

	sdl2_event: sdl2.Event
	for {
		if sdl2.PollEvent(&sdl2_event) {
			if sdl2_event.type == sdl2.EventType.QUIT {break}
		}
		sdl2.FillRect(surf, &rect, 0x000000)
		rect.x += 1
		sdl2.FillRect(surf, &rect, 0x0000ff)
		sdl2.UpdateWindowSurface(win_ptr)
		sdl2.Delay(20)
	}
}

raylib_render :: proc() {
	rl.InitWindow(640, 360, "billet")
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()
	}
}
