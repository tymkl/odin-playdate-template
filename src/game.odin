package main

import "pd"

GameData :: struct {
}

update :: proc(gameData: ^GameData) -> i32 {
	// render
	PD.graphics.clear(uintptr(pd.LCDSolidColor.White))
	PD.graphics.drawText(raw_data(string("Hello, World")), len("Hello, World"), .UTF8Encoding, 0, 0)

	return 1
}

gameEventHandler :: proc(playdate: ^pd.PlaydateAPI, event: pd.PDSystemEvent, arg: u32) -> i32 {
	
}
