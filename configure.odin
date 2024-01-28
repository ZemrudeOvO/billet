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

items: []item = make([]item, len(strings.split_lines(load_table_file(file_name))))
*/

load_config :: proc(file_name: string) {
	data, ok := os.read_entire_file_from_filename(file_name)
	assert(ok, "Failed to load the file")
	//defer delete(data)
	file_configs := strings.split_lines(transmute(string)data)

	type := typeid_of(config)
	names := reflect.struct_field_names(type)
}
