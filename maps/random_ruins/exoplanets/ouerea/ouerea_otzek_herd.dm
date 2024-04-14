/datum/map_template/ruin/exoplanet/ouerea_otzek_herd
	name = "Ouerea Otzek Herd"
	id = "ouerea_otzek_herd"
	description = "A herd of wild Otzek."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffixes = list("ouerea_otzek_herd.dmm")
	ban_ruins = list(/datum/map_template/ruin/exoplanet/moghes_otzek_herd)
