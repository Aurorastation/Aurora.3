/obj/structure/displaycase
	name = "display case"
	desc = "A display case for prized possessions. It taunts you to kick it."
	icon = 'icons/obj/display_case.dmi'
	icon_state = "glassbox"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	req_access = list(access_captain)
	var/health = 30
	var/obj/held_obj
	var/open = FALSE
	var/destroyed = FALSE
	var/spawn_contained_type

/obj/structure/displaycase/Initialize(mapload)
	. = ..()
	if(spawn_contained_type)
		var/obj/O = new spawn_contained_type(src)
		held_obj = O
		update_icon()

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if (1)
			do_destroy()
		if (2)
			if(prob(50))
				health -= 15
				health_check()
		if (3)
			if(prob(50))
				health -= 5
				health_check()


/obj/structure/displaycase/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()
	health_check()

/obj/structure/displaycase/proc/health_check()
	if(health <= 0)
		do_destroy()
	else
		playsound(loc, 'sound/effects/glass_hit.ogg', 75, 1)

/obj/structure/displaycase/proc/do_destroy()
	if(!destroyed)
		density = FALSE
		destroyed = TRUE
		new /obj/item/material/shard(loc)
		playsound(src, /decl/sound_category/glass_break_sound, 70, 1)
		update_icon()

/obj/structure/displaycase/update_icon()
	underlays = list()
	if(destroyed)
		icon_state = "glassbox-broken"
	else if(open)
		icon_state = "glassbox-open"
	else
		icon_state = "glassbox"
	if(held_obj)
		var/image/I = image(held_obj.icon, src, held_obj.icon_state)
		underlays += I

/obj/structure/displaycase/attackby(obj/item/W, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W, /obj/item/card/id))
		if(destroyed)
			to_chat(user, SPAN_WARNING("\The [src] has been destroyed and cannot be unlocked."))
			return
		var/obj/item/card/id/ID = W
		if(check_access(ID))
			user.visible_message("<b>[user]</b> presses their ID against \the [src], [open ? "closing" : "opening"] it.", SPAN_NOTICE("You press your ID against \the [src], [open ? "closing" : "opening"] it."))
			open = !open
			update_icon()
		else
			to_chat(user, SPAN_WARNING("Access denied."))
	else if(!held_obj && (destroyed || open))
		to_chat(user, SPAN_NOTICE("You set \the [W] down on \the [src]."))
		user.drop_from_inventory(W, src)
		held_obj = W
		update_icon()
	else
		if(destroyed)
			to_chat(user, SPAN_WARNING("\The [src] has already been destroyed."))
			return
		health -= W.force
		health_check()
		return ..()

/obj/structure/displaycase/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(destroyed || open)
		if(!held_obj)
			to_chat(user, SPAN_WARNING("There is nothing held inside \the [src]!"))
		else
			user.put_in_hands(held_obj)
			to_chat(user, SPAN_NOTICE("You take \the [held_obj] out of \the [src]."))
			held_obj = null
			update_icon()
	else
		if(user.a_intent != I_HURT)
			if(held_obj)
				to_chat(user, SPAN_NOTICE("You peer inside \the [src], noticing it has \a [held_obj] inside."))
			else
				to_chat(user, SPAN_NOTICE("You peer inside \the [src], noticing it has nothing inside."))
		else
			user.visible_message("<b>[user]</b> kicks \the [src].", SPAN_WARNING("You kick \the [src]."))
			health -= 2
			health_check()

/obj/structure/displaycase/captain_laser
	spawn_contained_type = /obj/item/gun/energy/captain