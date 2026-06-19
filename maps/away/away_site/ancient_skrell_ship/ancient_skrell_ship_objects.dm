/turf/unsimulated/mineral/cave/petrified_shell
	name = "petrified shell"
	desc = ""
	color = "#8a7387"

/turf/unsimulated/mineral/cave/petrified_shell/dark_purple
	color = "#574267"

/turf/unsimulated/mineral/cave/petrified_shell/dark_blue
	color = "#31444a"

/turf/unsimulated/wall/composite_stone/dark_purple
	color = "#4e4378"

/turf/unsimulated/wall/composite_stone/magenta
	color = "#6e2c6e"

/turf/simulated/floor/cave/shell
	color = "#8a7387"

/turf/simulated/floor/cave/shell/dark_purple
	color = "#574267"

/turf/simulated/floor/cave/shell/dark_blue
	color = "#31444a"

/turf/simulated/floor/exoplanet/water/smooth/shell
	base_turf_icon = "shell"

/obj/structure/decor/nralakk_projector
	name = "projector device"
	desc = "A small device with an optic lens, designed to project holograpic images in a short range. This one in particular looks complex."
	icon = 'icons/obj/item/skrell/nralakk_projector.dmi'
	icon_state = "projector"
	light_system = MOVABLE_LIGHT
	/// Used for preventing spam clicks.
	var/use_cooldown_time
	/// On/Off switch.
	var/on = FALSE
	/// A list that contains star_projection and projector_light, if present.
	var/list/holo_effects

/obj/structure/decor/nralakk_projector/attack_hand(mob/user)
	toggle_hologram(user)

/obj/structure/decor/nralakk_projector/proc/toggle_hologram(mob/user)
	if(use_cooldown_time > world.time)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] blinks a red light as you click the button, the mechanism doesn't recognize your consecutive inputs."))
		return

	use_cooldown_time = world.time + 5 SECONDS
	if(!on)
		var/obj/effect/decal/projector_light/PL = new(loc)
		PL.pixel_x = pixel_x
		PL.pixel_y = pixel_y + 2
		LAZYADD(holo_effects, PL)

		var/obj/effect/decal/star_projection/SP = new(loc)
		SP.pixel_x = pixel_x
		SP.pixel_y = pixel_y + 14
		LAZYADD(holo_effects, SP)
		set_light_range_power_color(2, 0.5, COLOR_BLUE_GRAY)
		set_light_on(TRUE)
	else
		QDEL_LAZYLIST(holo_effects)
		set_light_on(FALSE)

	on = !on
	playsound(get_turf(src), 'sound/machines/holoclick.ogg', 40)

/obj/structure/decor/nralakk_projector/Destroy()
	QDEL_LAZYLIST(holo_effects)
	return ..()

/obj/effect/decal/star_projection
	name = "star projection"
	desc = "A holographic map of a star system, seemingly also simulates the movements of celestial bodies represented within."
	icon = 'icons/obj/item/skrell/stellascope.dmi'
	icon_state = "starprojection"
	mouse_opacity = MOUSE_OPACITY_ICON
	layer = ABOVE_ABOVE_HUMAN_LAYER

/obj/effect/decal/projector_light
	icon = 'icons/obj/item/skrell/nralakk_projector.dmi'
	icon_state = "projector_light"
	alpha = 100 // light effect(tm)
	layer = OBJ_LAYER

/obj/structure/decor/nralakk_projector/toggled_on/Initialize()
	. = ..()
	toggle_hologram()

// ---- Airlocks

/obj/structure/machinery/door/airlock/hatch/skrell
	door_color = "#704470"
	stripe_color = "#382972"

/obj/structure/machinery/door/airlock/glass/skrell
	door_color = "#704470"
	stripe_color = "#382972"

/obj/structure/machinery/door/airlock/skrell
	door_color = "#704470"
	stripe_color = "#382972"

/obj/structure/machinery/door/airlock/multi_tile/glass/skrell
	door_color = "#704470"

// ---- indestructible walls

/turf/unsimulated/wall/shuttle/space_ship/skrell
	icon = 'icons/turf/smooth/shuttle_wall_dark.dmi'
	icon_state = "map-shuttle"
	color = "#4e4378"
	smoothing_flags = SMOOTH_MORE
	canSmoothWith = list(
		/obj/structure/window/shuttle,
		/turf/simulated/wall/shuttle,
		/turf/unsimulated/wall/shuttle)

/turf/unsimulated/wall/shuttle/space_ship/skrell/pink
	icon = 'icons/turf/smooth/shuttle_wall_dark.dmi'
	icon_state = "map-shuttle"
	color = "#6e2c6e"

// ---- event lore consoles

/obj/structure/machinery/computer/loreconsole/terminal/always_powered/ancient_skrell_event/captain_log_1
	entries = list(
		new/datum/lore_console_entry(
			"\[Expedition Log – AEV Lemure III\] \
			\[Date: 27/02/2460\] \
			\[Author: Captain Selim Atalay\]", {"
	<hr>
	Our lead was correct. It's hard to measure, this been the Sea, but our starting scout shows us all we hoped for. This is one the largest havens we've ever found.
	<br><br>
	Our sensors briefly picked up a station in the thinner fog here, we're currently trying to locate it after it was lost in the fog again. The implications of a station
	out here are hard to comprehend. How was it built under our nose? Who does it belong to? I dread to think the answer to both of these are
	\"something we dont truly know or comprehend.\"
	"}))

// ---- event papers

/obj/item/paper/fluff/ancient_skrell_ship/doctors_note
	name = "doctor's note"
	info = {"
We’re running low on medical supplies. Captain Atalay insists this find is worth the risk – if we leave, we might never. I’m inclined to agree. So just please be extra careful, take it slow. We have plenty of food, fuel, but if you get seriously injured, we might not make it back to Assunzione in time.
<br><br>- Dr A. Perratou
	"}

/obj/item/paper/fluff/ancient_skrell_ship/eng_note
	name = "power note"
	info = {"
Let the generators use up their fuel, then leaver them. Too much heat and potential radiation where we don’t want it. We’ll get this ship’s own generator back online.
<br><br>- Chief Andriani
	"}

/obj/effect/shuttle_landmark/ancient_skrell/landing_1a
	name = "Docking Area, 1a"
	landmark_tag = "nav_ancient_skrell_intrepid"
	dir = NORTH

/obj/effect/shuttle_landmark/ancient_skrell/landing_1b
	name = "Docking Area, 1b"
	landmark_tag = "nav_ancient_skrell_lz1"
	dir = NORTH

/obj/effect/shuttle_landmark/ancient_skrell/landing_1c
	name = "Docking Area, 1c"
	landmark_tag = "nav_ancient_skrell_lz2"
	dir = NORTH
