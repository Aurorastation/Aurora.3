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
	force = 3.0
	throwforce = 10.0
	throw_speed = 3
	throw_range = 7
	w_class = 3.0
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	var/mopping = 0
	var/mopcount = 0
	var/cleantime = 25
	var/last_clean
	var/clean_msg = FALSE

/obj/item/mop/Initialize()
	. = ..()
	create_reagents(30)
	janitorial_supplies |= src

/obj/item/mop/Destroy()
	janitorial_supplies -= src
	return ..()

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay) || istype(A, /obj/effect/rune))
		if(reagents.total_volume < 1)
			if(clean_msg)
				to_chat(user, span("notice", "Your mop is dry!"))
			return
		if (!(last_clean && world.time < last_clean + 120)) //spam is bad
			user.visible_message(span("warning", "[user] begins to mop \the [get_turf(A)]."))
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
				to_chat(user, span("notice", "You have finished mopping!"))
			update_icon()


/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		return
	..()

/obj/item/mop/update_icon()
	if(reagents.total_volume < 1)
		icon_state = "[initial(icon_state)]"
		item_state = icon_state
	if(reagents.total_volume > 1)
		icon_state = "[initial(icon_state)]_wet"
		item_state = icon_state

/obj/item/mop/on_reagent_change()
	update_icon()

/obj/item/mop/advanced
	name = "advanced mop"
	desc = "The most advanced tool in a custodian's arsenal, complete with a condenser for self-wetting! Just think of all the viscera you will clean up with this!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "advmop"
	item_state = "advmop"
	force = 6.0
	throwforce = 14
	throw_range = 8
	cleantime = 15
	var/refill_enabled = TRUE //Self-refill toggle for when a janitor decides to mop with something other than water.
	var/refill_rate = 0.5 //Rate per process() tick mop refills itself
	var/refill_reagent = "water" //Determins what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING

/obj/item/mop/advanced/New()
	..()
	START_PROCESSING(SSprocessing, src)

/obj/item/mop/advanced/attack_self(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing,src)
	to_chat(user, span("notice", "You set the condenser switch to the <b>'[refill_enabled ? "ON" : "OFF"]'</b> position."))
	playsound(user, 'sound/machines/click.ogg', 25, 1)

/obj/item/mop/advanced/process()
	if(reagents.total_volume < 30)
		reagents.add_reagent(refill_reagent, refill_rate)

/obj/item/mop/advanced/examine(mob/user)
	..()
	to_chat(user, span("notice", "\The condenser switch is set to <b>[refill_enabled ? "ON" : "OFF"]</b>."))

/obj/item/mop/advanced/Destroy()
	if(refill_enabled)
		STOP_PROCESSING(SSprocessing, src)
	return ..()
