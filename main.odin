package billet

import "core:fmt"
import "core:os"
import "core:strings"

file_name :: "data.blt"

main :: proc() {
	change_dir()

	load_config("config.cfg")

	load_table_file(file_name)
	defer delete_items()
	split_by_token(file_name)

	cli_args()
}
