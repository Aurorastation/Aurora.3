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
			to_chat(user, SPAN_WARNING("\The [src] blinks a red light as you click its button, the mechanism doesn't recognize your too consecutive inputs."))
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
