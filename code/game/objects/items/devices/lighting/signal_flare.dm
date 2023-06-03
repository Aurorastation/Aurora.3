/obj/item/device/flashlight/flare/signal
	name = "signal flare"
	desc = "A single-use green standard-issue signal flare. This flare will create a landing zone for shuttles. There are instructions on the side reading 'twist cap off, throw to the ground to activate homing capsule'."
	w_class = ITEMSIZE_SMALL
	flashlight_power = 1.8
	brightness_on = 6 // Very bright.
	light_color = LIGHT_COLOR_GREEN

	var/obj/effect/shuttle_landmark/automatic/landmark

/obj/item/device/flashlight/flare/signal/Initialize()
	. = ..()
	color = color_rotation(140)
	fuel = 15 MINUTES

/obj/item/device/flashlight/flare/signal/Destroy()
	QDEL_NULL(landmark)
	return ..()

/obj/item/device/flashlight/flare/signal/turn_off()
	. = ..()
	QDEL_NULL(landmark)

/obj/item/device/flashlight/flare/signal/throw_impact(atom/hit_atom)
	. = ..()
	setup_landmark()

/obj/item/device/flashlight/flare/signal/do_additional_pickup_checks(var/mob/user)
	if(landmark)
		to_chat(user, SPAN_WARNING("It's too dangerous to touch this now!"))
		return FALSE
	return ..()

/obj/item/device/flashlight/flare/signal/proc/setup_landmark()
	if(on && isturf(loc))
		visible_message(SPAN_DANGER("\The [src] flashes a bright light! A shuttle can land here now."))
		landmark = new(get_turf(src))
		landmark.name = "signal flare ([landmark.x],[landmark.y])"
		budge_text = "It's too dangerous to touch this now!"
		anchored = TRUE
