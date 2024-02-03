package billet

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

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
get_month_income :: proc(year, month: int) -> f64 {
	cost: f64 = 0
	for item in items {
		if item.cost > 0 && item.year == year && item.month == month {
			cost += item.cost
		}
	}
	return cost
}

get_month_expense :: proc(year, month: int) -> f64 {
	cost: f64 = 0
	for item in items {
		if item.cost < 0 && item.year == year && item.month == month {
			cost -= item.cost
		}
	}
	return cost
}

get_month_expense_except_housing :: proc(year, month: int) -> f64 {
	cost: f64 = 0
	for item in items {
		if item.cost < 0 &&
		   item.year == year &&
		   item.month == month &&
		   item.project != "住房相关" {
			cost -= item.cost
		}
	}
	return cost
}

get_expense_before_billing_day :: proc(year, month: int, day: i64) -> f64 {
	cost: f64 = 0
	for item in items {
		if month == 1 {
			if item.year == (year - 1) && item.month == 12 && item.day > cast(int)day {
				cost -= item.cost
			}
			if item.year == year && item.month == month && item.day <= cast(int)day {
				cost -= item.cost
			}
		} else {
			if item.year == year && item.month == (month - 1) && item.day > cast(int)day {
				cost -= item.cost
			}
			if item.year == year && item.month == month && item.day <= cast(int)day {
				cost -= item.cost
			}
		}
	}
	return -cost
}

income :: struct {
	project: string,
	income:  f64,
	persent: f64,
}

expense :: struct {
	project: string,
	expense: f64,
	persent: f64,
}

income_data: [dynamic]income
expense_data: [dynamic]expense

generate_project_data :: proc() {
	income_project_origin: [dynamic]string
	expense_project_origin: [dynamic]string
	for i := 0; i < len(items); i += 1 {
		if items[i].cost > 0 {
			append(&income_project_origin, items[i].project)
		} else {
			append(&expense_project_origin, items[i].project)
		}
	}
	slice.sort(income_project_origin[:])
	slice.sort(expense_project_origin[:])

	income_data = {{income_project_origin[0], 0, 0}}
	expense_data = {{expense_project_origin[0], 0, 0}}

	for i := 0; i < len(income_project_origin); i += 1 {
		new_data: income
		if income_project_origin[i] != income_data[len(income_data) - 1].project {
			new_data = income{income_project_origin[i], 0, 0}
			append(&income_data, new_data)
		}
	}
	for i := 0; i < len(expense_project_origin); i += 1 {
		new_data: expense
		if expense_project_origin[i] != expense_data[len(expense_data) - 1].project {
			new_data = expense{expense_project_origin[i], 0, 0}
			append(&expense_data, new_data)
		}
	}
}

get_income_ranking :: proc(year, month: int) {
	for item in items {
		if item.year == year && item.month == month {
			for i := 0; i < len(income_data); i += 1 {
				if item.project == income_data[i].project {
					income_data[i].income += item.cost
				}
			}
		}
	}
	for i := 0; i < len(income_data); i += 1 {
		income_data[i].persent = income_data[i].income / get_month_income(year, month)
	}
	for i in income_data {
		if i.income != 0 {
			buf: [8]byte
			fmt.println(
				format(i.project, 16),
				"\t",
				format(strconv.ftoa(buf[:], i.income, 'f', 2, 64), 8),
				"\t",
				i.persent * 100,
				"%\t",
				bar(i.persent, main_config.bar_lengh, main_config.is_bar_right_branket),
			)
		}
	}
}

get_expense_ranking :: proc(year, month: int) {
	for item in items {
		if item.year == year && item.month == month {
			for i := 0; i < len(expense_data); i += 1 {
				if item.project == expense_data[i].project {
					expense_data[i].expense += item.cost
				}
			}
		}
	}
	for i := 0; i < len(expense_data); i += 1 {
		expense_data[i].persent = expense_data[i].expense / get_month_expense(year, month)
	}
	for i in expense_data {
		if i.expense != 0 {
			buf: [8]byte
			fmt.println(
				format(i.project, 16),
				"\t",
				format(strconv.ftoa(buf[:], i.expense, 'f', 2, 64), 8),
				"\t",
				-i.persent * 100,
				"%\t",
				bar(-i.persent, main_config.bar_lengh, main_config.is_bar_right_branket),
			)
		}
	}
}

get_total_expense_in_year :: proc(year: int) -> f64 {
	cost: f64
	for item in items {
		if item.year == year && item.cost < 0 {
			cost += item.cost
		}
	}
	return -cost
}
