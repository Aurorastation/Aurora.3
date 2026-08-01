/obj/structure/displaycase
	name = "display case"
	desc = "A display case for prized possessions. It taunts you to kick it."
	icon = 'icons/obj/display_case.dmi'
	icon_state = "glassbox"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	req_access = list(ACCESS_CAPTAIN)
	maxhealth = OBJECT_HEALTH_VERY_LOW
	var/obj/held_obj
	var/open = FALSE
	var/destroyed = FALSE
	hitsound = 'sound/effects/glass_hit.ogg'
	destroy_sound = SFX_BREAK_GLASS
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
			on_death()
		if (2)
			if(prob(50))
				on_death()
			else
				add_damage(rand(20, 50))
		if (3)
			add_damage(rand(10, 40))


/obj/structure/displaycase/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	var/damage = hitting_projectile.damage
	if(damage)
		add_damage(damage)

/obj/structure/displaycase/on_death()
	if(!destroyed)
		density = FALSE
		destroyed = TRUE
		new /obj/item/material/shard(loc)
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

/obj/structure/displaycase/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/card/id))
		if(destroyed)
			to_chat(user, SPAN_WARNING("\The [src] has been destroyed and cannot be unlocked."))
			return

		var/obj/item/card/id/ID = attacking_item
		if(check_access(ID))
			user.visible_message("<b>[user]</b> presses their ID against \the [src], [open ? "closing" : "opening"] it.", SPAN_NOTICE("You press your ID against \the [src], [open ? "closing" : "opening"] it."))
			open = !open
			update_icon()

		else
			to_chat(user, SPAN_WARNING("Access denied."))

		return

	else if(!held_obj && (destroyed || open))
		to_chat(user, SPAN_NOTICE("You set \the [attacking_item] down on \the [src]."))
		user.drop_from_inventory(attacking_item, src)
		held_obj = attacking_item
		update_icon()

	if(destroyed)
		to_chat(user, SPAN_WARNING("\The [src] has already been destroyed."))
		return

	. = ..()

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
			user.do_attack_animation(src)
			playsound(src, 'sound/effects/glass_hit.ogg', 50, 1)
			add_damage(3)

/obj/structure/displaycase/captain_laser
	spawn_contained_type = /obj/item/gun/energy/captain

/obj/structure/displaycase/captain_revolver
	spawn_contained_type = /obj/item/gun/projectile/revolver/mateba/captain

/obj/structure/displaycase/adhomai_map
	spawn_contained_type = /obj/item/toy/adhomian_map
