/proc/generate_planet_name()
	return pick(
		"[capitalize(pick(GLOB.last_names))]-[pick(GLOB.greek_letters)]",
		"[capitalize(pick(GLOB.last_names))]-[pick(GLOB.nato_phonetic_letters)]")

/proc/generate_planet_type()
	return pick("terrestial planet", "ice planet", "dwarf planet", "desert planet", "ocean planet", "lava planet", "gas giant", "forest planet")
