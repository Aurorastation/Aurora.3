/datum/space_sector
	var/name
	var/description
	var/list/possible_erts = list()
	var/list/possible_exoplanets = list()
	var/list/cargo_price_coef = list("nt" = 1, "hpi" = 1, "zhu" = 1, "een" = 1, "get" = 1, "arz" = 1, "blm" = 1,
								"iac" = 1, "zsc" = 1, "vfc" = 1, "bis" = 1, "xmg" = 1, "npi" = 1) //how much the space sector afffects how expensive is ordering from that cargo supplier
