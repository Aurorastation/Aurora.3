/datum/map/event/christmas
	name = "Christmas Chalet"
	full_name = "Xanan Christmas Village and Chalet"
	path = "event/christmas"
	lobby_icons = list('icons/misc/titlescreens/sccv_horizon/sccv_horizon.dmi')
	lobby_transitions = FALSE
	allowed_jobs = list(/datum/job/visitor)
	force_spawnpoint = TRUE

	station_levels = list(1)
	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)

	station_name = "to be done"
	station_short = "to be done"
	dock_name = "to be done"
	dock_short = "to be done"
	boss_name = "to be done"
	boss_short = "to be done"
	company_name = "Stellar Corporate Conglomerate"
	company_short = "SCC"

	use_overmap = FALSE

	allowed_spawns = list("Living Quarters Lift")
	spawn_types = list(/datum/spawnpoint/living_quarters_lift)
	default_spawn = "Living Quarters Lift"

// Pine Trees
/obj/structure/flora/tree/pine_tree/main
name = "Pine Tree"
desc = "A tall snow covered pine tree."
icon = 'icons/obj/flora/pinetrees.dmi'
icon_state = "pine_1"
density = 1

/obj/structure/flora/tree/pine_tree/main/treetwo
name = "Pine Tree"
desc = "A tall snow covered pine tree."
icon = 'icons/obj/flora/pinetrees.dmi'
icon_state = "pine_2"

/obj/structure/flora/tree/pine_tree/main/treethree
name = "Pine Tree"
desc = "A tall snow covered pine tree."
con = 'icons/obj/flora/pinetrees.dmi'
icon_state = "pine_3"

/obj/structure/flora/tree/pine_tree/main/christmas
name = "Christmas Tree"
desc = "A tall, full tree covered in magical lights!"
icon = 'icons/obj/flora/pinetrees.dmi'
icon_state = "pine_c"
