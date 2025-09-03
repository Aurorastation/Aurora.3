// Cargo Elevator Hatch
/obj/structure/cargo_elevator_hatch
	name = "cargo elevator hatch"
	desc = "The cargo elevator's hatch. Two hefty chunks of blast resistant and hermetically sealed plasteel. Cargo comes from below."
	icon = 'icons/obj/cargo_elevator.dmi'
	icon_state = "cargo_elevator_hatch_offset"
	appearance_flags = DEFAULT_APPEARANCE_FLAGS // Makes it visible from off-screen, objects have "TILE_BOUND" set by default.
	pixel_x = -96 // So it doesn't get deleted by the elevator.
	pixel_y = -352 // Ditto.
	anchored = TRUE
	density = FALSE

/obj/structure/cargo_elevator_hatch/Initialize()
	. = ..()
	layer = DECAL_PLATING_LAYER // Set here, otherwise it isn't visible in the map editor.

/obj/structure/cargo_elevator_hatch/attack_hand(mob/user)
	to_chat(user, SPAN_NOTICE("You reach down and touch \the [src]. Nothing happens."))

/obj/structure/cargo_elevator_hatch/attackby(obj/item/attacking_item, mob/user)
	to_chat(user, SPAN_NOTICE("You hit \the [src] with \the [attacking_item]. Nothing happens."))

// Cargo Elevator Plating
/turf/simulated/floor/plating/cargo_elevator
	name = "cargo hatch plating"
	desc = "The cargo hatch's plating."

// Sanity checks in case someone somehow tries to interact with one of the platings.
/turf/simulated/floor/plating/cargo_elevator/attack_hand(mob/user)
	to_chat(user, SPAN_NOTICE("You reach down and touch \the [src]. Nothing happens."))

/turf/simulated/floor/plating/cargo_elevator/attackby(obj/item/attacking_item, mob/user)
	to_chat(user, SPAN_NOTICE("You hit \the [src] with \the [attacking_item]. Nothing happens."))

/obj/effect/elevator
	name = "\proper elevator shaft"
	desc = "There seems to be an awful lot of machinery down below."
	icon = 'icons/effects/delete_me_sometime.dmi'
	icon_state = "abyss"
	unacidable = TRUE
	layer = TURF_DETAIL_LAYER
	appearance_flags = KEEP_TOGETHER

/obj/effect/elevator/ex_act(severity)
	return

/obj/effect/elevator/animation_overlay
	icon_state = null
	blend_mode = BLEND_INSET_OVERLAY
	appearance_flags = KEEP_TOGETHER
