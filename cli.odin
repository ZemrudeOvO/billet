package billet

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"


cli_args :: proc() {
	if len(os.args) == 1 {
		fmt.println("-h: get help")
	} else {
		switch os.args[1] {
		case "-h":
			fmt.println("-i: get month income: yyyy mm	eg. ./billet -i 2023 11")
			fmt.println("-e: get month expense: yyyy mm	eg. ./billet -e 2023 11")
			fmt.println("-ea: get month expense except housing: yyyy mm	eg. ./billet -ea 2023 11")
			fmt.println(
				"-eb: get month expense before billing day: yyyy mm ?d	eg. ./billet -eb 2023 12 19",
			)
			fmt.println("-ir: get month income ranking: yyyy mm	eg. ./billet -ir 2023 11")
			fmt.println("-er: get month expense ranking: yyyy mm	eg. ./billet -er 2023 11")
			fmt.println(
				"-a: add data: eg. ./billet -a 饮食 2023 11 19 -25.8 信用卡 麦当劳",
			)
			fmt.println("-ey: get year expense ranking: yyyy eg. ./billet -ey 2023")
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
				);
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
