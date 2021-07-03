/datum/space_sector
	var/name
	var/description
	var/list/possible_erts = list()
	var/list/cargo_price_coef = list("NanoTrasen" = 1, "Haephaestus" = 1, "Zeng-Hu" = 1, "Eckhart's Energy" = 1, "Getmore Products" = 1, "Arizi Guild" = 1, "BLAM! Products" = 1,
								"Interstellar Aid Corps" = 1, "Zharrkov Shipping Company" = 1, "Virgo Freight Carriers" = 1, "Bishop Cybernetics" = 1, "Bishop Cybernetics" = 1,
								"Xion Manufacturing Group" = 1, "Necropolis Industries" = 1) //how much the space sector afffects how expensive is ordering from that cargo supplier
