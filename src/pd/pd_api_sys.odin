//
//  pdext_sys.h
//  Playdate Simulator
//
//  Created by Dave Hayden on 10/6/17.
//  Copyright © 2017 Panic, Inc. All rights reserved.
//
package pd

import "core:c"

PDButtons :: enum u32 {
	Left  = 1,
	Right = 2,
	Up    = 4,
	Down  = 8,
	B     = 16,
	A     = 32,
}

PDLanguage :: enum u32 {
	English  = 0,
	Japanese = 1,
	System   = 2, // for getLocalizedText()
}

AccessRequestCallback :: proc "c" (allowed: i32, userdata: rawptr)

accessReply :: enum u32 {
	Ask   = 0,
	Deny  = 1,
	Allow = 2,
}

PDDateTime :: struct {
	year:    u16,
	month:   u8, // 1-12
	day:     u8, // 1-31
	weekday: u8, // 1=monday-7=sunday
	hour:    u8, // 0-23
	minute:  u8,
	second:  u8,
}

PDMenuItem :: struct {}

PDPeripherals :: enum u32 {
	None           = 0,
	Accelerometer  = 1,

	// ...
	AllPeripherals = 65535,
}

PDCallbackFunction         :: proc "c" (userdata: rawptr) -> i32 // return 0 when done
PDMenuItemCallbackFunction :: proc "c" (userdata: rawptr)
PDButtonCallbackFunction   :: proc "c" (button: PDButtons, down: i32, _when: u32, userdata: rawptr) -> i32

PDInfo :: struct {
	osversion:  u32,
	language:   PDLanguage,
	pdxversion: u32,
}

PDPowerStatus :: enum u32 {
	Charging = 1,
	Usb      = 2,
	Screws   = 4,
}

playdate_sys :: struct {
	realloc:                    proc "c" (ptr: rawptr, size: c.size_t) -> rawptr, // ptr = NULL -> malloc, size = 0 -> free
	formatString:               proc "c" (ret: ^cstring, fmt: cstring, #c_vararg _: ..any) -> i32,
	logToConsole:               proc "c" (fmt: cstring, #c_vararg _: ..any),
	error:                      proc "c" (fmt: cstring, #c_vararg _: ..any),
	getLanguage:                proc "c" () -> PDLanguage,
	getCurrentTimeMilliseconds: proc "c" () -> u32,
	getSecondsSinceEpoch:       proc "c" (milliseconds: ^u32) -> u32,
	drawFPS:                    proc "c" (x: i32, y: i32),
	setUpdateCallback:          proc "c" (update: PDCallbackFunction, userdata: rawptr),
	getButtonState:             proc "c" (current: ^PDButtons, pushed: ^PDButtons, released: ^PDButtons),
	setPeripheralsEnabled:      proc "c" (mask: PDPeripherals),
	getAccelerometer:           proc "c" (outx: ^f32, outy: ^f32, outz: ^f32),
	getCrankChange:             proc "c" () -> f32,
	getCrankAngle:              proc "c" () -> f32,
	isCrankDocked:              proc "c" () -> i32,
	setCrankSoundsDisabled:     proc "c" (flag: i32) -> i32,                      // returns previous setting
	getFlipped:                 proc "c" () -> i32,
	setAutoLockDisabled:        proc "c" (disable: i32),
	setMenuImage:               proc "c" (bitmap: ^i32, xOffset: i32),
	addMenuItem:                proc "c" (title: cstring, callback: PDMenuItemCallbackFunction, userdata: rawptr) -> ^PDMenuItem,
	addCheckmarkMenuItem:       proc "c" (title: cstring, value: i32, callback: PDMenuItemCallbackFunction, userdata: rawptr) -> ^PDMenuItem,
	addOptionsMenuItem:         proc "c" (title: cstring, optionTitles: ^cstring, optionsCount: i32, f: PDMenuItemCallbackFunction, userdata: rawptr) -> ^PDMenuItem,
	removeAllMenuItems:         proc "c" (),
	removeMenuItem:             proc "c" (menuItem: ^PDMenuItem),
	getMenuItemValue:           proc "c" (menuItem: ^PDMenuItem) -> i32,
	setMenuItemValue:           proc "c" (menuItem: ^PDMenuItem, value: i32),
	getMenuItemTitle:           proc "c" (menuItem: ^PDMenuItem) -> cstring,
	setMenuItemTitle:           proc "c" (menuItem: ^PDMenuItem, title: cstring),
	getMenuItemUserdata:        proc "c" (menuItem: ^PDMenuItem) -> rawptr,
	setMenuItemUserdata:        proc "c" (menuItem: ^PDMenuItem, ud: rawptr),
	getReduceFlashing:          proc "c" () -> i32,

	// 1.1
	getElapsedTime:   proc "c" () -> f32,
	resetElapsedTime: proc "c" (),

	// 1.4
	getBatteryPercentage: proc "c" () -> f32,
	getBatteryVoltage:    proc "c" () -> f32,

	// 1.13
	getTimezoneOffset:       proc "c" () -> i32,
	shouldDisplay24HourTime: proc "c" () -> i32,
	convertEpochToDateTime:  proc "c" (epoch: u32, datetime: ^PDDateTime),
	convertDateTimeToEpoch:  proc "c" (datetime: ^PDDateTime) -> u32,

	// 2.0
	clearICache: proc "c" (),

	// 2.4
	setButtonCallback:        proc "c" (cb: PDButtonCallbackFunction, buttonud: rawptr, queuesize: i32),
	setSerialMessageCallback: proc "c" (callback: proc "c" (data: cstring)),
	vaFormatString:           proc "c" (outstr: ^cstring, fmt: cstring, args: c.va_list) -> i32,
	parseString:              proc "c" (str: cstring, format: cstring, #c_vararg _: ..any) -> i32,

	// ???
	delay: proc "c" (milliseconds: u32),

	// 2.7
	getServerTime: proc "c" (callback: proc "c" (time: cstring, err: cstring)),
	restartGame:   proc "c" (launchargs: cstring),
	getLaunchArgs: proc "c" (outpath: ^cstring) -> cstring,
	_bool:         proc "c" (command: u8, data: rawptr, len: i32, sendMirrorData: ^i32) -> proc "c" (u8, rawptr, i32) -> i32,

	// 3.0
	getSystemInfo: proc "c" () -> ^PDInfo,

	// 3.1
	getLocalizedText: proc "c" (key: cstring, language: PDLanguage) -> cstring,
	getVolume:        proc "c" () -> f32,
	getPowerStatus:   proc "c" () -> PDPowerStatus,
	exitToLauncher:   proc "c" (),
}

