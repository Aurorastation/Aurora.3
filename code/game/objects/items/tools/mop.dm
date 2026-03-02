/obj/item/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "mop"
	item_state = "mop"
	force = 3
	throwforce = 10.0
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	drop_sound = 'sound/items/drop/woodweapon.ogg'
	pickup_sound = 'sound/items/pickup/woodweapon.ogg'
	var/mopping = 0
	var/mopcount = 0
	var/cleantime = 25
	/// Spam limiter.
	var/last_clean
	var/clean_msg = FALSE

/obj/item/mop/Initialize()
	. = ..()
	create_reagents(30)
	if(is_station_turf(get_turf(src)))
		GLOB.janitorial_supplies |= src

/obj/item/mop/Destroy()
	if(src in GLOB.janitorial_supplies)
		GLOB.janitorial_supplies -= src
	return ..()

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return

	var/has_overlay = FALSE
	if(istype(A, /obj/effect/overlay))
		var/obj/effect/overlay/O = A
		if(O.no_clean)
			return
		has_overlay = TRUE

	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || has_overlay || istype(A, /obj/effect/rune))
		if(reagents.total_volume < 1)
			if(clean_msg)
				to_chat(user, SPAN_NOTICE("Your mop is dry!"))
			return
		// Spam is bad
		if(!(last_clean && world.time < last_clean + 120))
			user.visible_message(SPAN_WARNING("[user] begins to mop \the [get_turf(A)]."))
			clean_msg = TRUE
			last_clean = world.time
		else
			clean_msg = FALSE
		playsound(loc, 'sound/effects/mop.ogg', 25, 1)
		if(do_after(user, cleantime))
			var/turf/T = get_turf(A)
			if(T)
				T.clean(src, user)
			if(clean_msg)
				to_chat(user, SPAN_NOTICE("You have finished mopping!"))

/obj/effect/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/mop) || istype(attacking_item, /obj/item/soap))
		return FALSE
	return ..()

/obj/item/mop/update_icon()
	icon_state = "[initial(icon_state)][reagents.total_volume > 1 ? "_wet" : null]"
	item_state = icon_state
	update_held_icon()

/obj/item/mop/on_reagent_change()
	update_icon()

/obj/item/mop/advanced
	name = "advanced mop"
	desc = "The most advanced tool in a custodian's arsenal, complete with a condenser for self-wetting! Just think of all the viscera you will clean up with this!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "advmop"
	item_state = "advmop"
	force = 14
	throwforce = 14
	throw_range = 8
	cleantime = 15
	// Self-refill toggle for when a janitor decides to mop with something other than water.
	var/refill_enabled = TRUE
	/// Rate per process() tick mop refills itself. W/ max volume 30, fully replenish in 120s (at 2s ticks)
	var/refill_rate = 0.5
	// Determins what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING
	var/refill_reagent = /singleton/reagent/water

/obj/item/mop/advanced/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += SPAN_NOTICE("\The condenser switch is set to <b>[refill_enabled ? "ON" : "OFF"]</b>.")

/obj/item/mop/advanced/Initialize()
	. = ..()

	START_PROCESSING(SSprocessing, src)

/obj/item/mop/advanced/Destroy()
	STOP_PROCESSING(SSprocessing, src)

	. = ..()

/obj/item/mop/advanced/attack_self(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing,src)
	to_chat(user, SPAN_NOTICE("You set the condenser switch to the <b>'[refill_enabled ? "ON" : "OFF"]'</b> position."))
	playsound(user, 'sound/machines/click.ogg', 25, 1)

/obj/item/mop/advanced/process()
	if(reagents.total_volume < 30)
		reagents.add_reagent(refill_reagent, refill_rate)
