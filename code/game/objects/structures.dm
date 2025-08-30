/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = WEIGHT_CLASS_GIGANTIC
	layer = STRUCTURE_LAYER
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	pass_flags_self = PASSSTRUCTURE

	var/material_alteration = MATERIAL_ALTERATION_ALL // Overrides for material shit. Set them manually if you don't want colors etc. See wood chairs/office chairs.
	var/climbable
	var/breakable
	var/parts
	var/list/climbers
	var/list/footstep_sound	//footstep sounds when stepped on

	var/material/material
	var/build_amt = 2 // used by some structures to determine into how many pieces they should disassemble into or be made with

	var/slowdown = 0 //amount that pulling mobs have their movement delayed by

/obj/structure/Initialize(mapload)
	. = ..()
	if(!isnull(material) && !istype(material))
		material = SSmaterials.get_material_by_name(material)
	if (!mapload)
		updateVisibility(src)	// No point checking this before visualnet initializes.
	if(climbable)
		verbs += /obj/structure/proc/climb_on
	if (smoothing_flags)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/structure/Destroy()
	if(parts)
		new parts(loc)
	if (smoothing_flags)
		SSicon_smooth.remove_from_queues(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

	climbers = null

	return ..()

/obj/structure/attack_hand(mob/living/user)
	if(breakable)
		if((user.mutations & HULK) && !(user.isSynthetic()) && !(isvaurca(user)))
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")

	if(LAZYLEN(climbers) && !(user in climbers))
		user.visible_message(SPAN_WARNING("[user] shakes \the [src]."), \
					SPAN_NOTICE("You shake \the [src]."))
		structure_shaken()

	return ..()

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return

/obj/structure/proc/dismantle()
	var/material/dismantle_material
	if(!get_material())
		dismantle_material = SSmaterials.get_material_by_name(DEFAULT_WALL_MATERIAL) //if there is no defined material, it will use steel
	else
		dismantle_material = get_material()
	for(var/i = 1 to build_amt)
		dismantle_material.place_sheet(loc)
	qdel(src)

/obj/structure/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	bullet_ping(hitting_projectile)

/obj/structure/proc/climb_on()

	set name = "Climb Structure"
	set desc = "Climbs onto a structure. Shortcut middle-mouse click."
	set category = "Object"
	set src in oview(1)

	if(can_climb(usr))
		do_climb(usr)

/obj/structure/handle_middle_mouse_click(mob/user)
	if(can_climb(user))
		do_climb(usr)
		return TRUE
	return FALSE

/obj/structure/mouse_drop_receive(atom/dropped, mob/user, params)

	var/mob/living/H = user
	if(istype(H) && can_climb(H) && dropped == user)
		do_climb(dropped)
	else
		return ..()

/obj/structure/proc/can_climb(var/mob/living/user, post_climb_check=0)
	if (!climbable)
		to_chat(user, SPAN_WARNING("\The [src] cannot be climbed!"))
		return FALSE

	if (!can_touch(user) || (!post_climb_check && (user in climbers)))
		return FALSE

	if (!user.Adjacent(src))
		to_chat(user, SPAN_WARNING("You must be next to \the [src] to climb it."))
		return FALSE

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, SPAN_WARNING("There's \a [occupied] in the way."))
		return FALSE
	return TRUE

/obj/structure/proc/turf_is_crowded(var/exclude_self = FALSE)
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable)
				continue
		if(O && O.density && !(O.atom_flags & ATOM_FLAG_CHECKS_BORDER)) //ATOM_FLAG_CHECKS_BORDER structures are handled by the Adjacent() check.
			if(exclude_self && O == src)
				continue
			return O
	return 0

/obj/structure/proc/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return

	user.visible_message(SPAN_WARNING("[user] starts [atom_flags & ATOM_FLAG_CHECKS_BORDER ? "leaping over" : "climbing onto"] \the [src]!"))
	LAZYADD(climbers, user)

	if(!do_after(user, 5 SECONDS, src, DO_DEFAULT | DO_USER_UNIQUE_ACT))
		LAZYREMOVE(climbers, user)
		return

	if (!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers, user)
		return

	var/turf/TT = get_turf(src)
	if(atom_flags & ATOM_FLAG_CHECKS_BORDER)
		TT = get_step(get_turf(src), dir)
		if(user.loc == TT)
			TT = get_turf(src)

	user.visible_message(SPAN_WARNING("[user] [atom_flags & ATOM_FLAG_CHECKS_BORDER ? "leaps over" : "climbs onto"] \the [src]!"))
	user.forceMove(TT)
	LAZYREMOVE(climbers, user)

/obj/structure/proc/structure_shaken()
	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, SPAN_DANGER("You topple as you are shaken off \the [src]!"))
		LAZYREMOVE(climbers, M)

	for(var/mob/living/M in get_turf(src))
		if(M.lying) return //No spamming this on people.

		M.Weaken(3)
		to_chat(M, SPAN_DANGER("You topple as \the [src] moves under you!"))

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, SPAN_DANGER("You land heavily!"))
				M.adjustBruteLoss(damage)
				return

			var/obj/item/organ/external/affecting

			switch(pick(list("ankle","wrist",BP_HEAD,"knee","elbow")))
				if("ankle")
					affecting = H.get_organ(pick(BP_L_FOOT, BP_R_FOOT))
				if("knee")
					affecting = H.get_organ(pick(BP_L_LEG, BP_R_LEG))
				if("wrist")
					affecting = H.get_organ(pick(BP_L_HAND, BP_R_HAND))
				if("elbow")
					affecting = H.get_organ(pick(BP_L_ARM, BP_R_ARM))
				if(BP_HEAD)
					affecting = H.get_organ(BP_HEAD)

			if(affecting)
				to_chat(M, SPAN_DANGER("You land heavily on your [affecting.name]!"))
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, SPAN_DANGER("You land heavily!"))
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled_to)
		to_chat(user, SPAN_NOTICE("You need your hands and legs free for this."))
		return 0
	if (user.stat || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if (issilicon(user))
		to_chat(user, SPAN_NOTICE("You need hands for this."))
		return 0
	return 1

/obj/structure/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	if(!breakable || !damage || !environment_smash)
		return 0
	visible_message(SPAN_DANGER("[user] [attack_verb] the [src] apart!"))
	user.do_attack_animation(src)
	qdel(src)
	return 1

/obj/structure/get_material()
	return material
