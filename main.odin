package billet

file_name :: "data.blt"

main :: proc() {
	//Config
	load_config("config.cfg")

	//GUI
	//sdl2_render()
	//raylib_render()

	load_table_file(file_name)
	defer delete_items()
	split_by_token(file_name)

	cli_args()

	log()
}
