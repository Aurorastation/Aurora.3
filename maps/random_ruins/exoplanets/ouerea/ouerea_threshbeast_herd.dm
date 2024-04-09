/datum/map_template/ruin/exoplanet/ouerea_threshbeast_herd
	name = "Ouerea Threshbeast Herd"
	id = "ouerea_threshbeast_herd"
	description = "A herd of wild Threshbeasts."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	suffixes = list("ouerea/ouerea_threshbeast_herd.dmm")
	ban_ruins = list(/datum/map_template/ruin/exoplanet/moghes_threshbeast_herd)
