
/turf/simulated/floor/airless/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/simulated/floor/ice
	name = "ice"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/airless/ice
	name = "ice"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snow0"
	does_footprint = TRUE
	footprint_color = COLOR_SNOW
	track_distance = 4

/turf/simulated/floor/plating/snow
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snowplating"
	footstep_sound = /singleton/sound_category/snow_footstep

/turf/simulated/floor/vaurca
	name = "alien floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "vaurca"

/turf/simulated/floor/foamedmetal
	name = "foamed metal"
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"

/turf/simulated/floor/foamedmetal/attack_hand(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(ishuman(user))
		ChangeTurf(/turf/space)
		to_chat(user, SPAN_NOTICE("You clear away the metal foam."))

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /singleton/flooring/grass
	footstep_sound = /singleton/sound_category/grass_footstep

/turf/simulated/floor/grass/no_edge
	has_edge_icon = FALSE

/turf/simulated/floor/diona
	name = "biomass flooring"
	icon = 'icons/turf/flooring/diona.dmi'
	icon_state = "diona0"
	footstep_sound = /singleton/sound_category/grass_footstep
	initial_flooring = /singleton/flooring/diona

/turf/simulated/floor/diona/airless
	initial_gas = null
	temperature = TCMB
