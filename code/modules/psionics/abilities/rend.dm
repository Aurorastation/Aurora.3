/singleton/psionic_power/rend
	name = "Rend"
	desc = "Rend an adjacent target's biomolecular state apart. Very powerful, but with an extremely long cooldown and a huge psi-stamina cost. \
			Activate it in your hand to switch to a structure mode, in which you cannot target living beings (synthetics included) but you can tear apart \
			walls and airlocks much faster."
	icon_state = "gen_dissolve"
	point_cost = 3
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/rend

/obj/item/spell/rend
	name = "rend"
	icon_state = "chain_lightning"
	cast_methods = CAST_USE|CAST_MELEE
	aspect = ASPECT_PSIONIC
	force = 40
	armor_penetration = 30
	cooldown = 30
	psi_cost = 35
	attack_verb = list("rent apart", "disintegrated")
	hitsound = 'sound/weapons/heavysmash.ogg'
	item_flags = 0
	var/structure_mode = FALSE

/obj/item/spell/rend/on_use_cast(mob/user, bypass_psi_check)
	. = ..(user, TRUE)
	structure_mode = !structure_mode
	if(structure_mode)
		to_chat(user, SPAN_WARNING("You reconfigure your rending to damage structures. It can no longer be used on organics or synthetics, but it is much cheaper \
									to damage structures with."))
		maptext = SMALL_FONTS(7, "S")
		psi_cost = 15
	else
		to_chat(user, SPAN_WARNING("You reconfigure your rending to damage organics again."))
		maptext = SMALL_FONTS(7, "O")
		psi_cost = initial(psi_cost)

/obj/item/spell/rend/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(structure_mode && isliving(hit_atom))
		to_chat(user, SPAN_WARNING("Your rending is not configured for organics!"))
		return
	. = ..()
	if(!.)
		return
	if(structure_mode)
		if(iswall(hit_atom))
			var/turf/simulated/wall/W = hit_atom
			var/base_time = 5 SECONDS
			if(W.reinf_material)
				base_time += (W.reinf_material.hardness / 10) SECONDS
			user.visible_message(SPAN_WARNING("[user] lays [user.get_pronoun("his")] palms on \the [W] and begins discharging psionic energy on it..."),
								SPAN_WARNING("You lay your palms on \the [W] and begin permeating psionic energy through its structure..."))
			if(do_after(user, base_time))
				user.visible_message(SPAN_WARNING("[user] disintegrates \the [W]!"), SPAN_WARNING("You disintegrate \the [W]!"))
				W.dismantle_wall(TRUE, FALSE, TRUE)
		else if(isairlock(hit_atom))
			var/obj/machinery/door/airlock/A = hit_atom
			var/base_time = (round(A.maxhealth / 60)) SECONDS
			user.visible_message(SPAN_WARNING("[user] lays [user.get_pronoun("his")] palms on \the [A] and begins discharging psionic energy on it..."),
							SPAN_WARNING("You lay your palms on \the [A] and begin permeating psionic energy through its structure..."))
			if(do_after(user, base_time))
				user.visible_message(SPAN_WARNING("[user] disintegrates \the [A]!"), SPAN_WARNING("You disintegrate \the [A]!"))
				playsound(A, 'sound/effects/meteorimpact.ogg', 40)
				qdel(A)
