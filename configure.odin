package billet

import "core:fmt"
import "core:os"
import "core:reflect"
import "core:strings"

config :: struct {
	bar_lengh:            int,
	is_bar_right_branket: bool,
}

main_config := config{40, true}

/*
item :: struct {
	project:     string,
	year:        int,
	month:       int,
	day:         int,
	cost:        f64,
	account:     string,
	description: string,
}
*/

load_config :: proc() {
	data, ok := os.read_entire_file_from_filename(config_path)
	assert(ok, "Failed to load the file")
	//defer delete(data)
	file_configs := strings.split_lines(transmute(string)data)

	type := typeid_of(config)
	names := reflect.struct_field_names(type)
}
