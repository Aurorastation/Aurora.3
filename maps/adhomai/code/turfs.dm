/turf/unsimulated/wall/blizzard
	name = "blizzard"
	desc = "A thick snow storm."
	icon = 'icons/adhomai/turfs.dmi'
	icon_state = "blizzard"

/turf/unsimulated/mask/adhomai
	name = "adhomaimask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "sandstonevault"

/turf/simulated/floor/asteroid/ash/adhomai
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T0C-20

/turf/simulated/floor/asteroid/ash/rocky/adhomai
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T0C-20

/turf/simulated/floor/asteroid/basalt/adhomai
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T0C-20

/turf/simulated/lava
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T0C-20

/turf/simulated/mineral/adhomai
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T0C-20
	mined_turf = /turf/simulated/floor/asteroid/ash/adhomai

/turf/simulated/mineral/adhomai/surface
	actual_icon = 'icons/adhomai/icy_wall.dmi'

/turf/simulated/mineral/random/adhomai
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T0C-20
	mined_turf = /turf/simulated/floor/asteroid/ash/adhomai
	mineralSpawnChanceList = list(
		ORE_URANIUM = 2,
		ORE_PLATINUM = 2,
		ORE_IRON = 8,
		ORE_COAL = 8,
		ORE_DIAMOND = 1,
		ORE_GOLD = 2,
		ORE_SILVER = 2,
		ORE_CLAY = 5
	)

/turf/simulated/mineral/random/adhomai/surface
	actual_icon = 'icons/adhomai/icy_wall.dmi'

/turf/simulated/mineral/random/adhomai/high_chance
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T0C-20
	mineralSpawnChanceList = list(
		ORE_URANIUM = 2,
		ORE_PLATINUM = 2,
		ORE_IRON = 2,
		ORE_COAL = 2,
		ORE_DIAMOND = 1,
		ORE_GOLD = 2,
		ORE_SILVER = 2
	)
	mineralChance = 55

/turf/simulated/mineral/random/adhomai/high_chance/surface
	actual_icon = 'icons/adhomai/icy_wall.dmi'

/turf/simulated/mineral/random/adhomai/higher_chance
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T0C-20
	mineralSpawnChanceList = list(
		ORE_URANIUM = 3,
		ORE_PLATINUM = 3,
		ORE_IRON = 1,
		ORE_COAL = 1,
		ORE_DIAMOND = 1,
		ORE_GOLD = 3,
		ORE_SILVER = 3,
		ORE_PHORON = 1,
		ORE_CLAY = 1
	)
	mineralChance = 75

/turf/simulated/mineral/random/adhomai/higher_chance/surface
	actual_icon = 'icons/adhomai/icy_wall.dmi'

/turf/simulated/mineral/random/adhomai/higher_chance/meteor
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T0C-20
	mineralSpawnChanceList = list(
		ORE_URANIUM = 3,
		ORE_PLATINUM = 3,
		ORE_IRON = 0,
		ORE_COAL = 1,
		ORE_DIAMOND = 1,
		ORE_GOLD = 3,
		ORE_SILVER = 3,
		ORE_PHORON = 1,
		ORE_CLAY = 1,
		ORE_METEORIC = 5
	)
	mineralChance = 80

/turf/simulated/floor/adhomai/desert
	name = "desert sand"
	desc = "Uncomfortably gritty, and it gets everywhere."
	icon_state = "asteroid"
	icon = 'icons/turf/flooring/asteroid.dmi'
	footstep_sound = "gravelstep"

/turf/simulated/floor/adhomai/desert/Initialize()
	. = ..()
	if(prob(10))
		add_overlay("asteroid[rand(0,9)]")