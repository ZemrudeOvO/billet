package billet

file_name :: "data.blt"
config_path :: "config.cfg"

main :: proc() {
	load_config()

	load_table_file();defer delete_items()
	split_by_token(file_name)
	generate_project_data()

	cli_args()
}
