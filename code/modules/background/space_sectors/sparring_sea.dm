/datum/space_sector/sparring_sea
	name = SECTOR_SPARRING_SEA
	description = "A large region of heavily contested space, mostly avoided, barring those with lofty goals or sinister dealings. \
	It is populated by all sorts of outcasts and outlaws, but notably Unathi pirates and exiles, Dominian edict breakers and even the scarce eccentric band of Skrell \
	are all known to seek refuge here. Though piracy is common, plenty of stubborn colonies of all backgrounds make stakes here."
	skybox_icon = "sparring_sea"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert)
	starlight_color = "#b04609"
	starlight_power = 2
	starlight_range = 4

/datum/space_sector/mira_sancta
	name = SECTOR_MIRA_SANCTA
	description = "The center of the Empire of Dominia, Mira Sancta is home to the frozen world of Moroz, capital of the Empire and home to the Great Houses in all their power.\
	In spite of its position at the empire's center, however, it is not a peaceful sector - the Great Houses scheme against one another, the freedom fighters of Fisanduh struggle\
	to bring an end to the Empire's occupation of their lands, and the Tribunal watches over all. It is, however, largely safe from pirates and marauders, though only time will \
	tell whether that persists..."
	starlight_color = COLOR_WHITE //placeholder
	starlight_power = 5
	starlight_range = 1

/datum/space_sector/mira_sancta/generate_system_name()
	return "Mira Sancta, and nearby points of interest"
