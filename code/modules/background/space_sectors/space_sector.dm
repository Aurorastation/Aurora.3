/datum/space_sector
	var/name
	var/description
	var/list/possible_erts = list()
	var/cargo_price_coef = 1 //how much the space sector afffects how expensive is ordering from cargo
	var/cargo_time_coef = 1 //how much the space sector affects how long the cargo shuttle takes to arrive