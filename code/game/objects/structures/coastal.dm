/obj/structure/beach_umbrella
	name = "overhead beach umbrella"
	desc = "A tightly secured beach umbrella which looks pretty elegant against the sun."
	icon = 'icons/obj/structure/urban/misc_64x64.dmi'
	icon_state = "umbrella"
	anchored = TRUE
	layer = 9

/obj/structure/beach_umbrella/alt
	icon_state = "umbrella_alt"

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
	layer = 9

/obj/structure/crane
	name = "overhead guiding crane"
	desc = "A towering crane for lifting industrial sized cargo."
	icon = 'icons/obj/structure/industrial/cranes.dmi'
	icon_state = "crane"
	anchored = TRUE
	density = TRUE
	layer = 9
	pixel_x = -16
