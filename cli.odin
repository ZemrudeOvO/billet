package billet

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"


cli_args :: proc() {
	if len(os.args) == 1 {
		/******************************

		0. -a add
			project
			year
			month
			day
			cost
			credit
			description 

		1. income
			0. -i monthly income
			1. -ir income ranking
		2. expense
			0. -e monthly expense
			1. -ea except housing
			2. -eb billing day
			3. -er expense rankingA
			4. -ey yearly expense

		******************************/
		fmt.println("\n----------")
		fmt.println("0: add data\n1: get income\n2: get expense\n")

		buf: [256]byte
		n, err := os.read(os.stdin, buf[:])
		assert(err >= 0, string("input error"))

		for strconv.atoi(string(buf[:])) >= 3 || strconv.atoi(string(buf[:])) < 0 {
			fmt.println("Please re-type:")
			n, err = os.read(os.stdin, buf[:])
			assert(err >= 0, string("input error"))
		}

		switch cast(string)buf[:n - 1] {
		case "0":
			arg: [7]string
			fmt.println("\n----------")
			fmt.println("0: income\n1: expense\n")

			buf_add: [256]byte
			n_add, err_add := os.read(os.stdin, buf_add[:])
			assert(err_add >= 0, string("input error"))

			for strconv.atoi(string(buf_add[:])) >= 2 || strconv.atoi(string(buf_add[:])) < 0 {
				fmt.println("Please re-type:")
				n_add, err_add = os.read(os.stdin, buf_add[:])
				assert(err_add >= 0, string("input error"))
			}

			switch cast(string)buf_add[:n_add - 1] {
			case "0":
				fmt.println("\n----------")
				fmt.println("project:")
				for i := 0; i < len(income_data); i += 1 {
					fmt.printf("%d: %s\n", i, income_data[i].project)
				}
				fmt.println("")

				buf_proj: [256]byte
				n_proj, err_proj := os.read(os.stdin, buf_proj[:])
				assert(err_proj >= 0, string("input error"))

				for strconv.atoi(string(buf_proj[:])) >= len(income_data) ||
				    strconv.atoi(string(buf_proj[:])) < 0 {
					fmt.println("Please re-type:")
					n_proj, err_proj = os.read(os.stdin, buf_proj[:])
					assert(err_proj >= 0, string("input error"))
				}
				project_index: int = strconv.atoi(string(buf_proj[:]))
				arg[0] = income_data[project_index].project
			case "1":
				fmt.println("\n----------")
				fmt.println("project:")
				for i := 0; i < len(expense_data); i += 1 {
					fmt.printf("%d: %s\n", i, expense_data[i].project)
				}
				fmt.println("")

				buf_proj: [256]byte
				n_proj, err_proj := os.read(os.stdin, buf_proj[:])
				assert(err_proj >= 0, string("input error"))

				for strconv.atoi(string(buf_proj[:])) >= len(expense_data) ||
				    strconv.atoi(string(buf_proj[:])) < 0 {
					fmt.println("Please re-type:")
					n_proj, err_proj = os.read(os.stdin, buf_proj[:])
					assert(err_proj >= 0, string("input error"))
				}
				project_index: int = strconv.atoi(string(buf_proj[:]))
				arg[0] = expense_data[project_index].project
			}
			fmt.println("\n----------")
			fmt.print("year: ")

			buf_year: [256]byte
			n_year, err_year := os.read(os.stdin, buf_year[:])
			assert(err_year >= 0, string("input error"))
			arg[1] = string(buf_year[:n_year - 1])

			fmt.println("\n----------")
			fmt.print("month: ")

			buf_month: [256]byte
			n_month, err_month := os.read(os.stdin, buf_month[:])
			assert(n_month >= 0, string("input error"))
			for strconv.atoi(string(buf_month[:])) > 12 ||
			    strconv.atoi(string(buf_month[:])) <= 0 {
				fmt.println("Please re-type:")
				n_month, err_month = os.read(os.stdin, buf_month[:])
				assert(err_month >= 0, string("input error"))
			}
			arg[2] = string(buf_month[:n_month - 1])

			fmt.println("\n----------")
			fmt.print("day: ")

			buf_day: [256]byte
			n_day, err_day := os.read(os.stdin, buf_day[:])
			assert(err_day >= 0, string("input error"))
			for strconv.atoi(string(buf_day[:])) > 31 || strconv.atoi(string(buf_day[:])) <= 0 {
				fmt.println("Please re-type:")
				n_day, err_day = os.read(os.stdin, buf_day[:])
				assert(err_day >= 0, string("input error"))
			}
			arg[3] = string(buf_day[:n_day - 1])

			fmt.println("\n----------")
			fmt.print("cost: ")

			buf_cost: [256]byte
			n_cost, err_cost := os.read(os.stdin, buf_cost[:])
			assert(err_cost >= 0, string("input error"))
			arg[4] = string(buf_cost[:n_cost - 1])

			fmt.println("\n----------")
			fmt.println("0: credit\n1: debit\n")

			buf_account: [256]byte
			n_account, err_account := os.read(os.stdin, buf_account[:])
			assert(err_account >= 0, string("input error"))

			for strconv.atoi(string(buf_account[:])) > 1 ||
			    strconv.atoi(string(buf_account[:])) < 0 {
				fmt.println("Please re-type:")
				n_account, err_account = os.read(os.stdin, buf_account[:])
				assert(err_account >= 0, string("input error"))
			}
			switch cast(string)buf_account[:n_account - 1] {
			case "0":
				arg[5] = "信用卡"
			case "1":
				arg[5] = "借记卡"
			}

			fmt.println("\n----------")
			fmt.println("description\n")

			buf_description: [256]byte
			n_description, err_description := os.read(os.stdin, buf_description[:])
			assert(err_description >= 0, string("input error"))
			for len(strings.trim_right_null(string(buf_description[:]))) <= 1 {
				fmt.println("Please re-type:")
				n_description, err_description = os.read(os.stdin, buf_description[:])
				assert(err_description >= 0, string("input error"))
			}
			arg[6] = string(buf_description[:n_description - 1])

			add_item(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6])

		case "1":
			/******************************

			1. income
				0. -i monthly income
				1. -ir income ranking

			******************************/
			fmt.println("\n----------")
			fmt.println("0: get income monthly\n1: get income ranking\n")

			buf_income: [256]byte
			n_income, err_income := os.read(os.stdin, buf_income[:])
			assert(err_income >= 0, string("input error"))

			for strconv.atoi(string(buf_income[:])) > 1 ||
			    strconv.atoi(string(buf_income[:])) < 0 {
				fmt.println("Please re-type:")
				n_income, err_income = os.read(os.stdin, buf_income[:])
				assert(err_income >= 0, string("input error"))
			}

			switch cast(string)buf_income[:n - 1] {
			case "0":
				fmt.println("\n----------")
				fmt.print("year: ")

				arg: [2]string
				buf_year: [256]byte
				n_year, err_year := os.read(os.stdin, buf_year[:])
				assert(err_year >= 0, string("input error"))
				arg[0] = string(buf_year[:n_year - 1])

				fmt.println("\n----------")
				fmt.print("month: ")
				buf_month: [256]byte
				n_month, err_month := os.read(os.stdin, buf_month[:])
				assert(err_month >= 0, string("input error"))
				for strconv.atoi(string(buf_month[:])) > 12 ||
				    strconv.atoi(string(buf_month[:])) <= 0 {
					fmt.println("Please re-type:")
					n_month, err_month = os.read(os.stdin, buf_month[:])
					assert(err_month >= 0, string("input error"))
				}
				arg[1] = string(buf_month[:n_month - 1])

				fmt.println("\n----------")
				fmt.println(
					arg[0],
					arg[1],
					"income: ",
					get_month_income(strconv.atoi(arg[0]), strconv.atoi(arg[1])),
					"\n"
				)
			case "1":
				fmt.println("\n----------")
				fmt.print("year: ")

				arg: [2]string
				buf_year: [256]byte
				n_year, err_year := os.read(os.stdin, buf_year[:])
				assert(err_year >= 0, string("input error"))
				arg[0] = string(buf_year[:n_year - 1])

				fmt.println("\n----------")
				fmt.print("month: ")
				buf_month: [256]byte
				n_month, err_month := os.read(os.stdin, buf_month[:])
				assert(err_month >= 0, string("input error"))
				for strconv.atoi(string(buf_month[:])) > 12 ||
				    strconv.atoi(string(buf_month[:])) <= 0 {
					fmt.println("Please re-type:")
					n_month, err_month = os.read(os.stdin, buf_month[:])
					assert(err_month >= 0, string("input error"))
				}
				arg[1] = string(buf_month[:n_month - 1])

				fmt.println("\n----------")
				fmt.println(arg[0], arg[1], "income ranking:")
				get_income_ranking(strconv.atoi(arg[0]), strconv.atoi(arg[1]))
				fmt.print("\n")
			}


		case "2":
		/******************************
			2. expense
				0. -e monthly expense
				1. -ea except housing
				2. -eb billing day
				3. -er expense rankingA
				4. -ey yearly expense
		******************************/
			fmt.println("\n----------")
			fmt.println("0: get expense monthly")
			fmt.println("1: get expense except houseing")
			fmt.println("2: get expense before billing day")
			fmt.println("3: get expense ranking")
			fmt.println("4: get expense yearly")
			fmt.println("")

			buf_expense: [256]byte
			n_expense, err_expense := os.read(os.stdin, buf_expense[:])
			assert(err_expense >= 0, string("input error"))

			for strconv.atoi(string(buf_expense[:])) > 4 ||
			    strconv.atoi(string(buf_expense[:])) < 0 {
				fmt.println("Please re-type:")
				n_expense, err_expense = os.read(os.stdin, buf_expense[:])
				assert(err_expense >= 0, string("input error"))
			}

			switch cast(string)buf_expense[:n - 1] {
				case "0":
					fmt.println("\n----------")
					fmt.print("year: ")

					arg: [2]string
					buf_year: [256]byte
					n_year, err_year := os.read(os.stdin, buf_year[:])
					assert(err_year >= 0, string("input error"))
					arg[0] = string(buf_year[:n_year - 1])

					fmt.println("\n----------")
					fmt.print("month: ")
					buf_month: [256]byte
					n_month, err_month := os.read(os.stdin, buf_month[:])
					assert(err_month >= 0, string("input error"))
					for strconv.atoi(string(buf_month[:])) > 12 ||
				    	strconv.atoi(string(buf_month[:])) <= 0 {
						fmt.println("Please re-type:")
						n_month, err_month = os.read(os.stdin, buf_month[:])
						assert(err_month >= 0, string("input error"))
					}
					arg[1] = string(buf_month[:n_month - 1])

					fmt.println("\n----------")
					fmt.println(
						arg[0],
						arg[1],
						"expense: ",
						get_month_expense(strconv.atoi(arg[0]), strconv.atoi(arg[1])),
						"\n"
					)
				case "1":
					fmt.println("\n----------")
					fmt.print("year: ")

					arg: [2]string
					buf_year: [256]byte
					n_year, err_year := os.read(os.stdin, buf_year[:])
					assert(err_year >= 0, string("input error"))
					arg[0] = string(buf_year[:n_year - 1])

					fmt.println("\n----------")
					fmt.print("month: ")
					buf_month: [256]byte
					n_month, err_month := os.read(os.stdin, buf_month[:])
					assert(err_month >= 0, string("input error"))
					for strconv.atoi(string(buf_month[:])) > 31 ||
				    	strconv.atoi(string(buf_month[:])) <= 0 {
						fmt.println("Please re-type:")
						n_month, err_month = os.read(os.stdin, buf_month[:])
						assert(err_month >= 0, string("input error"))
					}
					arg[1] = string(buf_month[:n_month - 1])

					fmt.println("\n----------")
					fmt.println(
						arg[0],
						arg[1],
						"expense: ",
						get_month_expense_except_housing(strconv.atoi(arg[0]), strconv.atoi(arg[1])),
						"\n"
					)
				case "2":
					fmt.println("\n----------")
					fmt.print("year: ")

					arg: [3]string
					buf_year: [256]byte
					n_year, err_year := os.read(os.stdin, buf_year[:])
					assert(err_year >= 0, string("input error"))
					arg[0] = string(buf_year[:n_year - 1])

					fmt.println("\n----------")
					fmt.print("month: ")
					buf_month: [256]byte
					n_month, err_month := os.read(os.stdin, buf_month[:])
					assert(err_month >= 0, string("input error"))
					for strconv.atoi(string(buf_month[:])) > 12 ||
				    	strconv.atoi(string(buf_month[:])) <= 0 {
						fmt.println("Please re-type:")
						n_month, err_month = os.read(os.stdin, buf_month[:])
						assert(err_month >= 0, string("input error"))
					}
					arg[1] = string(buf_month[:n_month - 1])


					fmt.println("\n----------")
					fmt.print("day: ")
					buf_day: [256]byte
					n_day, err_day := os.read(os.stdin, buf_day[:])
					assert(err_day >= 0, string("input error"))
					for strconv.atoi(string(buf_day[:])) > 31 ||
				    	strconv.atoi(string(buf_day[:])) <= 0 {
						fmt.println("Please re-type:")
						n_day, err_day = os.read(os.stdin, buf_day[:])
						assert(err_day >= 0, string("input error"))
					}
					arg[2] = string(buf_day[:n_day - 1])

					fmt.println("\n----------")
					fmt.println(
						arg[0],
						arg[1],
						arg[2],
						"expense before: ",
						get_expense_before_billing_day(strconv.atoi(arg[0]), strconv.atoi(arg[1]),cast(i64)strconv.atoi(arg[2])),
						"\n"
					)
				case "3":
					fmt.println("\n----------")
					fmt.print("year: ")

					arg: [2]string
					buf_year: [256]byte
					n_year, err_year := os.read(os.stdin, buf_year[:])
					assert(err_year >= 0, string("input error"))
					arg[0] = string(buf_year[:n_year - 1])

					fmt.println("\n----------")
					fmt.print("month: ")
					buf_month: [256]byte
					n_month, err_month := os.read(os.stdin, buf_month[:])
					assert(err_month >= 0, string("input error"))
					for strconv.atoi(string(buf_month[:])) > 12 ||
				    	strconv.atoi(string(buf_month[:])) <= 0 {
						fmt.println("Please re-type:")
						n_month, err_month = os.read(os.stdin, buf_month[:])
						assert(err_month >= 0, string("input error"))
					}
					arg[1] = string(buf_month[:n_month - 1])

					fmt.println("\n----------")
					fmt.println(arg[0], arg[1], "expense ranking:")
					get_expense_ranking(strconv.atoi(arg[0]), strconv.atoi(arg[1]))
					fmt.print("\n")
				case "4":
					fmt.println("\n----------")
					fmt.print("year: ")

					arg: string
					buf_year: [256]byte
					n_year, err_year := os.read(os.stdin, buf_year[:])
					assert(err_year >= 0, string("input error"))
					arg = string(buf_year[:n_year - 1])


					fmt.println("\n----------")
					fmt.println(arg, "expense yearly: ", get_total_expense_in_year(strconv.atoi(arg)),"\n")
			}
		}


	} else {
		switch os.args[1] {
		case "-h":
			fmt.print("\n")
			fmt.println("-i:\t[get month income: yyyy mm]\neg. ./billet -i 2023 11\n")
			fmt.println("-e:\t[get month expense: yyyy mm]\neg. ./billet -e 2023 11\n")
			fmt.println(
				"-ea:\t[get month expense except housing: yyyy mm]\neg. ./billet -ea 2023 11\n",
			)
			fmt.println(
				"-eb:\t[get month expense before billing day: yyyy mm ?d]\neg. ./billet -eb 2023 12 19\n",
			)
			fmt.println("-ir:\t[get month income ranking: yyyy mm]\neg. ./billet -ir 2023 11\n")
			fmt.println("-er:\t[get month expense ranking: yyyy mm]\neg. ./billet -er 2023 11\n")
			fmt.println(
				"-a:\t[add data]\neg. ./billet -a 饮食 2023 11 19 -25.8 信用卡 麦当劳\n",
			)
			fmt.println("-ey:\t[get year expense yearly: yyyy]\neg. ./billet -ey 2023\n")
		case "-i":
			if len(os.args) == 4 {
				fmt.println(
					os.args[2],
					os.args[3],
					"income",
					get_month_income(strconv.atoi(os.args[2]), strconv.atoi(os.args[3])),
				)
				fmt.print("\n")
			} else {
				fmt.println(
					"wrong arguments: -i: get month income: yyyy mm	eg. ./billet -i 2023 11",
				)
			}
		case "-e":
			if len(os.args) == 4 {
				fmt.println(
					os.args[2],
					os.args[3],
					"expense",
					get_month_expense(strconv.atoi(os.args[2]), strconv.atoi(os.args[3])),
				)
				fmt.print("\n")
			} else {
				fmt.println(
					"wrong arguments: -e: get month expense: yyyy mm	eg. ./billet -e 2023 11",
				)
			}
		case "-ea":
			if len(os.args) == 4 {
				fmt.println(
					os.args[2],
					os.args[3],
					"expense_except_housing",
					get_month_expense_except_housing(
						strconv.atoi(os.args[2]),
						strconv.atoi(os.args[3]),
					),
				)
				fmt.print("\n")
			} else {
				fmt.println(
					"wrong arguments: -ea: get month expense except housing: yyyy mm	eg. ./billet -ea 2023 11",
				)
			}
		case "-eb":
			if len(os.args) == 5 {
				fmt.println(
					os.args[2],
					os.args[3],
					os.args[4],
					"expense before billing day(only use credit card)",
					get_expense_before_billing_day(
						strconv.atoi(os.args[2]),
						strconv.atoi(os.args[3]),
						i64(strconv.atoi(os.args[4])),
					),
				)
				fmt.print("\n")
			} else {
				fmt.println(
					"wrong arguments: -eb: get month expense before billing day: yyyy mm ?d	eg. ./billet -ob 2023 12 19",
				)
			}
		case "-ir":
			if len(os.args) == 4 {
				fmt.println(os.args[2], os.args[3], "income ranking:")
				get_income_ranking(strconv.atoi(os.args[2]), strconv.atoi(os.args[3]))
				fmt.print("\n")
			} else {
				fmt.println(
					"wrong arguments: -ir: get month income ranking: yyyy mm	eg. ./billet -ir 2023 11",
				)
			}
		case "-er":
			if len(os.args) == 4 {

				fmt.println(os.args[2], os.args[3], "expense ranking:")
				get_expense_ranking(strconv.atoi(os.args[2]), strconv.atoi(os.args[3]))
				fmt.print("\n")
			} else {
				fmt.println(
					"wrong argumens: -er: get month expense ranking: yyyy mm	eg. ./billet -er 2023 11",
				)
			}
		case "-a":
			if len(os.args) == 9 {
				add_item(
					os.args[2],
					os.args[3],
					os.args[4],
					os.args[5],
					os.args[6],
					os.args[7],
					os.args[8],
				)
			} else {
				fmt.println(
					"wrong arguments: -a: add data: eg. ./billet -a 饮食 2023 11 19 -25.8 信用卡 麦当劳",
				)
			}
		case "-ey":
			if len(os.args) == 3 {
				fmt.println(
					"total expense in",
					os.args[2],
					": ",
					get_total_expense_in_year(strconv.atoi(os.args[2])),
				)
			} else {
				fmt.println(
					"wrong arguments: -ey: get total expense in a year: eg. ./billet -ey 2024",
				)
			}
		case:
			fmt.println("wrong enter argument[1]")
		}
	}
}
