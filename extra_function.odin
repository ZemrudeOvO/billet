package billet

import "core:math"
import "core:strconv"
import "core:strings"


date_concat :: proc(year_int, month_int: int) -> string {
	year_buffer: [4]byte
	month_buffer: [2]byte
	slice := [?]string {
		strconv.itoa(year_buffer[:], year_int),
		"-",
		strconv.itoa(month_buffer[:], month_int),
	}
	return strings.concatenate(slice[:])
}

const_string_width :: 16

format :: proc(str: string, width: int) -> string {
	str_with_space: [dynamic]string
	append(&str_with_space, str)

	str_len := len(str)
	if width > str_len {
		for i in 0 ..< width - str_len {
			//for i := 0; i < width - str_len; i += 1 {
			append(&str_with_space, " ")
		}
	}
	return strings.concatenate(str_with_space[:])
}

bar :: proc(persent: f64, block: int, right_branket: bool) -> string {
	str: [dynamic]string
	append(&str, "[")
	block_num := int(math.round(persent * f64(block)))
	for i in 0 ..< block_num {
		//for i := 0; i < block_num; i += 1 {
		append(&str, "=")
	}
	for i in 0 ..< (block - block_num) {
		//for i := 0; i < (block - block_num); i += 1 {
		append(&str, " ")
	}
	if right_branket {
		append(&str, "]")
	}
	return strings.concatenate(str[:])
}
