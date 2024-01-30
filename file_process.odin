package billet

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

change_dir :: proc() {
	path := strings.trim_right(os.args[0], "billet")
	os.set_current_directory(path)
}

load_table_file :: proc(file_name: string) -> string {
	data, ok := os.read_entire_file_from_filename(file_name)
	assert(ok, "Failed to load the file")
	//defer delete(data)
	return strings.trim_right(transmute(string)data, "\n")
}

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


split_by_token :: proc(file_name: string) {
	lines := strings.split_lines(load_table_file(file_name))
	for i := 0; i < len(lines); i += 1 {
		token := strings.split(lines[i], " ")
		date := strings.split(token[1], "-")
		items[i] =  {
			token[0],
			strconv.atoi(date[0]),
			strconv.atoi(date[1]),
			strconv.atoi(date[2]),
			strconv.atof(token[2]),
			token[3],
			token[4],
		}
	}
}

delete_items :: proc() {
	delete(items)
}

add_item :: proc(
	project: string,
	year: string,
	month: string,
	day: string,
	cost: string,
	account: string,
	description: string,
) {
	str := [?]string {
		project,
		"\t",
		year,
		"-",
		month,
		"-",
		day,
		"\t",
		cost,
		"\t",
		account,
		"\t",
		description,
	}

	data, ok := os.read_entire_file_from_filename(file_name)
	assert(ok, "Failed to load the file")
	defer delete(data)

	slice := [?]string{strings.trim_right(string(data), "\n"), "\n", strings.concatenate(str[:])}

	os.write_entire_file(file_name, transmute([]byte)strings.concatenate(slice[:]))
}
