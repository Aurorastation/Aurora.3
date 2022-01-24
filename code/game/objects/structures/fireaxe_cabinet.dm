/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	icon_state = "fireaxe"
	anchored = 1
	density = 0

	var/damage_threshold = 15
	var/open
	var/unlocked
	var/shattered
	var/obj/item/material/twohanded/fireaxe/fireaxe

/obj/structure/fireaxecabinet/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	user.do_attack_animation(src)
	playsound(user, 'sound/effects/glass_hit.ogg', 50, 1)
	visible_message("<span class='danger'>[user] [attack_verb] \the [src]!</span>")
	if(damage_threshold > damage)
		to_chat(user, "<span class='danger'>Your strike is deflected by the reinforced glass!</span>")
		return
	if(shattered)
		return
	shattered = 1
	unlocked = 1
	open = 1
	playsound(user, /decl/sound_category/glass_break_sound, 100, 1)
	update_icon()

/obj/structure/fireaxecabinet/update_icon()
	cut_overlays()
	if(fireaxe)
		add_overlay("fireaxe_item")
	if(shattered)
		add_overlay("fireaxe_window_broken")
	else if(!open)
		add_overlay("fireaxe_window")

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
		to_chat(user, "<span class='warning'>\The [src] is locked.</span>")
		return
	toggle_open(user)

/obj/structure/fireaxecabinet/MouseDrop(over_object, src_location, over_location)
	if(over_object == usr)
		var/mob/user = over_object
		if(!istype(user))
			return

		if(!open)
			to_chat(user, "<span class='warning'>\The [src] is closed.</span>")
			return

		if(!fireaxe)
			to_chat(user, "<span class='warning'>\The [src] is empty.</span>")
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
				to_chat(user, "<span class='warning'>There is already \a [fireaxe] inside \the [src].</span>")
			else if(user.unEquip(O))
				O.forceMove(src)
				fireaxe = O
				to_chat(user, "<span class='notice'>You place \the [fireaxe] into \the [src].</span>")
				update_icon()
			return

	if(O.force)
		user.setClickCooldown(10)
		attack_generic(user, O.force, "bashes")
		return

	return ..()

/obj/structure/fireaxecabinet/proc/toggle_open(var/mob/user)
	if(shattered)
		open = 1
		unlocked = 1
	else
		user.setClickCooldown(10)
		open = !open
		to_chat(user, "<span class='notice'>You [open ? "open" : "close"] \the [src].</span>")
	update_icon()

/obj/structure/fireaxecabinet/proc/toggle_lock(var/mob/user)


	if(open)
		return

	if(shattered)
		open = 1
		unlocked = 1
	else
		user.setClickCooldown(10)
		to_chat(user, "<span class='notice'>You begin [unlocked ? "enabling" : "disabling"] \the [src]'s maglock.</span>")

		if(!do_after(user, 20))
			return

		if(shattered) return

		unlocked = !unlocked
		playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
		to_chat(user, "<span class = 'notice'>You [unlocked ? "disable" : "enable"] the maglock.</span>")

	update_icon()
