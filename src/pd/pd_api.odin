//
//  pd_api.h
//  Playdate C API
//
//  Created by Dave Hayden on 7/30/14.
//  Copyright (c) 2014 Panic, Inc. All rights reserved.
//
package pd

PlaydateAPI :: struct {
	system:      ^playdate_sys,
	file:        ^playdate_file,
	graphics:    ^playdate_graphics,
	sprite:      ^playdate_sprite,
	display:     ^playdate_display,
	sound:       ^playdate_sound,
	lua:         ^playdate_lua,
	json:        ^playdate_json,
	scoreboards: ^playdate_scoreboards,
	network:     ^playdate_network,
}

PDSystemEvent :: enum u32 {
	Init          = 0,
	InitLua       = 1,
	Lock          = 2,
	Unlock        = 3,
	Pause         = 4,
	Resume        = 5,
	Terminate     = 6,
	KeyPressed    = 7, // arg is keycode
	KeyReleased   = 8,
	LowPower      = 9,
	MirrorStarted = 10,
	MirrorEnded   = 11,
}
