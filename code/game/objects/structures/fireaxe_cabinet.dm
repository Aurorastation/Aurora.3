/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "A fire axe cabinet. There is small label that reads \"FOR EMERGENCY USE ONLY\" along with details for safe use of the axe on the side of it. As if."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "fireaxe"
	anchored = TRUE
	density = FALSE
	req_access = null

	var/damage_threshold = 10 // Damage needed to break the glass.
	var/open
	var/unlocked
	var/shattered
	var/obj/item/material/twohanded/fireaxe/fireaxe

/obj/structure/fireaxecabinet/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	user.do_attack_animation(src)
	playsound(user, 'sound/effects/glass_hit.ogg', 50, 1)
	visible_message(SPAN_WARNING("\The [user] [attack_verb] \the [src]!"))
	if(damage_threshold >= damage)
		to_chat(user, SPAN_WARNING("Your strike is deflected by the reinforced glass!"))
		return
	if(shattered)
		return
	shattered = TRUE
	unlocked = TRUE
	open = TRUE
	playsound(user, /decl/sound_category/glass_break_sound, 100, 1)
	update_icon()

/obj/structure/fireaxecabinet/update_icon()
	cut_overlays()
	if(fireaxe)
		add_overlay("axe")
	if(shattered)
		add_overlay("glass4")
	if(unlocked)
		add_overlay("unlocked")
	else
		add_overlay("locked")
	if(open)
		add_overlay("glass_raised")
	else
		add_overlay("glass")


/obj/structure/fireaxecabinet/New()
	..()
	fireaxe = new(src)
	update_icon()

/obj/structure/fireaxecabinet/attack_ai(var/mob/user)
	if(!ai_can_interact(user))
		return
	toggle_lock(user)

/obj/structure/fireaxecabinet/attack_hand(var/mob/user)
	if(!unlocked)
		to_chat(user, SPAN_NOTICE("\The [src] is locked."))
		return
	toggle_open(user)

/obj/structure/fireaxecabinet/MouseDrop(over_object, src_location, over_location)
	if(over_object == usr)
		var/mob/user = over_object
		if(!istype(user))
			return

		if(!open)
			to_chat(user, SPAN_NOTICE("\The [src] is closed."))
			return

		if(!fireaxe)
			to_chat(user, SPAN_NOTICE("\The [src] is empty."))
			return

		fireaxe.forceMove(get_turf(user))
		user.put_in_hands(fireaxe)
		fireaxe = null
		update_icon()

	return

/obj/structure/fireaxecabinet/Destroy()
	if(fireaxe)
		fireaxe.forceMove(get_turf(src))
		fireaxe = null
	return ..()

/obj/structure/fireaxecabinet/attackby(var/obj/item/O, var/mob/user)
	if(O.ismultitool())
		toggle_lock(user)
		return

	if(istype(O, /obj/item/material/twohanded/fireaxe))
		if(open)
			if(fireaxe)
				to_chat(user, SPAN_ALERT("There is already \a [fireaxe] inside \the [src]."))
			else if(user.unEquip(O))
				O.forceMove(src)
				fireaxe = O
				to_chat(user, SPAN_NOTICE("You place \the [fireaxe] into \the [src]."))
				update_icon()
			return

	if(O.force)
		user.setClickCooldown(10)
		attack_generic(user, O.force, "bashes")
		return

	return ..()

/obj/structure/fireaxecabinet/proc/toggle_open(var/mob/user)
	if(shattered)
		open = TRUE
		unlocked = TRUE
	else
		user.setClickCooldown(10)
		open = !open
		to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	update_icon()

/obj/structure/fireaxecabinet/proc/toggle_lock(var/mob/user)
	if(open)
		return

	if(shattered)
		open = TRUE
		unlocked = TRUE
	else
		user.setClickCooldown(10)
		to_chat(user, SPAN_NOTICE("You begin [unlocked ? "enabling" : "disabling"] \the [src]'s maglock."))

		if(!do_after(user, 20))
			return

		if(shattered)
			return

		unlocked = !unlocked
		to_chat(user, SPAN_NOTICE("You [unlocked ? "disable" : "enable"] the maglock."))

	update_icon()

/obj/structure/fireaxecabinet/armoury
	name = "armoury fire axe cabinet"