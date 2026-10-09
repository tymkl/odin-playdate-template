package main

import "base:runtime"
import "pd"

PD: ^pd.PlaydateAPI = nil
GameContext: runtime.Context

@(export)
eventHandler :: proc "c" (playdate: ^pd.PlaydateAPI, event: pd.PDSystemEvent, arg: u32) -> i32 {
	#partial switch event {
	case .Init:
		PD = playdate
		PD.display.setRefreshRate(0)

		context = runtime.default_context()
		context.allocator = playdate_allocator(PD)
		GameContext = context

		gameData := new(GameData)

		playdate.system.setUpdateCallback(updateEntrypoint, gameData)
	case:
		// set context and pass eventHandler to an Odin proc for ease of use
		context = GameContext
		gameEventHandler(playdate, event, arg)
	}

	return 0
}

updateEntrypoint :: proc "c" (userdata: rawptr) -> i32 {
	// set context and pass update to Odin proc for ease of use
	context = GameContext
	return update((^GameData)(userdata))
}
