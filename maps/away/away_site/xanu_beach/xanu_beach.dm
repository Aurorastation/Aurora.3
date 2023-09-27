/datum/map_template/ruin/away_site/xanu_beach
	name = "Xanu Prime"
	description = "A beach near Nouvelle-Rochelle on Xanu Prime."
	suffixes = list("away_site/xanu_beach/xanu_beach.dmm")
	sectors = list(SECTOR_LIBERTYS_CRADLE)
	spawn_weight = 0
	spawn_cost = 0
	id = "xanu_beach"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/xanu_beach
	map = "xanu_beach"
	descriptor = ""

/obj/effect/overmap/visitable/xanu_beach
	name = "Xanu Prime"
	desc = "The capital planet of the Coalition of Colonies, and also its most populated planet, residing in Liberty's Cradle. The only authorized destination for the \
			Horizon is a private beach resort near Nouvelle-Rochelle."
	icon_state = "globe2"
	color = COLOR_BLUE_GRAY
	initial_restricted_waypoints = list(
		"Intrepid" = list("xanu_beach_intrepid"),
	)
	place_near_main = list(1, 0)

/obj/effect/overmap/visitable/xanu_beach/Initialize()
	. = ..()
	adjust_scale(2, 2)

/obj/effect/shuttle_landmark/xanu_beach_intrepid
	name = "Côte d'Azur Resort"
	landmark_tag = "xanu_beach_intrepid"

/area/exoplanet/xanu_beach
	name = "Côte d'Azur Resort"
	emergency_lights = FALSE
	flags = HIDE_FROM_HOLOMAP
	always_unpowered = FALSE
	requires_power = FALSE
