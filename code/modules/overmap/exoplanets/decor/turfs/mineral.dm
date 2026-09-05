/turf/simulated/floor/exoplanet/mineral
	name = "sand"
	gender = PLURAL
	desc = "It's coarse and gets everywhere."
	dirt_color = "#544c31"
	footstep_sound = SFX_FOOTSTEP_SAND

/turf/simulated/floor/exoplanet/mineral/adhomai
	name = "icy rock"
	desc = "Some cold rock."
	icon = 'icons/turf/flooring/ice_cavern.dmi'
	icon_state = "icy_rock"
	temperature = T0C - 5

/turf/simulated/floor/exoplanet/mineral/adhomai/Initialize(mapload)
	. = ..()
	icon_state = "icy_rock[rand(1,19)]"

/turf/simulated/floor/exoplanet/mineral/cave/adhomai
	name = "icy cave rock"
	desc = "Some cold rock."
	icon = 'icons/turf/flooring/cave_floor.dmi'
	icon_state = "cave"
	color = "#97A7AA"

/turf/simulated/floor/exoplanet/mineral/cave/adhomai/Initialize()
	. = ..()
	icon_state = "cave_[rand(1,7)]"
