/obj/structure/dock_structure
	name = "docking tie"
	desc = "A large, very secure tie-off point for a dock."
	icon = 'icons/obj/structure/industrial/docks.dmi'
	icon_state = "dock_tie"
	anchored = TRUE

/obj/structure/dock_structure/rail
	name = "docking rail line"
	desc = "A large railing mechanism to lift vessels out of the water with ease."
	icon_state = "rail"

/obj/structure/dock_structure/rail/start
	icon_state = "rail_start"

/obj/structure/dock_structure/rail/end
	icon_state = "rail_end"

/obj/structure/boat
	name = "surface water craft"
	desc = "A large boat floating steadily atop the water."
	icon = 'icons/obj/structure/industrial/watercraft.dmi'
	icon_state = "radio_ship"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER
